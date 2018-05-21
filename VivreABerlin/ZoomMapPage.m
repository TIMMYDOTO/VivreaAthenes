//
//  ZoomMapPage.m
//  VivreABerlin
//
//  Created by home on 13/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "ZoomMapPage.h"
#import "GlobalVariables.h"
#import "Reachability.h"
#import "UIImageView+Network.h"
#import "AppDelegate.h"
#import "JTMaterialSpinner.h"
#import "SimpleFilesCache.h"
@interface ZoomMapPage (){
    
}

@end

@implementation ZoomMapPage

{
    NSMutableDictionary *MapInfo;
    MGLPointAnnotation *point;
    JTMaterialSpinner *spinnerview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    kAppDelegate.lockInPortrait = NO;
    
    
    
    NSURL *url = [NSURL URLWithString:@"mapbox://styles/mapbox/streets-v9"];
    self.ZoomMapView = [[MGLMapView alloc] initWithFrame:self.view.frame styleURL:url];
    
    self.ZoomMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview: self.ZoomMapView];
    [self.view bringSubviewToFront: self.ZoomMapView];
    self.ZoomMapView.delegate = self;
    
     BOOL unlockedIAP = [[NSUserDefaults standardUserDefaults] valueForKey:@"didUserPurchasedIap"];
       if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
           
           MapInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[[GlobalVariables getInstance].idOfPost stringByAppendingString:@"map"]]];
       }else{
    MapInfo = [[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[GlobalVariables getInstance].idOfPost];
       }
    
    

    NSMutableArray *location = [NSMutableArray array];
   location =  [[MapInfo valueForKey:@"practical_infos"] valueForKey:@"locations"];
    [location enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    point = [[MGLPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake([[obj valueForKey:@"lat"]doubleValue], [[obj valueForKey:@"lng"]doubleValue]);
        point.title = [obj valueForKey:@"title"];
        point.subtitle = [obj objectForKey:@"description"];
          [self.ZoomMapView addAnnotation:point];
    }];
    

    
    [self.ZoomMapView addSubview:self.closeZoomMapPage];
    [self.ZoomMapView bringSubviewToFront:self.closeZoomMapPage];
    
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 53, 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    
    [self.ZoomMapView addSubview: spinnerview];
    [self.ZoomMapView bringSubviewToFront: spinnerview];
    [spinnerview beginRefreshing];




}
- (void) mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"coordinates"];
    mapView.showsUserLocation = YES;
    MGLCoordinateBounds bounds;
    bounds.sw.latitude = [[dict valueForKey:@"sw.latitude"]doubleValue];
    bounds.sw.longitude = [[dict valueForKey:@"sw.longitude"]doubleValue];
    bounds.ne.latitude = [[dict valueForKey:@"ne.latitude"]doubleValue];
    bounds.ne.longitude =[[dict valueForKey:@"ne.longitude"]doubleValue];
    if (self.ZoomMapView.annotations.count > 1) {
            [mapView flyToCamera:[mapView cameraThatFitsCoordinateBounds:bounds edgePadding:UIEdgeInsetsMake(10, 10, 10, 10)] completionHandler:nil ];
    }
    else{
         [self.ZoomMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[MapInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue] + 0.0002, [[[MapInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue] - 0.00001) zoomLevel:16 direction:0 animated:YES];
        
    }


    
    [spinnerview endRefreshing];
    
    

    
    
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Always try to show a callout when an annotation is tapped.
    return true;
}
- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    if(![[NSString stringWithFormat:@"%@",[MapInfo valueForKey:@"post_thumbnail_url"]] isEqualToString:@"0"]){
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75.f, 70.f)];
        
        NSString* webName = [[NSString stringWithFormat:@"%@",[MapInfo valueForKey:@"post_thumbnail_url"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
        [imageview loadImageFromURL:url placeholderImage:nil cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[GlobalVariables getInstance].idOfPost]];
        
        if(!imageview.image){
            return nil;
            
        }
        
        return imageview;
        
        
    }
    
    return nil;
    
    
}


- (IBAction)closeZoomMapPage:(id)sender {
    
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        kAppDelegate.lockInPortrait = YES;
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    
    
}
-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
        NSLog(@"User has internet");
        return YES;
        
    }
    
    else {
        NSLog(@"User doesn't have internet");
        
        return NO;
    }
}
@end
