//
//  AnnouncementsViewController.m
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AnnouncementsViewController.h"
#import "JTMaterialSpinner.h"
#import "AnnouncementCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "Reachability.h"
#import "SimpleFilesCache.h"
#import "UIImageView+Network.h"
#import "AnnouncementArticleView.h"
#import "GlobalVariables.h"
#import "OLGhostAlertView.h"
#import "Header.h"
@interface AnnouncementsViewController ()

@end

@implementation AnnouncementsViewController

{
    JTMaterialSpinner *spinnerview;
    int Page;
    NSMutableArray *announcementsArray;
    NSDictionary *responseDict;
    BOOL changeFrameOnce;
    UIRefreshControl *refreshControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    changeFrameOnce = true;
    self.noAnnouncement.hidden = true;
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y + 22, 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    
   
 
    
    [GlobalVariables getInstance].currentAnnouncementScreen = @"AnnouncementsViewController";
    
    /*
    refreshControl = [[UIRefreshControl alloc]init];
    [self.announcesScrollView addSubview:refreshControl];
    [self.announcesScrollView setRefreshControl:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
     */
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"YES"])
        self.offlineButton.hidden = YES;
    
    
    [self.view addSubview:spinnerview];
    [self.view bringSubviewToFront:spinnerview];
    
    [spinnerview beginRefreshing];
    
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(openAnnouncement:) name:@"openAnnouncement" object:nil];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    self.logo.image = [UIImage imageNamed:@"Logo.png"];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    self.logo.clipsToBounds = true;
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
    [self.announcesScrollView bringSubviewToFront:self.rainbow];
    [self.announcesScrollView bringSubviewToFront:self.logo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Spin)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self Spin];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    
    
    if(hour >= 20){
        self.changeableBg.image =[UIImage imageNamed:@"BackgroundNight.png"];
        if (self.changeableBg.image == nil){
            self.changeableBg.image = [UIImage imageNamed:@"BackgroundDay.png"];
        }
    }
    else {
        self.changeableBg.image = [UIImage imageNamed:@"BackgroundDay.png"];
        if (self.changeableBg.image == nil){
            self.changeableBg.image = [UIImage imageNamed:@"BackgroundNight.png"];
        }
    }
    
    
    self.changeableBg.clipsToBounds = true;
    self.changeableBg.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.announcementTitle.adjustsFontSizeToFitWidth = true;
    self.announcementsTable.scrollEnabled = false;
    
    self.announcesScrollView.delaysContentTouches = NO;
    
    announcementsArray = [[NSMutableArray alloc] init];
    Page = 1;
    
    
    
    
    [GlobalVariables getInstance].DictionaryWithAllAnnouncements = [[NSMutableDictionary alloc] initWithDictionary:[(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllAnnouncements"]] mutableCopy]];
    
    self.annButtons.frame = CGRectMake(self.annButtons.frame.origin.x, self.logo.frame.origin.y + self.logo.frame.size.height, self.annButtons.frame.size.width, self.annButtons.frame.size.height);
    
    
    if([self isInternet] == YES){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            [self sendingAnHTTPPOSTRequestForAnnouncements:[NSString stringWithFormat:petitesAnnonces,Page]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(int i = 0 ; i < [[responseDict valueForKey:@"results"] count]; i++){
                    
                    [announcementsArray addObject:[responseDict valueForKey:@"results"][i]];
                    
                }
                
                
                
                [self.announcementsTable reloadData];
                
                
                CGFloat a = 0;
                
                if(Page >= [[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"pages"]] intValue]){
                    [self.announcesScrollView.infiniteScrollingView stopAnimating];
                    a = self.logo.frame.size.height/2.5;
                }
                else{
                    Page++;
                    a = 0;
                }
                
                
                
                CGRect frame = self.announcementsTable.frame;
                frame.size.height = self.announcementsTable.contentSize.height;
                self.announcementsTable.frame = frame;
                
                self.announcesScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.announcementsTable.frame.origin.y + self.announcementsTable.frame.size.height + a);
                
                [spinnerview endRefreshing];
                
                
        
            
                
            });
            
        });
        
        [self.announcesScrollView addInfiniteScrollingWithActionHandler:^{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self sendingAnHTTPPOSTRequestForAnnouncements:[NSString stringWithFormat:petitesAnnonces,Page]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     CGFloat a = 0;
                    
                     if(Page < [[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"pages"]] intValue]){
                         
                    for(int i = 0 ; i < [[responseDict valueForKey:@"results"] count]; i++){
                        
                        [announcementsArray addObject:[responseDict valueForKey:@"results"][i]];
                        
                    }
          
                    [self.announcementsTable reloadData];
                    [self.announcesScrollView.infiniteScrollingView stopAnimating];
   
                        Page++;
                         a = 0;
                     }
                     else{
                         [self.announcesScrollView.infiniteScrollingView stopAnimating];
                         a = self.logo.frame.size.height/2.5;
                     }
                    
                    CGRect frame = self.announcementsTable.frame;
                    frame.size.height = self.announcementsTable.contentSize.height;
                    self.announcementsTable.frame = frame;
                    
                    self.announcesScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.announcementsTable.frame.origin.y + self.announcementsTable.frame.size.height + a);
                    
                    

                    
                    
                });
            });
            
            if([self isInternet] == NO)
                [self.announcesScrollView.infiniteScrollingView stopAnimating];
            
            
            
            
        }];
        
        
    }
    
    else if([[GlobalVariables getInstance].DictionaryWithAllAnnouncements allKeys].count != 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            announcementsArray = [[NSMutableArray alloc]init];
            
            for(NSString *key in [[GlobalVariables getInstance].DictionaryWithAllAnnouncements allKeys]){
                [announcementsArray addObject:[[GlobalVariables getInstance].DictionaryWithAllAnnouncements  objectForKey:key]];
            }
            
            [self.announcementsTable reloadData];
            
            CGRect frame = self.announcementsTable.frame;
            frame.size.height = self.announcementsTable.contentSize.height;
            self.announcementsTable.frame = frame;
            
            self.announcesScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.announcementsTable.frame.origin.y + self.announcementsTable.frame.size.height + self.logo.frame.size.height/2.5);
            
            

            
            
            [spinnerview endRefreshing];
        });
        
        
        
    }
    else{
        self.noAnnouncement.hidden = false;
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self Spin];
}
-(void)refreshTable{
    if([self isInternet] == YES){
        announcementsArray = [[NSMutableArray alloc] init];
        Page = 1;
        
        [GlobalVariables getInstance].DictionaryWithAllAnnouncements = [[NSMutableDictionary alloc] initWithDictionary:[(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllAnnouncements"]] mutableCopy]];
        
        self.annButtons.frame = CGRectMake(self.annButtons.frame.origin.x, self.logo.frame.origin.y + self.logo.frame.size.height, self.annButtons.frame.size.width, self.annButtons.frame.size.height);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            [self sendingAnHTTPPOSTRequestForAnnouncements:[NSString stringWithFormat:petitesAnnonces,Page]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(int i = 0 ; i < [[responseDict valueForKey:@"results"] count]; i++){
                    
                    [announcementsArray addObject:[responseDict valueForKey:@"results"][i]];
                    
                }
                
                
                
                [self.announcementsTable reloadData];
                
                
                CGFloat a = 0;
                
                if(Page >= [[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"pages"]] intValue]){
                    [self.announcesScrollView.infiniteScrollingView stopAnimating];
                    a = self.logo.frame.size.height/2.5;
                }
                else{
                    Page++;
                    a = 0;
                }
                
                
                
                CGRect frame = self.announcementsTable.frame;
                frame.size.height = self.announcementsTable.contentSize.height;
                self.announcementsTable.frame = frame;
                
                self.announcesScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.announcementsTable.frame.origin.y + self.announcementsTable.frame.size.height + a);
                
                [spinnerview endRefreshing];
                [refreshControl endRefreshing];
                
                
                
            });
            
        });
        
    }
    else{
         [refreshControl endRefreshing];
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return announcementsArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnouncementCell";
    
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.announcementTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementsArray[indexPath.row] valueForKey:@"title"]]]];
    

    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"MM-dd-yyyy";
//    NSString *dateString = [dateFormatter stringFromDate:[announcementsArray[indexPath.row] valueForKey:@"title"]];
//    dateFormatter.dateFormat = @"dd-MM-yyyy";
//    NSString *dateString2 = [dateFormatter stringFromDate:[announcementsArray[indexPath.row] valueForKey:@"title"]];
    
   // cell.announcementDate.text = dateString2;
    
    cell.announcementDate.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementsArray[indexPath.row] valueForKey:@"post_date"]]]];
    
    NSArray *dateElements = [[NSArray alloc]initWithArray:[cell.announcementDate.text componentsSeparatedByString:@"-"]];
    cell.announcementDate.text = [NSString stringWithFormat:@"%@-%@-%@",dateElements[2],dateElements[1],dateElements[0]];
    
    
    
    
    if([self isInternet] == YES)
        cell.announcementContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementsArray[indexPath.row] valueForKey:@"excerpt"]]]];
    else
        cell.announcementContent.text =[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementsArray[indexPath.row] valueForKey:@"content"]]]];
    
    cell.announcementContent.text = [cell.announcementContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    cell.announcementContent.text = [[cell.announcementContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
    NSString* webName;
    if([self isInternet] == YES)
        webName = [[NSString stringWithFormat:@"%@",[announcementsArray[indexPath.row] valueForKey:@"thumbnail"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    else if([[announcementsArray[indexPath.row] valueForKey:@"images"] count] > 0)
        webName = [[NSString stringWithFormat:@"%@",[announcementsArray[indexPath.row] valueForKey:@"images"][0]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    [cell.announcementImage loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@",[announcementsArray valueForKey:@"id"][indexPath.row]]];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [GlobalVariables getInstance].idOfAnnouncement = [announcementsArray[indexPath.row] valueForKey:@"id"];
    
    AnnouncementArticleView * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementArticleView"];
    
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
- (IBAction)addAnnouncement:(id)sender {
    if([self isInternet] == YES){
    [GlobalVariables getInstance].editerClicked = NO;
    [GlobalVariables getInstance].currentPopUpAnnouncementScreen = @"AnnouncementsViewController";
    [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AddAnnouncement"]];
    }
    else{
        [self showMessage:@"Please connect to the internet"];
    }
    
}

- (IBAction)editAnnouncement:(id)sender {
     if([self isInternet] == YES){
    [GlobalVariables getInstance].editerClicked = YES;
    [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer = @"editAnnClickedOnHomePage";
    [GlobalVariables getInstance].currentPopUpAnnouncementScreen = @"AnnouncementsViewController";
      [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"EditAnnouncement"]];
     }
     else{
             [self showMessage:@"Please connect to the internet"];
         }
}

- (IBAction)searchAnnouncement:(id)sender {
    [GlobalVariables getInstance].editerClicked = NO;
    [GlobalVariables getInstance].currentPopUpAnnouncementScreen = @"AnnouncementsViewController";
    [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer = nil;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"SearchAnnouncement"]];
    
}

- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}

-(void)Spin{
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height == 812.0f) {
       
            if(changeFrameOnce == true && scrollView.contentOffset.y >= self.logo.frame.origin.y + self.logo.frame.size.height - 37){
                
                self.annButtons.frame = CGRectMake(self.annButtons.frame.origin.x, 37, self.annButtons.frame.size.width, self.annButtons.frame.size.height);
                
                [self.view addSubview:self.annButtons];
                [self.view bringSubviewToFront:self.annButtons];
                
                
                changeFrameOnce = false;
            }
            else if(changeFrameOnce ==  false && scrollView.contentOffset.y <= self.logo.frame.origin.y + self.logo.frame.size.height - 37){
                
                self.annButtons.frame = CGRectMake(self.annButtons.frame.origin.x, self.logo.frame.origin.y + self.logo.frame.size.height, self.annButtons.frame.size.width, self.annButtons.frame.size.height);
                
                [self.announcesScrollView addSubview:self.annButtons];
                [self.announcesScrollView bringSubviewToFront:self.annButtons];
                
                changeFrameOnce = true;
            }
            
        }
    
    else {
        if(changeFrameOnce == true && scrollView.contentOffset.y >= self.logo.frame.origin.y + self.logo.frame.size.height - 5){
            
            self.annButtons.frame = CGRectMake(self.annButtons.frame.origin.x, 5, self.annButtons.frame.size.width, self.annButtons.frame.size.height);
            
            [self.view addSubview:self.annButtons];
            [self.view bringSubviewToFront:self.annButtons];
            
            
            changeFrameOnce = false;
        }
        else if(changeFrameOnce ==  false && scrollView.contentOffset.y <= self.logo.frame.origin.y + self.logo.frame.size.height - 5){
            
            self.annButtons.frame = CGRectMake(self.annButtons.frame.origin.x, self.logo.frame.origin.y + self.logo.frame.size.height, self.annButtons.frame.size.width, self.annButtons.frame.size.height);
            
            [self.announcesScrollView addSubview:self.annButtons];
            [self.announcesScrollView bringSubviewToFront:self.annButtons];
            
            changeFrameOnce = true;
        }
        
    }
    
    if (scrollView.contentOffset.y < 0){
        [scrollView setContentOffset:CGPointMake(0, 0)];
       //  [spinnerview beginRefreshing];
       // [self refreshTable];
    }
    
}

-(void)sendingAnHTTPPOSTRequestForAnnouncements: (NSString *)url{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    
    responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    
    
    
    
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
                
            //    NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
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
-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
        
        return YES;
        
    }
    
    else {
        
        
        return NO;
    }
}
-(void) openAnnouncement: (NSNotification *) notification
{
    if([notification.object isEqualToString:@"Something"]){
    
    
    AnnouncementArticleView * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementArticleView"];
    
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
    else{
        [self Spin];
    }
    
}
- (IBAction)openiAPController:(id)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"IAPViewController"]];
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


@end
