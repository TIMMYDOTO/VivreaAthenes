//
//  MainViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "LeftViewController.h"
#import "AppDelegate.h"
#import "PopUpApplicationsController.h"
#import "CreditsViewController.h"

@interface MainViewController () {
    
    LeftViewController *leftViewController;
}



@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
                         presentationStyle:(LGSideMenuPresentationStyle)style
                                      type:(NSUInteger)type
{
    self = [super initWithRootViewController:rootViewController];
    
    if (self)
    {
        _type = type;
       
        // -----
        
      
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            leftViewController = [[UIStoryboard storyboardWithName:@"MainIPad" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftViewController"];
        else if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && [[UIScreen mainScreen] bounds].size.height == 812.0f)
        leftViewController = [[UIStoryboard storyboardWithName:@"MainiPhoneX" bundle: nil] instantiateViewControllerWithIdentifier:@"LeftViewController"];
        else
            leftViewController = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"LeftViewController"];
        
        
        
        // -----
        
        if (type == 0)
        {
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [self setLeftViewEnabledWithWidth:self.view.frame.size.width*0.4
                            presentationStyle:style
                         alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];
            else
                [self setLeftViewEnabledWithWidth:self.view.frame.size.width*0.7
                                presentationStyle:style
                             alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];
            
            self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
            self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;
            //           self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
            
            
            if (style == LGSideMenuPresentationStyleSlideAbove)
            {
                self.leftViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];
                
                //               leftViewController.tableView.backgroundColor = [UIColor redColor];
                //                leftViewController.tintColor = [UIColor blackColor];
                
                // -----
                
                
            }
            


            
        }
        // -----
        
        
        
        [self.leftView addSubview: leftViewController.view];
        
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(AllApsPopUp:) name:@"PopUpButtonClickedOnLeftController" object:nil];
    }
    return self;
}
-(void)AllApsPopUp: (NSNotification *) notification{
    
    if([notification.object isEqualToString:@"OpenPopUp"]){
        
        PopUpApplicationsController * child2 = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"PopUpApplicationsController"];
        
        child2.view.frame = self.view.bounds;
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
    }
    else if([notification.object isEqualToString:@"OpenPopUp2"]){
        
        CreditsViewController * child2 = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"CreditsViewController"];
        
        child2.view.frame = self.view.bounds;
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];    }
    else{
        UIViewController *vc = [self.childViewControllers lastObject];
        
        [UIView transitionWithView:self.view duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               
                               [vc willMoveToParentViewController:nil];
                               [vc.view removeFromSuperview];
                               [vc removeFromParentViewController];
                           } completion:nil];
    }
    
    
    

}
- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    if (![UIApplication sharedApplication].isStatusBarHidden && (_type == 2 || _type == 3))
        leftViewController.view.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
    else
        leftViewController.view.frame = CGRectMake(0.f , 0.f, size.width, size.height);
}


@end
