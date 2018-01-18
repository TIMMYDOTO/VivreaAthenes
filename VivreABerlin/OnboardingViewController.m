//
//  OnboardingViewController.m
//  VivreABerlin
//
//  Created by home on 16/11/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingFirstViewController.h"
#import "OnboardinInitialViewController.h"
@interface OnboardingViewController ()

@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pinkCircle.layer.cornerRadius = self.pinkCircle.frame.size.height/2;
    self.pinkCircle.clipsToBounds = true;
    self.leftView.layer.cornerRadius = self.leftView.frame.size.height/2;
    self.leftView.clipsToBounds = true;
    self.rightView.layer.cornerRadius = self.rightView.frame.size.height/2;
    self.rightView.clipsToBounds = true;
    self.midView.layer.cornerRadius = self.midView.frame.size.height/2;
    self.midView.clipsToBounds = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(deleteScreen) name:@"DeleteSecondScreen" object:nil];
    
    NSMutableAttributedString *attributedString;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        attributedString = [[NSMutableAttributedString alloc] initWithString:@"Trouvez les meilleures adresses" attributes:@{
                                                                                                                             NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Medium" size: 40.0f],
                                                                                                                             NSForegroundColorAttributeName: [UIColor colorWithRed:57.0f / 255.0f green:57.0f / 255.0f blue:83.0f / 255.0f alpha:1.0f]
                                                                                                                             }];
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Montserrat-Bold" size: 40.0f] range:NSMakeRange(12, 10)];
     }
     else{
     attributedString = [[NSMutableAttributedString alloc] initWithString:@"Trouvez les meilleures adresses" attributes:@{
                                                                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Medium" size: 31.0f],
                                                                                                                                                    NSForegroundColorAttributeName: [UIColor colorWithRed:57.0f / 255.0f green:57.0f / 255.0f blue:83.0f / 255.0f alpha:1.0f]
                                                                                                                                                    }];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Montserrat-Bold" size: 31.0f] range:NSMakeRange(12, 10)];
     }
    
    
    
    self.myTitle.attributedText = attributedString;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.gradientView.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor whiteColor].CGColor,
                            //(id)[UIColor whiteColor].CGColor,
                            (id)[UIColor colorWithRed:255/255.0f green:222/255.0f blue:200/255.0f alpha:1.0f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                              // [NSNumber numberWithFloat:0.3f],
                               [NSNumber numberWithFloat:0.7f],
                               nil];
    
    [self.gradientView.layer addSublayer:gradientLayer];
    
    
    
}
-(void) deleteScreen{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previousPage:(id)sender {

    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                           self.view.alpha = 0;
                       } completion:^(BOOL finished){
                           [self willMoveToParentViewController:nil];
                           [self.view removeFromSuperview];
                           [self removeFromParentViewController];
                       }];
    
}

- (IBAction)nextPage:(id)sender {
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    
    if([self.locationManager respondsToSelector: @selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];
    
    OnboardingFirstViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingFirstViewController"];
    
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
@end
