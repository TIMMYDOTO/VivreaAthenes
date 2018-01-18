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

@interface ZoomMapPage ()

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
    
    MapInfo = [[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[GlobalVariables getInstance].idOfPost];
    
    
    point = [[MGLPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([[[MapInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue], [[[MapInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue]);
    point.title = [MapInfo valueForKey:@"post_title"];
    point.subtitle = [NSString stringWithFormat:@"%@ -> %@",[[MapInfo valueForKey:@"category"]valueForKey:@"category_parent_name"], [[MapInfo valueForKey:@"category"] valueForKey:@"name"]];
    [self.ZoomMapView addAnnotation:point];

    
    if([self isInternet] == NO){
        self.ZoomMapView.maximumZoomLevel = 17;
    }
    
    [self.ZoomMapView addSubview:self.closeZoomMapPage];
    [self.ZoomMapView bringSubviewToFront:self.closeZoomMapPage];
    
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 53, 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    
    [self.ZoomMapView addSubview: spinnerview];
    [self.ZoomMapView bringSubviewToFront: spinnerview];
    [spinnerview beginRefreshing];

    if([self isInternet] == NO){
    dispatch_time_t popTimee = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTimee, dispatch_get_main_queue(), ^(void){
    [self.ZoomMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[MapInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue] + 0.0002, [[[MapInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue] - 0.00001) zoomLevel:16 direction:0 animated:YES];
        [spinnerview endRefreshing];
    });
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.ZoomMapView selectAnnotation:point animated:YES];
        
    });
    }


}
- (void) mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    
    mapView.showsUserLocation = YES;
    
    [self.ZoomMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[MapInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue] + 0.0002, [[[MapInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue] - 0.00001) zoomLevel:16 direction:0 animated:YES];
    
    [spinnerview endRefreshing];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.ZoomMapView selectAnnotation:point animated:YES];
        
    });
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Always try to show a callout when an annotation is tapped.
    return YES;
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
