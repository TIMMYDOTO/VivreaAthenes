//
//  OnboardinInitialViewController.m
//  VivreABerlin
//
//  Created by home on 20/11/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "OnboardinInitialViewController.h"
#import "OnboardingViewController.h"
#import <OneSignal/OneSignal.h>
#import "GlobalVariables.h"
@interface OnboardinInitialViewController ()

@end

@implementation OnboardinInitialViewController
{
    BOOL activated;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    activated = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(deleteScreen) name:@"DeleteFirstScreen" object:nil];
    
    self.firstCircle.layer.cornerRadius = self.firstCircle.frame.size.height/2;
    self.firstCircle.clipsToBounds = true;
    self.secondCircle.layer.cornerRadius = self.secondCircle.frame.size.height/2;
    self.secondCircle.clipsToBounds = true;
    self.thirdCircle.layer.cornerRadius = self.thirdCircle.frame.size.height/2;
    self.thirdCircle.clipsToBounds = true;
    
    self.activateNotifications.layer.cornerRadius = 7;
    self.activateNotifications.clipsToBounds = true;
    self.notificationview.layer.cornerRadius = 7;
    self.notificationview.clipsToBounds = true;
    
    self.leftView.layer.cornerRadius = self.leftView.frame.size.height/2;
    self.leftView.clipsToBounds = true;
    self.middleView.layer.cornerRadius = self.middleView.frame.size.height/2;
    self.middleView.clipsToBounds = true;
    self.rightView.layer.cornerRadius = self.rightView.frame.size.height/2;
    self.rightView.clipsToBounds = true;
    
    self.notificationview.layer.masksToBounds = NO;
    self.notificationview.layer.shadowOffset = CGSizeMake(0, 7);
    self.notificationview.layer.shadowRadius = 3;
    self.notificationview.layer.shadowOpacity = 0.15;
    
    self.activateNotifications.layer.masksToBounds = NO;
    self.activateNotifications.layer.shadowOffset = CGSizeMake(0, 2);
    self.activateNotifications.layer.shadowRadius = 1;
    self.activateNotifications.layer.shadowOpacity = 0.15;
    
    self.logoIcon.image = [UIImage imageNamed:@"Logo.png"];
    self.rainBow.image = [UIImage imageNamed:@"rainbow.png"];
    self.logoIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.logoIcon.clipsToBounds = true;
    self.rainBow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainBow.clipsToBounds = true;
    [self.notificationview bringSubviewToFront:self.rainBow];
    [self.notificationview bringSubviewToFront:self.logoIcon];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Spin)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
 
    
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
    
    NSMutableAttributedString *attributedString;
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        attributedString = [[NSMutableAttributedString alloc] initWithString:@"Recevez en premier les actus de votre ville en activant les notifications !" attributes:@{
                                                                                                                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Medium" size: 22.0f],
                                                                                                                                                                                                    NSForegroundColorAttributeName: [UIColor colorWithRed:57.0f / 255.0f green:57.0f / 255.0f blue:83.0f / 255.0f alpha:1.0f]
                                                                                                                                                                                                    }];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Montserrat-Bold" size: 22.0f] range:NSMakeRange(47, 28)];
        
    }
    else {
        attributedString = [[NSMutableAttributedString alloc] initWithString:@"Recevez en premier les actus de votre ville en activant les notifications !" attributes:@{
                                                                                                                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Medium" size: 38.0f],
                                                                                                                                                                                                    NSForegroundColorAttributeName: [UIColor colorWithRed:57.0f / 255.0f green:57.0f / 255.0f blue:83.0f / 255.0f alpha:1.0f]
                                                                                                                                                                                                    }];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Montserrat-Bold" size: 38.0f] range:NSMakeRange(47, 28)];
    }
    
    self.secondTitle.attributedText = attributedString;
}

-(void) viewWillAppear:(BOOL)animated{
    [self Spin];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) deleteScreen{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)activateNotifications:(id)sender {
    [OneSignal initWithLaunchOptions:[GlobalVariables getInstance].myLaunchOptions
                               appId:@"9604e532-9eb9-44f1-8c0c-68cd6cf32f02"
            handleNotificationAction:/*notificationOpenedBlock*/nil
                            settings:@{kOSSettingsKeyAutoPrompt: @false}];
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
    
    // Recommend moving the below line to prompt for push after informing the user about
    //   how your app will use them.
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        NSLog(@"User accepted notifications: %d", accepted);
        activated = YES;
    }];
    
}

- (IBAction)nextPage:(id)sender {
    
    if (!activated) {
        [OneSignal initWithLaunchOptions:[GlobalVariables getInstance].myLaunchOptions
                                   appId:@"9604e532-9eb9-44f1-8c0c-68cd6cf32f02"
                handleNotificationAction:/*notificationOpenedBlock*/nil
                                settings:@{kOSSettingsKeyAutoPrompt: @false}];
        OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
            NSLog(@"User accepted notifications: %d", accepted);
            activated = YES;
        }];
    }
    OnboardingViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
    
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
-(void)Spin{
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainBow.layer addAnimation:animation forKey:@"SpinAnimation"];
    
}
@end
