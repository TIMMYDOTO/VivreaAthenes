//
//  AppDelegate.m
//  VivreABerlin
//
//  Created by Stoica Mihail on 19/04/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ContainerViewController.h"
#import "Reachability.h"
#import "GlobalVariables.h"
#import <OneSignal/OneSignal.h>
#import "Header.h"
@import GoogleMobileAds;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
  // [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"didUserPurchasedIap"];
     NSLog(@"Puchased status : %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"didUserPurchasedIap"]);
    
    [GlobalVariables getInstance].myLaunchOptions = launchOptions;
    
    // Override point for customization after application launch.
    
    // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
    
    
//    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
//        // This block gets called when the user reacts to a notification received
//        OSNotificationPayload* payload = result.notification.payload;
//
//        NSString* messageTitle = @"OneSignal Example";
//        NSString* fullMessage = [payload.body copy];
//
//        if (payload.additionalData) {
//
//            if(payload.title)
//                messageTitle = payload.title;
//
//            NSDictionary* additionalData = payload.additionalData;
//
//            if (additionalData[@"actionSelected"])
//                fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", additionalData[@"actionSelected"]]];
//        }
//
//        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:messageTitle
//                                                            message:fullMessage
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Close"
//                                                  otherButtonTitles:nil, nil];
//        [alertView show];
//
//    };

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"showStartUpScreens"]){
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"9604e532-9eb9-44f1-8c0c-68cd6cf32f02"
            handleNotificationAction:/*notificationOpenedBlock*/nil
                            settings:@{kOSSettingsKeyAutoPrompt: @false}];
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
    
    // Recommend moving the below line to prompt for push after informing the user about
    //   how your app will use them.
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        NSLog(@"User accepted notifications: %d", accepted);
    }];
    }
    
    
    
    
    // Call syncHashedEmail anywhere in your iOS app if you have the user's email.
    // This improves the effectiveness of OneSignal's "best-time" notification scheduling feature.
    // [OneSignal syncHashedEmail:userEmail];
    
    
    
    
    [GADMobileAds configureWithApplicationID:googleAppID];

    UINavigationController *navigationController;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController: (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812.0f)
    navigationController = [[UINavigationController alloc] initWithRootViewController: (UITabBarController *)[[UIStoryboard storyboardWithName:@"MainiPhoneX" bundle:nil] instantiateInitialViewController]];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        navigationController = [[UINavigationController alloc] initWithRootViewController: (UITabBarController *)[[UIStoryboard storyboardWithName:@"MainIPad" bundle:nil] instantiateInitialViewController]];
    }
    
    
    
    
    
    navigationController.navigationBar.hidden = YES;
    
    MainViewController *mainViewController = nil;
    
    mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                              presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                           type:0];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
  

    
    
    
    NSMutableAttributedString *attrStringFromHtml = [[NSMutableAttributedString alloc]
                                                     initWithData: [@"<span>html enabled</span>" dataUsingEncoding:NSUnicodeStringEncoding
                                                                                              allowLossyConversion:NO]
                                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                     documentAttributes:nil error:nil];
    NSLog(@"%@",[attrStringFromHtml string]);

    
    
    
        
//
//    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//        if (screenSize.height == 812.0f)
//       // self.window.rootViewController = [[ContainerViewController alloc] initWithNibName:@"MainiPhoneX" bundle:nil];
//    }
//  //  [self.window makeKeyAndVisible];
    
    
    
    return YES;


}


- (void) setLockInPortrait:(BOOL)lockInPortrait{
    if(lockInPortrait == YES){
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    
    _lockInPortrait = lockInPortrait;
}
-(UIInterfaceOrientationMask)application:(UIApplication* )application supportedInterfaceOrientationsForWindow:(UIWindow* )window
{
    if(self.lockInPortrait){
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
            return UIInterfaceOrientationMaskPortraitUpsideDown;
        }
        else
            return UIInterfaceOrientationMaskPortrait;
    }
    else
        return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"TriedToo"])
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UserExit"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserExit"]);
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
