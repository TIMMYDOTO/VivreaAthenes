//
//  CatsSubCatsController.m
//  VivreABerlin
//
//  Created by home on 14/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "CatsSubCatsController.h"
#import "lastPostCellHomeView.h"
#import "Header.h"
#import "GlobalVariables.h"
#import "JTMaterialSpinner.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "Reachability.h"
#import "SimpleFilesCache.h"
#import "UIImageView+Network.h"
#import "CatsSubCatsCell.h"
#import "UIImage+animatedGIF.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>
@interface CatsSubCatsController ()

@end

@implementation CatsSubCatsController
{
    JTMaterialSpinner *spinnerView;
    NSMutableArray *allArticlesFromCategory;
    BOOL allArticlesReached;
    NSMutableDictionary *Dictionary;
    int Page;
    NSMutableArray *nativeAdsImage;
    NSMutableArray *nativeAdsDestionation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nativeAdsImage = [[NSMutableArray alloc]init];
    nativeAdsDestionation = [[NSMutableArray alloc]init];
    
    if([GlobalVariables getInstance].backToPostHasToBeHidden != YES)
        self.backToPost.hidden = YES;
    
    NSLog(@"CAT SLUG NAME IS :%@",[GlobalVariables getInstance].subCatSlugNumber);
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"YES"])
        self.offlineButton.hidden = YES;
    
    allArticlesReached = false;
    self.noArticlesFound.hidden = YES;
    
    self.catsSubCatsTable.delegate = self;
    self.catsSubCatsTable.dataSource = self;
    
    self.catsSubCatsScroll.delegate = self;
    
    [self.catsSubCatsTable setContentInset:UIEdgeInsetsMake(self.logo.frame.size.height/3.5 + 5,0,0,0)];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:243/255.0f blue:246/255.0f alpha:1.0f];
    
    
    Page = 1;
    
    spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 53, 45, 45)];
    spinnerView.circleLayer.lineWidth = 3.0;
    spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Spin)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    [self Spin];
    
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    
    
    if(hour >=20){
        self.changableBackground.image =[UIImage imageNamed:@"BackgroundNight.png"];
        if (self.changableBackground.image == nil){
            self.changableBackground.image = [UIImage imageNamed:@"BackgroundDay.png"];
        }
    }
    else {
        self.changableBackground.image = [UIImage imageNamed:@"BackgroundDay.png"];
        if (self.changableBackground.image == nil){
            self.changableBackground.image = [UIImage imageNamed:@"BackgroundNight.png"];
        }
    }
    
    self.authorView.hidden = YES;
    if([GlobalVariables getInstance].backGroundImageTag){
        NSString *bg = [[[GlobalVariables getInstance].backGroundImageTag componentsSeparatedByString:@"lala"] objectAtIndex:0];
        NSString *key = [[[GlobalVariables getInstance].backGroundImageTag componentsSeparatedByString:@"lala"] objectAtIndex:1];
        NSString *author = [[[GlobalVariables getInstance].backGroundImageTag componentsSeparatedByString:@"lala"] objectAtIndex:2];
        if(![bg isEqualToString:@"32"]){
        [self.changableBackground loadImageFromURL:[NSURL URLWithString:bg] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:key];
            
        UIButton *button = [[UIButton alloc] initWithFrame:self.changableBackground.bounds];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self
                   action:@selector(ClickedTheBG)
         forControlEvents:UIControlEventTouchUpInside];
        [self.catsSubCatsScroll addSubview:button];
        [self.catsSubCatsScroll bringSubviewToFront: button];
        
            [GlobalVariables getInstance].zoomingImageClickedFromTagAgenda = YES;
        }
        self.authorView.hidden = NO;
        self.authorOfBg.text = author;
        self.authorOfBg.numberOfLines = 2;
        
        if([author isEqualToString:@"123123"])
            self.authorView.hidden = YES;
        
    }
    
    self.categoryName.adjustsFontSizeToFitWidth = true;
    self.changableBackground.clipsToBounds = true;
    self.changableBackground.contentMode = UIViewContentModeScaleAspectFill;
    self.logo.image = [UIImage imageNamed:@"logo1"];
    
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    self.logo.clipsToBounds = true;
    
    self.rainbow.image = [UIImage imageNamed:@"rainbow.png"];
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
     [self.view bringSubviewToFront:self.logo];
    [self.view bringSubviewToFront:self.rainbow];
   
   
    
    self.catsSubCatsTable.scrollEnabled = false;
    self.catsSubCatsTable.showsVerticalScrollIndicator = false;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"]){
        self.categoryName.text = [GlobalVariables getInstance].slugName;
        self.categoryName.textColor = [UIColor darkGrayColor];
    }
    else if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"]){
        self.categoryName.text = [GlobalVariables getInstance].slugName;
        self.categoryName.textColor = [UIColor darkGrayColor];
    }
    else{
        self.categoryName.text = [GlobalVariables getInstance].nameOfcatSubCat;
    self.categoryName.textColor = [self colorWithHexString:[GlobalVariables getInstance].categoryColor];
    }
    
    
    allArticlesFromCategory = [[NSMutableArray alloc]init];
    
    if([self isInternet] == YES){
        
        [self.view addSubview:spinnerView];
        [self.view bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *adsDictionary;
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"]) {
                [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:postsFromTag,[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"],[NSString stringWithFormat:@"%d",Page]]];
            }
            else if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"]) {
                [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:postsFromTag,[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"],[NSString stringWithFormat:@"%d",Page]]];
                NSLog(@"post from tag %@", [NSString stringWithFormat:postsFromTag,[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"],[NSString stringWithFormat:@"%d",Page]]);
            }
            else {
                NSLog(@"%@", [NSString stringWithFormat:categoryLink,[GlobalVariables getInstance].idOfcatSubCat,[NSString stringWithFormat:@"%d",Page]]);
                [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:categoryLink,[GlobalVariables getInstance].idOfcatSubCat,[NSString stringWithFormat:@"%d",Page]]];
                
                adsDictionary = [self requestForNativeAds:[NSString stringWithFormat:categoryAdsLink,[GlobalVariables getInstance].subCatSlugNumber]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (int i = 0; i < [[adsDictionary valueForKey:@"ads"]count]; i++){
                    [nativeAdsImage addObject:[[adsDictionary valueForKey:@"ads"][i] valueForKey:@"ad_image"]];
                    [nativeAdsDestionation addObject:[[adsDictionary valueForKey:@"ads"][i] valueForKey:@"ad_url"]];
                }
                if([NSNull null] != [Dictionary objectForKey:@"results"]) {
                NSLog(@"results count %lu",[[Dictionary valueForKey:@"results"] count]);
                for(int i = 0 ; i < [[Dictionary valueForKey:@"results"] count]; i++)
                    [allArticlesFromCategory addObject:[Dictionary valueForKey:@"results"][i]];
                }
                
                if(Page == [[NSString stringWithFormat:@"%@",[Dictionary valueForKey:@"pages"]] intValue])
                {
                    allArticlesReached = true;
                }
                else
                    Page = 2;
                [self.catsSubCatsTable reloadData];
                
                [spinnerView endRefreshing];
                
                CGRect frame = self.catsSubCatsTable.frame;
                frame.size.height = self.catsSubCatsTable.contentSize.height;
                self.catsSubCatsTable.frame = frame;
                
                
                self.catsSubCatsScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.catsSubCatsTable.frame.origin.y + self.catsSubCatsTable.frame.size.height);
                
                
                
                
            });
        });
        
        self.catsSubCatsScroll.showsInfiniteScrolling = YES;
        
        
        [self.catsSubCatsScroll addInfiniteScrollingWithActionHandler:^{
            
            // NSLog(@"New request");
            
            
            if([self isInternet] == YES && allArticlesReached == false){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"]) {
                        [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:postsFromTag,[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"],[NSString stringWithFormat:@"%d",Page]]];
                    }
                    else if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"]) {
                        [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:postsFromTag,[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"],[NSString stringWithFormat:@"%d",Page]]];
                    }
                    else{
                        [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:categoryLink,[GlobalVariables getInstance].idOfcatSubCat,[NSString stringWithFormat:@"%d",Page]]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        //      NSLog(@"%@",Dictionary);
                        
                        
                        if([[Dictionary valueForKey:@"results"] count] > 0){
                            for(int i = 0 ; i < [[Dictionary valueForKey:@"results"] count]; i++){
                                
                                [allArticlesFromCategory addObject:[Dictionary valueForKey:@"results"][i]];
                                
                            }
                            
                            [self.catsSubCatsTable reloadData];
                            
                        }
                        if(Page == [[NSString stringWithFormat:@"%@",[Dictionary valueForKey:@"pages"]] intValue])
                        {
                            
                            allArticlesReached = true;
                        }
                        else
                            Page ++;
                        
                        CGRect frame = self.catsSubCatsTable.frame;
                        frame.size.height = self.catsSubCatsTable.contentSize.height;
                        self.catsSubCatsTable.frame = frame;
                        
                        if(Page == [[NSString stringWithFormat:@"%@",[Dictionary valueForKey:@"pages"]] intValue])
                            self.catsSubCatsScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.catsSubCatsTable.frame.origin.y + self.catsSubCatsTable.frame.size.height + self.logo.frame.size.height/2.5);
                        else
                            self.catsSubCatsScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.catsSubCatsTable.frame.origin.y + self.catsSubCatsTable.frame.size.height);
                        
                        
                        //    NSLog(@"%f %f %f %f",self.catsSubCatsTable.contentSize.height,self.catsSubCatsTable.frame.size.height,self.catsSubCatsScroll.contentSize.height,self.catsSubCatsTable.frame.origin.y);
                        
                        self.catsSubCatsScroll.showsInfiniteScrolling = YES;
                        
                        
                        [self.catsSubCatsScroll.infiniteScrollingView stopAnimating];
                        
                    });
                });
                
                
                
            }
            else
                [self.catsSubCatsScroll.infiniteScrollingView stopAnimating];
            
            
        }];
    }
    else {
        
        [GlobalVariables getInstance].DictionaryWithAllPosts = [[NSMutableDictionary alloc]initWithDictionary:(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllPosts"]]];
        
        
       
        
        for( NSString *key in [[GlobalVariables getInstance].DictionaryWithAllPosts allKeys]){

            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"]){
             if([[[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key] valueForKey:@"tags"] valueForKey:@"slug"] containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"]]) {
                              NSLog(@"SLUG TAG : %@ AND ALL SLUGS %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromPostTag"],[[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key] valueForKey:@"tags"] valueForKey:@"slug"]);
                  [allArticlesFromCategory addObject:[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]];
             }
            }
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"]){
                if([[[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key] valueForKey:@"tags"] valueForKey:@"slug"] containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"]]) {
                    NSLog(@"SLUG TAG : %@ AND ALL SLUGS %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"],[[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key] valueForKey:@"tags"] valueForKey:@"slug"]);
                    [allArticlesFromCategory addObject:[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]];
                }
            }

            else if([[GlobalVariables getInstance].idOfcatSubCat intValue] == [[[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key] valueForKey:@"category"] valueForKey:@"category_parent_id"] intValue]){
                
                [allArticlesFromCategory addObject:[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]];
                
            }
        }
        
        [self.catsSubCatsTable reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGRect frame = self.catsSubCatsTable.frame;
            frame.size.height = self.catsSubCatsTable.contentSize.height;
            self.catsSubCatsTable.frame = frame;
            
            
            self.catsSubCatsScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.catsSubCatsTable.frame.origin.y + self.catsSubCatsTable.frame.size.height + self.logo.frame.size.height/2.5);
        });
        
        
        
        
        if(allArticlesFromCategory.count == 0){
            self.noArticlesFound.hidden = NO;
            [self.catsSubCatsScroll bringSubviewToFront:self.noArticlesFound];
        }
        
        
        
    }
    
}

-(void) ClickedTheBG{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ScrollImageController"]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allArticlesFromCategory.count + nativeAdsImage.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self isInternet] == NO){
        
        [GlobalVariables getInstance].idOfPost =[[allArticlesFromCategory[indexPath.row] valueForKey:@"post_id"]stringValue];;
        [GlobalVariables getInstance].comingFrom = @"CategoryPage";
        [GlobalVariables getInstance].comingFromViewController = @"CatsSubCatsController";
        [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
        
        
    }
    
    else {
        
        if(allArticlesFromCategory.count >= 10 && nativeAdsImage.count == 2){
            if(indexPath.row == 0){
                
                if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:nativeAdsDestionation[indexPath.row]]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nativeAdsDestionation[indexPath.row]]];
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                    message:@"Ce réseau social n'a pas encore été installé"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                }
                
            }
            else if(indexPath.row > 0 && indexPath.row <10) {
                
                [GlobalVariables getInstance].idOfPost =[[allArticlesFromCategory[indexPath.row-1] valueForKey:@"id"]stringValue];
                [GlobalVariables getInstance].comingFrom = @"CategoryPage";
                [GlobalVariables getInstance].comingFromViewController = @"CatsSubCatsController";
                [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
                
            }
            else if(indexPath.row == 10) {
                if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:nativeAdsDestionation[1]]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nativeAdsDestionation[1]]];
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                    message:@"Ce réseau social n'a pas encore été installé"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                }
                
            }
            else {
                [GlobalVariables getInstance].idOfPost =[[allArticlesFromCategory[indexPath.row-2] valueForKey:@"id"]stringValue];
                [GlobalVariables getInstance].comingFrom = @"CategoryPage";
                [GlobalVariables getInstance].comingFromViewController = @"CatsSubCatsController";
                [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
                
            }
            
        }
        
        else  if(allArticlesFromCategory.count < 10 && nativeAdsImage.count == 2){
            
            if(indexPath.row == 0){
                
                if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:nativeAdsDestionation[indexPath.row]]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nativeAdsDestionation[indexPath.row]]];
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                    message:@"Ce réseau social n'a pas encore été installé"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                }
                
            }
            else if(indexPath.row > 0 && indexPath.row <= allArticlesFromCategory.count) {
                
                [GlobalVariables getInstance].idOfPost =[[allArticlesFromCategory[indexPath.row-1] valueForKey:@"id"]stringValue];
                [GlobalVariables getInstance].comingFrom = @"CategoryPage";
                [GlobalVariables getInstance].comingFromViewController = @"CatsSubCatsController";
                [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
                
            }
            else if(indexPath.row == allArticlesFromCategory.count + 1) {
                if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:nativeAdsDestionation[1]]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nativeAdsDestionation[1]]];
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                    message:@"Ce réseau social n'a pas encore été installé"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                }
                
            }
            else {
                [GlobalVariables getInstance].idOfPost = [[allArticlesFromCategory[indexPath.row-2] valueForKey:@"id"]stringValue];
                [GlobalVariables getInstance].comingFrom = @"CategoryPage";
                [GlobalVariables getInstance].comingFromViewController = @"CatsSubCatsController";
                [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
                
            }
            
            
            
            
        }
        
        else if(nativeAdsImage.count == 1){
            
            if(indexPath.row == 0){
                
                if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:nativeAdsDestionation[indexPath.row]]])
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nativeAdsDestionation[indexPath.row]]];
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                    message:@"Ce réseau social n'a pas encore été installé"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                }
                
            }
            else{
                [GlobalVariables getInstance].idOfPost = [[allArticlesFromCategory[indexPath.row-1] valueForKey:@"id"]stringValue];
                [GlobalVariables getInstance].comingFrom = @"CategoryPage";
                [GlobalVariables getInstance].comingFromViewController = @"CatsSubCatsController";
                [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
            }
        }
        else{
            
            [GlobalVariables getInstance].idOfPost =[[allArticlesFromCategory[indexPath.row] valueForKey:@"id"]stringValue];
            [GlobalVariables getInstance].comingFrom = @"CategoryPage";
            [GlobalVariables getInstance].comingFromViewController = @"CatsSubCatsController";
            [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
            
        }
        
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSString *name = @"Categories and Sub Categories Screen";
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [self Spin];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(nativeAdsImage.count == 2 && (indexPath.row ==  0 || indexPath.row == 10) && allArticlesFromCategory.count >= 10)
        return self.view.frame.size.width/2;
    else if(nativeAdsImage.count == 2 && (indexPath.row ==  0 || indexPath.row == allArticlesFromCategory.count + 1) && allArticlesFromCategory.count < 10)
        return self.view.frame.size.width/2;
    else if(nativeAdsImage.count == 1 && indexPath.row ==  0)
        return self.view.frame.size.width/2;
    else
        return 360;
    

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CatsSubCatsCell";
    
    CatsSubCatsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([self isInternet] == NO){
        
        [cell.articleImage loadImageFromURL: [NSURL URLWithString:@"asdas"] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allArticlesFromCategory[indexPath.row ] valueForKey:@"post_id"]]];
        
        
        cell.articleContent.text = [[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row ] valueForKey:@"post_content"]]] substringWithRange:NSMakeRange(0, 250)];
        
        cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row ] valueForKey:@"post_title"]]];
        
        cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        
        cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        return cell;
    }
    else{
        
        if(allArticlesFromCategory.count >= 10 && nativeAdsImage.count == 2){
            
            if(indexPath.row == 0){
                
                UIImageView *customImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.articleImage.frame.origin.x, self.logo.frame.size.height * 0.19, self.logo.frame.size.height * 4.4, self.logo.frame.size.height * 1.8)];
                [cell.contentView addSubview:customImage];
                [cell.contentView bringSubviewToFront:customImage];
                
                cell.articleTitle.hidden = true;
                cell.articleContent.hidden = true;
                cell.articleImage.hidden = true;
                
                
                NSString* webName = [nativeAdsImage[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [customImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@%@%lu",url.lastPathComponent,url.lastPathComponent.lastPathComponent,url.absoluteString.length]];
                
                
                [customImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
                [customImage.layer setBorderWidth: 0.5];
                customImage.layer.cornerRadius = 5;
                customImage.contentMode = UIViewContentModeScaleToFill;
                customImage.clipsToBounds = true;
                
                return cell;
            }
            else  if(indexPath.row > 0 && indexPath.row <10) {
                
                NSString* webName = [[allArticlesFromCategory[indexPath.row-1] valueForKey:@"thumbnail_url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [cell.articleImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allArticlesFromCategory[indexPath.row-1] valueForKey:@"id"]]];
                
                cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-1] valueForKey:@"excerpt"]]];
                
                cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-1] valueForKey:@"title"]]];
                
                cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                
                cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                
                return cell;
                
            }
            else if(indexPath.row == 10) {
                
                UIImageView *customImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.articleImage.frame.origin.x, self.logo.frame.size.height * 0.19, self.logo.frame.size.height * 4.4, self.logo.frame.size.height * 1.8)];
                [cell.contentView addSubview:customImage];
                [cell.contentView bringSubviewToFront:customImage];
                
                cell.articleTitle.hidden = true;
                cell.articleContent.hidden = true;
                cell.articleImage.hidden = true;
                
                
                NSString* webName = [nativeAdsImage[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [customImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@%@%lu",url.lastPathComponent,url.lastPathComponent.lastPathComponent,url.absoluteString.length]];
                
                [customImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
                [customImage.layer setBorderWidth: 0.5];
                customImage.layer.cornerRadius = 5;
                customImage.contentMode = UIViewContentModeScaleToFill;
                customImage.clipsToBounds = true;
                
                return cell;
                
            }
            else {
                
                NSString* webName = [[allArticlesFromCategory[indexPath.row-2] valueForKey:@"thumbnail_url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [cell.articleImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allArticlesFromCategory[indexPath.row-2] valueForKey:@"id"]]];
                
                cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-2] valueForKey:@"excerpt"]]];
                
                cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-2] valueForKey:@"title"]]];
                
                cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                
                cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                
                return cell;
            }
            
        }
        
        // Case 2
        else if(nativeAdsImage.count == 1){
            if(indexPath.row == 0){
                
                UIImageView *customImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.articleImage.frame.origin.x, self.logo.frame.size.height * 0.19, self.logo.frame.size.height * 4.4, self.logo.frame.size.height * 1.8)];
                [cell.contentView addSubview:customImage];
                [cell.contentView bringSubviewToFront:customImage];
                
                cell.articleTitle.hidden = true;
                cell.articleContent.hidden = true;
                cell.articleImage.hidden = true;
                
                
                NSString* webName = [nativeAdsImage[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [customImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@%@%lu",url.lastPathComponent,url.lastPathComponent.lastPathComponent,url.absoluteString.length]];
                
                [customImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
                [customImage.layer setBorderWidth: 0.5];
                customImage.layer.cornerRadius = 5;
                customImage.clipsToBounds = true;
                customImage.contentMode = UIViewContentModeScaleToFill;
                customImage.clipsToBounds = true;
                
                return cell;
            }
            else {
                
                NSString* webName = [[allArticlesFromCategory[indexPath.row-1] valueForKey:@"thumbnail_url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [cell.articleImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allArticlesFromCategory[indexPath.row-1] valueForKey:@"id"]]];
                
                cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-1] valueForKey:@"excerpt"]]];
                
                cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-1] valueForKey:@"title"]]];
                
                cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                
                cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                
                return cell;
                
            }
        }
        
        // Case 3
        else if(nativeAdsImage.count == 0){
            
            
            NSString* webName = [[allArticlesFromCategory[indexPath.row] valueForKey:@"thumbnail_url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url = [NSURL URLWithString:webStringURL];
            
            [cell.articleImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allArticlesFromCategory[indexPath.row] valueForKey:@"id"]]];
            
            cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row] valueForKey:@"excerpt"]]];
            
            cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row] valueForKey:@"title"]]];
            
            cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            
            cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            
            return cell;
            
            
        }
        
        
        if(allArticlesFromCategory.count < 10 && nativeAdsImage.count == 2){
            
            if(indexPath.row == 0){
                
                UIImageView *customImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.articleImage.frame.origin.x, self.logo.frame.size.height * 0.19, self.logo.frame.size.height * 4.4, self.logo.frame.size.height * 1.8)];
                [cell.contentView addSubview:customImage];
                [cell.contentView bringSubviewToFront:customImage];
                
                cell.articleTitle.hidden = true;
                cell.articleContent.hidden = true;
                cell.articleImage.hidden = true;
                
                
                NSString* webName = [nativeAdsImage[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [customImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@%@%lu",url.lastPathComponent,url.lastPathComponent.lastPathComponent,url.absoluteString.length]];
                
                [customImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
                [customImage.layer setBorderWidth: 0.5];
                customImage.layer.cornerRadius = 5;
                customImage.clipsToBounds = true;
                customImage.contentMode = UIViewContentModeScaleToFill;
                customImage.clipsToBounds = true;
                
                return cell;
            }
            else  if(indexPath.row > 0 && indexPath.row <= allArticlesFromCategory.count) {
                
                NSString* webName = [[allArticlesFromCategory[indexPath.row-1] valueForKey:@"thumbnail_url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [cell.articleImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allArticlesFromCategory[indexPath.row-1] valueForKey:@"id"]]];
                
                cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-1] valueForKey:@"excerpt"]]];
                
                cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allArticlesFromCategory[indexPath.row-1] valueForKey:@"title"]]];
                
                cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                
                cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                
                return cell;
                
            }
            else if(indexPath.row == allArticlesFromCategory.count+1) {
                
                UIImageView *customImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.articleImage.frame.origin.x, self.logo.frame.size.height * 0.19, self.logo.frame.size.height * 4.4, self.logo.frame.size.height * 1.8)];
                [cell.contentView addSubview:customImage];
                [cell.contentView bringSubviewToFront:customImage];
                
                cell.articleTitle.hidden = true;
                cell.articleContent.hidden = true;
                cell.articleImage.hidden = true;
                
                
                NSString* webName = [nativeAdsImage[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                
                [customImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@%@%lu",url.lastPathComponent,url.lastPathComponent.lastPathComponent,url.absoluteString.length]];
                
                [customImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
                [customImage.layer setBorderWidth: 0.5];
                customImage.layer.cornerRadius = 5;
                customImage.clipsToBounds = true;
                customImage.contentMode = UIViewContentModeScaleToFill;
                customImage.clipsToBounds = true;
                
                return cell;
                
            }
            
        }
        
        
    }
    
    return cell;
}
-(void)Spin{
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
    
}
-(void)sendingAnHTTGETTRequestCategoryClicked: (NSString *)url{
    if ([url isEqualToString:@"https://vivreathenes.com/wp-json/wp/v2/posts/category/544?page=1"]) {
        url = @"https://vivreathenes.com/wp-json/wp/v2/posts/tag/coups-de-coeur?page=1";
    }
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    NSLog(@"url2: %@", url);
    
    Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
}
-(NSDictionary *)getPostByTagName: (NSString *)url{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
}
-(NSDictionary *)requestForNativeAds: (NSString *)url{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    
    return  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    
    
    
    
}
-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
        
        return YES;
        
    }
    
    else {
        
        return NO;
    }
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
                
                // NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
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
- (IBAction)openSideMenu:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0)
        [scrollView setContentOffset:CGPointMake(0, 0)];
    
    if(scrollView.contentOffset.y > scrollView.contentSize.height)
        [self.catsSubCatsScroll triggerInfiniteScrolling];
}

- (IBAction)openiAPController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"IAPViewController"]];
}
- (IBAction)backToPost:(id)sender {
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromAgendaTag"]){
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"CanAddObjectToCarousel"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AgendaViewController"]];
    }
}
@end
