//
//  AppDelegate.h
//  VivreABerlin
//
//  Created by Stoica Mihail on 19/04/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define kMainViewController (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController
#define kNavigationController (NavigationController *)[(MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController rootViewController]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, setter=setLockInPortrait:)BOOL lockInPortrait;

@end

