//
//  ListOfPostsController.m
//  VivreABerlin
//
//  Created by home on 03/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "ListOfPostsController.h"
#import "CatsSubCatsCell.h"
#import "Reachability.h"
#import "GlobalVariables.h"
#import "Header.h"
#import "SimpleFilesCache.h"
#import "UIImageView+Network.h"
#import "JTMaterialSpinner.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>



@interface ListOfPostsController ()

@end

@implementation ListOfPostsController
{
    NSMutableArray *allSearchedPosts;
    JTMaterialSpinner *spinnerview;
    int Page;
    BOOL isKeyboardOn;
    BOOL makingRequest;
    CGFloat originOfScroll;
    BOOL changeFrameOnce;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    changeFrameOnce = true;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"YES"])
        self.offlineButton.hidden = YES;
    
    self.noArticleFounded.hidden = YES;
    
    self.searchedFieldArticle.userInteractionEnabled = false;
    
    self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.allPostsSearched.frame.origin.y - self.searchView.frame.size.height/2 - self.logo.frame.size.height/2.5, self.searchView.frame.size.width, self.searchView.frame.size.height);
    
    [self.searchView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.searchView.layer setBorderWidth: 0.5];
    
    
    Page = 1;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    
    allSearchedPosts = [[NSMutableArray alloc] init];
    
    self.allPostsSearched.scrollEnabled = false;
    
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 45 , 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    
    //    self.searchAPost.hidden = true;
    //    self.logo.hidden = true;
    //    self.rainbow.hidden = true;
    //    self.changeableBackground.hidden = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(setSearchBarText:) name:@"textChanged" object:nil];
    

    
    
    [self.searchedFieldArticle addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    self.searchedFieldArticle.text = [GlobalVariables getInstance].textSearched;
    self.searchedFieldArticle.placeholder = @"Je cherche...";
//    self.searchedFieldArticle.tintColor = [UIColor blueColor];
    
    
    makingRequest = false;
    [self initialize];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Spin)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    [self Spin];

    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    
    
    if(hour >=20){
        self.changeableBackground.image =[UIImage imageNamed:@"BackgroundNight.png"];
        if (self.changeableBackground.image == nil){
            self.changeableBackground.image = [UIImage imageNamed:@"BackgroundDay.png"];
        }
    }
    else {
        self.changeableBackground.image = [UIImage imageNamed:@"BackgroundDay.png"];
        if (self.changeableBackground.image == nil){
            self.changeableBackground.image = [UIImage imageNamed:@"BackgroundNight.png"];
        }
    }
    
    self.changeableBackground.clipsToBounds = true;
    self.changeableBackground.contentMode = UIViewContentModeScaleAspectFill;
    self.logo.image = [UIImage imageNamed:@"logo1"];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    self.logo.clipsToBounds = true;
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
     [self.searchScreenScroll bringSubviewToFront:self.logo];
    [self.searchScreenScroll bringSubviewToFront:self.rainbow];
   
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusOnSearchField)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.noArticleFounded addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    

    
}
-(void)focusOnSearchField{
    
    [self.searchedFieldArticle becomeFirstResponder];
}
-(void)setSearchBarText:(NSNotification *)notifacation{
    
    [GlobalVariables getInstance].textSearched = [NSString stringWithFormat:@"%@",notifacation.object];
    self.searchedFieldArticle.text = [NSString stringWithFormat:@"%@",notifacation.object];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return allSearchedPosts.count;
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *name = @"List of Posts Screen";
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [self Spin];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CatsSubCatsCell";
    
    CatsSubCatsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([self isInternet] == NO){
        
        NSString* webName = [[allSearchedPosts[indexPath.row] valueForKey:@"post_thumbnail_url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
       
        [cell.articleImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allSearchedPosts[indexPath.row ] valueForKey:@"post_id"]]];
 
        cell.articleContent.text = [[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allSearchedPosts[indexPath.row ] valueForKey:@"post_content"]]] substringWithRange:NSMakeRange(0, 200)];
        
        cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allSearchedPosts[indexPath.row ] valueForKey:@"post_title"]]];
        
        
        cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        
        
//        if([[NSString stringWithFormat:@"%@",[[allSearchedPosts[indexPath.row] valueForKey:@"category"] valueForKey:@"category_parent_name"]] length] < 60)
//        cell.lastCategoryNameTable.text = [NSString stringWithFormat:@"%@",[[allSearchedPosts[indexPath.row] valueForKey:@"category"] valueForKey:@"category_parent_name"]];
        
        NSString *stringWithoutSpaces = [[NSString stringWithFormat:@"%@",[[allSearchedPosts[indexPath.row] valueForKey:@"category"] valueForKey:@"category_parent_color"]]
                                         stringByReplacingOccurrencesOfString:@"#" withString:@""];
        cell.separatorView.backgroundColor = [self colorWithHexString:stringWithoutSpaces];

        cell.articleTitle.textColor = [self colorWithHexString:stringWithoutSpaces];
        [cell.articleImage.layer setBorderColor:[self colorWithHexString:stringWithoutSpaces].CGColor];
        [cell.articleImage.layer setBorderWidth: 3];
        
        return cell;
    }
    else{
        
        NSString* webName = [[allSearchedPosts[indexPath.row] valueForKey:@"thumbnail_url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
        [cell.articleImage loadImageFromURL: url placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[allSearchedPosts[indexPath.row ] valueForKey:@"id"]]];
        
        cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allSearchedPosts[indexPath.row ] valueForKey:@"excerpt"]]];
        
        cell.articleTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[allSearchedPosts[indexPath.row ] valueForKey:@"title"]]];
        
//        if([[NSString stringWithFormat:@"%@",[[allSearchedPosts[indexPath.row] valueForKey:@"category"] valueForKey:@"parent_name"]] length] < 60)
//        cell.lastCategoryNameTable.text = [NSString stringWithFormat:@"%@",[[allSearchedPosts[indexPath.row] valueForKey:@"category"] valueForKey:@"parent_name"]];
//    
        
        cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        NSString *stringWithoutSpaces = [[NSString stringWithFormat:@"%@",[[allSearchedPosts[indexPath.row] valueForKey:@"category"] valueForKey:@"color"]]
                                         stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
      //  NSLog(@"%@",stringWithoutSpaces);
        cell.articleTitle.textColor = [self colorWithHexString:stringWithoutSpaces];
        cell.separatorView.backgroundColor = [self colorWithHexString:stringWithoutSpaces];
        [cell.articleImage.layer setBorderColor:[self colorWithHexString:stringWithoutSpaces].CGColor];
        [cell.articleImage.layer setBorderWidth: 3];

        return cell;
        
        
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![self.searchedFieldArticle isFirstResponder]){
    
        if([self isInternet] == NO)
        [GlobalVariables getInstance].idOfPost =[allSearchedPosts[indexPath.row] valueForKey:@"post_id"];
    else
        [GlobalVariables getInstance].idOfPost =[allSearchedPosts[indexPath.row] valueForKey:@"id"];
    [GlobalVariables getInstance].comingFrom = @"Search";
    [GlobalVariables getInstance].comingFromViewController = @"ListOfPostsController";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
    }
    else{
        [self.searchedFieldArticle resignFirstResponder];
        isKeyboardOn = false;
    }
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    isKeyboardOn = true;
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

-(BOOL)substring:(NSString *)substr existsInString:(NSString *)str {
    if(!([str rangeOfString:substr options:NSCaseInsensitiveSearch].length==0)) {
        return YES;
    }
    
    return NO;
}


-(void)sendingAnHTTPPOSTRequestOniOSSearch: (NSString *)searchedText withPage: (NSString *)page{

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:adminAjax];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *params = [NSString stringWithFormat:@"action=dgab_search_posts&search=%@&page=%@",searchedText,page];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSLog(@"%@ %@",searchedText,page);
        
        self.searchedFieldArticle.userInteractionEnabled = true;

        
        
//        NSLog(@"%@",allSearchedPosts);
        
        
        if(makingRequest == true){
            allSearchedPosts = [[NSMutableArray alloc] init];
            [self.searchScreenScroll setContentOffset:CGPointMake(0, originOfScroll+1) animated:YES];
            [self.searchedFieldArticle resignFirstResponder];
        }
        [spinnerview beginRefreshing];
        
        
        self.noArticleFounded.hidden = YES;
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        for(int i = 0 ; i < [[responseDict valueForKey:@"results"] count]; i++){
            
            [allSearchedPosts addObject:[responseDict valueForKey:@"results"][i]];
            
        }

        [self.allPostsSearched reloadData];
        
        [self.searchScreenScroll.infiniteScrollingView stopAnimating];
        
        [spinnerview endRefreshing];
        
        if([GlobalVariables getInstance].textSearched.length > 0 && allSearchedPosts.count == 0){
            self.noArticleFounded.userInteractionEnabled = false;
            self.noArticleFounded.hidden = false;
            self.noArticleFounded.text = @"AUCUN RÉSULTAT";
            
            [self.searchedFieldArticle resignFirstResponder];
            
        }
        else if(allSearchedPosts.count == 0 && [GlobalVariables getInstance].textSearched.length == 0){
            self.noArticleFounded.userInteractionEnabled = YES;
            self.noArticleFounded.hidden = false;
            self.noArticleFounded.text = @"Merci de renseigner une recherche";

            [self.searchedFieldArticle resignFirstResponder];
            
        }
        
        CGFloat a = 0;
        
        if(Page >= [[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"pages"]] intValue]){
            self.searchScreenScroll.showsInfiniteScrolling = NO;
            [self.searchScreenScroll.infiniteScrollingView stopAnimating];
            self.searchScreenScroll.infiniteScrollingView.hidden = true;
            
            a = self.logo.frame.size.height/2.5;
        }
        else{
            Page++;
            a = 0;
        }

        
      
        dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect frame = self.allPostsSearched.frame;
        frame.size.height = self.allPostsSearched.contentSize.height;
        self.allPostsSearched.frame = frame;
        
        self.searchScreenScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.allPostsSearched.frame.origin.y + self.allPostsSearched.frame.size.height + a);

        originOfScroll = self.allPostsSearched.frame.origin.y - self.searchView.frame.size.height/2 - self.logo.frame.size.height/2.5 ;
         });
        
        
    }];
    [dataTask resume];
}

-(void)dismissKeyboard {
    
    if(self.searchedFieldArticle.text.length == 0){
    [self.searchedFieldArticle resignFirstResponder];
    
    }
    else {
        [self.searchedFieldArticle resignFirstResponder];
    }
    
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
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [searchBar resignFirstResponder];
//    
//    self.noArticleFounded.hidden = YES;
//    Page = 1;
//    [GlobalVariables getInstance].textSearched = searchBar.text;
//    makingRequest = true;
//    [self initialize];
//    [self.allPostsSearched reloadData];
//    
//    
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [GlobalVariables getInstance].textSearched = textField.text;
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    [self.searchScreenScroll setContentOffset:CGPointMake(0, originOfScroll+1) animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseKeyboard" object: [NSString stringWithFormat:@"%@",theTextField.text]];
    
    [GlobalVariables getInstance].textSearched = theTextField.text;
    Page = 1;

    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [spinnerview beginRefreshing];
        [self performSelector:@selector(initialize) withObject:theTextField.text afterDelay:1.0f];
        makingRequest = true;
        
    }
    else
        [self performSelector:@selector(initialize) withObject:theTextField.text afterDelay:0.01f];
    

    
}

-(void)initialize{
    
    self.noArticleFounded.hidden = YES;
    
    [GlobalVariables getInstance].textSearched = self.searchedFieldArticle.text;
    
    
    if(makingRequest == false){
        allSearchedPosts = [[NSMutableArray alloc] init];
    }

    
    
    if([self isInternet] == NO){
        
        if([GlobalVariables getInstance].textSearched.length > 0){
            self.noArticleFounded.userInteractionEnabled = false;
            self.noArticleFounded.hidden = true;
            self.noArticleFounded.text = @"AUCUN RÉSULTAT";
        }
        else{
            self.noArticleFounded.userInteractionEnabled = YES;
            self.noArticleFounded.hidden = false;
            self.noArticleFounded.text = @"Merci de renseigner une recherche";
            
        }

        
      //  NSLog(@"%@",[GlobalVariables getInstance].textSearched);
        [GlobalVariables getInstance].DictionaryWithAllPosts = [[NSMutableDictionary alloc]initWithDictionary:(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllPosts"]]];
        
        
        for( NSString *key in [[GlobalVariables getInstance].DictionaryWithAllPosts allKeys]){
          //  NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]valueForKey:@"post_title"]]);
            
            if([self substring:[GlobalVariables getInstance].textSearched existsInString:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]valueForKey:@"post_title"]]]]] == YES || [self substring:[GlobalVariables getInstance].textSearched existsInString:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]valueForKey:@"post_content"]]]]]){
                
                [allSearchedPosts addObject:[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]];
            }
        }
        
        self.searchedFieldArticle.hidden = false;
        self.logo.hidden = false;
        self.rainbow.hidden = false;
        self.changeableBackground.hidden = false;
        
        if(allSearchedPosts.count == 0){
            self.noArticleFounded.hidden = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.allPostsSearched reloadData];
            
            self.searchedFieldArticle.userInteractionEnabled = true;
            
            CGRect frame = self.allPostsSearched.frame;
            frame.size.height = self.allPostsSearched.contentSize.height;
            self.allPostsSearched.frame = frame;
            
            self.searchScreenScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.allPostsSearched.frame.origin.y + self.allPostsSearched.frame.size.height+ self.logo.frame.size.height/2.5);
            
            originOfScroll = self.allPostsSearched.frame.origin.y - self.searchView.frame.size.height/2 - self.logo.frame.size.height/2.5 ;

            
        });
        
    }
    else {
        [self.view addSubview:spinnerview];
        [self.view bringSubviewToFront:spinnerview];
        [spinnerview beginRefreshing];
        
        [self sendingAnHTTPPOSTRequestOniOSSearch:[GlobalVariables getInstance].textSearched withPage:[NSString stringWithFormat:@"%d",Page]];
        
        self.searchScreenScroll.showsInfiniteScrolling = YES;
        
        [self.searchScreenScroll addInfiniteScrollingWithActionHandler:^{
            
            if([self isInternet] == YES){
                makingRequest = false;
                [self sendingAnHTTPPOSTRequestOniOSSearch:[GlobalVariables getInstance].textSearched withPage:[NSString stringWithFormat:@"%d",Page]];
                
                
                
            }
            else if([self isInternet] == NO){
                [self.searchScreenScroll.infiniteScrollingView stopAnimating];
                
            }
        }];
        
        
        [self.allPostsSearched reloadData];
        
        
    }
    
    
    
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
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.height == 812.0f)
    {
        
        if(changeFrameOnce == true && self.searchScreenScroll.contentOffset.y >=  originOfScroll - 37){
            
            
            [self.searchView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
            [self.searchView.layer setBorderWidth: 0.5];
            
            [self.view addSubview:self.searchView];
            [self.view bringSubviewToFront:self.searchView];
            
            
            self.searchView.backgroundColor = [self colorWithHexString:@"42BCE9"];
            self.searchedFieldArticle.textColor = [UIColor whiteColor];
            
            self.searchView.frame = CGRectMake(0, 37, self.view.frame.size.width, self.searchView.frame.size.height);
            changeFrameOnce = false;
            
            
            
            
            
        }
        else if(changeFrameOnce == false && self.searchScreenScroll.contentOffset.y <= originOfScroll - 37){
            
            
            
            
            
            [self.searchScreenScroll addSubview:self.searchView];
            [self.searchScreenScroll bringSubviewToFront:self.searchView];
            
            
            self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.allPostsSearched.frame.origin.y - self.searchView.frame.size.height/2 - self.logo.frame.size.height/2.5, self.searchView.frame.size.width, self.searchView.frame.size.height);
            
            self.searchView.backgroundColor = [UIColor whiteColor];
            self.searchedFieldArticle.textColor = [UIColor blackColor];
            
            
            [self.searchView.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [self.searchView.layer setBorderWidth: 0.5];
            
            changeFrameOnce = true;
            
            
            
            
        }
        
    }
    else{
    if(changeFrameOnce == true && self.searchScreenScroll.contentOffset.y >=  originOfScroll){
        
        
        [self.searchView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [self.searchView.layer setBorderWidth: 0.5];
        
        [self.view addSubview:self.searchView];
        [self.view bringSubviewToFront:self.searchView];
        
        
        self.searchView.backgroundColor = [self colorWithHexString:@"42BCE9"];
        self.searchedFieldArticle.textColor = [UIColor whiteColor];
        
        self.searchView.frame = CGRectMake(0, -1, self.view.frame.size.width, self.searchView.frame.size.height);
        changeFrameOnce = false;
        
        
        
        
        
    }
    else if(changeFrameOnce == false && self.searchScreenScroll.contentOffset.y <= originOfScroll - 1){
        
        
        
        
        
        [self.searchScreenScroll addSubview:self.searchView];
        [self.searchScreenScroll bringSubviewToFront:self.searchView];
        
        
        self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.allPostsSearched.frame.origin.y - self.searchView.frame.size.height/2 - self.logo.frame.size.height/2.5, self.searchView.frame.size.width, self.searchView.frame.size.height);
        
        self.searchView.backgroundColor = [UIColor whiteColor];
        self.searchedFieldArticle.textColor = [UIColor blackColor];
        
        
        [self.searchView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [self.searchView.layer setBorderWidth: 0.5];
        
        changeFrameOnce = true;
        
        

        
    }
        
    }

    
    if (scrollView.contentOffset.y < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
       

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(changeFrameOnce == true)
        [self.searchScreenScroll setContentOffset:CGPointMake(0, originOfScroll+1) animated:YES];
}
- (IBAction)openiAPController:(id)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"IAPViewController"]];
}
@end
