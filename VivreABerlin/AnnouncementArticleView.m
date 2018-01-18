//
//  AnnouncementArticleView.m
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AnnouncementArticleView.h"
#import "JTMaterialSpinner.h"
#import "Reachability.h"
#import "GlobalVariables.h"
#import "UIImageView+Network.h"
#import "Header.h"
#import <Social/Social.h>
#import "SimpleFilesCache.h"
#import "OLGhostAlertView.h"

@interface AnnouncementArticleView ()

@end

@implementation AnnouncementArticleView
{
    JTMaterialSpinner *spinnerview;
    NSDictionary *announcementInfos;
    NSMutableArray *imageUrls;
    BOOL changeFrameOnce;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"YES"])
        self.offlineButton.hidden = YES;
    
    changeFrameOnce = true;
    self.notSaved.hidden = true;
    NSLog(@"ANNOUNCEMENT ID: %@",[GlobalVariables getInstance].idOfAnnouncement);
    
    [GlobalVariables getInstance].currentAnnouncementScreen = @"AnnouncementArticleView";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(removeScreen:) name:@"removeScreen" object:nil];
    
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y + 22, 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    [self.view addSubview:spinnerview];
    [self.view bringSubviewToFront:spinnerview];
    
    [spinnerview beginRefreshing];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    self.logo.image = [UIImage imageNamed:@"Logo.png"];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    self.logo.clipsToBounds = true;
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
    [self.annScrollView bringSubviewToFront:self.rainbow];
    [self.annScrollView bringSubviewToFront:self.logo];
    
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
    
    self.annScrollView.delaysContentTouches = NO;
    
    self.addAnn.adjustsFontSizeToFitWidth = true;
    self.editAnn.adjustsFontSizeToFitWidth = true;
    self.exitAnn.adjustsFontSizeToFitWidth = true;
    
    self.imagesScroll.hidden = true;
    self.viewsView.hidden = true;
    
    self.contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.contentTextView.editable = false;
    self.contentTextView.scrollEnabled = false;
    self.contentTextView.showsVerticalScrollIndicator = false;
    self.contentTextView.selectable = YES;
    
    self.announceButtons.frame = CGRectMake(self.announceButtons.frame.origin.x, self.logo.frame.origin.y + self.logo.frame.size.height * 1.2, self.announceButtons.frame.size.width, self.announceButtons.frame.size.height);
    
    [GlobalVariables getInstance].DictionaryWithAllAnnouncements = [[NSMutableDictionary alloc] initWithDictionary:[(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllAnnouncements"]] mutableCopy]];
   // NSLog(@"%@",[GlobalVariables getInstance].DictionaryWithAllAnnouncements);
    
    if([self isInternet] == YES){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self getInfosOfAnnouncement:[NSString stringWithFormat:petitesAnnoncesArticleView,[GlobalVariables getInstance].idOfAnnouncement]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.titleOfAnnounce.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementInfos valueForKey:@"title"]]]];
                self.titleOfAnnounce.numberOfLines = 0;
                [self.titleOfAnnounce sizeToFit];
                
                
                
                self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.titleOfAnnounce.frame.size.height + self.titleOfAnnounce.frame.origin.y + 10, self.contentTextView.frame.size.width, self.contentTextView.frame.size.height);
                
                self.contentTextView.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementInfos valueForKey:@"content"]]]];
                [self.contentTextView sizeToFit];
                
                UITextView *newTextView = [[UITextView alloc]initWithFrame:CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y + self.contentTextView.frame.size.height + 10, self.viewsView.frame.size.width, 100)];
                newTextView.backgroundColor = [UIColor clearColor];
                
                [UIView transitionWithView:self.contentTextView
                                  duration:0.4f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    
                                    
                                    [[GlobalVariables getInstance].DictionaryWithAllAnnouncements setObject:announcementInfos forKey:[GlobalVariables getInstance].idOfAnnouncement];
                                    [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:[GlobalVariables getInstance].DictionaryWithAllAnnouncements] withName:@"DictionaryWithAllAnnouncements"];
                                    
                                    
        
                                    
                                    
                                    
                                    [self.annScrollView addSubview:newTextView];
                                    [self.annScrollView bringSubviewToFront:newTextView];
                                    
                                    newTextView.dataDetectorTypes = UIDataDetectorTypeLink;
                                    newTextView.editable = false;
                                    newTextView.scrollEnabled = false;
                                    newTextView.showsVerticalScrollIndicator = false;
                                    UIFont *arialFont = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                                    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
                                    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"Contact: " attributes: arialDict];
                                    
                                    UIFont *VerdanaFont = [UIFont fontWithName:@"Montserrat-Light" size:14.0];
                                    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
                                    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: [self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementInfos valueForKey:@"contact_email"]]] attributes:verdanaDict];
                                    
                                    [aAttrString addAttribute:NSForegroundColorAttributeName value:self.contentTextView.textColor range:(NSMakeRange(aAttrString.length, 0))];
                                    [vAttrString addAttribute:NSForegroundColorAttributeName value:self.titleOfAnnounce.textColor range:(NSMakeRange(0, vAttrString.length))];
                                    
                                    [aAttrString appendAttributedString:vAttrString];
                                    
                                    
                                    newTextView.attributedText = aAttrString;
                                    
                                    [newTextView sizeToFit];
                                    
                                    
                                //    NSLog(@"%@",newTextView.text);
                                    
                                    imageUrls = [[NSMutableArray alloc]init];
                                    
                                    if([[announcementInfos valueForKey:@"images"] count] == 0)
                                        self.imagesScroll.frame = CGRectMake(0, newTextView.frame.size.height + newTextView.frame.origin.y, 0, 0);
                                    else{
                                        self.imagesScroll.frame = CGRectMake(self.imagesScroll.frame.origin.x, newTextView.frame.size.height + newTextView.frame.origin.y, self.imagesScroll.frame.size.width, self.imagesScroll.frame.size.height);
                                        
                                        
                                        CGFloat originOfImage = 0;
                                        
                                        for(int i = 0 ; i < [[announcementInfos valueForKey:@"images"] count]; i++){
                                            
                                            
                                            
                                            UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(originOfImage, self.imageinScroll.frame.origin.y, self.imageinScroll.frame.size.width, self.imageinScroll.frame.size.height)];
                                            imageview.layer.cornerRadius = 5;
                                            imageview.contentMode = UIViewContentModeScaleAspectFill;
                                            imageview.clipsToBounds = true;
                                            [imageview.layer setBorderColor:[self colorWithHexString:@"F69901"].CGColor];
                                            [imageview.layer setBorderWidth: 2.75 * self.view.frame.size.width / 375];
                                            
                                            
                                            NSString* webName = [[[announcementInfos valueForKey:@"images"][i] valueForKey:@"original"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                            NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                            NSURL* url = [NSURL URLWithString:webStringURL];
                                            
                                            [imageUrls addObject:[NSString stringWithFormat:@"%@",[[announcementInfos valueForKey:@"images"][i] valueForKey:@"original"]]];
                                            
                                            [imageview loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [[[[NSString stringWithFormat:@"%@", imageUrls[i]] substringFromIndex: [[NSString stringWithFormat:@"%@", imageUrls[i]] length] - 20] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""]];
                                            
                                            
                                            
                                            UIButton *imageButton = [[UIButton alloc]initWithFrame:imageview.frame];
                                            
                                            imageButton.tag = i;
                                            imageButton.backgroundColor = [UIColor clearColor];
                                            [imageButton addTarget:self
                                                            action:@selector(ClickAnimage:)
                                                  forControlEvents:UIControlEventTouchUpInside];
                                            
                                            
                                            [self.imagesScroll addSubview:imageview];
                                            [self.imagesScroll bringSubviewToFront:imageview];
                                            [self.imagesScroll addSubview:imageButton];
                                            [self.imagesScroll bringSubviewToFront:imageButton];
                                            
                                            self.imagesScroll.contentSize = CGSizeMake(originOfImage + imageview.frame.size.width, self.imagesScroll.frame.size.height);
                                            self.imagesScroll.showsHorizontalScrollIndicator = false;
                                            
                                            originOfImage = originOfImage + imageview.frame.size.width + 10;
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                    self.viewsView.frame = CGRectMake(self.viewsView.frame.origin.x, self.imagesScroll.frame.size.height + self.imagesScroll.frame.origin.y, self.viewsView.frame.size.width, self.viewsView.frame.size.height);
                                    
                                    self.numberOfViews.text = [NSString stringWithFormat:@"Cette annonce a été vue %d fois",[[announcementInfos valueForKey:@"views"] intValue]];
                                    self.numberOfViews.adjustsFontSizeToFitWidth = true;
                                    
                                    
                                    self.imagesScroll.hidden = false;
                                    self.viewsView.hidden = false;
                                    
                                    self.annScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.viewsView.frame.size.height + self.viewsView.frame.origin.y + self.logo.frame.size.width/2.5);
                                    
                                    [spinnerview endRefreshing];
                                    
                                } completion:nil];
                
                
            });
            
        });
        
    }
    else if ([[GlobalVariables getInstance].DictionaryWithAllAnnouncements objectForKey:[GlobalVariables getInstance].idOfAnnouncement] != nil){
        

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *announcementOfflineInfos = [[NSMutableDictionary alloc]initWithDictionary:(NSMutableDictionary *)[[GlobalVariables getInstance].DictionaryWithAllAnnouncements objectForKey:[GlobalVariables getInstance].idOfAnnouncement]];
            
            
            [UIView transitionWithView:self.contentTextView
                              duration:0.4f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                

                                
                                self.titleOfAnnounce.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementOfflineInfos valueForKey:@"title"]]]];
                                self.titleOfAnnounce.numberOfLines = 0;
                                [self.titleOfAnnounce sizeToFit];
                                
                                
                                
                                self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.titleOfAnnounce.frame.size.height + self.titleOfAnnounce.frame.origin.y + 10, self.contentTextView.frame.size.width, self.contentTextView.frame.size.height);
                                
                                self.contentTextView.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementOfflineInfos valueForKey:@"content"]]]];
                                [self.contentTextView sizeToFit];
                                
                                
                                UITextView *newTextView = [[UITextView alloc]initWithFrame:CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y + self.contentTextView.frame.size.height + 10, self.contentTextView.frame.size.width, 100)];
                                [self.annScrollView addSubview:newTextView];
                                [self.annScrollView bringSubviewToFront:newTextView];
                                newTextView.backgroundColor = [UIColor clearColor];
                                newTextView.dataDetectorTypes = UIDataDetectorTypeLink;
                                newTextView.editable = false;
                                newTextView.scrollEnabled = false;
                                newTextView.showsVerticalScrollIndicator = false;
                                UIFont *arialFont = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                                NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
                                NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"Contact: " attributes: arialDict];
                                
                                UIFont *VerdanaFont = [UIFont fontWithName:@"Montserrat-Light" size:14.0];
                                NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
                                NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: [self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[announcementOfflineInfos valueForKey:@"contact_email"]]] attributes:verdanaDict];
                                
                                [aAttrString addAttribute:NSForegroundColorAttributeName value:self.contentTextView.textColor range:(NSMakeRange(aAttrString.length, 0))];
                                [vAttrString addAttribute:NSForegroundColorAttributeName value:self.titleOfAnnounce.textColor range:(NSMakeRange(0, vAttrString.length))];
                                
                                [aAttrString appendAttributedString:vAttrString];
                                
                                
                                newTextView.attributedText = aAttrString;
                                
                                [newTextView sizeToFit];
                                
                                
                              //  NSLog(@"%@",newTextView.text);
                                
                                imageUrls = [[NSMutableArray alloc]init];
                                
                                if([[announcementOfflineInfos valueForKey:@"images"] count] == 0)
                                    self.imagesScroll.frame = CGRectMake(0, newTextView.frame.size.height + newTextView.frame.origin.y, 0, 0);
                                else{
                                    self.imagesScroll.frame = CGRectMake(self.imagesScroll.frame.origin.x, newTextView.frame.size.height + newTextView.frame.origin.y, self.imagesScroll.frame.size.width, self.imagesScroll.frame.size.height);
                                    
                                    
                                    CGFloat originOfImage = 0;
                                    
                                    for(int i = 0 ; i < [[announcementOfflineInfos valueForKey:@"images"] count]; i++){
                                        
                                        
                                        
                                        UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(originOfImage, self.imageinScroll.frame.origin.y, self.imageinScroll.frame.size.width, self.imageinScroll.frame.size.height)];
                                        imageview.layer.cornerRadius = 5;
                                        imageview.contentMode = UIViewContentModeScaleAspectFill;
                                        imageview.clipsToBounds = true;
                                        [imageview.layer setBorderColor:[self colorWithHexString:@"F69901"].CGColor];
                                        [imageview.layer setBorderWidth: 2.75 * self.view.frame.size.width / 375];
                                        
                                        
                                        NSString* webName = [[[announcementOfflineInfos valueForKey:@"images"][i] valueForKey:@"original"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                        NSURL* url = [NSURL URLWithString:webStringURL];
                                        
                                        [imageUrls addObject:[NSString stringWithFormat:@"%@",[[announcementOfflineInfos valueForKey:@"images"][i] valueForKey:@"original"]]];
                                        
                                        [imageview loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey: [[[[NSString stringWithFormat:@"%@", imageUrls[i]] substringFromIndex: [[NSString stringWithFormat:@"%@", imageUrls[i]] length] - 20] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""]];
                                        
                                        
                                        
                                        UIButton *imageButton = [[UIButton alloc]initWithFrame:imageview.frame];
                                        
                                        imageButton.tag = i;
                                        imageButton.backgroundColor = [UIColor clearColor];
                                        [imageButton addTarget:self
                                                        action:@selector(ClickAnimage:)
                                              forControlEvents:UIControlEventTouchUpInside];
                                        
                                        
                                        [self.imagesScroll addSubview:imageview];
                                        [self.imagesScroll bringSubviewToFront:imageview];
                                        [self.imagesScroll addSubview:imageButton];
                                        [self.imagesScroll bringSubviewToFront:imageButton];
                                        
                                        self.imagesScroll.contentSize = CGSizeMake(originOfImage + imageview.frame.size.width, self.imagesScroll.frame.size.height);
                                        self.imagesScroll.showsHorizontalScrollIndicator = false;
                                        
                                        originOfImage = originOfImage + imageview.frame.size.width + 10;
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                self.viewsView.frame = CGRectMake(self.viewsView.frame.origin.x, self.imagesScroll.frame.size.height + self.imagesScroll.frame.origin.y, self.viewsView.frame.size.width, self.viewsView.frame.size.height);
                                
                                self.numberOfViews.text = [NSString stringWithFormat:@"Cette annonce a été vue %d fois",[[announcementOfflineInfos valueForKey:@"views"] intValue]];
                                self.numberOfViews.adjustsFontSizeToFitWidth = true;
                                
                                
                                self.imagesScroll.hidden = false;
                                self.viewsView.hidden = false;
                                
                                self.annScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.viewsView.frame.size.height + self.viewsView.frame.origin.y + self.logo.frame.size.width/2.5);
                                
                                [spinnerview endRefreshing];
                                
                            } completion:nil];
            
            
        });

        
    }
    else{
        self.notSaved.hidden = false;
        [spinnerview endRefreshing];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self Spin];
}
- (void) ClickAnimage: (UIButton*) button {
    
    NSInteger tag = button.tag;
    
    [GlobalVariables getInstance].announcementImageUrl = imageUrls[tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ScrollImageController"]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}

//- (IBAction)getBack:(id)sender {
//
//    [self willMoveToParentViewController:nil];
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//}

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
                
                //NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
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
-(void)Spin{
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
    
}

-(void)getInfosOfAnnouncement: (NSString *)url{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    
    announcementInfos = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    
    
    
    
}
- (IBAction)searchAnn:(id)sender {
    [GlobalVariables getInstance].editerClicked = NO;
    [GlobalVariables getInstance].currentPopUpAnnouncementScreen = @"AnnouncementArticleView";
      [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"SearchAnnouncement"]];
}
- (IBAction)editerAnn:(id)sender {
    if([self isInternet] == YES){
    [GlobalVariables getInstance].editerClicked = YES;
    [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer = @"EditAnnClickedOnArtcilePage";
    [GlobalVariables getInstance].currentPopUpAnnouncementScreen = @"AnnouncementArticleView";
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"EditAnnouncement"]];
    }
    else{
        [self showMessage:@"Please connect to the internet"];
    }
}
- (IBAction)addAnno:(id)sender {
    if([self isInternet] == YES){
    [GlobalVariables getInstance].editerClicked = NO;
    [GlobalVariables getInstance].currentPopUpAnnouncementScreen = @"AnnouncementArticleView";
    [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer = nil;
    [GlobalVariables getInstance].currentAnnouncementScreen =  @"AnnouncementArticleView";
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AddAnnouncement"]];
    }
    else{
        [self showMessage:@"Please connect to the internet"];
    }
}

- (IBAction)exitAnnounce:(id)sender {
    
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                           self.view.alpha = 0;
                       } completion:^(BOOL finished){
                           [self willMoveToParentViewController:nil];
                           [self.view removeFromSuperview];
                           [self removeFromParentViewController];
                       }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == self.annScrollView){
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height == 812.0f) {
            
                if(changeFrameOnce == true && scrollView.contentOffset.y >= self.logo.frame.origin.y + self.logo.frame.size.height*1.2 - 37){
                    
                    self.announceButtons.frame = CGRectMake(self.announceButtons.frame.origin.x, 37, self.announceButtons.frame.size.width, self.announceButtons.frame.size.height);
                    
                    [self.view addSubview:self.announceButtons];
                    [self.view bringSubviewToFront:self.announceButtons];
                    
                    
                    changeFrameOnce = false;
                }
                else if(changeFrameOnce ==  false && scrollView.contentOffset.y <= self.logo.frame.origin.y + self.logo.frame.size.height*1.2 - 37){
                    
                    self.announceButtons.frame = CGRectMake(self.announceButtons.frame.origin.x, self.logo.frame.origin.y + self.logo.frame.size.height*1.2, self.announceButtons.frame.size.width, self.announceButtons.frame.size.height);
                    
                    [self.annScrollView addSubview:self.announceButtons];
                    [self.annScrollView bringSubviewToFront:self.announceButtons];
                    
                    changeFrameOnce = true;
                }
            }
            
            
        
        else {
            if(changeFrameOnce == true && scrollView.contentOffset.y >= self.logo.frame.origin.y + self.logo.frame.size.height*1.2 - 5){
                
                self.announceButtons.frame = CGRectMake(self.announceButtons.frame.origin.x, 5, self.announceButtons.frame.size.width, self.announceButtons.frame.size.height);
                
                [self.view addSubview:self.announceButtons];
                [self.view bringSubviewToFront:self.announceButtons];
                
                
                changeFrameOnce = false;
            }
            else if(changeFrameOnce ==  false && scrollView.contentOffset.y <= self.logo.frame.origin.y + self.logo.frame.size.height*1.2 - 5){
                
                self.announceButtons.frame = CGRectMake(self.announceButtons.frame.origin.x, self.logo.frame.origin.y + self.logo.frame.size.height*1.2, self.announceButtons.frame.size.width, self.announceButtons.frame.size.height);
                
                [self.annScrollView addSubview:self.announceButtons];
                [self.annScrollView bringSubviewToFront:self.announceButtons];
                
                changeFrameOnce = true;
            }
        }
    
    
    if (scrollView.contentOffset.y < 0)
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
}
- (IBAction)shareFB:(id)sender {
    
    NSString *textToShare = [NSString stringWithFormat:@"%@ - Voir les annonces - Vivre à %@ - %@ ",[announcementInfos valueForKey:@"title" ],nameOfTheCity,[announcementInfos valueForKey:@"url"]];
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText: textToShare];
    [self presentViewController:controller animated:YES completion:Nil];
    
    
}

- (IBAction)shareTwet:(id)sender {
    
    NSString *textToShare = [NSString stringWithFormat:@"%@ - Voir les annonces - Vivre à %@ - %@ ",[announcementInfos valueForKey:@"title" ],nameOfTheCity,[announcementInfos valueForKey:@"url"]];
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText: textToShare];
    
    [self presentViewController:controller animated:YES completion:Nil];
    
    
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


-(void) removeScreen: (NSNotification *) notification
{
  
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [GlobalVariables getInstance].currentAnnouncementScreen = @"AnnouncementsViewController";
    
    
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
