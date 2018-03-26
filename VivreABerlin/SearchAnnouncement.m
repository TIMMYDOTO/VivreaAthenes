//
//  SearchAnnouncement.m
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "SearchAnnouncement.h"
#import "GlobalVariables.h"
#import "Reachability.h"
#import "Header.h"
#import "UIImageView+Network.h"
#import "AnnouncementCell.h"
#import "SimpleFilesCache.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "JTMaterialSpinner.h"
@interface SearchAnnouncement ()

@end

@implementation SearchAnnouncement

{
    NSMutableArray *searchedAnnouncementsArray;
    int Page;
    JTMaterialSpinner *spinnerview;
    NSDictionary *responseDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    self.noAnnfound.hidden = true;
    
    self.searchScreenView.layer.cornerRadius = 5;
    self.searchScreenView.clipsToBounds = true;
    self.subView.layer.cornerRadius = 5;
    self.subView.clipsToBounds = true;
    self.searchFieldView.layer.cornerRadius = self.searchFieldView.frame.size.height/2;
    self.searchFieldView.clipsToBounds = true;
    
    self.searchField.delegate = self;
    
    self.searchTable.alpha = 0;

    searchedAnnouncementsArray = [[NSMutableArray alloc]init];
    self.searchTable.backgroundColor = [UIColor clearColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(closeSearch) name:@"closeSearch" object:nil];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchedAnnouncementsArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnouncementCell";
    
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.announcementTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[searchedAnnouncementsArray[indexPath.row] valueForKey:@"title"]]]];
    cell.announcementDate.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[searchedAnnouncementsArray[indexPath.row] valueForKey:@"post_date"]]]];
    if([self isInternet] == YES)
        cell.announcementContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[searchedAnnouncementsArray[indexPath.row] valueForKey:@"excerpt"]]]];
    else
        cell.announcementContent.text =[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[searchedAnnouncementsArray[indexPath.row] valueForKey:@"content"]]]];
    
    cell.announcementContent.text = [cell.announcementContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    cell.announcementContent.text = [[cell.announcementContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
    NSString* webName;
    if([self isInternet] == YES)
        webName = [[NSString stringWithFormat:@"%@",[searchedAnnouncementsArray[indexPath.row] valueForKey:@"thumbnail"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    else if([[searchedAnnouncementsArray[indexPath.row] valueForKey:@"images"] count] > 0)
        webName = [[NSString stringWithFormat:@"%@",[searchedAnnouncementsArray[indexPath.row] valueForKey:@"images"][0]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    [cell.announcementImage loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@",[searchedAnnouncementsArray valueForKey:@"id"][indexPath.row]]];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [GlobalVariables getInstance].idOfAnnouncement = [searchedAnnouncementsArray[indexPath.row] valueForKey:@"id"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    
    if([[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementsViewController"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
    }
    else if([[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementArticleView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.text.length > 0)
    [self initializeSearch];
    
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self.searchField isFirstResponder]){
        [self.searchField resignFirstResponder];
    }
    else{
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.searchScreenView)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    }
}
- (IBAction)launchSearch:(id)sender {

    [self.searchField resignFirstResponder];
    
    if(self.searchField.text.length > 0)
    [self initializeSearch];
    
    
    
}
//- (IBAction)addANn:(id)sender {
//    [self.searchField resignFirstResponder];
//    [GlobalVariables getInstance].editerClicked = NO;
//    [GlobalVariables getInstance].currentPopUpAnnouncementScreen = @"AnnouncementSearchView";
//    [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer = nil;
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AddAnnouncement"]];
//}
//
//- (IBAction)editAnn:(id)sender {
//    [self.searchField resignFirstResponder];
//    [GlobalVariables getInstance].editerClicked = YES;
//    [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer = @"EditAnnClickedOnSearchPage";
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"EditAnnouncement"]];
//}

- (IBAction)getBack:(id)sender {
    [self.searchField resignFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}

-(void)initializeSearch{
    searchedAnnouncementsArray = [[NSMutableArray alloc] init];
    self.noAnnfound.hidden = true;
    Page = 1;
    
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 18 , self.searchTable.center.y - 10, 35, 35)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [self colorWithHexString:@"829B00"].CGColor;
    
    [self.view addSubview:spinnerview];
    [self.view bringSubviewToFront:spinnerview];
    
    [self.view addSubview:self.searchTable];
    [self.view bringSubviewToFront:self.searchTable];

    [UIView animateWithDuration:0.3 animations:^{
        
    self.subView.frame = CGRectMake(self.subView.frame.origin.x, self.subView.frame.origin.y, self.subView.frame.size.width, self.searchScreenView.frame.size.height + self.searchTable.frame.size.height + 5);
        
    }completion:nil];
    
    [spinnerview beginRefreshing];
    
    [GlobalVariables getInstance].DictionaryWithAllAnnouncements = [[NSMutableDictionary alloc] initWithDictionary:[(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllAnnouncements"]] mutableCopy]];
    

    
    if([self isInternet] == YES){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            [self sendingAnHTTPPOSTRequestForAnnouncements:[NSString stringWithFormat:searchPetitesAnnonces,[self.searchField.text lowercaseString],Page]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(int i = 0 ; i < [[responseDict valueForKey:@"results"] count]; i++){
                    
                    [searchedAnnouncementsArray addObject:[responseDict valueForKey:@"results"][i]];
                    
                }
                
                
                [self.searchTable reloadData];
                
                if(searchedAnnouncementsArray.count == 0)
                    self.noAnnfound.hidden = false;
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.searchTable.alpha = 1;
                    
                }completion:nil];
                
                if(Page >= [[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"pages"]] intValue]){
                    [self.searchTable.infiniteScrollingView stopAnimating];
                 
                }
                else{
                    Page++;
                    
                }
                
                
                [spinnerview endRefreshing];
                
                
                
                
            });
            
        });
        
        [self.searchTable addInfiniteScrollingWithActionHandler:^{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self sendingAnHTTPPOSTRequestForAnnouncements:[NSString stringWithFormat:searchPetitesAnnonces,[self.searchField.text lowercaseString],Page]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if(Page < [[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"pages"]] intValue]){
                        
                    for(int i = 0 ; i < [[responseDict valueForKey:@"results"] count]; i++){
                        
                        [searchedAnnouncementsArray addObject:[responseDict valueForKey:@"results"][i]];
                        
                    }

                    [self.searchTable reloadData];
                    [self.searchTable.infiniteScrollingView stopAnimating];
                    
                    
                    if(searchedAnnouncementsArray.count == 0)
                        self.noAnnfound.hidden = false;

                        Page++;
                    
                    
                    }
                    else{
                        self.searchTable.infiniteScrollingView.enabled = NO;
                    }
                     [self.searchTable.infiniteScrollingView stopAnimating];
                    
                });
            });
            
            if([self isInternet] == NO)
                [self.searchTable.infiniteScrollingView stopAnimating];
            
            
        }];
        
        
    }
    
    else if([[GlobalVariables getInstance].DictionaryWithAllAnnouncements allKeys].count != 0) {
        
            searchedAnnouncementsArray = [[NSMutableArray alloc]init];
            
            for( NSString *key in [[GlobalVariables getInstance].DictionaryWithAllAnnouncements allKeys]){
                
                if([self substring:self.searchField.text existsInString:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[[GlobalVariables getInstance].DictionaryWithAllAnnouncements objectForKey:key]valueForKey:@"title"]]]] == YES || [self substring:self.searchField.text existsInString:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[[GlobalVariables getInstance].DictionaryWithAllAnnouncements objectForKey:key]valueForKey:@"content"]]]] == YES){
                    
                    [searchedAnnouncementsArray addObject:[[GlobalVariables getInstance].DictionaryWithAllAnnouncements objectForKey:key]];
                }
            }
            
            
            [self.searchTable reloadData];
            
            [spinnerview endRefreshing];
       
            [UIView animateWithDuration:0.8 animations:^{
            
            self.searchTable.alpha = 1;
            
            }completion:nil];
        
            if(searchedAnnouncementsArray.count == 0)
            self.noAnnfound.hidden = false;
        
        
        
    }
    
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
-(BOOL)substring:(NSString *)substr existsInString:(NSString *)str {
    if(!([str rangeOfString:substr options:NSCaseInsensitiveSearch].length==0)) {
        return YES;
    }
    
    return NO;
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.searchTable.layer.mask)
    {
        CAGradientLayer *maskLayer = [CAGradientLayer layer];

        maskLayer.locations = @[[NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:0.075],
                                [NSNumber numberWithFloat:1.0],
                                [NSNumber numberWithFloat:1.0]];

        maskLayer.bounds = CGRectMake(0, 0,
                                      self.searchTable.frame.size.width,
                                      self.searchTable.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;

        self.searchTable.layer.mask = maskLayer;
    }
    [self scrollViewDidScroll:self.searchTable];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;


    NSArray *colors;

    if (scrollView.contentOffset.y + scrollView.contentInset.top <= 0) {
        //Top of scrollView
        colors = @[(__bridge id)innerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)outerColor];
    } else if (scrollView.contentOffset.y + scrollView.frame.size.height
               >= scrollView.contentSize.height) {
        //Bottom of tableView
        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)outerColor];
    } else {
        //Middle
        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)outerColor];
    }
    ((CAGradientLayer *)scrollView.layer.mask).colors = colors;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    scrollView.layer.mask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}
-(void)closeSearch {

  //  if([[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"AnnouncementsViewController"])
  //  {
  //      [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
 //       [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
 //       [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];

 //   }
 //   else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
   //      [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
  //  }
    
}
@end
