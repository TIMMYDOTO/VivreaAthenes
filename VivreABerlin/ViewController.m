//
//  ViewController.m
//  VivreABerlin
//
//  Created by Stoica Mihail on 19/04/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "GlobalVariables.h"
#import "lastPostCellHomeView.h"
#import "Header.h"
#import "UIImageView+Network.h"
#import "Reachability.h"
#import "SimpleFilesCache.h"
#import "DMCircularScrollView.h"
#import "AdsCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import <QuartzCore/QuartzCore.h>
#import "OnboardinInitialViewController.h"
#import "ContainerViewController.h"
#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height <= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

@interface ViewController ()

@end


@implementation ViewController

{
    NSDictionary *homeDictionary;
    NSDictionary *offlineHomeDictonary;
    NSMutableArray *sliderContentText;
    NSMutableArray *sliderPostTitles;
    NSMutableArray *sliderImagesUrls;
    NSMutableArray *sliderImagesData;
    
    NSMutableArray *lastPostContent;
    NSMutableArray *lastPostCategoryName;
    NSMutableArray *lastPostCategoryTitleName;
    NSMutableArray *lastPostsUrlImages;
    NSMutableArray *lastPostsColors;
    
    int scrollPosition;
    
    NSArray *threePageScroller_Views;
    DMCircularScrollView* threePageScrollView;
    UIRefreshControl *refreshControl;
    NSMutableArray *arrayWithUrlImageAds;
    NSMutableArray *arrayWithUrlAds;
    
    NSMutableArray *allimages;
    NSMutableArray *allDescriptions;
    NSMutableArray *allTitles;
    BOOL offlineModeOn;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"Viewcontroller12");
    allimages = [[NSMutableArray alloc]init];
    allDescriptions = [[NSMutableArray alloc]init];
    allTitles = [[NSMutableArray alloc]init];
    
    if(([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
        self.newsLetter.hidden = true;
        self.openIapImage.hidden = false;
        offlineModeOn = true;
    }
    else{
        self.newsLetter.hidden = false;
      //  self.openIapImage.hidden = true;
        offlineModeOn = false;
    }

    self.collectionViewDots.scrollEnabled = false;
   // [self.viewControllerSrollView setContentInset:UIEdgeInsetsMake(-self.logoIcon.frame.size.height/3.1, 0, 0, 0)];
    
    [GlobalVariables getInstance].comingFrom = @"Home";
    
   // [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    self.logoIcon.image = [UIImage imageNamed:@"logo1"];
    self.logoIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.logoIcon.clipsToBounds = true;
    self.rainbowHome.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbowHome.clipsToBounds = true;
     [self.viewControllerSrollView bringSubviewToFront:self.logoIcon];
    [self.viewControllerSrollView bringSubviewToFront:self.rainbowHome];
   
    
    self.newsLetter.contentMode = UIViewContentModeScaleAspectFill;
    self.newsLetter.clipsToBounds = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Spin)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self Spin];
    
    
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    
    
    if(hour >=20){
        self.changeableBackground.image =[UIImage imageNamed:@"BackgroundNight"];
        if (self.changeableBackground.image == nil){
            self.changeableBackground.image = [UIImage imageNamed:@"BackgroundDay"];
        }
    }
    else {
        self.changeableBackground.image = [UIImage imageNamed:@"BackgroundDay"];
        if (self.changeableBackground.image == nil){
            self.changeableBackground.image = [UIImage imageNamed:@"BackgroundNight"];
        }
    }
    
    
    
    self.changeableBackground.clipsToBounds = true;
    self.changeableBackground.contentMode = UIViewContentModeScaleAspectFill;
    
    
    
    offlineHomeDictonary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"homeDictionary"];
    
    sliderContentText = [[NSMutableArray alloc]init];
    sliderPostTitles = [[NSMutableArray alloc] init];
    sliderImagesUrls = [[NSMutableArray alloc]init];
    sliderImagesData = [[NSMutableArray alloc]init];
    
    lastPostContent = [[NSMutableArray alloc]init];
    lastPostCategoryName = [[NSMutableArray alloc]init];
    lastPostCategoryTitleName = [[NSMutableArray alloc]init];
    lastPostsUrlImages = [[NSMutableArray alloc]init];
    lastPostsColors = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 5 ; i++) {
        
        
        [sliderContentText addObject:[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"post_content"][i]];
        [sliderPostTitles addObject:[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"post_title"][i]];
        [sliderImagesUrls addObject:[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"thumbnail_url"][i]];
        
        
    }
    
    for(int i = 0; i < [[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"] valueForKey:@"post_content"] count]; i++) {
//        NSLog(@"%d", [[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"] valueForKey:@"post_content"][i]);
        [lastPostContent addObject:[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"] valueForKey:@"post_content"][i]];
        [lastPostCategoryName addObject:[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"name"][i]];
        [lastPostCategoryTitleName addObject:[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"] valueForKey:@"post_title"][i]];
        [lastPostsUrlImages addObject:[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"thumbnail_url"][i]];
        [lastPostsColors addObject:[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"category_color"][i]];
    }
    
    arrayWithUrlImageAds = [[NSMutableArray alloc] init];
    arrayWithUrlAds = [[NSMutableArray alloc] init];
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    for(int i = 0 ; i < [[offlineHomeDictonary valueForKey:@"ads"] count];i++){
        [arrayWithUrlImageAds addObject:[[offlineHomeDictonary valueForKey:@"ads"] valueForKey:@"ad_image"][i]];
        [arrayWithUrlAds addObject:[[offlineHomeDictonary valueForKey:@"ads"] valueForKey:@"ad_url"][i]];
    }
    
    
    threePageScrollView = [[DMCircularScrollView alloc] initWithFrame:CGRectMake(self.randomLastPostPerCategory.frame.origin.x, self.sliderScrollView.frame.origin.y , self.sliderScrollView.frame.size.width, self.sliderScrollView.frame.size.height)];
    threePageScrollView.pageWidth = self.sliderScrollView.frame.size.width;
    threePageScroller_Views = [self generateSampleUIViews];
    
    threePageScrollView.backgroundColor = [UIColor clearColor];
    [threePageScrollView setPageCount:[threePageScroller_Views count]
                       withDataSource:^UIView *(NSUInteger pageIndex) {
                           
                           return [threePageScroller_Views objectAtIndex:pageIndex];
                       }];
    
    //                 [UIView animateWithDuration:0.3 animations:^{
    //                    [threePageScrollView relayoutPageItems:1];
    //                 } completion:^(BOOL finished) {
    //                 }];
    
    
    threePageScrollView.handlePageChange =  ^(NSUInteger currentPageIndex,NSUInteger previousPageIndex) {
        NSLog(@"PAGE HAS CHANGED. CURRENT PAGE IS %lu (prev=%lu)", (unsigned long)currentPageIndex, (unsigned long)previousPageIndex);
        scrollPosition = (int) currentPageIndex;
        [self.collectionViewDots reloadData];
    };
    
    [self.viewControllerSrollView addSubview:threePageScrollView];
    [self.viewControllerSrollView bringSubviewToFront:threePageScrollView];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //NEWCODE
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"showStartUpScreens"]){
            // UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
            //                                                     bundle:nil];
            OnboardinInitialViewController *add =
            [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardinInitialViewController"];
            
            [self presentViewController:add
                               animated:YES
                             completion:nil];
        }
        
        self.randomLastPostPerCategory.bounces = false;
        self.randomLastPostPerCategory.scrollEnabled = false;
        self.viewControllerSrollView.showsVerticalScrollIndicator = false;
        
        
        
        CGRect frame = self.randomLastPostPerCategory.frame;
        frame.size.height = self.randomLastPostPerCategory.contentSize.height;
        self.randomLastPostPerCategory.frame = frame;
        
        
        self.viewControllerSrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.randomLastPostPerCategory.frame.origin.y + self.randomLastPostPerCategory.frame.size.height + self.logoIcon.frame.size.height/2.5);
        
        if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
        {
        [self.viewControllerSrollView addPullToRefreshWithActionHandler:^{
          
            [self refreshTable];
           
                 } position:SVPullToRefreshPositionBottom];
        }
        

        
    });
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) ) {
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"SectionTAGONCE"]) {
            
            [GlobalVariables getInstance].sectionTagTickets = [[NSUserDefaults standardUserDefaults] objectForKey:@"SectionTAGONCE"];
            [GlobalVariables getInstance].sectionTagNameTickets = [[NSUserDefaults standardUserDefaults] objectForKey:@"sectionTagNameTickets"];
            
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            
            [self makingRequest:HomePageLink];
            NSDictionary *resultForSlugsAndBoolForAds = [self makingRequestForAds:settingsData];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [GlobalVariables getInstance].allCategoriesName = [[NSMutableArray alloc]init];
                [GlobalVariables getInstance].allCategoriesSlugs = [[NSMutableArray alloc]init];
                
                if([[[resultForSlugsAndBoolForAds objectForKey:@"ads"] objectForKey:@"active"] intValue] == 1){
                    [GlobalVariables getInstance].canDisplayInterstitials = YES;
                    [GlobalVariables getInstance].delayBetweenInterstitials = [[[resultForSlugsAndBoolForAds objectForKey:@"ads"] objectForKey:@"delay"] intValue];
                    
                }
                else
                    [GlobalVariables getInstance].canDisplayInterstitials = NO;
            
                for(int i = 0 ; i < [[resultForSlugsAndBoolForAds objectForKey:@"main_categories"] count]; i++){
                    [[GlobalVariables getInstance].allCategoriesName addObject:[[resultForSlugsAndBoolForAds objectForKey:@"main_categories"][i] objectForKey:@"name"]];
                    [[GlobalVariables getInstance].allCategoriesSlugs addObject:[[resultForSlugsAndBoolForAds objectForKey:@"main_categories"][i] objectForKey:@"slug"]];
                }
                
                if ([[[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"section_tickets"] intValue] == 0 ) {
                    
                    
                    
                    [GlobalVariables getInstance].canDisplayTicketsWebView = false;
                    [GlobalVariables getInstance].sectionTagTickets = [[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"section_tag"];
                    
                    if([[[resultForSlugsAndBoolForAds objectForKey:@"gyg"] allKeys] containsObject:@"full_name_tag"])
                        [GlobalVariables getInstance].sectionTagNameTickets = [[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"full_name_tag"];
                }
                else {
                    [GlobalVariables getInstance].canDisplayTicketsWebView = true;
                    [GlobalVariables getInstance].sectionTagTickets = nil;
                    [GlobalVariables getInstance].sectionTagNameTickets = nil;
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:[GlobalVariables getInstance].sectionTagTickets forKey:@"SectionTAGONCE"];
                 [[NSUserDefaults standardUserDefaults] setObject:[GlobalVariables getInstance].sectionTagNameTickets forKey:@"sectionTagNameTickets"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) )
                    [[NSUserDefaults standardUserDefaults] setObject:homeDictionary forKey:@"homeDictionary"];
                
                
                
                
            });
        
//        });
    }
        else {
         
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                [GlobalVariables getInstance].sectionTagTickets = [[NSUserDefaults standardUserDefaults] objectForKey:@"SectionTAGONCE"];
                
                [GlobalVariables getInstance].sectionTagNameTickets = [[NSUserDefaults standardUserDefaults] objectForKey:@"sectionTagNameTickets"];
                
                [self makingRequest:HomePageLink];
                NSDictionary *resultForSlugsAndBoolForAds = [self makingRequestForAds:settingsData];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [GlobalVariables getInstance].allCategoriesName = [[NSMutableArray alloc]init];
                    [GlobalVariables getInstance].allCategoriesSlugs = [[NSMutableArray alloc]init];
                    
                    if([[[resultForSlugsAndBoolForAds objectForKey:@"ads"] objectForKey:@"active"] intValue] == 1){
                        [GlobalVariables getInstance].canDisplayInterstitials = YES;
                        [GlobalVariables getInstance].delayBetweenInterstitials = [[[resultForSlugsAndBoolForAds objectForKey:@"ads"] objectForKey:@"delay"] intValue];
                    }
                    else
                        [GlobalVariables getInstance].canDisplayInterstitials = NO;
                    
                    for(int i = 0 ; i < [[resultForSlugsAndBoolForAds objectForKey:@"main_categories"] count]; i++){
                        [[GlobalVariables getInstance].allCategoriesName addObject:[[resultForSlugsAndBoolForAds objectForKey:@"main_categories"][i] objectForKey:@"name"]];
                        [[GlobalVariables getInstance].allCategoriesSlugs addObject:[[resultForSlugsAndBoolForAds objectForKey:@"main_categories"][i] objectForKey:@"slug"]];
                    }
                    
                    if ([[[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"section_tickets"] intValue] == 0 ) {
                        [GlobalVariables getInstance].canDisplayTicketsWebView = false;
                        [GlobalVariables getInstance].sectionTagTickets = [[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"section_tag"];
                        
                      
                        
                        if([[[resultForSlugsAndBoolForAds objectForKey:@"gyg"] allKeys] containsObject:@"full_name_tag"])
                             [GlobalVariables getInstance].sectionTagNameTickets = [[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"full_name_tag"];
                    }
                    else {
                        [GlobalVariables getInstance].canDisplayTicketsWebView = true;
                        [GlobalVariables getInstance].sectionTagTickets = nil;
                        [GlobalVariables getInstance].sectionTagNameTickets = nil;
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[GlobalVariables getInstance].sectionTagTickets forKey:@"SectionTAGONCE"];
                    [[NSUserDefaults standardUserDefaults] setObject:[GlobalVariables getInstance].sectionTagNameTickets forKey:@"sectionTagNameTickets"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) )
                        [[NSUserDefaults standardUserDefaults] setObject:homeDictionary forKey:@"homeDictionary"];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[GlobalVariables getInstance].sectionTagTickets forKey:@"SectionTAGONCE"];
                    [[NSUserDefaults standardUserDefaults] setObject:[GlobalVariables getInstance].sectionTagNameTickets forKey:@"sectionTagNameTickets"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                });
                
            });
                    
            
                    
                    
            
                
           
        }
    }
    
    
}

-(void)refreshTable{
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) ) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self makingRequest:HomePageLink];
  
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
                    [[NSUserDefaults standardUserDefaults] setObject:homeDictionary forKey:@"homeDictionary"];
                offlineHomeDictonary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"homeDictionary"];
                
                self.changeableBackground.clipsToBounds = true;
                self.changeableBackground.contentMode = UIViewContentModeScaleAspectFill;
                
                sliderContentText = [[NSMutableArray alloc]init];
                sliderImagesUrls = [[NSMutableArray alloc]init];
                sliderImagesData = [[NSMutableArray alloc]init];
                sliderPostTitles = [[NSMutableArray alloc]init];
                
                lastPostContent = [[NSMutableArray alloc]init];
                lastPostCategoryName = [[NSMutableArray alloc]init];
                lastPostCategoryTitleName = [[NSMutableArray alloc]init];
                lastPostsUrlImages = [[NSMutableArray alloc]init];
                lastPostsColors = [[NSMutableArray alloc]init];
                
                for (int i = 0; i < 5 ; i++) {
                    
                    
                    
                    [sliderContentText addObject:[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"post_content"][i]];
                    [sliderImagesUrls addObject:[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"thumbnail_url"][i]];
                     [sliderPostTitles addObject:[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"post_title"][i]];
                    
                    
                }
                
                arrayWithUrlImageAds = [[NSMutableArray alloc] init];
                arrayWithUrlAds = [[NSMutableArray alloc] init];
                if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
                for(int i = 0 ; i < [[offlineHomeDictonary valueForKey:@"ads"] count];i++){
                    [arrayWithUrlImageAds addObject:[[offlineHomeDictonary valueForKey:@"ads"] valueForKey:@"ad_image"][i]];
                    [arrayWithUrlAds addObject:[[offlineHomeDictonary valueForKey:@"ads"] valueForKey:@"ad_url"][i]];
                }
                
                for(int i = 0 ; i <[[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"] valueForKey:@"post_content"] count] ;i++) {
                    
                    [lastPostContent addObject:[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"] valueForKey:@"post_content"][i]];
                    [lastPostCategoryName addObject:[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"name"][i]];
                    [lastPostCategoryTitleName addObject:[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"] valueForKey:@"post_title"][i]];
                    [lastPostsUrlImages addObject:[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"thumbnail_url"][i]];
                    [lastPostsColors addObject:[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"category_color"][i]];
                }
                
                [self.randomLastPostPerCategory reloadData];
                
                 [self.viewControllerSrollView.pullToRefreshView stopAnimating];
                
                int i  = 0;
                int k  = 0;
                int z = 0;
                for(UIImageView *newImage in allimages)
                {
                    [newImage loadImageFromURL: [NSURL URLWithString: sliderImagesUrls[i]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"ID"][i]]];
                    i++;
                }
                
                for(UILabel *description in allDescriptions)
                {
                    description.text = [NSString stringWithFormat:@"%@",[self stringByDecodingXMLEntities:[self stringByStrippingHTML:sliderContentText[k]]]];
                    description.text = [description.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    description.text = [[description.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                    description.text = [description.text stringByReplacingOccurrencesOfString:@"[article sponsorisé]" withString:@""];
                    
                    k++;
                }
                
                for(UILabel *title in allTitles)
                {
                    title.text = [NSString stringWithFormat:@"%@",[self stringByDecodingXMLEntities:[self stringByStrippingHTML:sliderPostTitles[z]]]];
                    title.text = [title.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    title.text = [[title.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                    title.text = [title.text stringByReplacingOccurrencesOfString:@"[article sponsorisé]" withString:@""];
                    
                    z++;
                }
         
                
                
                
                [refreshControl endRefreshing];
                
                
                
            });
            
        });
        
        
    }
    else {
        [self.viewControllerSrollView.pullToRefreshView stopAnimating];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
-(void)viewWillAppear:(BOOL)animated{
    [self Spin];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cell";
    
    UICollectionViewCell *celll = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    celll.backgroundColor = [UIColor lightGrayColor];
    CGRect newframe = celll.frame;
    newframe.size.height = 7;
    newframe.size.width = 7;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        newframe.size.height = 13;
        newframe.size.width = 13;
        
    }
    celll.frame = newframe;
    
    
    if (indexPath.row ==  scrollPosition) {
        celll.backgroundColor = [UIColor colorWithRed:65/255.0f green:169/255.0f blue:204/255.0f alpha:1];
        CGRect newframe = celll.frame;
        newframe.size.height = 8;
        newframe.size.width = 8;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            newframe.size.height = 15;
            newframe.size.width = 15;
            
        }
        
        
        celll.frame = newframe;
    }
    
    celll.layer.cornerRadius = celll.frame.size.width/2;
    
    celll.clipsToBounds = true;
    
    
    return celll;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lastPostCategoryName.count + arrayWithUrlImageAds.count;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0 && scrollView == self.viewControllerSrollView) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
}
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
    if(arrayWithUrlImageAds.count == 2 && (indexPath.row ==  7 || indexPath.row == 3)){
        return self.view.frame.size.width/1.7;
    }
       else if(arrayWithUrlImageAds.count == 1 && indexPath.row ==  7)
           return self.view.frame.size.width/1.7;
    else if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    return 140;
    }
    else if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    
        if(arrayWithUrlImageAds.count == 2 && (indexPath.row ==  7 || indexPath.row == 3)){
            return self.view.frame.size.width/2.2;
        }
        else if(arrayWithUrlImageAds.count == 1 && indexPath.row ==  7)
            return self.view.frame.size.width/2.2;
        else 
            return 220;
    
    }
    return  0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"lastPostCellHomeView";
    
    lastPostCellHomeView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(arrayWithUrlImageAds.count == 1){
        
        if(indexPath.row >=0 && indexPath.row <7){
            
            static NSString *CellIdentifier = @"lastPostCellHomeView";
            
            lastPostCellHomeView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.lastCategoryNameTable.text = lastPostCategoryName[indexPath.row];
            NSString *stringWithoutSpaces = [lastPostsColors[indexPath.row]
                                             stringByReplacingOccurrencesOfString:@"#" withString:@""];
            cell.cellBackground.backgroundColor = [self colorWithHexString:stringWithoutSpaces];
            
            [cell.lastPostPicutreTable loadImageFromURL: [NSURL URLWithString: lastPostsUrlImages[indexPath.row]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row]]];
            
            
            cell.lastPostContentTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostContent[indexPath.row]]];
            cell.lastPostContentTable.text = [[cell.lastPostContentTable.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            cell.lastCategoryTitleTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostCategoryTitleName[indexPath.row]]];
            cell.lastPostPicutreTable.contentMode = UIViewContentModeScaleAspectFill;
            cell.lastCategoryNameTable.clipsToBounds = true;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else if(indexPath.row == 7) {
            static NSString *CellIdentifier = @"AdsCell";
            
            AdsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            [cell.adsImage loadImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",arrayWithUrlImageAds[0]]] placeholderImage: nil cachingKey:[[NSString stringWithFormat:@"%@", arrayWithUrlImageAds[0]] substringFromIndex: [[NSString stringWithFormat:@"%@", arrayWithUrlImageAds[0]] length] - 20]];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.adsImage.layer.cornerRadius = 7;
            cell.adsImage.contentMode = UIViewContentModeScaleAspectFill;
            cell.adsImage.clipsToBounds = true;
            
            UIButton * buton = [[UIButton alloc]initWithFrame:cell.contentView.frame];
            [buton addTarget:self action:@selector(AdsClicked1) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:buton];
            [cell.contentView bringSubviewToFront:buton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        else if(indexPath.row >7) {
            
            static NSString *CellIdentifier = @"lastPostCellHomeView";
            
            lastPostCellHomeView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.lastCategoryNameTable.text = lastPostCategoryName[indexPath.row-1];
            NSString *stringWithoutSpaces = [lastPostsColors[indexPath.row-1]
                                             stringByReplacingOccurrencesOfString:@"#" withString:@""];
            cell.cellBackground.backgroundColor = [self colorWithHexString:stringWithoutSpaces];
            
            [cell.lastPostPicutreTable loadImageFromURL: [NSURL URLWithString: lastPostsUrlImages[indexPath.row-1]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row-1]]];
            
            
            cell.lastPostContentTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostContent[indexPath.row-1]]];
            cell.lastPostContentTable.text = [[cell.lastPostContentTable.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            cell.lastCategoryTitleTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostCategoryTitleName[indexPath.row-1]]];
            
            cell.lastPostPicutreTable.contentMode = UIViewContentModeScaleAspectFill;
            cell.lastCategoryNameTable.clipsToBounds = true;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
        
    }
    else if(arrayWithUrlImageAds.count == 2){
        if(indexPath.row >=0 && indexPath.row <3){
            
            static NSString *CellIdentifier = @"lastPostCellHomeView";
            
            lastPostCellHomeView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.lastCategoryNameTable.text = lastPostCategoryName[indexPath.row];
            NSString *stringWithoutSpaces = [lastPostsColors[indexPath.row]
                                             stringByReplacingOccurrencesOfString:@"#" withString:@""];
            cell.cellBackground.backgroundColor = [self colorWithHexString:stringWithoutSpaces];
            
            [cell.lastPostPicutreTable loadImageFromURL: [NSURL URLWithString: lastPostsUrlImages[indexPath.row]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row]]];
            
            
            cell.lastPostContentTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostContent[indexPath.row]]];
            cell.lastPostContentTable.text = [[cell.lastPostContentTable.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            cell.lastCategoryTitleTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostCategoryTitleName[indexPath.row]]];
            cell.lastPostPicutreTable.contentMode = UIViewContentModeScaleAspectFill;
            cell.lastCategoryNameTable.clipsToBounds = true;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else if(indexPath.row == 3){
            
            static NSString *CellIdentifier = @"AdsCell";
            
            AdsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            [cell.adsImage loadImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",arrayWithUrlImageAds[0]]] placeholderImage: nil cachingKey:[[NSString stringWithFormat:@"%@", arrayWithUrlImageAds[0]] substringFromIndex: [[NSString stringWithFormat:@"%@", arrayWithUrlImageAds[0]] length] - 20]];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.adsImage.layer.cornerRadius = 7;
            cell.adsImage.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.adsImage.clipsToBounds = true;
            
            UIButton * buton = [[UIButton alloc]initWithFrame:cell.contentView.frame];
            [buton addTarget:self action:@selector(AdsClicked1) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:buton];
            [cell.contentView bringSubviewToFront:buton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }
        if(indexPath.row >3 && indexPath.row <7){
            
            static NSString *CellIdentifier = @"lastPostCellHomeView";
            
            lastPostCellHomeView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.lastCategoryNameTable.text = lastPostCategoryName[indexPath.row-1];
            NSString *stringWithoutSpaces = [lastPostsColors[indexPath.row-1]
                                             stringByReplacingOccurrencesOfString:@"#" withString:@""];
            cell.cellBackground.backgroundColor = [self colorWithHexString:stringWithoutSpaces];
            
            [cell.lastPostPicutreTable loadImageFromURL: [NSURL URLWithString: lastPostsUrlImages[indexPath.row-1]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row-1]]];
            cell.lastPostPicutreTable.contentMode = UIViewContentModeScaleAspectFill;
            cell.lastCategoryNameTable.clipsToBounds = true;
            
            cell.lastPostContentTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostContent[indexPath.row-1]]];
            cell.lastPostContentTable.text = [[cell.lastPostContentTable.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            cell.lastCategoryTitleTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostCategoryTitleName[indexPath.row-1]]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else if( indexPath.row == 7) {
            static NSString *CellIdentifier = @"AdsCell";
            
            AdsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            [cell.adsImage loadImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",arrayWithUrlImageAds[1]]] placeholderImage: nil cachingKey:[[NSString stringWithFormat:@"%@", arrayWithUrlImageAds[1]] substringFromIndex: [[NSString stringWithFormat:@"%@", arrayWithUrlImageAds[1]] length] - 20]];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.adsImage.layer.cornerRadius = 7;
            cell.adsImage.contentMode = UIViewContentModeScaleAspectFill;
            cell.adsImage.clipsToBounds = true;
            
            UIButton * buton = [[UIButton alloc]initWithFrame:cell.contentView.frame];
            [buton addTarget:self action:@selector(AdsClicked2) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:buton];
            [cell.contentView bringSubviewToFront:buton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
         else if(indexPath.row >7) {
            
            static NSString *CellIdentifier = @"lastPostCellHomeView";
            
            lastPostCellHomeView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.lastCategoryNameTable.text = lastPostCategoryName[indexPath.row-2];
            NSString *stringWithoutSpaces = [lastPostsColors[indexPath.row-2]
                                             stringByReplacingOccurrencesOfString:@"#" withString:@""];
            cell.cellBackground.backgroundColor = [self colorWithHexString:stringWithoutSpaces];
            
            [cell.lastPostPicutreTable loadImageFromURL: [NSURL URLWithString: lastPostsUrlImages[indexPath.row-2]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row-2]]];
            
            
            cell.lastPostContentTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostContent[indexPath.row-2]]];
            cell.lastPostContentTable.text = [[cell.lastPostContentTable.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            cell.lastCategoryTitleTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostCategoryTitleName[indexPath.row-2]]];
            
            cell.lastPostPicutreTable.contentMode = UIViewContentModeScaleAspectFill;
            cell.lastCategoryNameTable.clipsToBounds = true;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.row == 7){
        return cell;
    }
    else {
     
        static NSString *CellIdentifier = @"lastPostCellHomeView";
        
        lastPostCellHomeView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.lastCategoryNameTable.text = lastPostCategoryName[indexPath.row];
        NSString *stringWithoutSpaces = [lastPostsColors[indexPath.row]
                                         stringByReplacingOccurrencesOfString:@"#" withString:@""];
        cell.cellBackground.backgroundColor = [self colorWithHexString:stringWithoutSpaces];
        
        [cell.lastPostPicutreTable loadImageFromURL: [NSURL URLWithString: lastPostsUrlImages[indexPath.row]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row]]];
        
        
        cell.lastPostContentTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostContent[indexPath.row]]];
        cell.lastPostContentTable.text = [[cell.lastPostContentTable.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        cell.lastCategoryTitleTable.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:lastPostCategoryTitleName[indexPath.row]]];
        
        
        cell.lastPostPicutreTable.contentMode = UIViewContentModeScaleAspectFill;
        cell.lastCategoryNameTable.clipsToBounds = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
    if(arrayWithUrlImageAds.count == 2){
        if(indexPath.row >= 0 && indexPath.row < 3) {

            [GlobalVariables getInstance].idOfPost =[[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row]stringValue];
            [GlobalVariables getInstance].comingFrom = @"Home";
            [GlobalVariables getInstance].comingFromViewController = @"ViewController";
             [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];


        }
        else if(indexPath.row > 3 && indexPath.row < 7) {

            [GlobalVariables getInstance].idOfPost =[[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row-1]stringValue];
            [GlobalVariables getInstance].comingFrom = @"Home";
            [GlobalVariables getInstance].comingFromViewController = @"ViewController";
             [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];


        }
        else if(indexPath.row > 7 && indexPath.row < 10) {

            [GlobalVariables getInstance].idOfPost =[[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row-2]stringValue];
            [GlobalVariables getInstance].comingFrom = @"Home";
            [GlobalVariables getInstance].comingFromViewController = @"ViewController";
             [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];


        }
    }
    else if(arrayWithUrlImageAds.count == 1){

        if(indexPath.row >= 0 && indexPath.row < 7) {

            [GlobalVariables getInstance].idOfPost =[[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row]stringValue];
            [GlobalVariables getInstance].comingFrom = @"Home";
            [GlobalVariables getInstance].comingFromViewController = @"ViewController";
             [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];


        }
        else if(indexPath.row > 7) {

            [GlobalVariables getInstance].idOfPost =[[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row-1]stringValue];
            [GlobalVariables getInstance].comingFrom = @"Home";
            [GlobalVariables getInstance].comingFromViewController = @"ViewController";
             [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];


        }


    }
    else {

            [GlobalVariables getInstance].idOfPost =[[[[offlineHomeDictonary valueForKey:@"categories"] valueForKey:@"latest_post"]valueForKey:@"ID"][indexPath.row]stringValue];
            [GlobalVariables getInstance].comingFrom = @"Home";
        [GlobalVariables getInstance].comingFromViewController = @"ViewController";
             [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];





    }

    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return self.view.frame.size.height/3.65;
//}


-(void)makingRequest:(NSString *)url
{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) )
        homeDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
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

- (NSString *)stringByDecodingXMLEntities:(NSString *)text {
    NSUInteger myLength = [text length];
    NSUInteger ampIndex = [text rangeOfString:@"&" options:NSLiteralSearch].location;
    
    if (ampIndex == NSNotFound) {
        return text;
    }
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    
    NSScanner *scanner = [NSScanner scannerWithString:text];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
        }
        else {
            NSString *amp;
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];
        }
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}

- (IBAction)menuButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}

- (IBAction)openNewsletter:(id)sender {
    NSLog(@"newLter");
//    if(offlineModeOn == false){
//
//    [UIView animateWithDuration:0.1 animations:^{
//        self.newsLetter.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.15 animations:^{
//            self.newsLetter.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.15 animations:^{
//                self.newsLetter.transform = CGAffineTransformIdentity;
//
//
//            }];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PopUpNewsletterController"]];
//        }];
//
//    }];
//    }
//    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"IAPViewController"]];
//    }

}

- (IBAction)openMenu:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}

- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSMutableString *outString;
    
    if (inputString)
    {
        outString = [[NSMutableString alloc] initWithString:inputString];
        
        if ([inputString length] > 0)
        {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString deleteCharactersInRange:r];
            }
        }
    }
    
    return outString;
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
-(void)viewDidAppear:(BOOL)animated{
    
    for (int i = 0 ; i < 8; i++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [self tableView: self.randomLastPostPerCategory cellForRowAtIndexPath: path];
    }
    
    
    
}
- (void) ClickAPost: (UIButton*) button {
    
    NSInteger tag = button.tag;
    
    [GlobalVariables getInstance].idOfPost = [[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"ID"][tag]stringValue];
    [GlobalVariables getInstance].comingFrom = @"Home";
    [GlobalVariables getInstance].comingFromViewController = @"ViewController";
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
                 [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
}
- (NSMutableArray *) generateSampleUIViews {
    
    NSMutableArray *views_list = [[NSMutableArray alloc] init];
    
    for (NSUInteger k = 0; k < 5; k++) {
        
        
        
        UILabel *description;
        UIImageView *imageCat;
        UILabel *title;
        UIView *back_view;
        UIView *titleSubView;
        
        self.postTitleSubView.hidden = YES;
        back_view = [[UIView alloc] initWithFrame: self.sliderScrollView.frame];
        
        titleSubView = [[UIView alloc] initWithFrame:self.postTitleSubView.frame];
        titleSubView.backgroundColor = self.postTitleSubView.backgroundColor;
        titleSubView.layer.cornerRadius = self.postTitleSubView.layer.cornerRadius;
        titleSubView.clipsToBounds = true;
        
        
        imageCat = [[UIImageView alloc] initWithFrame: self.sliderImage.frame];
        
        [imageCat loadImageFromURL: [NSURL URLWithString: sliderImagesUrls[k]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [NSString stringWithFormat:@"%@Thumbnail",[[offlineHomeDictonary valueForKey:@"slider_posts"] valueForKey:@"ID"][k]]];
        
        imageCat.layer.cornerRadius = imageCat.frame.size.width/8;
        imageCat.contentMode = UIViewContentModeScaleAspectFill;
        imageCat.clipsToBounds = true;
        
        [allimages addObject:imageCat];
        
        
        description = [[UILabel alloc] initWithFrame: self.sliderText.frame];
        title = [[UILabel alloc] initWithFrame: self.sliderTitlePost.bounds];
        title.font = self.sliderTitlePost.font;
        title.textColor = self.sliderTitlePost.textColor;
        title.textAlignment = NSTextAlignmentCenter;
        
        description.text = [NSString stringWithFormat:@"%@",[self stringByDecodingXMLEntities:[self stringByStrippingHTML:sliderContentText[k]]]];
        title.text = [NSString stringWithFormat:@"%@",[self stringByDecodingXMLEntities:[self stringByStrippingHTML:sliderPostTitles[k]]]];
        
        description.numberOfLines = 7;
        description.lineBreakMode = NSLineBreakByTruncatingTail;
        description.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.f];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
         
             description.font = [UIFont fontWithName:@"Montserrat-Regular" size:20.f];
            
        }
        
        description.text = [description.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        description.text = [[description.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        description.text = [description.text stringByReplacingOccurrencesOfString:@"[article sponsorisé]" withString:@""];
        
        title.text = [title.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        title.text = [[title.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        title.text = [title.text stringByReplacingOccurrencesOfString:@"[article sponsorisé]" withString:@""];
        
        back_view.backgroundColor = [UIColor clearColor];
        
        [allDescriptions addObject:description];
        [allTitles addObject:title];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, description.frame.origin.x + description.frame.size.width, back_view.frame.size.height)];
        button.tag = k;
        [button addTarget:self
                   action:@selector(ClickAPost:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [back_view addSubview:titleSubView];
        [back_view addSubview:description];
        [back_view addSubview:title];
        [back_view addSubview: imageCat];
        [back_view addSubview:button];
        
        [back_view bringSubviewToFront: description];
        [back_view bringSubviewToFront: imageCat];
        [back_view bringSubviewToFront: button];
        [back_view bringSubviewToFront: title];
        [back_view bringSubviewToFront: titleSubView];
        
        button.backgroundColor = [UIColor clearColor];
        [views_list addObject: back_view];
        
    }
    
    
    
    return views_list;
}
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//
//    if (!self.randomLastPostPerCategory.layer.mask)
//    {
//        CAGradientLayer *maskLayer = [CAGradientLayer layer];
//
//        maskLayer.locations = @[[NSNumber numberWithFloat:0.0],
//                                [NSNumber numberWithFloat:0.075],
//                                [NSNumber numberWithFloat:1.0],
//                                [NSNumber numberWithFloat:1.0]];
//
//        maskLayer.bounds = CGRectMake(0, 0,
//                                      self.randomLastPostPerCategory.frame.size.width,
//                                      self.randomLastPostPerCategory.frame.size.height);
//        maskLayer.anchorPoint = CGPointZero;
//
//        self.randomLastPostPerCategory.layer.mask = maskLayer;
//    }
//    [self scrollViewDidScroll:self.randomLastPostPerCategory];
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
//    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
//
//
//    NSArray *colors;
//
//    if (scrollView.contentOffset.y + scrollView.contentInset.top <= 0) {
//        //Top of scrollView
//        colors = @[(__bridge id)innerColor, (__bridge id)innerColor,
//                   (__bridge id)innerColor, (__bridge id)outerColor];
//    } else if (scrollView.contentOffset.y + scrollView.frame.size.height
//               >= scrollView.contentSize.height) {
//        //Bottom of tableView
//        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
//                   (__bridge id)innerColor, (__bridge id)outerColor];
//    } else {
//        //Middle
//        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
//                   (__bridge id)innerColor, (__bridge id)outerColor];
//    }
//    ((CAGradientLayer *)scrollView.layer.mask).colors = colors;
//
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    scrollView.layer.mask.position = CGPointMake(0, scrollView.contentOffset.y);
//    [CATransaction commit];
//}

-(void)Spin{
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainbowHome.layer addAnimation:animation forKey:@"SpinAnimation"];
    [self.rainbowHome setImage:[UIImage imageNamed:@"rainbow"]];
    if(([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
        self.newsLetter.hidden = true;
        self.openIapImage.hidden = false;
        offlineModeOn = true;
    }
    else{
       // self.newsLetter.hidden = false;
       // self.openIapImage.hidden = true;
        offlineModeOn = false;
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"YES"]){
       // self.newsLetter.hidden = false;
       // self.openIapImage.hidden = true;
        offlineModeOn = false;
    }

}

-(void)AdsClicked1{
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayWithUrlAds objectAtIndex:0]]]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayWithUrlAds objectAtIndex:0]]]];
    
}
-(void)AdsClicked2{
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayWithUrlAds objectAtIndex:1]]]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayWithUrlAds objectAtIndex:1]]]];
    
}
@end
