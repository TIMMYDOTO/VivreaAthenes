//
//  OnboardingViewController.h
//  VivreABerlin
//
//  Created by home on 16/11/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OnboardingViewController : UIViewController <UIScrollViewDelegate, CLLocationManagerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *onBoardingScroll;
@property (weak, nonatomic) IBOutlet UIView *pinkCircle;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
- (IBAction)previousPage:(id)sender;
- (IBAction)nextPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
