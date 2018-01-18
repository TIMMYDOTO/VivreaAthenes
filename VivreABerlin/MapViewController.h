//
//  MapViewController.h
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//
@import Mapbox;
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MGLMapViewDelegate,CLLocationManagerDelegate, CLLocationManagerDelegate>


- (IBAction)showUserLocation:(id)sender;
@property (strong, nonatomic) MGLMapView * mapView;

@property (weak, nonatomic) IBOutlet UIButton *openFilters;

@property (weak, nonatomic) IBOutlet UIImageView *backToDistrict;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UILabel *popup;
@property (nonatomic) UIImageView *imagegee;
@property (weak, nonatomic) IBOutlet UIView *frameForMap;
- (IBAction)openSideMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *districtsImage;
@property (weak, nonatomic) IBOutlet UIImageView *filtersImage;
- (IBAction)OpenDistricts:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showMyLocation;
@property (weak, nonatomic) IBOutlet UIImageView *centerLocation;
- (IBAction)backToDistrict:(id)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
