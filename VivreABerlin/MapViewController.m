//
//  MapViewController.m
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "MapViewController.h"
#import "GlobalVariables.h"
#import "JTMaterialSpinner.h"
#import "DistrictsViewController.h"
#import "FilterViewController.h"
#import "UIImageView+Network.h"
#import "SimpleFilesCache.h"
#import "Header.h"
#import "Reachability.h"
#import "TYMProgressBarView.h"
#import "IAPViewController.h"
#import "MapCreditsController.h"
#import <CoreLocation/CoreLocation.h>
#import "ContainerViewController.h"
@interface MapViewController (){

    NSMutableArray *coordinates;
}

@property (strong, nonatomic) IBOutlet UIImageView *img;


@end


@implementation MapViewController
{
    
    TYMProgressBarView *progressView;
    JTMaterialSpinner * spinnerview;
    UIButton *downloadMap;
    UIButton *openMapCredits;
    BOOL LocationActivated;
    MGLCoordinateBounds bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    coordinates = [NSMutableArray array];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(ChangeScreen:) name:@"ChangeFilters" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlinePackProgressDidChange:) name:MGLOfflinePackProgressChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlinePackDidReceiveError:) name:MGLOfflinePackErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlinePackDidReceiveMaximumAllowedMapboxTiles:) name:MGLOfflinePackMaximumMapboxTilesReachedNotification object:nil];
    
    self.openFilters.userInteractionEnabled = false;
    
    self.centerLocation.image = [UIImage imageNamed:@"target.png"];
    self.centerLocation.contentMode = UIViewContentModeScaleAspectFit;
    self.centerLocation.clipsToBounds = true;
    self.view.backgroundColor = [self colorWithHexString:@"f1f2f5"];


    


    NSURL *url = [NSURL URLWithString:@"mapbox://styles/mapbox/streets-v9"];
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.frame styleURL:url];
    
    
    [self requestForAuthorization];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview: self.mapView];
    [self.view sendSubviewToBack: self.mapView];
    self.frameForMap.hidden = true;
    self.mapView.delegate = self;
    
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 53, 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    
    [self.mapView addSubview: spinnerview];
    [self.mapView bringSubviewToFront: spinnerview];
    [spinnerview beginRefreshing];
    
    [self createAnnotations];
    
    if([self isInternet] == NO){
        
        [spinnerview endRefreshing];
        self.mapView.maximumZoomLevel = 20;
    }
    
    if([GlobalVariables getInstance].comingFromPostView == true){
        [GlobalVariables getInstance].comingFromPostView = false;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake( [GlobalVariables getInstance].lastLatitudine, [GlobalVariables getInstance].lastLongitudine);
            
//            [self.mapView setCenterCoordinate:center zoomLevel:12 direction:0 animated:NO];
            
            
        });
        
    }
    else{
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake( [GlobalVariables getInstance].latitudine, [GlobalVariables getInstance].longitudine);
            
            [self.mapView setCenterCoordinate:center zoomLevel:12 direction:0 animated:NO];
            
            
        });
    }

    self.mapView.compassView.hidden = false;
    self.mapView.compassView.alpha = 1.f;
    
    
    [self.openFilters addTarget:self
                         action:@selector(OpenFilters)
               forControlEvents:UIControlEventTouchUpInside];
    
    

    
    
    self.mapView.tintColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];
    
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake( [GlobalVariables getInstance].latitudine, [GlobalVariables getInstance].longitudine);
    
        [self.mapView setCenterCoordinate:center zoomLevel:[GlobalVariables getInstance].zoomLvl direction:0 animated:YES];
    
    
    
    [GlobalVariables getInstance].deleteAnnotationsArray = [[NSMutableArray alloc]init];
    
    
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//             [self centerUserLocationInMap: [GlobalVariables getInstance].lastUserLocation zoom: 15];
//        });
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"]){
            downloadMap = [[UIButton alloc]initWithFrame:CGRectMake(self.mapView.frame.size.width * 0.25 , self.mapView.frame.size.height * 0.87, self.mapView.frame.size.width/2, 30)];
            downloadMap.titleLabel.textAlignment=NSTextAlignmentCenter;
            downloadMap.layer.cornerRadius = downloadMap.frame.size.height/4;
            [downloadMap setTitle:@"Télécharger la carte" forState:UIControlStateNormal];
            [downloadMap.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:15.f]];
            [downloadMap.titleLabel setTextColor:[UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f]];
            [downloadMap setTitleColor:[UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [downloadMap setBackgroundColor:[UIColor whiteColor]];
            downloadMap.titleLabel.adjustsFontSizeToFitWidth = true;
            downloadMap.showsTouchWhenHighlighted = true;
            [self.view addSubview:downloadMap];
            [self.view bringSubviewToFront:downloadMap];
            [downloadMap addTarget:self action:@selector(StartDownloadingTheMap) forControlEvents:UIControlEventTouchUpInside];
            downloadMap.enabled = true;
            
        }
     
    });
    
    
  
}

-(void)requestForAuthorization{
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    
    if([self.locationManager respondsToSelector: @selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
             LocationActivated = false;
            
        case kCLAuthorizationStatusDenied:
             LocationActivated = false;
        break;
        case kCLAuthorizationStatusAuthorizedAlways:
             LocationActivated = true;
            [self.locationManager startMonitoringSignificantLocationChanges];
            [self.locationManager startUpdatingLocation];
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
             LocationActivated = true;
            [self.locationManager startMonitoringSignificantLocationChanges];
            [self.locationManager startUpdatingLocation];
            
        default:
            break;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 1.f) {
        // If the event is recent, do something with it.
          NSLog(@"latitude %+.7f, longitude %+.7f\n",
                 location.coordinate.latitude,
                 location.coordinate.longitude);
    }
    
    [GlobalVariables getInstance].lastUserLocation = location;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

}
-(void) ChangeScreen: (NSNotification *) notification
{
    [GlobalVariables getInstance].canFilter = true;
    
    if ([notification.object isEqualToString:@"openDistricts"])
    {
        DistrictsViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"DistrictsViewController"];
        
        child2.view.frame = self.view.bounds;
        
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                               [self.view bringSubviewToFront:child2.view];
                           } completion:nil];
        
    }
    else if([notification.object isEqualToString:@"openFilters"]) {
        
        FilterViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
        
        child2.view.frame = self.view.bounds;
        
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                               [self.view bringSubviewToFront:child2.view];
                           } completion:nil];
        
        
    }
    else if([notification.object isEqualToString:@"reloadPozition"]){
        
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"latDis"] != nil) {
            float latDist = [[[NSUserDefaults standardUserDefaults]objectForKey:@"latDis"]doubleValue];
            float longDist = [[[NSUserDefaults standardUserDefaults]objectForKey:@"longDis"]doubleValue];
            float zoom = [[[NSUserDefaults standardUserDefaults]objectForKey:@"zoomLvl"]doubleValue];
            [self.mapView setCenterCoordinate:
             CLLocationCoordinate2DMake(latDist, longDist)
                                    zoomLevel: zoom
                                     animated: YES];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"latDis"];
            
            return;
        }
      
        NSLog(@"coordinates %@", coordinates);
       
        
        NSDictionary *maxLatDict =  @{
                                      @"lat" : @0
                                      };
        NSDictionary *minLatDict =  @{
                                      @"lat" : @180
                                      };
        
        
        NSDictionary *maxLongDict =  @{
                                      @"long" : @0
                                      };
        NSDictionary *minLongDict =  @{
                                      @"long" : @180
                                      };
        for (NSDictionary *diction in coordinates) {
            if ([[diction objectForKey:@"lat"] doubleValue]>[[maxLatDict objectForKey:@"lat"] doubleValue]) {
                maxLatDict = diction;
            }
            if ([[diction objectForKey:@"lat"]doubleValue]<[[minLatDict objectForKey:@"lat"]doubleValue]) {
                minLatDict = diction;
            }
            if ([[diction objectForKey:@"long"] doubleValue]>[[maxLongDict objectForKey:@"long"] doubleValue]) {
                maxLongDict = diction;
            }
            if ([[diction objectForKey:@"long"]doubleValue]<[[minLongDict objectForKey:@"long"]doubleValue]) {
                minLongDict = diction;
            }
            
        }
        NSLog(@"maxLatDict %@", maxLatDict);
        NSLog(@"minLatDict %@", minLatDict);
        
        NSLog(@"maxLongDict %@", maxLongDict);
        NSLog(@"minLongDict %@", minLongDict);

        
        bounds.sw = CLLocationCoordinate2DMake((CLLocationDegrees)[[minLatDict valueForKey:@"lat"] doubleValue], (CLLocationDegrees)[[minLongDict valueForKey:@"long"] doubleValue]);
        
        bounds.ne = CLLocationCoordinate2DMake((CLLocationDegrees)[[maxLatDict valueForKey:@"lat"] doubleValue], (CLLocationDegrees)[[maxLongDict valueForKey:@"long"] doubleValue]);
        
//       [self.mapView cameraThatFitsCoordinateBounds:bounds];
        [self.mapView flyToCamera:[self.mapView cameraThatFitsCoordinateBounds:bounds edgePadding:UIEdgeInsetsMake(10, 10, 10, 10)] completionHandler:nil];
          [spinnerview endRefreshing];
    }
    else if([notification.object isEqualToString:@"filtrating"] && [GlobalVariables getInstance].canFilter == true) {
        [GlobalVariables getInstance].canFilter = false;
        [spinnerview beginRefreshing];
        [self createAnnotations];
        
    }
    else if([notification.object isEqualToString:@"startDownloadingMap"]) {
        [downloadMap setTitle:@"" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"TriedToo" forKey:@"UserBoughtTheMap"];
        [self startOfflinePackDownload];
        

        [downloadMap setBackgroundImage:nil forState:UIControlStateNormal];
        [downloadMap setBackgroundColor:[UIColor clearColor]];
        
    }
}
-(void)createAnnotations{

    [coordinates removeAllObjects];
    self.openFilters.userInteractionEnabled = false;
    
    [GlobalVariables getInstance].Annotations = [[NSMutableArray alloc]init];
    
    [self.mapView removeAnnotations:[GlobalVariables getInstance].deleteAnnotationsArray];
    
    [GlobalVariables getInstance].deleteAnnotationsArray = [[NSMutableArray alloc]init];
    

    

    
    [GlobalVariables getInstance].arrayWithAnnotations = [[NSMutableArray alloc]initWithArray:[[GlobalVariables getInstance].MapPageInfos valueForKey:@"categories"]];
    
    
    for ( int i = 0 ; i < [GlobalVariables getInstance].arrayWithAnnotations.count;i++){
        [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:i] setValue:@"NO" forKey:@"isExpanded"];
        
        [[GlobalVariables getInstance].arrayWithAnnotations setValue:@"0" forKey:@"level"];
        for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] count]; j ++){
            
            [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"][j] setValue:@"1" forKey:@"level"];
            
        }
    }
    if(([GlobalVariables getInstance].PerSessionForFilters != true) ){
        for ( int i = 0 ; i < [[GlobalVariables getInstance].arrayWithAnnotations count];i++){
            for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] count]; j ++) {
                [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"][j] setValue:@"YES" forKey:@"isSelected"];
                
            }
        }
        [GlobalVariables getInstance].PerSessionForFilters = true;
    }
////////////
    
    
        for ( int i = 0 ; i < [GlobalVariables getInstance].arrayWithAnnotations.count;i++){
            
            for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] count]; j ++){
                if ([[[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"][j] valueForKey:@"isSelected" ] isEqualToString:@"YES"]){
                    [[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i][j] setValue:[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"category_name" ] forKey:@"parent_category_name"];
                    [[GlobalVariables getInstance].Annotations addObject:[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i][j]];
//
//
//                    NSLog(@"[GlobalVariables getInstance].Annotations %@", [GlobalVariables getInstance].Annotations );
                    
                    
                }
                
                
            }
        }
        

    
    
        if([[NSString stringWithFormat:@"%lu",(unsigned long)[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] count]] isEqualToString:@"0"])
            self.openFilters.userInteractionEnabled = true;
        
        if([[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] count] == 0){
            [spinnerview endRefreshing];
        }

        for (int i = 0 ; i< [[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] count]; i++) {
            
            NSLog(@"annonatations count %lu ", [[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] count]);
            
            
            for ( int j = 0 ; j < [[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lat"][i] count]; j++) {
                MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
                
                
                if([self isInternet] == NO && [[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lng"][i][j] floatValue] <= [NordEastMarkerLong floatValue] && [[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lng"][i][j] floatValue] >= [SouthWestMarkerLong floatValue] && [[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lat"][i][j] floatValue] <= [NordEastMarkerLat floatValue] && [[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lat"][i][j] floatValue] >= [SouthWestMarkerLat floatValue] && [[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_id"][i][j]]] != nil){
                    
                    
                    point.coordinate = CLLocationCoordinate2DMake([[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lat"][i][j] floatValue], [[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lng"][i][j] floatValue]);
                    point.title = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_title"][i][j]]];
                    [[GlobalVariables getInstance].deleteAnnotationsArray addObject:point];
                    point.subtitle = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@ -> %@",[[GlobalVariables getInstance].Annotations valueForKey:@"parent_category_name"][i],[[GlobalVariables getInstance].Annotations valueForKey:@"category_name"][i]]]];
                }
                else if([self isInternet] == YES){
                    
                    point.coordinate = CLLocationCoordinate2DMake([[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lat"][i][j] floatValue], [[[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"location"] valueForKey:@"lng"][i][j] floatValue]);

                    
                    NSDictionary *dict = @{
                                           @"lat" : [NSNumber numberWithDouble:point.coordinate.latitude],
                                           @"long" : [NSNumber numberWithDouble:point.coordinate.longitude]
                                           };

                    [coordinates addObject:dict];

                    point.title = [[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_title"][i][j];
                    [[GlobalVariables getInstance].deleteAnnotationsArray addObject:point];
                    point.subtitle = [NSString stringWithFormat:@"%@ -> %@",[[GlobalVariables getInstance].Annotations valueForKey:@"parent_category_name"][i],[[GlobalVariables getInstance].Annotations valueForKey:@"category_name"][i]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // point is the same 
                    [self.mapView addAnnotation:point];
                    if (i == [[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] count] -1){
                        self.openFilters.userInteractionEnabled = true;
                    
                        
                    }
                   
                    if([GlobalVariables getInstance].PerSession == true){
                        
                        if(point.coordinate.latitude == [GlobalVariables getInstance].lastLatitudine && point.coordinate.longitude == [GlobalVariables getInstance].lastLongitudine){
                            
                            [GlobalVariables getInstance].PerSession = false;
                           
                            [self.mapView selectAnnotation:point animated:YES];
                                
                            
                            
                        }
                    }

       
                });
                   
                
                
                
            }
            
        }
        
      
//    });

    
    
}



- (void) centerUserLocationInMap: (CLLocation*) location zoom: (NSInteger) zoom {
    
    [self.mapView setCenterCoordinate:
     CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                            zoomLevel: zoom
                             animated: YES];
    
    
    
}

- (void) mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    
    

    
    mapView.showsUserLocation = YES;
    
    
    
    CGRect frame = CGRectMake(self.centerLocation.frame.origin.x, self.centerLocation.frame.origin.y + self.centerLocation.frame.size.height + 5, self.mapView.compassView.frame.size.width, self.mapView.compassView.frame.size.height);
    self.mapView.compassView.frame = frame;
    
    
    
    
    openMapCredits = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [openMapCredits setFrame:CGRectMake(self.mapView.attributionButton.frame.origin.x - self.mapView.attributionButton.frame.size.width - 5, self.mapView.attributionButton.frame.origin.y, self.mapView.attributionButton.frame.size.width, self.mapView.attributionButton.frame.size.height)];
    [openMapCredits setTitle:@"©" forState:UIControlStateNormal];
    [openMapCredits.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Light" size:20]];
    [openMapCredits.titleLabel setTextColor:[self colorWithHexString:@"569CCA"]];
    [openMapCredits.layer setBorderColor:[self colorWithHexString:@"569CCA"].CGColor];
    [openMapCredits.layer setBorderWidth:1];
    [openMapCredits.layer setCornerRadius:openMapCredits.frame.size.width/2];
    openMapCredits.clipsToBounds = true;
    [openMapCredits addTarget:self action:@selector(openMapCredits) forControlEvents:UIControlEventTouchDown];
    [self.mapView addSubview:openMapCredits];
    [self.mapView bringSubviewToFront:openMapCredits];
    
    
    // self.mapView.compassView.center = self.view.center;
    self.mapView.backgroundColor = [UIColor blueColor];
    
    
//    [self createAnnotations];
    
    
    for (MGLOfflinePack *pack in [[MGLOfflineStorage sharedOfflineStorage] packs]){
        [pack requestProgress];
        
        dispatch_time_t popTimee = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTimee, dispatch_get_main_queue(), ^(void){
        if(pack.state == 1){
            [pack resume];
        }
            
        });
    }
    
    [spinnerview endRefreshing];
    
    
}
-(void)StartDownloadingTheMap{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"IAPViewController"]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Always try to show a callout when an annotation is tapped.
    [self.mapView setCenterCoordinate:annotation.coordinate zoomLevel:15 animated:YES];
    
    return YES;
}
- (IBAction)showUserLocation:(id)sender {
    
    if(LocationActivated == true){
        [self centerUserLocationInMap: [GlobalVariables getInstance].lastUserLocation zoom: 15];
        self.mapView.showsUserLocation = true;
    }
    else{
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service de géolocalisation désactivé!"
                                                                message:@"Merci d'autoriser la géolocalisation pour utiliser correctement l'app. Votre position restera privée et securisée"
                                                               delegate:self
                                                      cancelButtonTitle:@"Réglages"
                                                      otherButtonTitles:@"Annuler", nil];
            
            [alertView show];
        }
        
    }

    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.centerLocation.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2 , 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.centerLocation.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.centerLocation.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
   
    
   
    
    
    
}


- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}
- (IBAction)OpenDistricts:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"openDistricts"]];
}

- (void) OpenFilters {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"openFilters"]];
    
}



- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    NSArray *items = [annotation.subtitle componentsSeparatedByString:@" -> "];   //take the one array for split the string
    
    NSString *str2=[items objectAtIndex:1];
    
    
    for (int i = 0 ; i< [[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] count]; i++) {
        
        
        if([str2 isEqualToString:[[GlobalVariables getInstance].Annotations valueForKey:@"category_name"][i]]){
            
            for (int j = 0 ; j< [[[GlobalVariables getInstance].Annotations[i] valueForKey:@"markers"] count]; j++) {
                
                if([annotation.title isEqualToString:[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_title"][i][j] ]) {
                    UIImageView *imageview ;
                    NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_id"][i][j]]);
                    
                    if([self isInternet] == YES){
                        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75.f, 60.f)];
                        
                        NSString* webName = [[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_thumbnail_url"][i][j] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSURL* url = [NSURL URLWithString:webStringURL];
                        
                    
                        [imageview loadImageFromURL: url placeholderImage: nil cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_id"][i][j]]];
                        
                        return imageview;
                    }
                    else if([self isInternet] == NO && [[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_id"][i][j]]] != nil){
                        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75.f, 60.f)];
                        
                        NSString* webName = [[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_thumbnail_url"][i][j] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSURL* url = [NSURL URLWithString:webStringURL];
                        
                        [imageview loadImageFromURL: url placeholderImage: nil cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_id"][i][j]]];
                        
                        if(!imageview.image)
                            return nil;
                        
                        return imageview;

                    }

                }
            }
        }
        
        
        
    }
    return nil;
}
- (void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation
{
    
    // Optionally handle taps on the callout
    NSArray *items = [annotation.subtitle componentsSeparatedByString:@" -> "];   //take the one array for split the string
    
    NSString *str2=[items objectAtIndex:1];
    
    for (int i = 0 ; i< [[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] count]; i++) {
        
        
        if([str2 isEqualToString:[[GlobalVariables getInstance].Annotations valueForKey:@"category_name"][i]]){
            
            for (int j = 0 ; j< [[[GlobalVariables getInstance].Annotations[i] valueForKey:@"markers"] count]; j++) {
                
                if([annotation.title isEqualToString:[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_title"][i][j] ]) {
                    NSLog(@"Id of the post : %@",[[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_id"][i][j]);
                    [GlobalVariables getInstance].idOfPost = [[[GlobalVariables getInstance].Annotations valueForKey:@"markers"] valueForKey:@"post_id"][i][j];
                    [GlobalVariables getInstance].comingFrom = @"Map";
                    [GlobalVariables getInstance].comingFromViewController = @"MapViewController";
                     [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
                    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
                    
                    
                }
            }
        }
        
        
        
    }
    
    NSLog(@"Tapped the callout for: %@", annotation);
    
    // Hide the callout
    [mapView deselectAnnotation:annotation animated:YES];
   
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
 

    
    NSArray *items = [annotation.subtitle componentsSeparatedByString:@" -> "];

    
    NSString *nameOfAnnotation=[items objectAtIndex:1];
  
    NSLog(@"nameOfAnnotation %@", nameOfAnnotation);
    NSString *url = @"";

    if ([nameOfAnnotation isEqualToString:@"S'installer à Athènes"] ) {
        url = @"https://vivreathenes.com/wp-content/uploads/2015/06/s_installer.png";
    }else if ([nameOfAnnotation isEqualToString:@"Transports"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2015/06/transports.png";
    }else if ([nameOfAnnotation isEqualToString:@"Activités intérieures"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2018/02/enfants-activites-interieures.png";
    }
        else if ([nameOfAnnotation isEqualToString:@"Activités sportives"]){
            url = @"https://vivreathenes.com/wp-content/uploads/2018/02/enfants-activites-sportives.png";
        }
    else if ([nameOfAnnotation isEqualToString:@"Centre d'Athènes"]){

        url = @"https://vivreathenes.com/wp-content/uploads/2018/02/enfants-centre-athenes.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Sorties en famille"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2018/02/enfants-sorties-famille.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Bien-être"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2015/06/bien_etre.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Shopping"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2018/02/shopping.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Cafés et Bars"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2015/06/cafes_thes.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Night life"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2016/09/by_night.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Restaurants"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2015/06/restaurants_et_cafes.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Circuits"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2015/09/itineraires.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Hébergement"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2018/02/hebergements.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Monuments"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2018/02/monuments.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Musées"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2015/09/musees.png";
    }
    else if ([nameOfAnnotation isEqualToString:@"Visites guidées"]){
        url = @"https://vivreathenes.com/wp-content/uploads/2018/03/visites-guidees.png";
    }
    NSString * reuseIdentifier = NSStringFromClass(annotation.class);
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:[NSString stringWithFormat:@"%@",nameOfAnnotation]];

    

    
    
    if (!annotationImage) {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        
        if ([nameOfAnnotation isEqualToString:@"Médecine douce / Ostéopathes"]){
            image = [UIImage imageNamed:@"Medicine.png"];
        }
        
        if(image == nil)
            return nil;
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
       
    
       
        annotationImage = [MGLAnnotationImage annotationImageWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/2, image.size.height/2)] reuseIdentifier:[NSString stringWithFormat:@"%@",nameOfAnnotation]];
    }
    
    return annotationImage;
}
- (void)startOfflinePackDownload {
    
    id <MGLOfflineRegion> region = [[MGLTilePyramidOfflineRegion alloc] initWithStyleURL:self.mapView.styleURL bounds:MGLCoordinateBoundsMake(CLLocationCoordinate2DMake([SouthWestMarkerLat doubleValue], [SouthWestMarkerLong doubleValue]), CLLocationCoordinate2DMake([NordEastMarkerLat doubleValue], [NordEastMarkerLong doubleValue])) fromZoomLevel:3 toZoomLevel:15];
    
    // Store some data for identification purposes alongside the downloaded resources.
    NSDictionary *userInfo = @{ @"name": [NSString stringWithFormat:@"VivreA%@",nameOfTheCity] };
    NSData *context = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    
    // Create and register an offline pack with the shared offline storage object.
    [[MGLOfflineStorage sharedOfflineStorage] addPackForRegion:region withContext:context completionHandler:^(MGLOfflinePack *pack, NSError *error) {
        if (error != nil) {
            // The pack couldn’t be created for some reason.
            NSLog(@"Error: %@", error.localizedFailureReason);
        } else {
            // Start downloading.
            [pack resume];
        }
    }];
    
}

#pragma mark - MGLOfflinePack notification handlers

- (void)offlinePackProgressDidChange:(NSNotification *)notification {
    MGLOfflinePack *pack = notification.object;
    
    for (MGLOfflinePack *pack in [MGLOfflineStorage sharedOfflineStorage].packs) {
        NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
        NSLog(@"Offline pack %@ %llu %llu and state:%lo", userInfo[@"name"], pack.progress.countOfResourcesCompleted, pack.progress.countOfTilesCompleted,(long)pack.state);
        
    }
    
    // Get the associated user info for the pack; in this case, `name = My Offline Pack`
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    MGLOfflinePackProgress progress = pack.progress;
    // or [notification.userInfo[MGLOfflinePackProgressUserInfoKey] MGLOfflinePackProgressValue]
    uint64_t completedResources = progress.countOfResourcesCompleted;
    uint64_t expectedResources = progress.countOfResourcesExpected;
    
    // Calculate current progress percentage.
    float progressPercentage = (float)completedResources / expectedResources;
    
    // Setup the progress bar.
    if (!progressView) {
        // progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGSize frame = self.view.bounds.size;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
             progressView = [[TYMProgressBarView alloc] initWithFrame:CGRectMake(frame.width / 5.43, frame.height * 0.9, frame.width / 1.5, 40)];
            else
        progressView = [[TYMProgressBarView alloc] initWithFrame:CGRectMake(frame.width / 5.43, frame.height * 0.9, frame.width / 1.5, 13)];
        
        
        progressView.barBorderColor = [UIColor grayColor];
        progressView.barFillColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];
        progressView.tintColor = [self colorWithHexString:@"f1f2f5"];
        progressView.barInnerBorderColor = [self colorWithHexString:@"f1f2f5"];
        progressView.barBackgroundColor = [UIColor whiteColor];
        progressView.barBorderWidth = 1.0;
        progressView.clipsToBounds = true;
        
        [self.view addSubview:progressView];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            downloadMap = [[UIButton alloc]initWithFrame:CGRectMake(self.mapView.frame.size.width / 5.43, self.mapView.frame.size.height * 0.9 - 23, self.mapView.frame.size.width/1.5, 55)];
            else
                
        downloadMap = [[UIButton alloc]initWithFrame:CGRectMake(self.mapView.frame.size.width / 5.43, self.mapView.frame.size.height * 0.9 - 23, self.mapView.frame.size.width/1.5, 20)];
        downloadMap.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:16.f];
        downloadMap.titleLabel.textAlignment=NSTextAlignmentCenter;
        [downloadMap setBackgroundColor:[UIColor clearColor]];
        downloadMap.layer.cornerRadius = 0;
        [downloadMap setTitle:@"Télécharger la carte" forState:UIControlStateNormal];
        [downloadMap setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        downloadMap.titleLabel.adjustsFontSizeToFitWidth = true;
        downloadMap.showsTouchWhenHighlighted = true;
        [self.view addSubview:downloadMap];
        [self.view bringSubviewToFront:downloadMap];
        downloadMap.enabled = false;
    }
    progressView.progress = progressPercentage;
    
    
    if (completedResources == expectedResources) {
        NSString *byteCount = [NSByteCountFormatter stringFromByteCount:progress.countOfBytesCompleted countStyle:NSByteCountFormatterCountStyleMemory];
        NSLog(@"Offline pack “%@” completed: %@, %llu resources", userInfo[@"name"], byteCount, completedResources);
        [progressView removeFromSuperview];
        [downloadMap removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)pack.state] forKey:@"packState"];
        //[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"DownloadMap"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UserBoughtTheMap"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    } else {
        // Otherwise, print download/verification progress.
        [downloadMap setTitle:[NSString stringWithFormat:@"Downloading the map %.0f%%.",progressPercentage * 100] forState:UIControlStateNormal];
        
        NSLog(@"Offline pack “%@” has %llu of %llu resources — %.2f%%.", userInfo[@"name"], completedResources, expectedResources, progressPercentage * 100);
    }
    
    
}

- (void)offlinePackDidReceiveError:(NSNotification *)notification {
    MGLOfflinePack *pack = notification.object;
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    NSError *error = notification.userInfo[MGLOfflinePackUserInfoKeyError];
    NSLog(@"Offline pack “%@” received error: %@", userInfo[@"name"], error.localizedFailureReason);
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UserExit"];
  
}

- (void)offlinePackDidReceiveMaximumAllowedMapboxTiles:(NSNotification *)notification {
    MGLOfflinePack *pack = notification.object;
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    uint64_t maximumCount = [notification.userInfo[MGLOfflinePackUserInfoKeyMaximumCount] unsignedLongLongValue];
    NSLog(@"Offline pack “%@” reached limit of %llu tiles.", userInfo[@"name"], maximumCount);
}
-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
        
        return YES;
        
    }
    
    else {
        
        
        return NO;
    }
}
-(UIColor*)colorWithHexString:(NSString*)hex {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (IBAction)backToDistrict:(id)sender {
    if (bounds.ne.latitude) {
        [self.mapView flyToCamera:[self.mapView cameraThatFitsCoordinateBounds:bounds edgePadding:UIEdgeInsetsMake(10, 10, 10, 10)] completionHandler:nil];
    }else{
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake( [GlobalVariables getInstance].latitudine, [GlobalVariables getInstance].longitudine);
            [self.mapView setCenterCoordinate:center zoomLevel:8 direction:0 animated:YES];
    }
    
//    [UIView animateWithDuration:0.3/1.5 animations:^{
//        self.backToDistrict.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2 , 1.2);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3/2 animations:^{
//            self.backToDistrict.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3/2 animations:^{
//                self.backToDistrict.transform = CGAffineTransformIdentity;
//            }];
//        }];
//    }];
    

//    

}
- (void) openMapCredits {
    
    [openMapCredits.layer setBorderColor:[self colorWithHexString:@"CDE7F0"].CGColor];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [openMapCredits.layer setBorderColor:[self colorWithHexString:@"569CCA"].CGColor];
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"MapCreditsController"]];
    
    
}

- (UIImage *) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)dealloc {
    // Remove offline pack observers.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}
- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSMutableString *outString;
    
    if (inputString)
    {
        outString = [[NSMutableString alloc] initWithString:inputString];
        
        if ([inputString length] > 0)
        {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString deleteCharactersInRange:r];
            }
        }
    }
    
    return outString;
}

- (NSString *)stringByDecodingXMLEntities:(NSString *)text {
    NSUInteger myLength = [text length];
    NSUInteger ampIndex = [text rangeOfString:@"&" options:NSLiteralSearch].location;
    
    if (ampIndex == NSNotFound) {
        return text;
    }
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    
    NSScanner *scanner = [NSScanner scannerWithString:text];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                //    NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
        }
        else {
            NSString *amp;
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];
        }
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}



@end
