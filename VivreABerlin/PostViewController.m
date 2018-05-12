//
//  PostViewController.m
//  VivreABerlin
//
//  Created by Artyom Schiopu on 4/26/18.
//  Copyright © 2018 Stoica Mihail. All rights reserved.
//

#import "PostViewController.h"
#import "GlobalVariables.h"
#import "AFNetworking.h"
#import "Header.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"
#import <Social/Social.h>
#import "SuggestionsCell.h"
#import "SimpleFilesCache.h"

#import "PostModel.h"

@interface PostViewController (){
    
    __weak IBOutlet UILabel *practicalInfosLabel;
    IBOutlet UIView *practicalInfos;
    
    __weak IBOutlet UIView *articlesSuggestions;
    __weak IBOutlet UIView *scheduleView;
    CGFloat initialpozitionOfBackButton;
    CGFloat initialpozitionOfOpenMenuButton;
    __weak IBOutlet UILabel *lundiSchedule;
    UIButton *backToTop;
    __weak IBOutlet UILabel *mardiSchedule;
    
    __weak IBOutlet UILabel *mercrediSchedule;
    
    __weak IBOutlet UILabel *jeudiSchedule;
    
    __weak IBOutlet UILabel *vendrediSchedule;
    
    __weak IBOutlet UILabel *samediSchedule;
    
    __weak IBOutlet UILabel *dimancheSchedule;
    
    
    BOOL changeFrameOnce;
    BOOL changeFrameOnce1;
    __weak IBOutlet UIButton *menuButton;
    
    __weak IBOutlet UIButton *backButton;
  
    NSString *finalString;
    
    MGLPointAnnotation *point;
    PostModel *postModel;
    
    __weak IBOutlet UIScrollView *mainScrollView;
    
    __weak IBOutlet UIButton *facebookfb;
    CGRect heightForPracticalInfos;
    __weak IBOutlet UIImageView *imageViewHeader;
    
    __weak IBOutlet UIView *blueSeparatorView;
    
    __weak IBOutlet UILabel *authorLabel;
    NSString *htmlString;
    BOOL canAppear;
    WKWebView *wkWebView;
    int numberOfStars;
    CGFloat screenWidth;
    CGFloat screenHeight;
    __weak IBOutlet UIImageView *rainbow;
    __weak IBOutlet UIImageView *logo;
    
    __weak IBOutlet UILabel *postsBigTitle;
    __weak IBOutlet UILabel *passage;
    
    
    __weak IBOutlet UIView *starImageView;
    __weak IBOutlet UIImageView *starImage1;
    __weak IBOutlet UIImageView *starImage2;
    __weak IBOutlet UIImageView *starImage3;
    __weak IBOutlet UIImageView *starImage4;
    __weak IBOutlet UIImageView *starImage5;
    NSMutableArray *starImageArr;
    float heightOfObj;
    
    BOOL unlockedIAP;
    NSMutableArray *postInfo;

    NSMutableArray *allTagsSlugs;
    NSMutableArray *allTagsName;
    
    float yPositionForSchedule;
    
    NSMutableArray *arrayUsedInTable;
    NSMutableArray *arrayWithImagesUsedInTable;
    
    CGFloat scale;
}

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    unlockedIAP = [[NSUserDefaults standardUserDefaults] valueForKey:@"didUserPurchasedIap"];
    unlockedIAP = NO;
    
    arrayUsedInTable = [[NSMutableArray alloc] init];
    arrayWithImagesUsedInTable = [[NSMutableArray alloc] init];
    allTagsSlugs = [[NSMutableArray alloc] init];
    allTagsName = [[NSMutableArray alloc] init];
    
    starImageArr = [[NSMutableArray alloc] initWithObjects:starImage1, starImage2, starImage3, starImage4, starImage5, nil];
    scale = 1.0;
    NSLog(@"%@ id OF POST",[GlobalVariables getInstance].idOfPost);
//     [[GlobalVariables getInstance] setIdOfPost:@"35197"];
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
        NSLog(@"local");
        postModel = [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]];
        
        
        for (int i = 0; i < [postModel.numberOfStars intValue]; i++) {
            [starImageArr[i] setImage:[UIImage imageNamed:@"starColour.png"]];
            
        }
        imageViewHeader.image = [SimpleFilesCache cachedImageWithName:[[GlobalVariables getInstance].idOfPost stringByAppendingString:@"img"]];
        authorLabel.text = postModel.authorName;
        
         wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, imageViewHeader.frame.size.height+200, screenWidth, 0) configuration:[WKWebViewConfiguration new]];
        passage.text = postModel.passageText;
        postsBigTitle.text = postModel.postTitleText;
         [postsBigTitle sizeToFit];
        [wkWebView loadHTMLString:postModel.htmlString baseURL: nil];
//        NSLog(@"ew]contentSize].height %f", [[wkWebView scrollView]contentSize].height);
        [self settingMap:postModel.postMapView];
        
    }
    else{ [self getPost]; }
   
    
    [self settingDesign];
   
    initialpozitionOfOpenMenuButton = self.view.frame.size.height/12;
    initialpozitionOfBackButton = self.view.frame.size.height/5;
    changeFrameOnce = true;
    changeFrameOnce1 = true;
    
    
    
    
    
}

-(void)settingDesign{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
     screenWidth = screenRect.size.width;
     screenHeight = screenRect.size.height;

    [imageViewHeader setFrame:CGRectMake(0, 0, screenWidth, 236)];
    [blueSeparatorView setFrame:CGRectMake(0, imageViewHeader.frame.size.height - 29, screenWidth, 29)];
    [rainbow setFrame:CGRectMake(screenWidth/2-40, imageViewHeader.frame.size.height-42, 80, 85)];
    [logo setFrame:CGRectMake(screenWidth/2-40, imageViewHeader.frame.size.height-42, 80, 85)];
    
    [authorLabel setFrame:CGRectMake(screenWidth, imageViewHeader.frame.size.height-31, 0, 38)];
    [facebookfb setFrame:CGRectMake(5, imageViewHeader.frame.size.height + 10, 45, 30)];
    [postsBigTitle setFrame:CGRectMake(5, facebookfb.frame.origin.y + facebookfb.frame.size.height + 15, screenWidth - 20, 38)];
    [passage setFrame:CGRectMake(5, postsBigTitle.frame.origin.y + postsBigTitle.frame.size.height + 12 , screenWidth, 38)];

    [starImageView setFrame:CGRectMake(5, passage.frame.origin.y + passage.frame.size.height + 4, 90, 27)];
    if (wkWebView == nil) {
        wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, starImageView.frame.origin.y + starImageView.frame.size.height+20, screenWidth, 0) configuration:[WKWebViewConfiguration new]];
    }
 

    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
    wkWebView.opaque = false;
    wkWebView.scrollView.scrollEnabled = NO;


    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomingWKWebView:)];
    pinchRecognizer.delegate = self;

    wkWebView.scrollView.delegate = self;
    [wkWebView.scrollView addGestureRecognizer:pinchRecognizer];
     wkWebView.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:0.0f];
    wkWebView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:245/255.0f alpha:1.0f];

    
    [mainScrollView addSubview:wkWebView];
    [mainScrollView bringSubviewToFront:rainbow];
    [mainScrollView bringSubviewToFront:logo];

}
-(void)settingMap:(MGLMapView *)mapView{
    NSURL *url = [NSURL URLWithString:@"mapbox://styles/mapbox/streets-v9"];
    if (mapView != nil) {
        self.postMapView = postModel.postMapView;
        
        self.postMapView.styleURL = url;
        self.postMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.postMapView.delegate = self;
        self.postMapView.logoView.alpha = 0.f;
        self.postMapView.attributionButton.alpha = 0.f;
        self.postMapView.compassView.hidden = false;
        self.postMapView.compassView.alpha = 0.f;
        self.postMapView.rotateEnabled = false;
        [self.postMapView addAnnotation:postModel.point];
        [self.postMapView selectAnnotation:postModel.point animated:YES];
        
    }
    else if ([[postInfo valueForKey:@"location"] count] > 0){
        
        
        self.postMapView = [[MGLMapView alloc]init];
        
        self.postMapView.styleURL = url;
        self.postMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.postMapView.delegate = self;
        if([self isInternet] == NO){
            
            self.postMapView.maximumZoomLevel = 17;
            
        }
        
        self.postMapView.logoView.alpha = 0.f;
        self.postMapView.attributionButton.alpha = 0.f;
        self.postMapView.compassView.hidden = false;
        self.postMapView.compassView.alpha = 0.f;
        self.postMapView.rotateEnabled = false;
        
        
        point = [[MGLPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake([[[postInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue], [[[postInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue]);
        point.title = [postInfo valueForKey:@"post_title"];
        
        if([[NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_id"]] isEqualToString:@"0"]){
            point.subtitle = [NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
        }
        else{
            point.subtitle = [NSString stringWithFormat:@"%@ > %@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_name"],[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
        }
        
        [self.postMapView addAnnotation:point];
        postModel.point = point;
        
        
        if([self isInternet] == NO){
            dispatch_time_t popTimee = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
            dispatch_after(popTimee, dispatch_get_main_queue(), ^(void){
                [self.postMapView setCenterCoordinate:point.coordinate zoomLevel:16 direction:0 animated:YES];
                //                [spinner endRefreshing];
            });
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.postMapView selectAnnotation:point animated:YES];
                
            });
        }
        
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.postMapView selectAnnotation:point animated:YES];
            
        });
        
        
        
    }
    else{
         self.postMapView = [[MGLMapView alloc]init];
    }
    
    
    
    
}
-(void)zoomingWKWebView:(UIPinchGestureRecognizer *)recongizer{
//    NSLog(@"zoomingWKWebView %f", recongizer.scale);
    
    if (recongizer.scale  >= 0.7f && recongizer.scale <= 3.0) {
//        NSLog(@"scrollView gestureRecognizers %f",  recongizer.scale );
        float percent = 100.0 * recongizer.scale;
        NSString *javaStr = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize='%f%%'", percent];
        
        [wkWebView evaluateJavaScript:javaStr completionHandler:nil];
        
//        NSLog(@"heighttt %f", [[wkWebView scrollView]contentSize].height);
//        if (scale < recongizer.scale) {
//            [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, wkWebView.frame.size.height * recongizer.scale)]; }
//        else{ [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, wkWebView.frame.size.height * recongizer.scale)]; }
        [wkWebView sizeToFit];
        NSLog(@"webivew hegiht %f", [[wkWebView scrollView]contentSize].height);
        scale = recongizer.scale;
//

        
        [practicalInfos setFrame:CGRectMake(0, [[wkWebView scrollView]contentSize].height + wkWebView.frame.origin.y+49, screenWidth, 744)];
        
   
    }
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return TRUE;
}
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return nil;
}

-(void)getPost{
    NSLog(@"ne local");
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:postDetailLink, [GlobalVariables getInstance].idOfPost]];
    NSLog(@"URL %@", URL);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"responseObject: %@" , responseObject);
            
            postInfo = [NSMutableArray array];
            postInfo = responseObject;
     
           
//             [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:postInfo] withName:[[GlobalVariables getInstance].idOfPost stringByAppendingString:@"map"]];
            
            
            postsBigTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[postInfo valueForKey:@"post_title"]]];
            [postsBigTitle sizeToFit];
 
            if([[NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_id"]] isEqualToString:@"0"]){
                passage.text = [NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
            }
            else{
                passage.text = [NSString stringWithFormat:@"%@ > %@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_name"],[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
            }
          
        
      
            NSString *authorName = [responseObject objectForKey:@"post_thumbnail_caption"];
            [authorLabel setText:authorName];
            
            
            [authorLabel sizeToFit];
         
       [authorLabel setFrame:CGRectMake(screenWidth - authorLabel.frame.size.width - 4, authorLabel.frame.origin.y, authorLabel.frame.size.width, 38)];
            numberOfStars = [[[responseObject valueForKey:@"ratings"] valueForKey:@"average"] intValue];
            for (int i = 0; i < numberOfStars; i++) {
                [starImageArr[i] setImage:[UIImage imageNamed:@"starColour.png"]];
                
            }
            
            if ([[responseObject objectForKey:@"practical_infos"] count] ){
                [self settingPracticalInfos];
            }
            
         
            
            htmlString = [responseObject objectForKey:@"post_content"];
            [self settingWebView:htmlString];
            
         
            NSString *urlStringHeadImg = [responseObject objectForKey:@"post_thumbnail_url"];
            [imageViewHeader sd_setImageWithURL:[NSURL URLWithString:urlStringHeadImg]
                               placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   
                                   postModel = [[PostModel alloc]initPostWithImageHeader:image authorName:authorName htmlString:finalString numberOfStars:[NSNumber numberWithInt: numberOfStars] passageText:passage.text postTitleText:postsBigTitle.text];
                                   [SimpleFilesCache saveImageToCacheDirectory:image withName: [[GlobalVariables getInstance].idOfPost stringByAppendingString:@"img"]] ;
                                  
                                  
                                   [self settingMap:nil];
                               }];
            
       
        }
    }];
    [dataTask resume];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

     if(scrollView == mainScrollView){
         
         if(canAppear != YES && mainScrollView.contentOffset.y > mainScrollView.contentSize.height * 0.38){
             
             
             backToTop = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.91, 37, 37)];
             backToTop.alpha = 0.0f;
             [UIView transitionWithView:backToTop duration:0.2
                                options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                    [backToTop setImage:[UIImage imageNamed:@"scrolltotop.png"] forState:UIControlStateNormal];
                                    [backToTop addTarget:self action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];
                                    [self.view addSubview:backToTop];
                                    [self.view bringSubviewToFront:backToTop];
                                    backToTop.alpha = 1.0f;
                                    canAppear = YES;
                                    
                                } completion:nil];
             
         }
         else if(backToTop && mainScrollView.contentOffset.y < mainScrollView.contentSize.height * 0.38){
             [UIView transitionWithView:backToTop duration:0.2
                                options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                    
                                    backToTop.alpha = 0.0f;
                                    
                                    canAppear = NO;
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:0.0 animations:^{
                                        [backToTop removeFromSuperview];
                                    }];
                                }];
         }
         
         
         if(changeFrameOnce1 == true && scrollView.contentOffset.y >= initialpozitionOfOpenMenuButton - 37){
             menuButton.frame = CGRectMake(backButton.frame.origin.x, 10, menuButton.frame.size.width, menuButton.frame.size.height);
             backButton.frame = CGRectMake(backButton.frame.origin.x, 60, backButton.frame.size.width, backButton.frame.size.height);
             [self.view addSubview:menuButton];
//             [self.view addSubview:backButton];
             changeFrameOnce1 = false;
         }
         else if(changeFrameOnce1 == false && scrollView.contentOffset.y < initialpozitionOfOpenMenuButton - 37) {
             
             menuButton.frame = CGRectMake(menuButton.frame.origin.x, initialpozitionOfOpenMenuButton, menuButton.frame.size.width, menuButton.frame.size.height);
//              backButton.frame = CGRectMake(menuButton.frame.origin.x, initialpozitionOfBackButton, menuButton.frame.size.width, backButton.frame.size.height);
             [mainScrollView addSubview:menuButton];
//            [mainScrollView addSubview:backButton];
             
             changeFrameOnce1 = true;
         }
    }
}

-(void)backToTop{
    
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSError *error = nil;
        NSStringEncoding encoding;
        
        NSString *my_string = [[NSString alloc] initWithContentsOfURL:navigationAction.request.URL
                                                         usedEncoding:&encoding
                                                                error:&error];
        
        
        NSArray *listItems = [my_string componentsSeparatedByString:@"<link rel='shortlink' href='https://vivreathenes.com/?p="];
        if ([navigationAction.request.URL.absoluteString containsString:@"vivre"] == false) {
//            [webView loadRequest:[NSURLRequest requestWithURL:navigationAction.request.URL]];
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];

            return nil;
        }
        NSArray *listItems2 = [listItems[1] componentsSeparatedByString:@"' />"];
         NSString *foundedId = listItems2[0];
        
        NSLog(@"foundedId %@", foundedId);
        [[GlobalVariables getInstance] setIdOfPost:foundedId];
        [self getPost];
        
    }
    return nil;
}
-(void)settingWebView:(NSString *)htmlStr{
 
    htmlStr = [@"<body>" stringByAppendingString:htmlStr];
    
    htmlStr = [htmlStr stringByAppendingString:@"</editor-signature></body>"];
    
    
//    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@".html\">" withString:@".html\" target=\"_blank\" >"];
     htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"href=" withString:@"target=\"_blank\" href="];
    
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<caption>" withString:@"<caption><center><wp-caption-text>"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</caption>" withString:@"</wp-caption-text></center></caption>"];
    
    
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<a target" withString:@"<link-style><a target"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</a>" withString:@"</a></link-style>"];
    
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"<p>"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</p><p>" withString:@"</p>"];
    
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<span class=\"editor-signature\">" withString:@"<editor-signature>"];
    
  

    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
   
      htmlStr = [@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">" stringByAppendingString:htmlStr];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    
    
    NSString *cssString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
   finalString = [cssString stringByAppendingString:htmlStr];
    
   
    NSLog(@"finalString %@", finalString);
   
      [wkWebView loadHTMLString:finalString baseURL:nil];


}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self backToTop];
  
    [self performSelector:@selector(finishedLoading) withObject:nil afterDelay:0.2];
    
}
- (IBAction)getBack:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"%@", [GlobalVariables getInstance].comingFromViewController]];
}
- (IBAction)menuButtonClicked:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}
- (IBAction)facebook:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        facebookfb.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            facebookfb.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                facebookfb.transform = CGAffineTransformIdentity;
                
                NSString *textToShare = [NSString stringWithFormat:@"%@ - Vivre à %@ %@",[postInfo valueForKey:@"post_title" ],nameOfTheCity,[postInfo valueForKey:@"post_url"]];
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [controller setInitialText: textToShare];
                
                [self presentViewController:controller animated:YES completion:Nil];
              
            }];
            
        }];
        
    }];
}


-(void)settingPracticalInfos{
    NSString *metros = [[NSString alloc] init];
    NSString *typeOfResto = @"Types de resto :";
    
    NSString *price = [[NSString alloc] init];
    
    if ([[postInfo valueForKey:@"practical_infos"] valueForKey:@"district"] != [NSNull null]) {
        [arrayUsedInTable addObject:[[postInfo valueForKey:@"practical_infos"] valueForKey:@"district"]];
        [arrayWithImagesUsedInTable addObject:@"quartier"];
    }
    if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"title"] valueForKey:@"text"]].length >4) {
        [arrayUsedInTable addObject:[NSString stringWithFormat:@"%@title%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"title"] valueForKey:@"text"],[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"title"] valueForKey:@"link"]]];
        [arrayWithImagesUsedInTable addObject:@"0"];
    }
    if ([[[postInfo valueForKey:@"practical_infos"]valueForKey:@"schedule"] count]) {
        //        hasInfos = @1;
        [arrayUsedInTable addObject:scheduleView];
        [arrayWithImagesUsedInTable addObject:@"0"];
        [self setttingSchedule];
    }

  
    if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"artist"] valueForKey:@"text"]].length >4){
        [arrayUsedInTable addObject:[NSString stringWithFormat:@"%@XYZ%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"artist"] valueForKey:@"text"],[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"artist"] valueForKey:@"link"]]];
        [arrayWithImagesUsedInTable addObject:@"people"];
        
    }
    if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"place"] valueForKey:@"text"]].length >3) {
        if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"place"] valueForKey:@"link"]].length >3)
            [arrayUsedInTable addObject:[NSString stringWithFormat:@"%@XYZ%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"place"] valueForKey:@"text"],[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"place"] valueForKey:@"link"]]];
        else
            [arrayUsedInTable addObject:[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"place"] valueForKey:@"text"]];
        
        [arrayWithImagesUsedInTable addObject:@"places"];
        
    }
    if ([NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"date"]].length >4){
        [arrayUsedInTable addObject:[NSString stringWithFormat:@"LELOL%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"date"]]];
        [arrayWithImagesUsedInTable addObject:@"calendar"];
    }
    if ([NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"date_extra"]].length >6) {
        [arrayUsedInTable addObject:[[postInfo valueForKey:@"practical_infos"] valueForKey:@"date_extra"]];
        [arrayWithImagesUsedInTable addObject:@"0"];
    }
    
    
    
    if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"phones"][0] valueForKey:@"tel"]].length >4) {
        [arrayUsedInTable addObject:[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"phones"][0] valueForKey:@"tel"]];
        [arrayWithImagesUsedInTable addObject:@"phone"];
    }
    
    if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"mails"][0] valueForKey:@"tel"]].length >4) {
        [arrayUsedInTable addObject:[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"mails"][0] valueForKey:@"tel"]];
        [arrayWithImagesUsedInTable addObject:@"email"];
    }
    
    if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"websites"][0] valueForKey:@"tel"]].length >4) {
        [arrayUsedInTable addObject:[NSString stringWithFormat:@"Site WebXYZ%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"websites"][0] valueForKey:@"tel"]]];
        [arrayWithImagesUsedInTable addObject:@"link"];
    }
    
    if ([NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"facebook"]].length >4) {
        [arrayUsedInTable addObject:[NSString stringWithFormat:@"facebookXYZ%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"facebook"]]];
        [arrayWithImagesUsedInTable addObject:@"facebookk"];
        
    }
    if ([NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"instagram"]].length >4){
        [arrayUsedInTable addObject:[NSString stringWithFormat:@"instagramXYZ%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"date"]]];
        [arrayWithImagesUsedInTable addObject:@"instagramm"];
        
    }
    
    
    if([[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] isKindOfClass:[NSDictionary class]]) {
        if ([NSString stringWithFormat:@"%@",[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"normal"] valueForKey:@"start"]].length != 0) {
            
            if([[NSString stringWithFormat:@"%@",[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"normal"] valueForKey:@"start"]] isEqualToString:@"0"])
                price = @"Gratuit";
            else {
                
                if ([NSString stringWithFormat:@"%@",[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"normal"] valueForKey:@"end"]].length != 0)
                    price = [NSString stringWithFormat:@"%@ € - %@ €", [[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"normal"] valueForKey:@"start"],[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"normal"] valueForKey:@"end"]];
                else
                    price = [price stringByAppendingString: [NSString stringWithFormat:@"%@ €",[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"normal"] valueForKey:@"start"]]];
                if ([NSString stringWithFormat:@"%@",[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"reduced"] valueForKey:@"start"]].length != 0)
                    price = [price stringByAppendingString:[NSString stringWithFormat:@" Réduit : %@ €",[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price"] valueForKey:@"reduced"] valueForKey:@"start"]]];
            }
            
            [arrayUsedInTable addObject:price];
            [arrayWithImagesUsedInTable addObject:@"price-tag"];
        }
        
    }
    if ([NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price_extra"]].length >6) {
        [arrayUsedInTable addObject:[[postInfo valueForKey:@"practical_infos"] valueForKey:@"price_extra"]];
        [arrayWithImagesUsedInTable addObject:@"0"];
    }
    
    if ([[NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"cb_accepted"] valueForKey:@"value"]] isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"cb_accepted"] valueForKey:@"field_is_visible"]] isEqualToString:@"1"]) {
        [arrayUsedInTable addObject:@"CB non acceptée"];
        [arrayWithImagesUsedInTable addObject:@"warning"];
    }
    if ([[NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"smoking"] valueForKey:@"value"]] isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"smoking"] valueForKey:@"field_is_visible"]] isEqualToString:@"1"]) {
        [arrayUsedInTable addObject:@"Non fumeur"];
        [arrayWithImagesUsedInTable addObject:@"no-smoke"];
        
    }
    
    
    for (int i = 0 ; i < [[[postInfo valueForKey:@"practical_infos"] valueForKey:@"types_of_resturant"] count]; i++)
        typeOfResto = [typeOfResto stringByAppendingString:[NSString stringWithFormat:@" %@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"types_of_resturant"][i] valueForKey:@"name"]]];
    if(typeOfResto.length>18) {
        [arrayUsedInTable addObject:typeOfResto];
        [arrayWithImagesUsedInTable addObject:@"0"];
        
    }
    
    
    
    else if ([[NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"cb_accepted"] valueForKey:@"value"]] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"cb_accepted"] valueForKey:@"field_is_visible"]] isEqualToString:@"1"]) {
        [arrayUsedInTable addObject:@"CB acceptée"];
        [arrayWithImagesUsedInTable addObject:@"card"];
    }
    for (int i = 0 ; i < [[[postInfo valueForKey:@"practical_infos"] valueForKey:@"locations"] count]; i++) {
        [arrayUsedInTable addObject:[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"locations"][i] valueForKey:@"address"]];
        [arrayWithImagesUsedInTable addObject:@"location"];
    }
    
    for (int i = 0 ; i < [[[postInfo valueForKey:@"practical_infos"] valueForKey:@"metros"] count]; i++)
        metros = [metros stringByAppendingString:[NSString stringWithFormat:@" %@ %@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"metros"][i] valueForKey:@"code"], [[[postInfo valueForKey:@"practical_infos"] valueForKey:@"metros"][i] valueForKey:@"name"]]];
    if(metros.length > 0) {
        [arrayUsedInTable addObject:metros];
        [arrayWithImagesUsedInTable addObject:@"metro"];
        
    }
    
    
    NSLog(@"arrayUsedInTable %@", arrayUsedInTable);
     NSLog(@"arrayWithImagesUsedInTable %@", arrayWithImagesUsedInTable);
    heightOfObj = 85;
    [arrayUsedInTable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:arrayWithImagesUsedInTable[idx]]];
        practicalInfosLabel.text =  @"Infos Pratiques";
        if (obj == scheduleView) {
            [self setttingSchedule];
            
        }
        else{
        UITextView *lbl = [[UITextView alloc]init];
        lbl.text = obj;
        lbl.editable = false;
            lbl.backgroundColor = [UIColor clearColor];
            if ([lbl.text containsString:@"@"]) {
                lbl.dataDetectorTypes = UIDataDetectorTypeAll;
            }
                else {
                    lbl.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
                    
                }
            lbl.textContainer.maximumNumberOfLines = 2;
            lbl.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            [imgView setFrame:CGRectMake(10, heightOfObj, 22, 25)];
            
            if ([arrayWithImagesUsedInTable[idx] isEqualToString:@"phone"] || [arrayWithImagesUsedInTable[idx] isEqualToString:@"location"]) {
            [imgView setFrame:CGRectMake(14, heightOfObj, 15, 25)];
            }
            if ([arrayWithImagesUsedInTable[idx] isEqualToString:@"quartier"]) {
                [imgView setFrame:CGRectMake(14, heightOfObj, 20, 15)];
            }
      
            if([[arrayUsedInTable objectAtIndex:idx] containsString:@"XYZ"]) {
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[[[arrayUsedInTable objectAtIndex:idx] componentsSeparatedByString:@"XYZ"] objectAtIndex:0]];
                [attributedString addAttribute: NSLinkAttributeName value: [[[arrayUsedInTable objectAtIndex:idx] componentsSeparatedByString:@"XYZ"] objectAtIndex:1] range: NSMakeRange(0, attributedString.length)];
               lbl.attributedText = attributedString;
//                lbl.delegate = self;
                lbl.dataDetectorTypes = UIDataDetectorTypeLink;
            }
            if([[arrayUsedInTable objectAtIndex:idx] containsString:@"title"]) {
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[[[arrayUsedInTable objectAtIndex:idx] componentsSeparatedByString:@"title"] objectAtIndex:0]];
                [attributedString addAttribute: NSLinkAttributeName value: [[[arrayUsedInTable objectAtIndex:idx] componentsSeparatedByString:@"title"] objectAtIndex:1] range: NSMakeRange(0, attributedString.length)];
                lbl.attributedText = attributedString;
    
                [lbl setFont:[UIFont fontWithName:@"Verdana-Bold" size:21]];
               
                lbl.dataDetectorTypes = UIDataDetectorTypeLink;
//                [lbl setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0]]; doesn't work for some f***** reason. why so hard..
                
             
            }
            
            
            if ([arrayWithImagesUsedInTable[idx] isEqualToString:@"0"])  {
                [lbl setFrame:CGRectMake(10, heightOfObj-2.5, screenWidth - 70, 36)];
            }else{
                [lbl setFrame:CGRectMake(40, heightOfObj-2.5, screenWidth - 70, 36)]; }
        
        heightOfObj = lbl.frame.size.height + lbl.frame.origin.y + 25;
       
//        [lbl sizeToFit];
        [practicalInfos addSubview:imgView];
        [practicalInfos addSubview:lbl];
        [practicalInfos bringSubviewToFront:imgView];
        [practicalInfos bringSubviewToFront:lbl];
            
            heightForPracticalInfos = practicalInfos.frame;
            heightForPracticalInfos.size.height = lbl.frame.origin.y+lbl.frame.size.height;
           
        }
       
    }];
    
    
}
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    // Do whatever you want here
//    NSLog(@"%@", URL); // URL is an instance of NSURL of the tapped link
//    return NO; // Return NO if you don't want iOS to open the link
//}
-(void)setttingSchedule{
    
    NSMutableDictionary *schedule = [[postInfo valueForKey:@"practical_infos"]valueForKey:@"schedule"];
 
    
    NSString *startMonday = [[schedule valueForKey:@"monday"]valueForKey:@"start"];
    NSString *endMonday = [NSString stringWithFormat:@" -  %@", [[schedule valueForKey:@"monday"]valueForKey:@"end"]];
    
    NSString *startMardi = [[schedule valueForKey:@"tuesday"]valueForKey:@"start"];
    NSString *endMardi = [NSString stringWithFormat:@" -  %@", [[schedule valueForKey:@"tuesday"]valueForKey:@"end"]];
    
    NSString *startMercredi = [[schedule valueForKey:@"wednesday"]valueForKey:@"start"];
    NSString *endMercredi = [NSString stringWithFormat:@" -  %@", [[schedule valueForKey:@"wednesday"]valueForKey:@"end"]];
    
    NSString *startJeudi = [[schedule valueForKey:@"thursday"]valueForKey:@"start"];
    NSString *endJeudi = [NSString stringWithFormat:@" -  %@", [[schedule valueForKey:@"thursday"]valueForKey:@"end"]];
    
    NSString *startVendredi = [[schedule valueForKey:@"friday"]valueForKey:@"start"];
    NSString *endVendredi = [NSString stringWithFormat:@" -  %@", [[schedule valueForKey:@"friday"]valueForKey:@"end"]];
    
    NSString *startSamedi = [[schedule valueForKey:@"saturday"]valueForKey:@"start"];
    NSString *endSamedi = [NSString stringWithFormat:@" -  %@", [[schedule valueForKey:@"saturday"]valueForKey:@"end"]];
    
    NSString *startDimanche = [[schedule valueForKey:@"sunday"]valueForKey:@"start"];
    NSString *endDimanche = [NSString stringWithFormat:@" -  %@", [[schedule valueForKey:@"sunday"]valueForKey:@"end"]];

   
    
    
    self.arrScheduleLabels = [[NSMutableArray alloc]initWithObjects:lundiSchedule, mardiSchedule, mercrediSchedule, jeudiSchedule, vendrediSchedule, samediSchedule, dimancheSchedule, nil];


    lundiSchedule.text = [startMonday stringByAppendingString:endMonday];
    mardiSchedule.text = [startMardi stringByAppendingString:endMardi];
    mercrediSchedule.text = [startMercredi stringByAppendingString:endMercredi];
    jeudiSchedule.text = [startJeudi stringByAppendingString:endJeudi];
    vendrediSchedule.text = [startVendredi stringByAppendingString:endVendredi];
    samediSchedule.text = [startSamedi stringByAppendingString:endSamedi];
    dimancheSchedule.text = [startDimanche stringByAppendingString:endDimanche];
    
    
   
    
    
    NSMutableArray *sortedArr = [[schedule allKeys]mutableCopy];
    for (NSString *day in [[schedule allKeys]mutableCopy]) {
        if ([day isEqualToString:@"monday"]) {
            [sortedArr replaceObjectAtIndex:0 withObject:[schedule valueForKey:@"monday"]];
        }
        if ([day isEqualToString:@"tuesday"]) {
          [sortedArr replaceObjectAtIndex:1 withObject:[schedule valueForKey:@"tuesday"]];
        }
        if ([day isEqualToString:@"wednesday"]) {
           [sortedArr replaceObjectAtIndex:2 withObject:[schedule valueForKey:@"wednesday"]];
        }
        if ([day isEqualToString:@"thursday"]) {
            [sortedArr replaceObjectAtIndex:3 withObject:[schedule valueForKey:@"thursday"]];
        }
        if ([day isEqualToString:@"friday"]) {
            [sortedArr replaceObjectAtIndex:4 withObject:[schedule valueForKey:@"friday"]];
        }
        if ([day isEqualToString:@"saturday"]) {
           [sortedArr replaceObjectAtIndex:5 withObject:[schedule valueForKey:@"saturday"]];
        }
        if ([day isEqualToString:@"sunday"]) {
            [sortedArr replaceObjectAtIndex:6 withObject:[schedule valueForKey:@"sunday"]];
        }
    }
    NSUInteger index = 0;

    
    for (NSDictionary *dict in sortedArr ) {
        UILabel *lbl =  self.arrScheduleLabels[index];
        
        if ([lbl.text isEqualToString:@" -  "] && [[sortedArr[index] valueForKey:@"status"] isEqualToString:@"closed"]) {
            lbl.text = @"Fermé";
            
            
        }
        else if ([lbl.text isEqualToString:@" -  "] && [[sortedArr[index] valueForKey:@"status"] isEqualToString:@"closed"]){
            lbl.text = @"Ouvert";
        }
        [lbl sizeToFit];
        index++;
    }
    

    [scheduleView setFrame:CGRectMake(scheduleView.frame.origin.x, heightOfObj, scheduleView.frame.size.width, scheduleView.frame.size.height)];
    [scheduleView setHidden:NO];
    heightOfObj = scheduleView.frame.size.height + scheduleView.frame.origin.y + 30;
}


-(void)finishedLoading{
//    CGSize contentSize = CGSizeMake(0, 0);
//    contentSize.height = [[wkWebView scrollView]contentSize].height + wkWebView.frame.origin.y+60+1300;
//    NSLog(@"height %f", contentSize.height);
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]){
        [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, [postModel.heightForWKWebView floatValue])];
    }
    else{
    [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, [[wkWebView scrollView]contentSize].height)];
        postModel.heightForWKWebView = @([[wkWebView scrollView]contentSize].height);
    }

    
    [practicalInfos setFrame:CGRectMake(0, wkWebView.frame.size.height + wkWebView.frame.origin.y + 40, screenWidth, heightForPracticalInfos.size.height)];
    [mainScrollView addSubview:practicalInfos];
    
    
    if ([[postInfo valueForKey:@"locations"] count]) {
        [self.postMapView setFrame:CGRectMake(0, practicalInfos.frame.origin.y + practicalInfos.frame.size.height + 30, self.view.frame.size.width, self.view.frame.size.height/2.5)];
    }
    else{
         [self.postMapView setFrame:CGRectMake(0, practicalInfos.frame.origin.y + practicalInfos.frame.size.height + 30, self.view.frame.size.width, 0)];
    }
    UIButton *openMapPage = [[UIButton alloc]initWithFrame:self.postMapView.frame];
   
    [mainScrollView  addSubview:self.postMapView];
    [mainScrollView addSubview:openMapPage];
    [mainScrollView bringSubviewToFront:openMapPage];
    [openMapPage addTarget:self action:@selector(openMapPage) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tagsL = [[UILabel alloc]initWithFrame:CGRectMake(4, _postMapView.frame.origin.y + _postMapView.frame.size.height + 12, 50, 50)];
 
    tagsL.text = @"TAGS :";
    tagsL.font = [UIFont fontWithName:@"Montserrat-Light" size:16];
   
    
    tagsL.textColor = [UIColor blackColor];
    [tagsL setHidden:YES];
    float buttonWidth = 0.0;
    float buttonXpos = tagsL.frame.origin.x + tagsL.frame.size.width;
    for (int i = 0; i<[[postInfo valueForKey:@"tags"] count]; i++) {
        [tagsL setHidden: NO];
        
        [allTagsSlugs addObject:[[postInfo valueForKey:@"tags"][i]  valueForKey:@"slug"]];
        [allTagsName addObject:[[postInfo valueForKey:@"tags"][i]  valueForKey:@"name"]];
        UIButton *tag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [tag addTarget:self
                   action:@selector(tagPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [tag setTitle:[[[postInfo valueForKey:@"tags"][i] valueForKey:@"name"]uppercaseString] forState:UIControlStateNormal];
        [tag setBackgroundColor:[UIColor colorWithRed:227.0/255.0 green:228.0/255.0 blue:234.0/255.0 alpha:1.0]];
        
        tag.frame = CGRectMake(buttonXpos + buttonWidth + 4,  tagsL.frame.origin.y + 5, 0, 50.0);
//
       
        tag.layer.cornerRadius = tag.frame.size.height/5;
        tag.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:16];
        
        tag.titleLabel.textAlignment = NSTextAlignmentCenter;
        tag.titleLabel.adjustsFontSizeToFitWidth = true;
        tag.titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:76.0/255.0 blue:105.0/255.0 alpha:1.0];
       
        [tag sizeToFit];
        if (buttonXpos + buttonWidth + tag.frame.size.width  + 4 > screenWidth) {
            tag.frame = CGRectMake(10, tagsL.frame.origin.y + 40 , 0, 50.0);
            [tag sizeToFit];
        }
        CGRect size = tag.frame;
        size.size.width = size.size.width + 7;
        tag.frame = size;
        buttonWidth = tag.frame.size.width + 5;
        buttonXpos = tag.frame.origin.x;
        //Set Tag for future identification
        [tag setTag:i];
      
        [mainScrollView addSubview:tag];
        [mainScrollView bringSubviewToFront:tag];
        
        [mainScrollView addSubview:tagsL];
        [mainScrollView bringSubviewToFront:tagsL];
        
    }

    if ([[postInfo valueForKey:@"suggested_posts"]count]) {
        NSInteger numberOfPost = [[postInfo valueForKey:@"suggested_posts"]count];
        [mainScrollView addSubview:self.tableView];
        
        
        [self.tableView setFrame:CGRectMake(0, tagsL.frame.origin.y + 150, screenWidth, self.view.frame.size.width/3.5*numberOfPost)];
        [self.tableView setScrollEnabled:NO];
//        mainScrollView.contentSize = CGSizeMake(screenWidth, self.tableView.frame.origin.y + self.tableView.frame.size.height + 100);

        [articlesSuggestions setFrame:CGRectMake(0, self.tableView.frame.origin.y - 50, screenWidth, 40)];
        [articlesSuggestions setHidden:NO];
        [mainScrollView addSubview:articlesSuggestions];
        [mainScrollView bringSubviewToFront:articlesSuggestions];
    }
    
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in mainScrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.width = screenWidth;
    contentRect.size.height = contentRect.size.height + 400.0;
    mainScrollView.contentSize = contentRect.size;
    
   
}
-(void)tagPressed :(UIButton *)button{
    [GlobalVariables getInstance].backToPostHasToBeHidden = YES;
    NSInteger index = button.tag;
    
    NSLog(@"TAG CLICKED SLUG IS : %@",allTagsSlugs[index]);
    [GlobalVariables getInstance].slugName = allTagsName[index];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromAgendaTag"];
    [GlobalVariables getInstance].backGroundImageTag = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",allTagsSlugs[index]] forKey:@"ComingFromPostTag"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CatsSubCatsController"]];
}
- (void) mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    
    mapView.showsUserLocation = YES;
     if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
         [self.postMapView setCenterCoordinate:CLLocationCoordinate2DMake(postModel.point.coordinate.latitude, postModel.point.coordinate.longitude) zoomLevel:16 animated:YES];
          }
     else{
         [self.postMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[postInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue] + 0.0002, [[[postInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue] - 0.00001) zoomLevel:16 direction:0 animated:YES];
         
         postModel.postMapView = mapView;
         [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:postModel] withName:[GlobalVariables getInstance].idOfPost];
     }
  
    

}
-(void) openMapPage{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ZoomMapPage"]];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tag = indexPath.row;
    NSLog(@"%lu", tag);
    [GlobalVariables getInstance].idOfPost = [[postInfo valueForKey:@"suggested_posts"] valueForKey:@"id"][tag];
    NSLog(@"[GlobalVariables getInstance].idOfPost %@ ", [GlobalVariables getInstance].idOfPost);
    [GlobalVariables getInstance].comingFrom = @"Posts";
    [GlobalVariables getInstance].comingFromViewController = @"PostViewController";
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[postInfo valueForKey:@"suggested_posts"]count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuggestionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.thumbnail sd_setImageWithURL:[[postInfo valueForKey:@"suggested_posts"][indexPath.row]valueForKey:@"thumbnail_url"] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    cell.title.text = [[postInfo valueForKey:@"suggested_posts"][indexPath.row]valueForKey:@"title"];
    cell.fragment.text = [[postInfo valueForKey:@"suggested_posts"][indexPath.row]valueForKey:@"excerpt"];
  
   
    
    UIColor *borderColor = [UIColor colorWithRed:(246.0/255.0) green:(153.0/255.0) blue:(1.0/255.0) alpha:1.0];
    [cell.thumbnail.layer setBorderColor:borderColor.CGColor];
   
    
    
    [cell.thumbnail.layer setBorderWidth: 2.75];
    cell.thumbnail.layer.cornerRadius = cell.thumbnail.frame.size.height /2;
    cell.thumbnail.layer.masksToBounds = YES;
    cell.thumbnail.contentMode = UIViewContentModeScaleAspectFill;

 
    [cell.thumbnail setFrame:CGRectMake(5, cell.frame.size.height/2 - cell.thumbnail.frame.size.height/2, 80, 80)];
    [cell.title setFrame:CGRectMake(5 + cell.thumbnail.frame.size.width + 15, cell.thumbnail.frame.origin.y, screenWidth - cell.thumbnail.frame.size.width - 25, 25)];
    [cell.fragment setFrame:CGRectMake(5 + cell.thumbnail.frame.size.width + 15, cell.title.frame.origin.y + cell.title.frame.size.height +8 , screenWidth - cell.thumbnail.frame.size.width - 25, 20)];
    
    cell.title.adjustsFontSizeToFitWidth = true;
    
    [cell.title sizeToFit];
    [cell.fragment sizeToFit];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return self.view.frame.size.width/15;
    else

        return self.view.frame.size.width/3.5;
}
-(NSString *)stringByStrippingHTML:(NSString *)inputString
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
-(BOOL)isInternet{
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {return YES; }
    
    else { return NO; }
}
@end
