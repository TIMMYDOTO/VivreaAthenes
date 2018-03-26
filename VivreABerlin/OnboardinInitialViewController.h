//
//  OnboardinInitialViewController.h
//  VivreABerlin
//
//  Created by home on 20/11/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardinInitialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *firstCircle;
@property (weak, nonatomic) IBOutlet UIView *secondCircle;
@property (weak, nonatomic) IBOutlet UIView *thirdCircle;
@property (weak, nonatomic) IBOutlet UILabel *firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UIButton *activateNotifications;
- (IBAction)activateNotifications:(id)sender;
- (IBAction)nextPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *notificationview;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rainBow;

@end
