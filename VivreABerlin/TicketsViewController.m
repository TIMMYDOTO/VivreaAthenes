//
//  TicketsViewController.m
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "TicketsViewController.h"
#import "Header.h"
#import "JTMaterialSpinner.h"
#import "GlobalVariables.h"
#import "CatsSubCatsCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIImageView+Network.h"

@interface TicketsViewController ()

@end

@implementation TicketsViewController

{
    JTMaterialSpinner *spinnerview;
    UIWebView *webViewCustom;
    BOOL executeOnlyOnce;
    UIButton *returnBtn;
    BOOL changeFrameOnce;
    BOOL hideReturnAllBtn;
    CGFloat originOfMenuButton;
    NSMutableArray *arrayUsedInTable;
    NSMutableDictionary *Dictionary;
    int Page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    changeFrameOnce = true;
    executeOnlyOnce = YES;
    
    arrayUsedInTable = [[NSMutableArray alloc] init];
    
    originOfMenuButton = self.openSideMenu.frame.origin.y;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"YES"])
        self.offlineButton.hidden = YES;
    
    
    self.openSideMenu.frame = CGRectMake(self.openSideMenu.frame.origin.x, originOfMenuButton, self.openSideMenu.frame.size.width, self.openSideMenu.frame.size.height);
    
    [self.view addSubview:spinnerview];
    [self.view bringSubviewToFront:spinnerview];
    
    [spinnerview beginRefreshing];
    self.ticketsScroll.bounces = false;
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    self.logo.image = [UIImage imageNamed:@"Logo.png"];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    self.logo.clipsToBounds = true;
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
    [self.ticketsScroll bringSubviewToFront:self.rainbow];
    [self.ticketsScroll bringSubviewToFront:self.logo];
    
    [self.view bringSubviewToFront:self.logo];
    [self.view bringSubviewToFront:self.rainbow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Spin)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self Spin];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    
    
    if(hour >= 20){
        self.thumbnailBackground.image = [UIImage imageNamed:@"BackgroundNight.png"];
        if (self.thumbnailBackground.image == nil){
            self.thumbnailBackground.image = [UIImage imageNamed:@"BackgroundDay.png"];
        }
    }
    else {
        self.thumbnailBackground.image = [UIImage imageNamed:@"BackgroundDay.png"];
        if (self.thumbnailBackground.image == nil){
            self.thumbnailBackground.image = [UIImage imageNamed:@"BackgroundNight.png"];
        }
    }
    
    
    self.thumbnailBackground.clipsToBounds = true;
    self.thumbnailBackground.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.ticketsScroll.delaysContentTouches = NO;
    
    
    
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y + 22, 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    [self.view addSubview:spinnerview];
    [self.view bringSubviewToFront:spinnerview];
    
    [spinnerview beginRefreshing];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    NSDictionary *resultForSlugsAndBoolForAds = [self makingRequestForAds:settingsData];
    if ([[[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"section_tickets"] intValue] == 0 ) {
        [GlobalVariables getInstance].canDisplayTicketsWebView = false;
        [GlobalVariables getInstance].sectionTagTickets = [[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"section_tag"];
        
        if([[[resultForSlugsAndBoolForAds objectForKey:@"gyg"] allKeys] containsObject:@"full_name_tag"])
            [GlobalVariables getInstance].sectionTagNameTickets = [[resultForSlugsAndBoolForAds objectForKey:@"gyg"] objectForKey:@"full_name_tag"];
    }
    else {
        [GlobalVariables getInstance].canDisplayTicketsWebView = true;
        [GlobalVariables getInstance].sectionTagTickets = nil;
    }
    });
    
    
    if([GlobalVariables getInstance].canDisplayTicketsWebView == true) {
        self.ticketTable.hidden = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSDictionary *result = [self sendingAnHTTPPOSTRequestForAnnouncements:getYourGuidePOI];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                UILabel *firstTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.ticketImage.frame.origin.x, self.ticketsTopTitle.frame.size.height + self.ticketsTopTitle.frame.origin.y + 12, self.view.frame.size.width - 14, 1)];
                firstTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"● %@",[result objectForKey:@"title"]]]];
                firstTitle.font = [UIFont fontWithName:@"Montserrat-SemiBold" size:16];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    firstTitle.font = [UIFont fontWithName:@"Montserrat-SemiBold" size:20];
                else {
                    CGRect frame = firstTitle.frame;
                    frame.origin.x = 10;
                    firstTitle.frame = frame;
                }
                firstTitle.textColor = [self colorWithHexString:@"839C00"];
                firstTitle.numberOfLines = 0;
                [firstTitle sizeToFit];
                [self.ticketsScroll addSubview:firstTitle];
                [self.ticketsScroll bringSubviewToFront:firstTitle];
                
                
                UILabel *firstContent = [[UILabel alloc]initWithFrame:CGRectMake(self.ticketImage.frame.origin.x, firstTitle.frame.size.height + firstTitle.frame.origin.y + 5, self.view.frame.size.width - 14, 1)];
                firstContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[result objectForKey:@"page_description"]]];
                firstContent.font = [UIFont fontWithName:@"Montserrat-Light" size:14];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    firstContent.font = [UIFont fontWithName:@"Montserrat-Light" size:18];
                else{
                    CGRect frame = firstContent.frame;
                    frame.origin.x = 10;
                    firstContent.frame = frame;
                }
                
                firstContent.numberOfLines = 0;
                firstContent.textColor = [UIColor darkGrayColor];
                [firstContent sizeToFit];
                [self.ticketsScroll addSubview:firstContent];
                [self.ticketsScroll bringSubviewToFront:firstContent];
                
                
                
                if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
                    returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, firstContent.frame.size.height + firstContent.frame.origin.y + 5, self.view.frame.size.width/3, 30)];
                else
                    returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.ticketImage.frame.origin.x, firstContent.frame.size.height + firstContent.frame.origin.y + 5, self.view.frame.size.width/5, 30)];
                
                [returnBtn setTitle:@"Retour - Tout voir" forState:UIControlStateNormal];
                [returnBtn setBackgroundColor:[UIColor clearColor]];
                [returnBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-SemiBold" size:16]];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    [returnBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-SemiBold" size:19]];
                [returnBtn.titleLabel setAdjustsFontSizeToFitWidth:true];
                [returnBtn setTitleColor:[self colorWithHexString:@"839C00"] forState:UIControlStateNormal];
                [returnBtn.layer setCornerRadius:2];
                [returnBtn setClipsToBounds:YES];
                [self.ticketsScroll addSubview:returnBtn];
                [self.ticketsScroll bringSubviewToFront:returnBtn];
                [returnBtn addTarget:self
                              action:@selector(getBack)
                    forControlEvents:UIControlEventTouchUpInside];
                
                
                webViewCustom = [[UIWebView alloc]initWithFrame:CGRectMake(0, returnBtn.frame.size.height + returnBtn.frame.origin.y + 5, self.view.frame.size.width, 500)];
                NSString *urlString = getYourGuideTour;
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                [webViewCustom loadRequest:urlRequest];
                webViewCustom.scrollView.scrollEnabled = YES;
                webViewCustom.scrollView.bounces = false;
                webViewCustom.delegate = self;
                [self.ticketsScroll addSubview:webViewCustom];
                [self.ticketsScroll bringSubviewToFront:webViewCustom];
                
                
                hideReturnAllBtn = YES;
                [self hideReturnBtn];
                
            });
            
        });
        
    }
    else {
        
        
        
        self.ticketTable.bounces = false;
        //   self.ticketTable.scrollEnabled = false;
        
        [spinnerview beginRefreshing];
        
        Page = 0;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            
            if([GlobalVariables getInstance].sectionTagNameTickets != nil)
            self.ticketsSlug.text = [GlobalVariables getInstance].sectionTagNameTickets;
            [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:postsFromTag,[GlobalVariables getInstance].sectionTagTickets,[NSString stringWithFormat:@"%d",Page]]];
            NSLog(@"u %@", [NSString stringWithFormat:postsFromTag,[GlobalVariables getInstance].sectionTagTickets,[NSString stringWithFormat:@"%d",Page]]);
            NSLog(@"url %@",[GlobalVariables getInstance].sectionTagTickets);
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ////////////////////////////////////
//            NSLog(@"[Dictionaryyy %lu",[[Dictionary valueForKey:@"results"] count]);
                for(int i = 0 ; i < [[Dictionary valueForKey:@"results"] count]; i++){
              
                    [arrayUsedInTable addObject:[Dictionary valueForKey:@"results"][i]];
                }
                [self.ticketTable reloadData];
                
                [spinnerview endRefreshing];
                
                CGRect frame = self.ticketTable.frame;
                frame.size.height = self.ticketTable.contentSize.height;
                self.ticketTable.frame = frame;
                
                
                self.ticketsScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.ticketTable.frame.origin.y + self.ticketTable.frame.size.height);
                
                Page ++;
                
                
            });
        });
        
        self.ticketsScroll.showsInfiniteScrolling = YES;
        
        Page ++;
        
        [self.ticketsScroll addInfiniteScrollingWithActionHandler:^{
            
            NSLog(@"scroll");
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                
                [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:postsFromTag,[GlobalVariables getInstance].sectionTagTickets,[NSString stringWithFormat:@"%d",Page]]];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
        
      
                    
                    if([[Dictionary valueForKey:@"results"] count] > 0){
                        NSLog(@"Dictionary count %lu", [[Dictionary valueForKey:@"results"] count]);
                        for(int i = 0 ; i < [[Dictionary valueForKey:@"results"] count]; i++){
                            [arrayUsedInTable addObject:[Dictionary valueForKey:@"results"][i]];
                        }
                        
                        [self.ticketTable reloadData];
                        
                    }
                    
                    CGRect frame = self.ticketTable.frame;
                    frame.size.height = self.ticketTable.contentSize.height;
                    self.ticketTable.frame = frame;
                    
                    if(Page == [[NSString stringWithFormat:@"%@",[Dictionary valueForKey:@"pages"]] intValue]) {
                        self.ticketsScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.ticketTable.frame.origin.y + self.ticketTable.frame.size.height + self.logo.frame.size.height/2.5);
                        self.ticketsScroll.showsInfiniteScrolling = false;
                    }
                    else {
                        Page ++;
                        
                        self.ticketsScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.ticketTable.frame.origin.y + self.ticketTable.frame.size.height);
                    }
                    
                    
                    [self.ticketsScroll.infiniteScrollingView stopAnimating];
                    
                });
            });
        }];
        
        
        
        
        
        
        
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self Spin];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)requestURL navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [requestURL URL];
    NSLog(@"##### url = %@",[url absoluteString]);
    if(![[url absoluteString] isEqualToString:getYourGuideTour]){
        hideReturnAllBtn = NO;
        [self hideReturnBtn];
    }
    return YES;
}
-(void)hideReturnBtn{
    if(hideReturnAllBtn)
        returnBtn.hidden = YES;
    else
        returnBtn.hidden = NO;
}

-(void)getBack{
    [UIView animateWithDuration:0.1 animations:^{
        returnBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            returnBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                returnBtn.transform = CGAffineTransformIdentity;
            }];
            
        }];
        
    }];
    [webViewCustom removeFromSuperview];
    webViewCustom = [[UIWebView alloc]initWithFrame:CGRectMake(0, returnBtn.frame.size.height + returnBtn.frame.origin.y + 5, self.view.frame.size.width, 500)];
    NSString *urlString = getYourGuideTour;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webViewCustom loadRequest:urlRequest];
    webViewCustom.scrollView.scrollEnabled = YES;
    webViewCustom.scrollView.bounces = false;
    webViewCustom.delegate = self;
    hideReturnAllBtn = YES;
    [self hideReturnBtn];
    [self.ticketsScroll addSubview:webViewCustom];
    [self.ticketsScroll bringSubviewToFront:webViewCustom];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@ TADAAAAA",[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"]);
    if (!webView.isLoading) {
        if(executeOnlyOnce == YES){
            NSLog(@"NANANANANNAA");
            executeOnlyOnce = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                dispatch_time_t popTimee = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(popTimee, dispatch_get_main_queue(), ^(void){
                    
                    [spinnerview endRefreshing];
                    
                    webViewCustom.frame = CGRectMake(webViewCustom.frame.origin.x, webViewCustom.frame.origin.y, webViewCustom.frame.size.width, webViewCustom.scrollView.contentSize.height);
                    
                    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        self.ticketsScroll.contentSize = CGSizeMake(0, webViewCustom.frame.size.height + webViewCustom.frame.origin.y);
                    else
                        self.ticketsScroll.contentSize = CGSizeMake(0, webViewCustom.frame.size.height + webViewCustom.frame.origin.y + 2);
                    
                });
            });
        }
    }
    else
        return;
}


-(void)webViewDidStartLoad:(UIWebView *)web1{
    executeOnlyOnce = YES;
    [spinnerview beginRefreshing];
}




-(NSDictionary *)sendingAnHTTPPOSTRequestForAnnouncements: (NSString *)url{
    
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
    
finish: return result;
}

- (IBAction)openSideBar:(id)sender {
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == self.ticketsScroll){
        if(scrollView.contentOffset.y < 0)
            [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    //        else if(changeFrameOnce ==  false && scrollView.contentOffset.y  < returnBtn.frame.origin.y - originOfMenuButton - returnBtn.frame.size.height * 1.5){
    //
    //            [UIView animateWithDuration:0.3 animations:^{
    //
    //                self.openSideMenu.alpha = 1;
    //
    //            }completion:^(BOOL finished) {
    //
    //                [UIView animateWithDuration:0.2 animations:^{
    //
    //                    self.bigButton.hidden = NO;
    //
    //
    //
    //                }];
    //
    //            }];
    //            changeFrameOnce = true;
    //        }
    //
    //    }
    
}

#pragma mark - NEWTABLE:

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayUsedInTable.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [GlobalVariables getInstance].idOfPost = [arrayUsedInTable[indexPath.row] valueForKey:@"id"];
    [GlobalVariables getInstance].comingFromViewController = @"TicketsViewController";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  300;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath: %ld", (long)indexPath.row);
    static NSString *CellIdentifier = @"CatsSubCatsCell";
    
    CatsSubCatsCell *cell = [self.ticketTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    [cell.articleImage loadImageFromURL: [NSURL URLWithString:[arrayUsedInTable[indexPath.row ] valueForKey:@"thumbnail_url"]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[arrayUsedInTable[indexPath.row ] valueForKey:@"id"]]];
    
    
    cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[arrayUsedInTable[indexPath.row ] valueForKey:@"excerpt"]]];
    
    cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[arrayUsedInTable[indexPath.row ] valueForKey:@"title"]]];
    
    cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
    return cell;
}

- (IBAction)openIAP:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"IAPViewController"]];
}
-(void)sendingAnHTTGETTRequestCategoryClicked: (NSString *)url{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
       NSLog(@"url:%@", jsonFileUrl);
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    
    Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    NSLog(@"getting dictionary %@", Dictionary);
    
    
    
}

-(NSDictionary *)makingRequestForAds:(NSString *)url
{
 
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    NSLog(@"url %@",url);
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
}
@end
