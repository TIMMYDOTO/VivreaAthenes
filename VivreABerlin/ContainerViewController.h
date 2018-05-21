//
//  ContainerViewController.h
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBAudienceNetwork/FBAudienceNetwork.h>
@import GoogleMobileAds;


@interface ContainerViewController : UIViewController <FBInterstitialAdDelegate, GADInterstitialDelegate>
@property (nonatomic, strong) FBInterstitialAd *interstitialAd;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UIView *containerviewcontroller;
@property (weak, nonatomic) IBOutlet UIButton *firstTabBarItem;
@property (weak, nonatomic) IBOutlet UIButton *secondTabBarItem;
@property (weak, nonatomic) IBOutlet UIButton *thirdTabBarItem;
@property (weak, nonatomic) IBOutlet UIButton *forthTabBarItem;
@property (weak, nonatomic) IBOutlet UIButton *fifthTabBarItem;
- (IBAction)firstTabBarItem:(id)sender;
- (IBAction)secondTabBarItem:(id)sender;
- (IBAction)thirdTabBarItem:(id)sender;
- (IBAction)forthTabBarItem:(id)sender;
- (IBAction)fifthTabBarItem:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *frameForSpinner;
@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundTabBar;
@property (weak, nonatomic) IBOutlet UIImageView *firstTabBarImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondTabBarImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdTabBarImg;
@property (weak, nonatomic) IBOutlet UIImageView *forthTabBarImg;
@property (weak, nonatomic) IBOutlet UIImageView *fifthTabBarImg;
@property (weak, nonatomic) IBOutlet UILabel *progresslabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfLoadingScreen;
@property (weak, nonatomic) IBOutlet UIView *imageViewEffectloading;
@property (weak, nonatomic) IBOutlet UIView *frameForProgress;
@property (weak, nonatomic) IBOutlet UIImageView *loadinScreen;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
