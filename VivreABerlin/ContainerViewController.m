//
//  ContainerViewController.m
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "ContainerViewController.h"
#import "ViewController.h"
#import "AgendaViewController.h"
#import "MapViewController.h"
#import "AnnouncementsViewController.h"
#import "TicketsViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

#import "PopUpNewsletterController.h"
#import "PopUpApplicationsController.h"
#import "Header.h"
#import "Reachability.h"
#import "JTMaterialSpinner.h"
#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "FilterViewController.h"
#import "DistrictsViewController.h"
#import "SimpleFilesCache.h"
#import "IAPViewController.h"
#import "ScrollImageController.h"
#import "ListOfPostsController.h"
#import "ZoomMapPage.h"
#import "CatsSubCatsController.h"
#import "MapCreditsController.h"
#import "AgendaArticlePopUp.h"
#import "AddAnnouncement.h"
#import "EditAnnouncement.h"
#import "SearchAnnouncement.h"
#import "OLGhostAlertView.h"
#import "CreditsViewController.h"
#import "AstuceVC.h"
#import "PostViewController.h"
JTMaterialSpinner * spinnerView;

@interface ContainerViewController ()

@end

@implementation ContainerViewController

{
    ViewController * child1;
    NSMutableDictionary * HomePageInfos;
    Reachability* internetReachable;
    BOOL canShowAdd;
 
    IBOutlet UIView *statusView;
    
    __weak IBOutlet UIView *astuceView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    statusView.layer.zPosition = -1;

    [GlobalVariables getInstance].currentViewController = @"ViewController";
    
 
    
    canShowAdd = YES;
    NSDictionary *adsSettings = [[self makingRequestForAds:settingsData]valueForKey:@"ads"];
    BOOL section_tickets = [[[[self makingRequestForAds:settingsData]valueForKey:@"gyg"]valueForKey:@"section_tickets"]boolValue];
    [GlobalVariables getInstance].delayBetweenInterstitials = [[adsSettings valueForKey:@"delay"]intValue];

    [NSTimer scheduledTimerWithTimeInterval:[GlobalVariables getInstance].delayBetweenInterstitials
                                     target:self
                                   selector:@selector(changeShowAddStatus)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
    
    kAppDelegate.lockInPortrait = YES;
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    if([GlobalVariables getInstance].sectionTagTickets.length == 0){
 
    self.backgroundTabBar.image = [UIImage imageNamed:@"tabBarBackground"];
    self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
      
 self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
    self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
    self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
    self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
    }
    else{
        self.backgroundTabBar.image = [UIImage imageNamed:@"tabBarBackground"];
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
          self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
    }
    if (section_tickets) {
         self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
    }
    else{
          self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
    }
    self.backgroundTabBar.clipsToBounds = true;
    self.firstTabBarImg.clipsToBounds = true;
    self.secondTabBarImg.clipsToBounds = true;
    self.thirdTabBarImg.clipsToBounds = true;
    self.forthTabBarImg.clipsToBounds = true;
    self.fifthTabBarImg.clipsToBounds = true;
    
    
    self.backgroundTabBar.contentMode = UIViewContentModeScaleAspectFit;
    self.firstTabBarImg.contentMode = UIViewContentModeScaleAspectFit;
    self.secondTabBarImg.contentMode = UIViewContentModeScaleAspectFit;
    self.thirdTabBarImg.contentMode = UIViewContentModeScaleAspectFit;
    self.forthTabBarImg.contentMode = UIViewContentModeScaleAspectFit;
    self.fifthTabBarImg.contentMode = UIViewContentModeScaleAspectFit;
    
   
    [GlobalVariables getInstance].PerSession = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(SCHIMBECRAN:) name:@"NotificationMessageEvent" object:nil];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"canMakeRequestForAgenda"];
    
    self.imageViewEffectloading.hidden = true;
    self.imageOfLoadingScreen.hidden = true;
 //   NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"MapInfo"]]);
    
    if(([self isInternet] == YES) && ([NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"MapInfo"]] == nil || [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"homeDictionary"] == nil)){
        
        
        
        self.imageViewEffectloading.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        self.imageViewEffectloading.hidden = false;
        self.imageOfLoadingScreen.hidden = false;
        self.progresslabel.numberOfLines = 1;
        self.progresslabel.adjustsFontSizeToFitWidth=true;
        
        self.progressView.progressTintColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:self.frameForSpinner.frame];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        self.frameForSpinner.hidden = true;
        
        [self.imageViewEffectloading addSubview: spinnerView];
        [self.imageViewEffectloading bringSubviewToFront: spinnerView];
        
        
        
        self.loadinScreen.layer.cornerRadius = 15;
        self.loadinScreen.clipsToBounds = true;
        
        [[self.progressView layer]setFrame:self.frameForProgress.frame];
        [[self.progressView layer]setBorderColor:[UIColor darkGrayColor].CGColor];
        self.progressView.trackTintColor = [self colorWithHexString:@"f1f2f5"];
        
        [[self.progressView layer]setCornerRadius:self.progressView.frame.size.height / 2];
        self.progressView.clipsToBounds = YES;
        
        
        
        [self.view addSubview:self.progressView];
        [self.view bringSubviewToFront:self.progressView];
        
        self.frameForProgress.hidden = true;
        
        
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger hour = [components hour];
        
        
        if(hour >=20){
            self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundNight.png"];
            if (self.imageOfLoadingScreen.image == nil){
                self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundDay.png"];
            }
        }
        else {
            self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundDay.png"];
            if (self.imageOfLoadingScreen.image == nil){
                self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundNight.png"];
            }
        }
        
        self.imageOfLoadingScreen.contentMode = UIViewContentModeScaleAspectFill;
        self.imageOfLoadingScreen.clipsToBounds = true;
        
        self.loadinScreen.layer.cornerRadius = 15;
        self.loadinScreen.clipsToBounds = true;
        self.progresslabel.clipsToBounds = true;
        self.progresslabel.textColor = [UIColor blackColor];
        
        [spinnerView beginRefreshing];
        
        
        [self.progressView setProgress:0.25 animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.imageOfLoadingScreen.hidden = false;
            
            double delayInSeconds = 2.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.progressView setProgress:0.50 animated:YES];;
                
            });
            double delayInSecondss = 4.5;
            dispatch_time_t popTimee = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSecondss * NSEC_PER_SEC));
            dispatch_after(popTimee, dispatch_get_main_queue(), ^(void){
                [self.progressView setProgress:0.75 animated:YES];
                
            });
            
                
                [self makingRequestForHomePage:HomePageLink];
                [[NSUserDefaults standardUserDefaults] setObject:HomePageInfos forKey:@"homeDictionary"];
                [self makingRequestForMap:mapLink];
            
            
            
            [GlobalVariables getInstance].MapPageInfos = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"MapInfo"]]];
            
            [GlobalVariables getInstance].latitudine =[[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"initial_position"] valueForKey:@"lat"] floatValue];
            [GlobalVariables getInstance].longitudine =[[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"initial_position"] valueForKey:@"lng"] floatValue];
            
            [GlobalVariables getInstance].zoomLvl =[[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"initial_position"] valueForKey:@"zoom"] floatValue];
            [GlobalVariables getInstance].filtresIconsCaption = [[NSMutableArray alloc] init];
            
            
            [GlobalVariables getInstance].arrayWithAnnotations = [[NSMutableArray alloc]initWithArray:[[GlobalVariables getInstance].MapPageInfos valueForKey:@"categories"]];
            for ( int i = 0 ; i < 3;i++){
                for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i] count]; j ++) {
                    [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"][j] setValue:@"YES" forKey:@"isSelected"];
                    
                    
                    
                    if([[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i][j] valueForKey:@"icon_caption"]] length] >0)
                        [[GlobalVariables getInstance].filtresIconsCaption addObject:[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i][j] valueForKey:@"icon_caption"]]];
                    
                    
                    
                    
                }
            }
            
            [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:[GlobalVariables getInstance].filtresIconsCaption] withName:@"FiltresIconsCaption"];

            if([self isInternet]==YES){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    [self makingRequestForMap:mapLink];
                    
                    
                   
                    
                  //  NSLog(@"Request finished in background");
                    
                });
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.self.progressView setProgress:1.0 animated:YES];
                
                
                
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    self.imageViewEffectloading.hidden = true;
                    self.imageOfLoadingScreen.hidden = true;
                    [spinnerView endRefreshing];
                    
                  
                    ViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                    
                        child2.view.frame = self.containerviewcontroller.bounds;
                        [self addChildViewController:child2];
                        [child2 didMoveToParentViewController:self];
                        child2.view.frame = self.containerviewcontroller.bounds;
                        [self.containerviewcontroller addSubview:child2.view];
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ViewPostOnHomeTapBar"];
                   
                   
                    
                    [GlobalVariables getInstance].finishedLoading = true;
                    [GlobalVariables getInstance].comingFromForAgenda = @"Home";
                    
                    [self.progressView removeFromSuperview];
                    
                    
                    [UIView animateWithDuration:0.3/1.5 animations:^{
                        self.thirdTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2 , 1.2);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3/2 animations:^{
                            self.thirdTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.3/2 animations:^{
                                self.thirdTabBarImg.transform = CGAffineTransformIdentity;
                            }];
                        }];
                    }];
                });
                
                
                
            });
            
            
        });
    }
    
    
         else if([self isInternet] == NO  && ![[NSUserDefaults standardUserDefaults] valueForKey:@"didUserPurchasedIap"]){
    
            [self noInternetFoundAndUserDidndPaid];
    
          }
    
    
    else if([NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"MapInfo"]] != nil && [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"homeDictionary"] != nil){
        

        
        [GlobalVariables getInstance].MapPageInfos = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"MapInfo"]]];
        
        [GlobalVariables getInstance].arrayWithAnnotations = [[NSMutableArray alloc]initWithArray:[[GlobalVariables getInstance].MapPageInfos valueForKey:@"categories"]];
        [GlobalVariables getInstance].filtresIconsCaption = [[NSMutableArray alloc] init];
        for ( int i = 0 ; i < 3;i++){
            for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i] count]; j ++) {
                
                [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"][j] setValue:@"YES" forKey:@"isSelected"];
                
                
                
                if([[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i][j] valueForKey:@"icon_caption"]] length] >0)
                    [[GlobalVariables getInstance].filtresIconsCaption addObject:[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].arrayWithAnnotations valueForKey:@"subcategories"][i][j] valueForKey:@"icon_caption"]]];
                
                
            }
        }

        [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:[GlobalVariables getInstance].filtresIconsCaption] withName:@"FiltresIconsCaption"];
        
        if([self isInternet]==YES){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                [self makingRequestForMap:mapLink];
                
                //NSLog(@"Request finished in background");
                
            });
            
        }
        
        
      
            ViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            
            child2.view.frame = self.containerviewcontroller.bounds;
            [self addChildViewController:child2];
            [child2 didMoveToParentViewController:self];
            child2.view.frame = self.containerviewcontroller.bounds;
            [self.containerviewcontroller addSubview:child2.view];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ViewPostOnHomeTapBar"];
        
        
        [GlobalVariables getInstance].finishedLoading = true;
        [GlobalVariables getInstance].comingFromForAgenda = @"Home";
        
        [GlobalVariables getInstance].MapPageInfos = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"MapInfo"]]];
        
        [GlobalVariables getInstance].latitudine =[[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"initial_position"] valueForKey:@"lat"] floatValue];
        [GlobalVariables getInstance].longitudine =[[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"initial_position"] valueForKey:@"lng"] floatValue];
        
        [GlobalVariables getInstance].zoomLvl =[[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"initial_position"] valueForKey:@"zoom"] floatValue];
    }
    else{
        [self noInternetFoundAndUserDidndPaid];
    }
    
        [GlobalVariables getInstance].DictionaryWithAllPosts = [[NSMutableDictionary alloc]initWithDictionary:(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllPosts"]]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)openAstuce:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AstuceVC"]];
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable: {
           
            if(![[NSUserDefaults standardUserDefaults] valueForKey:@"didUserPurchasedIap"]){
                
                [self noInternetFoundAndUserDidndPaid];
                
            }
            else if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] ){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"MapViewController"]];
            
            }
            
            break;
        }
        case ReachableViaWiFi: {
           
          //  NSLog(@"The internet is working via WIFI.");
            if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] ){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"MapViewController"]];
                
            }
            
            
            break;
        }
        case ReachableViaWWAN: {
            //[self.bannerView loadRequest: [GADRequest request]];
          //  NSLog(@"The internet is working via WWAN.");
            
            
            break;
        }
    }
}
-(void)changeShowAddStatus{
    canShowAdd = YES;
}

-(void)noInternetFoundAndUserDidndPaid{
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    
    
    if(hour >=20){
        self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundNight.png"];
        if (self.imageOfLoadingScreen.image == nil){
            self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundDay.png"];
        }
    }
    else {
        self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundDay.png"];
        if (self.imageOfLoadingScreen.image == nil){
            self.imageOfLoadingScreen.image = [UIImage imageNamed:@"BackgroundNight.png"];
        }
    }
    
    self.imageOfLoadingScreen.contentMode = UIViewContentModeScaleAspectFill;
    self.imageOfLoadingScreen.clipsToBounds = true;
    
    self.imageViewEffectloading.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    self.imageViewEffectloading.hidden = false;
    self.imageOfLoadingScreen.hidden = false;
    
    self.progresslabel.text = @"Connexion internet requise pour accéder à l’app.";
    self.progresslabel.font = [UIFont fontWithName:@"Montserrat-Light" size:20];
    self.progresslabel.textColor = [UIColor redColor];
    self.progresslabel.numberOfLines = 0;
    [self.progresslabel sizeToFit];
    
    //self.progresslabel.adjustsFontSizeToFitWidth = true;
    
    self.progresslabel.center = self.loadinScreen.center;
    
    CGRect neworigin = self.progresslabel.frame;
    neworigin.origin.y = self.progresslabel.frame.origin.y - self.loadinScreen.frame.size.height/7;
    self.progresslabel.frame = neworigin;
   
    self.loadinScreen.layer.cornerRadius = 15;
    self.loadinScreen.clipsToBounds = true;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(GoToSetings)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OK" forState:UIControlStateNormal];
    button.frame = CGRectMake(self.progresslabel.frame.origin.x+self.progresslabel.frame.size.width/2-40, self.progresslabel.frame.origin.y+  self.progresslabel.frame.size.height*1.1 , self.loadinScreen.frame.size.width/3, self.loadinScreen.frame.size.height/6);
    
    CGPoint newPoint = button.center;
    newPoint.x = self.loadinScreen.center.x;
    button.center = newPoint;
    
    [self.imageViewEffectloading addSubview:button];
    [self.imageViewEffectloading bringSubviewToFront:button];
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 5;
    button.clipsToBounds =true;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.hidden =false;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (spinnerView.isAnimating) {
        [astuceView setHidden:YES];
      }
    else{
        [astuceView setHidden:NO];
    }
      [astuceView setFrame:CGRectMake(screenWidth/2 - 137, screenHeight - astuceView.frame.size.height - 10, 275, 87)];
    astuceView.layer.cornerRadius = 13;
    astuceView.clipsToBounds = true;
}


-(void)GoToSetings{
    NSArray* urlStrings = @[@"prefs:root=WIFI", @"App-Prefs:root=WIFI"];
    for(NSString* urlString in urlStrings){
        NSURL* url = [NSURL URLWithString:urlString];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            
            [[UIApplication sharedApplication] openURL:url];
            
            exit(0);
            
        }
    }
}




-(void) SCHIMBECRAN: (NSNotification *) notification
{

    if ([notification.object isEqualToString:@"ViewController"]  && [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ViewPostOnHomeTapBar"];
        
        if([GlobalVariables getInstance].sectionTagTickets.length == 0){
            
        
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
        self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
        [GlobalVariables getInstance].comingFromForAgenda = @"Home";
        }
        else {
            self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
            self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
            self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
            self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
            self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
            [GlobalVariables getInstance].comingFromForAgenda = @"Home";
        }
       
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"] ){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
       
        }
        
                    [GlobalVariables getInstance].comingFrom = @"Home";
        [GlobalVariables getInstance].currentViewController = @"ViewController";
        kAppDelegate.lockInPortrait = YES;
        
        
        
        
            ViewController *detailVc = [self.childViewControllers objectAtIndex:0];
            
            
            [UIView transitionWithView:self.containerviewcontroller duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                   [self.containerviewcontroller bringSubviewToFront:detailVc.view];
                               } completion:nil];
        
        
        

    }
    else if([notification.object isEqualToString:@"ViewController"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"ViewPostOnHomeTapBar"] == YES){
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ViewPostOnHomeTapBar"];
        
        [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
        
        
    }
    
    else if([notification.object isEqualToString:@"ViewController"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"ViewPostOnHomeTapBar"] != YES){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ViewPostOnHomeTapBar"];
        
        if([GlobalVariables getInstance].sectionTagTickets.length == 0){

        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
        self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
        [GlobalVariables getInstance].comingFromForAgenda = @"Home";
        }
        else {
            self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
            self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
            self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
            self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
            self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
            [GlobalVariables getInstance].comingFromForAgenda = @"Home";
        }
        
        
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"] ){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
          //  NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        
        [GlobalVariables getInstance].comingFrom = @"Home";
        [GlobalVariables getInstance].currentViewController = @"ViewController";
        kAppDelegate.lockInPortrait = YES;
        
        
        
       
            ViewController *detailVc = [self.childViewControllers objectAtIndex:0];
            
            
            [UIView transitionWithView:self.containerviewcontroller duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                   [self.containerviewcontroller bringSubviewToFront:detailVc.view];
                               } completion:nil];
        
        

    }
    else if ([notification.object isEqualToString:@"PostViewController"])
    {
        [GlobalVariables getInstance].comingFromForAgenda = @"Posts";
        kAppDelegate.lockInPortrait = YES;
      
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"]){
            
            UIViewController *vc = [self.childViewControllers lastObject];
         
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
          //   NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        
        
        PostViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
        
        child2.arrOfId = [notification.userInfo valueForKey:@"arrOfId"];
        
                   child2.view.frame = self.containerviewcontroller.bounds;
                   [self.containerviewcontroller addSubview:child2.view];
                [UIView transitionWithView:self.containerviewcontroller duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                       [self addChildViewController:child2];
                                       [child2 didMoveToParentViewController:self];
//                                       child2.view.frame = self.view.frame;
                                       [self.containerviewcontroller addSubview:child2.view];
                                   } completion:nil];
//
                [GlobalVariables getInstance].currentViewController = @"PostViewController";

//
//        child2.view.frame = self.containerviewcontroller.bounds;
//
//        [UIView transitionWithView:self.containerviewcontroller duration:0.3
//                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                               [self addChildViewController:child2];
//                               [child2 didMoveToParentViewController:self];
//                               child2.view.frame = self.view.frame;
//                               [self.containerviewcontroller addSubview:child2.view];
//                           } completion:nil];
//
//        [GlobalVariables getInstance].currentViewController = @"PostViewController";
        
        
    }
    else if ([notification.object isEqualToString:@"CatsSubCatsController"])
    {
        [GlobalVariables getInstance].comingFromForAgenda = @"CategoryPage";
        kAppDelegate.lockInPortrait = YES;
        
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"]){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
        //    NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        
        
        CatsSubCatsController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"CatsSubCatsController"];
        
        child2.view.frame = self.containerviewcontroller.bounds;
        
        
        [UIView transitionWithView:self.containerviewcontroller duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.containerviewcontroller.bounds;
                               [self.containerviewcontroller addSubview:child2.view];
                           } completion:nil];
        
        [GlobalVariables getInstance].currentViewController = @"CatsSubCatsController";
        
        
    }

    else if ([notification.object isEqualToString:@"IAPViewController"])
    {
        
        kAppDelegate.lockInPortrait = YES;
        
        
        IAPViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"IAPViewController"];
        
        child2.view.frame = self.view.bounds;
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
        
    }
    else if ([notification.object isEqualToString:@"PostViewController"])
    {
        [GlobalVariables getInstance].comingFromForAgenda = @"Posts";
        kAppDelegate.lockInPortrait = YES;
        
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"]){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
            //   NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        
        
        PostViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
        
        child2.view.frame = self.containerviewcontroller.bounds;
        
        
        [UIView transitionWithView:self.containerviewcontroller duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.containerviewcontroller.bounds;
                               [self.containerviewcontroller addSubview:child2.view];
                           } completion:nil];
        
        
        [GlobalVariables getInstance].currentViewController = @"PostViewController";
    }
    else if ([notification.object isEqualToString:@"AddAnnouncement"])
    {
        NSDictionary *userInfo = notification.userInfo;
        kAppDelegate.lockInPortrait = YES;
        NSLog(@"userInfo %@", userInfo);
        
        AddAnnouncement * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAnnouncement"];
   
        
                        child2.titleeeee = [userInfo valueForKey:@"title"];
                        child2.emailContact = [userInfo valueForKey:@"contact_email"];
                        child2.contactName = [userInfo valueForKey:@"contact_name"];
                        child2.adID = [userInfo valueForKey:@"ad_id"];
                        child2.adKey = [userInfo valueForKey:@"ad_key"];
                        child2.details = [userInfo valueForKey:@"details"];
        
                        child2.canBeDeleted = YES;
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
    }
    else if ([notification.object isEqualToString:@"editAdAnnouncement"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSLog(@"userInfo %@", userInfo);
        kAppDelegate.lockInPortrait = YES;
        
           [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"EditAnnouncement"] userInfo: userInfo];
 
        
        
    }
    else if ([notification.object isEqualToString:@"PopUpApplications"])
    {
        
        kAppDelegate.lockInPortrait = YES;
        
        
        PopUpApplicationsController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpApplicationsController"];
        
        child2.view.frame = self.view.bounds;
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
    }
    else if ([notification.object isEqualToString:@"CreditsViewController"])
    {
        
        kAppDelegate.lockInPortrait = YES;
        
        
         CreditsViewController* child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditsViewController"];
        
        child2.view.frame = self.view.bounds;
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
    }
    else if ([notification.object isEqualToString:@"AstuceVC"])
    {
        
        kAppDelegate.lockInPortrait = YES;
        
        
        AstuceVC* child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AstuceVC"];
        
        child2.view.frame = self.view.bounds;
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
    }
    else if ([notification.object isEqualToString:@"EditAnnouncement"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSLog(@"userInfo %@", userInfo);
        kAppDelegate.lockInPortrait = YES;
        
        
        EditAnnouncement * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"EditAnnouncement"];
        
        child2.view.frame = self.view.bounds;
        child2.emailfield.text = [userInfo objectForKey:@"contact_email"];
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
        
    }

    else if ([notification.object isEqualToString:@"SearchAnnouncement"])
    {
        
        kAppDelegate.lockInPortrait = YES;
        
        
        SearchAnnouncement * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchAnnouncement"];
        
        child2.view.frame = self.view.bounds;
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
        
    }

    else if ([notification.object isEqualToString:@"ListOfPostsController"])
    {
         
        kAppDelegate.lockInPortrait = YES;
        
        [GlobalVariables getInstance].comingFromForAgenda = @"Search";
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"]){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
        }

        
        
        ListOfPostsController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ListOfPostsController"];
        
        child2.view.frame = self.containerviewcontroller.bounds;
        
        
        [UIView transitionWithView:self.containerviewcontroller duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.containerviewcontroller.bounds;
                               [self.containerviewcontroller addSubview:child2.view];
                           } completion:nil];
        
        [GlobalVariables getInstance].currentViewController = @"ListOfPostsController";
        
        
        
    }
    else if ([notification.object isEqualToString:@"AgendaViewController"])
    {

        kAppDelegate.lockInPortrait = YES;
        
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"]){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
         //     NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        
        [GlobalVariables getInstance].currentViewController = @"AgendaViewController";
        
        AgendaViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AgendaViewController"];
       
        child2.view.frame = self.containerviewcontroller.bounds;
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIconTouched"];
        self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
        
        
        [UIView transitionWithView:self.containerviewcontroller duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.containerviewcontroller.bounds;
                               [self.containerviewcontroller addSubview:child2.view];
                               
                           } completion:nil];
        
    }
    
    else if ([notification.object isEqualToString:@"MapViewController"])
    {
        
        
        [GlobalVariables getInstance].comingFromForAgenda = @"Map";
        kAppDelegate.lockInPortrait = YES;
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
//        self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIconTouched"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"] ){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
        //      NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        
        [GlobalVariables getInstance].currentViewController = @"MapViewController";
        
        
        MapViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        
        child2.view.frame = self.containerviewcontroller.bounds;
        
        
        
        [self addChildViewController:child2];
        [child2 didMoveToParentViewController:self];
        child2.view.frame = self.containerviewcontroller.bounds;
        [self.containerviewcontroller addSubview:child2.view];
        
        
        
        
        
    }
    else if ([notification.object isEqualToString:@"AnnouncementsViewController"])
    {

         [GlobalVariables getInstance].comingFromForAgenda = @"Announcements";
        
        kAppDelegate.lockInPortrait = YES;
        
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"]){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
        //      NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        [GlobalVariables getInstance].currentViewController = @"AnnouncementsViewController";
        
        AnnouncementsViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementsViewController"];
        
        child2.view.frame = self.containerviewcontroller.bounds;
        
        [UIView transitionWithView:self.containerviewcontroller duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.containerviewcontroller.bounds;
                               [self.containerviewcontroller addSubview:child2.view];
                           } completion:nil];
        

        
       
        
        
    }
    else if ([notification.object isEqualToString:@"TicketsViewController"])
    {
        
        if([self isInternet] == YES){
        [GlobalVariables getInstance].comingFromForAgenda = @"Tickets";
        kAppDelegate.lockInPortrait = YES;
        
        if([[GlobalVariables getInstance].currentViewController isEqualToString:@"MapViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"] || [[GlobalVariables getInstance].currentViewController isEqualToString:@"ListOfPostsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"CatsSubCatsController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AgendaViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"AnnouncementsViewController"]  || [[GlobalVariables getInstance].currentViewController isEqualToString:@"TicketsViewController"]){
            
            UIViewController *vc = [self.childViewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
         //     NSLog(@"%@ Controller sters ------------------------------------------",[GlobalVariables getInstance].currentViewController);
        }
        
        [GlobalVariables getInstance].currentViewController = @"TicketsViewController";
        
        TicketsViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"TicketsViewController"];
        
        child2.view.frame = self.containerviewcontroller.bounds;
        
        [UIView transitionWithView:self.containerviewcontroller duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.containerviewcontroller.bounds;
                               [self.containerviewcontroller addSubview:child2.view];
                           } completion:nil];
        
        }
        else{
            
             [self showMessage:@"Connexion internet requise"];
        }
        
        
        
    }
    else if ([notification.object isEqualToString:@"ScrollImageController"])
    {
        
        ScrollImageController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ScrollImageController"];
        
        child2.view.frame = self.view.bounds;
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
        
    }
    else if ([notification.object isEqualToString:@"MapCreditsController"])
    {
        
        MapCreditsController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MapCreditsController"];
        
        child2.view.frame = self.view.bounds;
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
        
    }

    else if ([notification.object isEqualToString:@"ZoomMapPage"])
    {
        
        ZoomMapPage * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ZoomMapPage"];
        
        child2.view.frame = self.view.bounds;
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
        
    }
    else if ([notification.object isEqualToString:@"PopUpNewsletterController"])
    {

        

        
        PopUpNewsletterController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpNewsletterController"];
        
        child2.view.frame = self.view.bounds;
        
        
        
        
        [self addChildViewController:child2];
        [child2 didMoveToParentViewController:self];
        child2.view.frame = self.view.bounds;
        [self.view addSubview:child2.view];

        
    }
    else if ([notification.object isEqualToString:@"AgendaArticlePopUp"])
    {
        
        kAppDelegate.lockInPortrait = YES;
        
        AgendaArticlePopUp * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AgendaArticlePopUp"];
        
        child2.view.frame = self.view.bounds;
        
        
        
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [self addChildViewController:child2];
                               [child2 didMoveToParentViewController:self];
                               child2.view.frame = self.view.bounds;
                               [self.view addSubview:child2.view];
                           } completion:nil];
        
        
    }
    else if ([notification.object isEqualToString:@"closePopUp"])
    {
        
        kAppDelegate.lockInPortrait = YES;
        
        UIViewController *vc = [self.childViewControllers lastObject];
        
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               
                               [vc willMoveToParentViewController:nil];
                               [vc.view removeFromSuperview];
                               [vc removeFromParentViewController];
                        } completion:nil];

    }
       else if ([notification.object isEqualToString:@"menuButton"])
        [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
    

}

- (IBAction)firstTabBarItem:(id)sender {

    if(canShowAdd && [GlobalVariables getInstance].canDisplayInterstitials){
        self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:facebookInterstitialID];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAd];
      
        canShowAdd = NO;
    }
    if([GlobalVariables getInstance].sectionTagTickets.length == 0){
    self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIconTouched"];
    self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
    self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
    self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
    self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
    }
    else {
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIconTouched"];
        self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.firstTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.firstTabBarImg.transform = CGAffineTransformIdentity;
            
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AgendaViewController"]];
}

- (IBAction)secondTabBarItem:(id)sender {
    
    if(canShowAdd && [GlobalVariables getInstance].canDisplayInterstitials){
        self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:@"167997730311966_358154934629577"];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAd];
        canShowAdd = NO;
    }
    if([GlobalVariables getInstance].sectionTagTickets.length == 0){
    self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
    self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIconTouched"];
    self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
    self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
        
    }
    else {
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
        self.secondTabBarImg.image = [UIImage imageNamed:@"SelectedHearth"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.secondTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.secondTabBarImg.transform = CGAffineTransformIdentity;
            
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"TicketsViewController"]];
}

- (IBAction)thirdTabBarItem:(id)sender {
    
    if(canShowAdd && [GlobalVariables getInstance].canDisplayInterstitials){
        self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:@"167997730311966_358154934629577"];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAd];
        canShowAdd = NO;
    }
     if([GlobalVariables getInstance].sectionTagTickets.length == 0){
    self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
    self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
    self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
    self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
    self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
     }
     else {
         self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
         self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
         self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIconTouched"];
         self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
         self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
     }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ViewController"]];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.thirdTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2 , 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.thirdTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.thirdTabBarImg.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (IBAction)forthTabBarItem:(id)sender {
    
    if(canShowAdd && [GlobalVariables getInstance].canDisplayInterstitials){
        self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:@"167997730311966_358154934629577"];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAd];
        canShowAdd = NO;
    }
    if([GlobalVariables getInstance].sectionTagTickets.length == 0){
    self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
    self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
    self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
    self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIconTouched"];
        NSLog(@"elf.forthTabBarImg.image %@", self.forthTabBarImg.image);
    self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
    }
    else {
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
        self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIconTouched"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIcon"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        self.forthTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.forthTabBarImg.transform = CGAffineTransformIdentity;
            
        }];
    }];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"MapViewController"]];
    
}

- (IBAction)fifthTabBarItem:(id)sender {
    
    if(canShowAdd && [GlobalVariables getInstance].canDisplayInterstitials){
        self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:@"167997730311966_358154934629577"];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAd];
        canShowAdd = NO;
    }
    if([GlobalVariables getInstance].sectionTagTickets.length == 0){
    self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
    self.secondTabBarImg.image = [UIImage imageNamed:@"ticketTabBarIcon"];
    self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
    self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
    self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIconTouched"];
    }
    else {
        self.firstTabBarImg.image = [UIImage imageNamed:@"agendaTabBarIcon"];
        self.secondTabBarImg.image = [UIImage imageNamed:@"deselectedHearth"];
        self.thirdTabBarImg.image = [UIImage imageNamed:@"homeTabBarIcon"];
        self.forthTabBarImg.image = [UIImage imageNamed:@"mapTabBarIcon"];
        self.fifthTabBarImg.image = [UIImage imageNamed:@"announcementsTabBarIconTouched"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.fifthTabBarImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.fifthTabBarImg.transform = CGAffineTransformIdentity;
            
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AnnouncementsViewController"]];
    
}



-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
      //  NSLog(@"User has internet");
        return YES;
        
    }
    
    else {
      //  NSLog(@"User doesn't have internet");
        
        return NO;
    }
}

-(NSDictionary *)makingRequestForAds:(NSString *)url
{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    NSLog(@"jsonFileUrl %@", jsonFileUrl);
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
}
-(void)makingRequestForHomePage:(NSString *)url
{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    if([self isInternet] == YES){
    HomePageInfos = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
        
    }
}

-(void)makingRequestForMap:(NSString *)url
{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError]
                    ];
    
    if([self isInternet] == YES){
    [SimpleFilesCache saveToCacheDirectory:data withName:@"MapInfo"];
    }
    
    
    
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    // Check whether it implements a dummy methods called canRotate
    
    
    // Only allow portrait (standard behaviour)
    return UIInterfaceOrientationMaskPortrait;
}

-(UIColor*)colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
-(void)showMessage: (NSString *)content{
    
    OLGhostAlertView *demo = [[OLGhostAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", content] message:nil timeout:1 dismissible:YES];
    demo.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:14.0 ];
    demo.titleLabel.textColor = [UIColor whiteColor];
    demo.backgroundColor =  [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];;
    demo.bottomContentMargin = 50;
    demo.layer.cornerRadius = 7;
    
    [demo show];
    
    
}
- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"Ad is loaded and ready to be displayed");
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // You can now display the full screen ad using this code:
    [interstitialAd showAdFromRootViewController:self];
}
- (void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"The user sees the add");
    // Use this function as indication for a user's impression on the ad.
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"The user clicked on the ad and will be taken to its destination");
    // Use this function as indication for a user's click on the ad.
}

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"The user clicked on the close button, the ad is just about to close");
    // Consider to add code here to resume your app's flow
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    NSLog(@"Interstitial had been closed");
    if([[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"]){
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"CanAddObjectToCarousel"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
    }
    
    // Consider to add code here to resume your app's flow
}
- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"Ad failed to load");
    NSLog(@"%@",[error localizedDescription]);
    
    
    self.interstitial = [self createAndLoadInterstitial];
    
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:googleInterstitialID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}


- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd");
    [self.interstitial presentFromRootViewController:self];

}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    if([[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"CanAddObjectToCarousel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
    }
    NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    NSLog(@"interstitialDidDismissScreen");
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}
@end

