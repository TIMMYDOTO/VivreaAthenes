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
#import "OLGhostAlertView.h"
#import "BEMCheckBox.h"
#import "PostModel.h"

@interface PostViewController (){
    OLGhostAlertView *demo;
    __weak IBOutlet UILabel *practicalInfosLabel;
    IBOutlet UIView *practicalInfos;
    NSMutableArray *pointArr;
    __weak IBOutlet UIView *articlesSuggestions;
    __weak IBOutlet UIView *scheduleView;
    CGFloat initialpozitionOfBackButton;
    CGFloat initialpozitionOfOpenMenuButton;
    __weak IBOutlet UILabel *lundiSchedule;
    UIButton *backToTop;
    __weak IBOutlet UILabel *mardiSchedule;
    UIButton *tag;
    __weak IBOutlet UILabel *mercrediSchedule;
    __weak IBOutlet UIButton *subm;
    
    __weak IBOutlet UILabel *jeudiSchedule;
    
    __weak IBOutlet UILabel *vendrediSchedule;
    
    UIView *viewForContactForm;
    WKWebView *wkWebViewForm;
    __weak IBOutlet UILabel *samediSchedule;
    
    __weak IBOutlet UILabel *dimancheSchedule;
    
    NSNumber *numberOfTags;
    BOOL changeFrameOnce;
    BOOL changeFrameOnce1;
    __weak IBOutlet UIButton *menuButton;
    float heightForObj;
    __weak IBOutlet UIButton *backButton;
  
    NSString *finalString;
    
    MGLPointAnnotation *point;
    PostModel *postModel;
    
    __weak IBOutlet UIScrollView *mainScrollView;
    
    __weak IBOutlet UIButton *facebookfb;
    CGRect heightForPracticalInfos;
    __weak IBOutlet UIImageView *imageViewHeader;
    
    __weak IBOutlet UIView *blueSeparatorView;
    UILabel *tagsL;
    __weak IBOutlet UILabel *authorLabel;
    NSString *htmlString;
    BOOL canAppear;
    WKWebView *wkWebView;
    int numberOfStars;
    CGFloat screenWidth;
    float percent;
    CGFloat screenHeight;
    __weak IBOutlet UIImageView *rainbow;
    __weak IBOutlet UIImageView *logo;
    
    __weak IBOutlet UILabel *postsBigTitle;
    __weak IBOutlet UILabel *passage;
    UILongPressGestureRecognizer *longTap;
    
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
    
    UIView *viewForTags;
    float yPositionForSchedule;
    
    NSMutableArray *arrayOfSchedule;
    NSMutableArray *arrayUsedInTable;
    NSMutableArray *arrayWithImagesUsedInTable;
    
    NSMutableArray *thumbnailArr;
    NSMutableArray *titleArr;
    NSMutableArray *fragmentArr;
    
    NSUInteger suggestionsCount;
    int tagsCount;
    UIActivityIndicatorView *activityView;
    UIView *blackCurtain;
    NSString *authorName;
    
    NSString *_wpcf7;
    NSString *_wpcf7_version;
    NSString *_wpcf7_locale;
    NSString *_wpcf7_unit_tag;
    NSString *_wpcf7_container_post;
    
    
    
    UILabel *yourName;
    UILabel *yourEmail;
    UILabel *yourDates;
    UILabel *yourNumber;
    UILabel *yourSubject;
    UILabel *yourMessage;
    BEMCheckBox *ckeckbox;
    BEMCheckBox *ckeckbox2;

    
    UITextField *textFieldForName;
    UITextField *textFieldForEmail;
    UITextField *textFieldForDates;
    UITextField *textFieldForNumber;
    UITextField *textFieldForSubject;
    UITextField *textFieldForMessage;
    
}

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//Hello world
    blackCurtain = [[UIView alloc] init];
    [blackCurtain setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height*0.93)];
    [blackCurtain setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
    [self.view addSubview:blackCurtain];
    
    
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    unlockedIAP = [[NSUserDefaults standardUserDefaults] valueForKey:@"didUserPurchasedIap"];

    
    
    
    thumbnailArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];
    fragmentArr = [[NSMutableArray alloc] init];

    if (!self.arrOfId) {
        self.arrOfId = [[NSMutableArray alloc] init];
    }
    
//    arrOfId = [[NSUserDefaults standardUserDefaults]objectForKey:@"arrOfId"];
    
    
    numberOfTags = [[NSNumber alloc]init];
    arrayOfSchedule = [[NSMutableArray alloc] init];
    arrayUsedInTable = [[NSMutableArray alloc] init];
    arrayWithImagesUsedInTable = [[NSMutableArray alloc] init];
    allTagsSlugs = [[NSMutableArray alloc] init];
    allTagsName = [[NSMutableArray alloc] init];
    percent = 100.0;
    starImageArr = [[NSMutableArray alloc] initWithObjects:starImage1, starImage2, starImage3, starImage4, starImage5, nil];
    
    NSLog(@"%@ id OF POST",[GlobalVariables getInstance].idOfPost);
//    [[GlobalVariables getInstance] setIdOfPost:@"33023"];

    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
        NSLog(@"local");
        postModel = [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]];
        
        for (int i = 0; i < [postModel.numberOfStars intValue]; i++) {
            [starImageArr[i] setImage:[UIImage imageNamed:@"starColour.png"]];
            
        }
        imageViewHeader.image = postModel.imageHeader;
        NSString *authorNam = postModel.authorName;
        NSAttributedString * attrSt = [[NSAttributedString alloc] initWithData:[authorNam dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        authorLabel.attributedText = attrSt;
        [authorLabel setTextColor:[UIColor whiteColor]];
        [authorLabel setTextAlignment:NSTextAlignmentRight];
        [authorLabel setFont:[UIFont fontWithName:@"Montserrat-Italic" size:12.f]];
       

         wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, imageViewHeader.frame.size.height+200, screenWidth, 0) configuration:[WKWebViewConfiguration new]];
        passage.text = postModel.passageText;
        postsBigTitle.text = postModel.postTitleText;
    
       
        [wkWebView loadHTMLString:postModel.htmlString baseURL:[NSBundle mainBundle].bundleURL];
      
    }
    else{ [self getPost]; }
   
    
    [self settingDesign];
   
    initialpozitionOfOpenMenuButton = self.view.frame.size.height/12;
    initialpozitionOfBackButton = self.view.frame.size.height/5;
    changeFrameOnce = true;
    changeFrameOnce1 = true;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    double delayInSeconds = 7;
   
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *idOFPost = [GlobalVariables getInstance].idOfPost;
        [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:postModel] withName:[NSString stringWithFormat:@"%@", idOFPost]];
        NSLog(@"model is saved");
        [self showMessage:@"Article enregistré!"];
        [self.view addSubview:demo];
        demo.center = self.view.center;
        [self.view bringSubviewToFront:demo];
    });
    
}

-(void)settingDesign{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
     screenWidth = screenRect.size.width;
     screenHeight = screenRect.size.height;

    [mainScrollView setFrame:CGRectMake(0, 0, screenWidth, screenHeight*0.92)];
   
    [imageViewHeader setFrame:CGRectMake(0, 0, screenWidth, 236)];
    [blueSeparatorView setFrame:CGRectMake(0, imageViewHeader.frame.size.height - 29, screenWidth, 29)];
    [rainbow setFrame:CGRectMake(screenWidth/2-35, imageViewHeader.frame.size.height-40, 69, 79)];
    [logo setFrame:CGRectMake(screenWidth/2-35, imageViewHeader.frame.size.height-40, 69, 79)];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.clipsToBounds = true;
    rainbow.contentMode = UIViewContentModeScaleAspectFit;
    rainbow.clipsToBounds = true;
    [rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
    
    
    
    [authorLabel setFrame:CGRectMake(screenWidth /2 + 40, imageViewHeader.frame.size.height-32.5, screenWidth/2 - 42, 38)];

    [facebookfb setFrame:CGRectMake(5, imageViewHeader.frame.size.height + 10, 45, 30)];
    [postsBigTitle setFrame:CGRectMake(5, facebookfb.frame.origin.y + facebookfb.frame.size.height + 15, screenWidth - 10, 43)];

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

// wkWebView.backgroundColor = [UIColor colorWithRed:100.0/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    
    [mainScrollView addSubview:wkWebView];
  

}
- (IBAction)tapOnHeader:(UITapGestureRecognizer *)sender {
    
 if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
     [SimpleFilesCache saveImageToCacheDirectory:postModel.imageHeader withName:@"imgHeader"];
     
      [[NSUserDefaults standardUserDefaults]setObject:postModel.authorName forKey:@"authorLblTxt"];
 }else{
       [[NSUserDefaults standardUserDefaults]setObject:authorName forKey:@"authorLblTxt"];
        [GlobalVariables getInstance].urlOfImageClicked = [postInfo valueForKey:@"post_thumbnail_url"];
 }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ScrollImageController"]];
}
- (void)appDidBecomeActive:(NSNotification *)notification {
    [activityView setHidden:YES];
    [blackCurtain setHidden:YES];

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
        [self.postMapView addAnnotations:postModel.annotations];
 
        
    }
    else if ([[[postInfo valueForKey:@"practical_infos"] valueForKey:@"locations"] count] > 0){
        
        
        self.postMapView = [[MGLMapView alloc]init];
        
        self.postMapView.styleURL = url;
        self.postMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.postMapView.delegate = self;

        
        self.postMapView.logoView.alpha = 0.f;
        self.postMapView.attributionButton.alpha = 0.f;
        self.postMapView.compassView.hidden = false;
        self.postMapView.compassView.alpha = 0.f;
        self.postMapView.rotateEnabled = false;
        
        pointArr = [[NSMutableArray alloc]init];
        
        NSMutableArray *locations = [[NSMutableArray alloc]init];
        
        postModel.annotations = [NSMutableArray array];
        locations = [[postInfo valueForKey:@"practical_infos"] valueForKey:@"locations"];
        [locations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            point = [[MGLPointAnnotation alloc] init];
            
            point.coordinate = CLLocationCoordinate2DMake([[obj objectForKey:@"lat"]doubleValue], [[obj objectForKey:@"lng"]doubleValue ]);
            point.title = [obj objectForKey:@"title"];
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[obj objectForKey:@"description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
             point.subtitle = [attrStr string];
//            point.subtitle = [obj objectForKey:@"description"];
         
            [pointArr addObject:point];
            [self.postMapView addAnnotation:point];
            [postModel.annotations addObject:point];

        }];
        [[GlobalVariables getInstance].DictionaryWithAllPosts setObject:postInfo forKey:[GlobalVariables getInstance].idOfPost];
        
//        postModel.point = point;

    }
    else{
         self.postMapView = [[MGLMapView alloc]init];
    }
    
    
}

-(void)zoomingWKWebView:(UIPinchGestureRecognizer *)recongizer{
  NSLog(@"wkWebView.scrollView.frame.size.heighte %f", wkWebView.scrollView.contentSize.height);
    if (recongizer.scale <= 2.0f) {
 
        if (recongizer.scale > 1.0 && percent < 130) {
            percent = percent + 1;
            NSString *javaStr = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize='%f%%'", percent];

            [wkWebView evaluateJavaScript:javaStr completionHandler:^(id _Nullable f, NSError * _Nullable error) {
              
                //                [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, [height floatValue]-20)];
                
                [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, wkWebView.scrollView.contentSize.height)];
               
                [viewForContactForm setFrame:CGRectMake(0, wkWebView.frame.origin.y + wkWebView.frame.size.height + 30, screenWidth, 810)];
                if (viewForContactForm == nil) {
                              [practicalInfos setFrame:CGRectMake(0, wkWebView.frame.origin.y + wkWebView.frame.size.height + 10, screenWidth, heightForPracticalInfos.size.height)];
                }else{
                     [practicalInfos setFrame:CGRectMake(0, viewForContactForm.frame.origin.y + viewForContactForm.frame.size.height + 30, screenWidth, heightForPracticalInfos.size.height)];
                }
       NSLog(@"height %f", viewForContactForm.frame.origin.y);
            /////////////////
                [self.postMapView setFrame:CGRectMake(0, practicalInfos.frame.origin.y + practicalInfos.frame.size.height + 49, screenWidth, self.postMapView.frame.size.height)];
                
                [viewForTags setFrame:CGRectMake(4, _postMapView.frame.origin.y + _postMapView.frame.size.height + 14, viewForTags.frame.size.width, viewForTags.frame.size.height)];
                
                [self.tableView setFrame:CGRectMake(0, viewForTags.frame.origin.y + 150, screenWidth, self.view.frame.size.width/3.5 * [postModel.suggestionsCount doubleValue])];
                [articlesSuggestions setFrame:CGRectMake(0, self.tableView.frame.origin.y - 50, screenWidth, 40)];
                CGRect contentRect = CGRectZero;
                for (UIView *view in mainScrollView.subviews) {
                    contentRect = CGRectUnion(contentRect, view.frame);
                }
                contentRect.size.width = screenWidth;
                contentRect.size.height = contentRect.size.height+40;
                mainScrollView.contentSize = contentRect.size;
            }];
            }
 
        }
 
    }


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return TRUE;
}
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return nil;
}

- (IBAction)submit:(UIButton *)sender {
 
    if (textFieldForName.text.length == 0 || textFieldForEmail.text.length == 0 || textFieldForDates.text.length == 0 || textFieldForNumber.text.length == 0 || [self NSStringIsValidEmail:textFieldForEmail.text] == NO || textFieldForSubject.text.length == 0 || textFieldForMessage.text.length == 0 || !ckeckbox.on || !ckeckbox2.on) {
        if([self NSStringIsValidEmail:textFieldForEmail.text] == NO || textFieldForEmail.text.length == 0){
            
            
            [textFieldForEmail.layer setBorderColor:[UIColor redColor].CGColor];
            [textFieldForEmail.layer setBorderWidth:1.5f];
            
        }
        else{
            [textFieldForEmail.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForEmail.layer setBorderWidth:1.0];
        }
        
        if (textFieldForName.text.length == 0) {
            [textFieldForName.layer setBorderColor:[UIColor redColor].CGColor];
            [textFieldForName.layer setBorderWidth:1.5f];
            
        }
        
        else{
            [textFieldForName.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForName.layer setBorderWidth:1.0];
        }
        if (textFieldForDates.text.length == 0) {
            [textFieldForDates.layer setBorderColor:[UIColor redColor].CGColor];
            [textFieldForDates.layer setBorderWidth:1.5f];
            
        }
        else{
            [textFieldForDates.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForDates.layer setBorderWidth:1.0];
        }
        if (textFieldForNumber.text.length == 0) {
            [textFieldForNumber.layer setBorderColor:[UIColor redColor].CGColor];
            [textFieldForNumber.layer setBorderWidth:1.5f];
            
        }
        else{
            [textFieldForNumber.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForNumber.layer setBorderWidth:1.0];
        }
        
        if (textFieldForSubject.text.length == 0) {
            [textFieldForSubject.layer setBorderColor:[UIColor redColor].CGColor];
            [textFieldForSubject.layer setBorderWidth:1.5f];
            
        }
        else{
            [textFieldForSubject.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForSubject.layer setBorderWidth:1.0];
        }
        if (textFieldForMessage.text.length == 0) {
            [textFieldForMessage.layer setBorderColor:[UIColor redColor].CGColor];
            [textFieldForMessage.layer setBorderWidth:1.5f];
            
        }
        else{
            [textFieldForMessage.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForMessage.layer setBorderWidth:1.0];
        }
        if (!ckeckbox.on) {
            ckeckbox.tintColor = [UIColor redColor];
            
        }
        else{
            ckeckbox.tintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
            
        }
        if (!ckeckbox2.on) {
            ckeckbox2.tintColor = [UIColor redColor];
        }else{
            ckeckbox2.tintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
        }
        return;
    }
    [subm setHidden:YES];
    [activityView startAnimating];
    activityView.frame = subm.frame;
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [mainScrollView addSubview:activityView];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

    NSURL *url = [NSURL URLWithString:@"https://vivreathenes.com/wp-json/contact-form-7/v1/contact-forms/33036/feedback"] ;
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *params = [NSString stringWithFormat:@"your-name=%@&your-email=%@&your-dates=%@&your-number=%@&your-subject=%@&your-message=%@&terms=%@&terms-2=%@", textFieldForName.text,textFieldForEmail.text,textFieldForDates.text,textFieldForNumber.text,textFieldForSubject,textFieldForMessage,@"1",@"1"];
    NSLog(@"params %@", params);



    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *string = [[NSString alloc] initWithData:urlRequest.HTTPBody encoding:NSUTF8StringEncoding];
    NSLog(@"url body %@", string);

    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"responce %@", response);
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"responseDict %@", responseDict);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
        
        if ([httpResponse statusCode] == 200) {
            [self showMessage:[responseDict valueForKey:@"message"]];
            textFieldForName.text = @"";
            textFieldForEmail.text = @"";
            textFieldForDates.text = @"";
            textFieldForNumber.text = @"";
            textFieldForSubject.text = @"";
            textFieldForMessage.text = @"";
             [textFieldForEmail.layer setBorderWidth:1.f];
            [textFieldForEmail.layer setBorderColor:[UIColor grayColor].CGColor];
            
            [textFieldForName.layer setBorderWidth:1.f];
            [textFieldForName.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForDates.layer setBorderWidth:1.f];
            [textFieldForDates.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForNumber.layer setBorderWidth:1.f];
            [textFieldForNumber.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForSubject.layer setBorderWidth:1.f];
            [textFieldForSubject.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForMessage.layer setBorderWidth:1.f];
            [textFieldForMessage.layer setBorderColor:[UIColor grayColor].CGColor];
            ckeckbox2.tintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
            ckeckbox.tintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
        }
        [activityView removeFromSuperview];
        [subm setHidden:NO];
    }];
     [dataTask resume];
    
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
            
            postInfo = [[NSMutableArray alloc]init];
            postInfo = responseObject;
            
            suggestionsCount = [[postInfo valueForKey:@"suggested_posts"]count];
            
    
            
            for (tagsCount = 0; tagsCount < [[postInfo valueForKey:@"tags"] count]; tagsCount++) {
                numberOfTags = [NSNumber numberWithInteger:tagsCount];
                [allTagsSlugs addObject:[[postInfo valueForKey:@"tags"][tagsCount]  valueForKey:@"slug"]];
                [allTagsName addObject:[[postInfo valueForKey:@"tags"][tagsCount]  valueForKey:@"name"]];
            }
            if ([[postInfo valueForKey:@"location"]count] > 0) {
                
                [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:postInfo] withName:[NSString stringWithFormat:@"%@map",[GlobalVariables getInstance].idOfPost]];
             

            }
     
            
            
            postsBigTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[postInfo valueForKey:@"post_title"]]];

          
            [postsBigTitle sizeToFit];
 
            if([[postInfo valueForKey:@"category"]valueForKey:@"category_parent_id"] == [NSNull null] || [[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_id"]integerValue] == 0){
                passage.text = @"";

            }
            else{
                passage.text = [NSString stringWithFormat:@"%@ > %@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_name"],[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
            }
          
        
      
            authorName = [responseObject objectForKey:@"post_thumbnail_caption"];
           NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[authorName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            authorLabel.attributedText = attrStr;
           [authorLabel setTextColor:[UIColor whiteColor]];
            [authorLabel setTextAlignment:NSTextAlignmentRight];
            [authorLabel setFont:[UIFont fontWithName:@"Montserrat-Italic" size:12.f]];
            [authorLabel setFrame:CGRectMake(screenWidth /2 + 40, authorLabel.frame.origin.y, screenWidth/2-42, 38)];
        
            
            numberOfStars = [[[responseObject valueForKey:@"ratings"] valueForKey:@"average"] intValue];
            for (int i = 0; i < numberOfStars; i++) {
                [starImageArr[i] setImage:[UIImage imageNamed:@"starColour.png"]];
                
            }
      
            if ([[responseObject objectForKey:@"practical_infos"] count] ){
                [self settingPracticalInfos:nil arrayOfInfosImg:nil];
            }
           
         
            
            htmlString = [responseObject objectForKey:@"post_content"];

            [self settingWebView:htmlString];
            
         
            NSString *urlStringHeadImg = [responseObject objectForKey:@"post_thumbnail_url"];
            [imageViewHeader sd_setImageWithURL:[NSURL URLWithString:urlStringHeadImg]
                               placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   
                                 
//
                                       postModel = [[PostModel alloc]initPostWithImageHeader:image authorName:authorName htmlString:finalString numberOfStars:[NSNumber numberWithInt: numberOfStars] passageText:passage.text postTitleText:postsBigTitle.text];
                                       postModel.arrayOfInfos = arrayUsedInTable;
                                       postModel.arrayOfInfosImg = arrayWithImagesUsedInTable;
                                       postModel.arrayOfSchedule = arrayOfSchedule;
                                       postModel.tagsCount = numberOfTags;
                                       postModel.allTagsSlugs = allTagsSlugs;
                                       postModel.allTagsName = allTagsName;
                                  
                                        postModel.suggestionsCount = [NSNumber numberWithInteger:suggestionsCount];
                                   postModel.thumbnail = [[NSMutableArray alloc]init];
                                   postModel.title = [[NSMutableArray alloc]init];
                                   postModel.fragment = [[NSMutableArray alloc]init];
                                    postModel.identifier = [[NSMutableArray alloc]init];

                                
                                  
                                  
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

             [self.view addSubview:menuButton];

             changeFrameOnce1 = false;
         }
         else if(changeFrameOnce1 == false && scrollView.contentOffset.y < initialpozitionOfOpenMenuButton - 37) {
             
             menuButton.frame = CGRectMake(menuButton.frame.origin.x, initialpozitionOfOpenMenuButton, menuButton.frame.size.width, menuButton.frame.size.height);

             [mainScrollView addSubview:menuButton];

             
             changeFrameOnce1 = true;
         }
         if(changeFrameOnce == true && scrollView.contentOffset.y  +menuButton.frame.size.height >= initialpozitionOfBackButton - backButton.frame.size.height ) {
             
             backButton.frame = CGRectMake(backButton.frame.origin.x, menuButton.frame.origin.y + menuButton.frame.size.height + 5, backButton.frame.size.width, backButton.frame.size.height);
             
             [self.view addSubview:backButton];
             [self.view bringSubviewToFront:backButton];
             
             changeFrameOnce = false;
             
         }
         else if(changeFrameOnce == false && scrollView.contentOffset.y < backButton.frame.origin.y - backButton.frame.size.height + 25) {
             
             backButton.frame = CGRectMake(backButton.frame.origin.x, initialpozitionOfBackButton, backButton.frame.size.width, backButton.frame.size.height);
             
             [mainScrollView addSubview:backButton];
             [mainScrollView bringSubviewToFront:backButton];
             
             changeFrameOnce = true;
             
         }
    }
}

-(void)backToTop{
    
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
   
    decisionHandler(WKNavigationActionPolicyAllow);
    [activityView setHidden:NO];
    [blackCurtain setHidden:NO];
}


-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{


    if (![navigationAction.request.URL.absoluteString containsString:@"http"]) {
        return nil;
    }
  
    if (!navigationAction.targetFrame.isMainFrame) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSError *error = nil;
        NSStringEncoding encoding;
        
        NSString *my_string = [[NSString alloc] initWithContentsOfURL:navigationAction.request.URL
                                                         usedEncoding:&encoding
                                                                error:&error];
        
        
        NSArray *listItems = [my_string componentsSeparatedByString:@"<link rel='shortlink' href='https://vivreathenes.com/?p="];
        if ([navigationAction.request.URL.absoluteString containsString:@"vivreathenes.com"] == false) {

           
            
     
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            

            return nil;
        }
        NSArray *listItems2 = [listItems[1] componentsSeparatedByString:@"' />"];
         NSString *foundedId = listItems2[0];
        
    
        [self.arrOfId addObject:[GlobalVariables getInstance].idOfPost];
//        [[NSUserDefaults standardUserDefaults]setObject:arrOfId forKey:@"arrOfId"];
        NSLog(@"foundedId %@", foundedId);
        NSDictionary *dict = [NSDictionary dictionaryWithObject:self.arrOfId forKey:@"arrOfId"];
        
        [[GlobalVariables getInstance] setIdOfPost:foundedId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"] userInfo:dict];


        
    }
    return nil;
}

-(void)settingWebView:(NSString *)htmlStr{
    
    
    
    htmlStr = [@"<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js\"></script><body>" stringByAppendingString:htmlStr];
    htmlStr = [@"<script src=\"contact-form.js\"></script>" stringByAppendingString:htmlStr];
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
    
    htmlStr = [@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></head>" stringByAppendingString:htmlStr];

    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
   
    
//    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"href=\"#" withString:@""];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    
    
    NSString *cssString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
   finalString = [cssString stringByAppendingString:htmlStr];
    
   
    NSLog(@"finalString %@", finalString);


      [wkWebView loadHTMLString:finalString baseURL:[NSBundle mainBundle].bundleURL];

   
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [activityView setHidden:YES];
    [blackCurtain setHidden:YES];

    [self performSelector:@selector(finishedLoading) withObject:nil afterDelay:0.2];
    
}
- (IBAction)getBack:(UIButton *)sender {
    if (self.arrOfId.count) {
        [[GlobalVariables getInstance] setIdOfPost:self.arrOfId.lastObject];
        [self.arrOfId removeObject:_arrOfId.lastObject];
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:self.arrOfId forKey:@"arrOfId"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"] userInfo:dict];
    }
    else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"%@", [GlobalVariables getInstance].comingFromViewController]];
    }
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

-(void)settingContactForm{
    viewForContactForm = [[UIView alloc]initWithFrame:CGRectMake(0, wkWebView.frame.size.height + wkWebView.frame.origin.y + 30, screenWidth, 810)];
    [mainScrollView addSubview:viewForContactForm];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 20)];
    title.text = [[[postInfo valueForKey:@"practical_infos"]valueForKey:@"contact_form"] valueForKey:@"title"];
    
     [title setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:15]];
    [title sizeToFit];
    
     heightForObj = title.frame.size.height + title.frame.origin.y + 25;
    
    [viewForContactForm addSubview:title];
    [[[[postInfo valueForKey:@"practical_infos"]valueForKey:@"contact_form"]valueForKey:@"fields"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSLog(@"obj %@", obj);
        if ([[obj valueForKey:@"type"]isEqualToString:@"hidden"]) {
            
            
        }

        else if([[obj valueForKey:@"name"] isEqualToString:@"your-name"]){
            yourName = [[UILabel alloc]initWithFrame:CGRectMake(10, heightForObj, 50, 20)];
            yourName.text = [obj valueForKey:@"label"];
            [yourName setFont:[UIFont fontWithName:@"Gudea" size:15]];
            [yourName sizeToFit];
            [viewForContactForm addSubview:yourName];
            
            textFieldForName = [[UITextField alloc]initWithFrame:CGRectMake(10, yourName.frame.origin.y+20, 200, 20)];
            
            [textFieldForName setBackgroundColor:[UIColor whiteColor]];
            [textFieldForName.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForName.layer setBorderWidth:1.0];
            [textFieldForName  setFont: [UIFont fontWithName:@"Gudea" size:15]];
            [textFieldForName.layer setCornerRadius:4.0f];
            UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
            [textFieldForName setLeftViewMode:UITextFieldViewModeAlways];
            [textFieldForName setLeftView:spacerView];
            
            [viewForContactForm addSubview:textFieldForName];
            heightForObj = heightForObj + 70;
        }
        else if([[obj valueForKey:@"name"] isEqualToString:@"your-email"]){
            yourEmail = [[UILabel alloc]initWithFrame:CGRectMake(10, heightForObj, 50, 20)];
            yourEmail.text = [obj valueForKey:@"label"];
            [yourEmail setFont:[UIFont fontWithName:@"Gudea" size:15]];
            [yourEmail sizeToFit];
            [viewForContactForm addSubview:yourEmail];
            textFieldForEmail = [[UITextField alloc]initWithFrame:CGRectMake(10, yourEmail.frame.origin.y+20, 200, 20)];
            [textFieldForEmail setBackgroundColor:[UIColor whiteColor]];
            [textFieldForEmail.layer setBorderColor:[UIColor grayColor].CGColor];
            
            textFieldForEmail.keyboardType = UIKeyboardTypeEmailAddress;
            [textFieldForEmail.layer setBorderWidth:1.0];
            [textFieldForEmail.layer setCornerRadius:4.0f];
            [textFieldForEmail  setFont: [UIFont fontWithName:@"Gudea" size:15]];
            UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
            [textFieldForEmail setLeftViewMode:UITextFieldViewModeAlways];
            [textFieldForEmail setLeftView:spacerView];
            
            [viewForContactForm addSubview:textFieldForEmail];
            heightForObj = heightForObj + 70;
        }
        else if([[obj valueForKey:@"name"] isEqualToString:@"your-dates"]){
            yourDates = [[UILabel alloc]initWithFrame:CGRectMake(10, heightForObj, 50, 20)];
            yourDates.text = [obj valueForKey:@"label"];
            [yourDates setFont:[UIFont fontWithName:@"Gudea" size:15]];
            [yourDates sizeToFit];
            [viewForContactForm addSubview:yourDates];
            textFieldForDates = [[UITextField alloc]initWithFrame:CGRectMake(10, yourDates.frame.origin.y+20, 200, 20)];
            [textFieldForDates setBackgroundColor:[UIColor whiteColor]];
            [textFieldForDates.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForDates.layer setBorderWidth:1.0];
            [textFieldForDates.layer setCornerRadius:4.0f];
            [textFieldForDates  setFont: [UIFont fontWithName:@"Gudea" size:15]];
            UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
            [textFieldForDates setLeftViewMode:UITextFieldViewModeAlways];
            [textFieldForDates setLeftView:spacerView];
            
            [viewForContactForm addSubview:textFieldForDates];
            heightForObj = heightForObj + 70;
        }
        else if([[obj valueForKey:@"name"] isEqualToString:@"your-number"]){
            yourNumber = [[UILabel alloc]initWithFrame:CGRectMake(10, heightForObj, 50, 20)];
            yourNumber.text = [obj valueForKey:@"label"];
            [yourNumber setFont:[UIFont fontWithName:@"Gudea" size:15]];
            [yourNumber sizeToFit];
            [viewForContactForm addSubview:yourNumber];
            textFieldForNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, yourNumber.frame.origin.y+20, 140, 20)];
            [textFieldForNumber setBackgroundColor:[UIColor whiteColor]];
            textFieldForNumber.keyboardType = UIKeyboardTypeNumberPad;
            [textFieldForNumber.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForNumber.layer setBorderWidth:1.0];
            [textFieldForNumber.layer setCornerRadius:4.0f];
            [textFieldForNumber  setFont: [UIFont fontWithName:@"Gudea" size:15]];
            UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
            [textFieldForNumber setLeftViewMode:UITextFieldViewModeAlways];
            [textFieldForNumber setLeftView:spacerView];
            
            [viewForContactForm addSubview:textFieldForNumber];
            heightForObj = heightForObj + 70;
        }
        else if([[obj valueForKey:@"name"] isEqualToString:@"your-subject"]){
            yourSubject = [[UILabel alloc]initWithFrame:CGRectMake(10, heightForObj, 50, 20)];
            yourSubject.text = [obj valueForKey:@"label"];
            [yourSubject setFont:[UIFont fontWithName:@"Gudea" size:15]];
            [yourSubject sizeToFit];
            [viewForContactForm addSubview:yourSubject];
            textFieldForSubject = [[UITextField alloc]initWithFrame:CGRectMake(10, yourSubject.frame.origin.y+20, 250, 20)];
            [textFieldForSubject setBackgroundColor:[UIColor whiteColor]];
            [textFieldForSubject.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForSubject.layer setBorderWidth:1.0];
            [textFieldForSubject.layer setCornerRadius:4.0f];
            
            [textFieldForSubject  setFont: [UIFont fontWithName:@"Gudea" size:15]];
            UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
            [textFieldForSubject setLeftViewMode:UITextFieldViewModeAlways];
            [textFieldForSubject setLeftView:spacerView];
            
            [viewForContactForm addSubview:textFieldForSubject];
            heightForObj = heightForObj + 70;
        }
        else if([[obj valueForKey:@"name"] isEqualToString:@"your-message"]){
            yourMessage = [[UILabel alloc]initWithFrame:CGRectMake(10, heightForObj, 50, 20)];
            yourMessage.text = [obj valueForKey:@"label"];
            [yourMessage setFont:[UIFont fontWithName:@"Gudea" size:15]];
            [yourMessage sizeToFit];
            [viewForContactForm addSubview:yourMessage];
            textFieldForMessage = [[UITextField alloc]initWithFrame:CGRectMake(10, yourMessage.frame.origin.y+20, 250, 200)];
            [textFieldForMessage setBackgroundColor:[UIColor whiteColor]];
            [textFieldForMessage.layer setBorderColor:[UIColor grayColor].CGColor];
            [textFieldForMessage.layer setBorderWidth:1.0];
            [textFieldForMessage.layer setCornerRadius:4.0f];
            textFieldForMessage.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            [textFieldForMessage  setFont: [UIFont fontWithName:@"Gudea" size:15]];
            UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
            [textFieldForMessage setLeftViewMode:UITextFieldViewModeAlways];
            [textFieldForMessage setLeftView:spacerView];
            
            [viewForContactForm addSubview:textFieldForMessage];
            heightForObj = heightForObj + 235;
        }
        else if([[obj valueForKey:@"name"] isEqualToString:@"terms"]){
            ckeckbox = [[BEMCheckBox alloc]initWithFrame:CGRectMake(10, heightForObj+3, 15, 15)];
            [ckeckbox addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
            [ckeckbox setBoxType:BEMBoxTypeSquare];
            [ckeckbox setOnAnimationType:BEMAnimationTypeFill];
            [viewForContactForm addSubview:ckeckbox];
            
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, heightForObj, screenWidth-25, 20)];
            lbl.text = [obj valueForKey:@"label"];
            [lbl setFont:[UIFont fontWithName:@"Gudea" size:15]];
            
            
            [lbl setNumberOfLines:0];
            [lbl sizeToFit];
            [viewForContactForm addSubview:lbl];
            heightForObj = heightForObj + 50;
        }
        else if([[obj valueForKey:@"name"] isEqualToString:@"terms-2"]){
            ckeckbox2 = [[BEMCheckBox alloc]initWithFrame:CGRectMake(10, heightForObj+40, 15, 15)];
            [ckeckbox2 setBoxType:BEMBoxTypeSquare];
            [ckeckbox2 setOnAnimationType:BEMAnimationTypeFill];
            [ckeckbox2 addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
         
            [viewForContactForm addSubview:ckeckbox2];
            
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, heightForObj+30, screenWidth-25, 20)];
            [textView setBackgroundColor:[UIColor clearColor]];
            NSString *hString = [obj valueForKey:@"label"];
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[hString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            textView.attributedText = attrStr;
            
            [textView setFont:[UIFont fontWithName:@"Gudea" size:15]];
            
            textView.delegate = self;
            [textView setEditable:NO];
            [textView sizeToFit];
            
            [viewForContactForm addSubview:textView];
            heightForObj = heightForObj + 80;
        }

        else if([[obj valueForKey:@"type"] isEqualToString:@"submit"]){
            heightForObj = heightForObj + 20;
       
            subm.layer.cornerRadius = 4;
            subm.clipsToBounds = YES;
            [subm.layer setBorderWidth:0.5f];
            [subm.layer setBorderColor:[[UIColor blackColor] CGColor]];

            [subm setFrame:CGRectMake(10, heightForObj, screenWidth - 20, 40)];
            [subm setTitle:[obj valueForKey:@"value"] forState:UIControlStateNormal];
 
            [viewForContactForm addSubview:subm];
        }
      
    }];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    blackCurtain = [[UIView alloc] init];
//    [blackCurtain setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height*0.93)];
//    [blackCurtain setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
//    [self.view addSubview:blackCurtain];
//
//
//    activityView = [[UIActivityIndicatorView alloc]
//                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityView.center = self.view.center;
//    [activityView startAnimating];
//    [self.view addSubview:activityView];
     [[UIApplication sharedApplication] openURL:URL];
    return YES; // Return NO if you don't want iOS to open the link
}
-(void)checkboxClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
}
-(void)settingPracticalInfos:(NSMutableArray *)arraOfInfosObj arrayOfInfosImg:(NSMutableArray *)arrayOfInfosImg{

    if (arraOfInfosObj && arrayOfInfosImg) {
        heightOfObj = 70;
        [arraOfInfosObj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:arrayOfInfosImg[idx]]];
//            practicalInfosLabel.text =  @"Infos Pratiques";
            if ([obj isKindOfClass:[UIView class]]) {
                [self setttingSchedule:postModel.arrayOfSchedule];
                
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
                
                if ([arrayOfInfosImg[idx] isEqualToString:@"phone"]) {
                    [imgView setFrame:CGRectMake(14, heightOfObj, 20, 25)];
//
                }
                if ([arrayOfInfosImg[idx] isEqualToString:@"location"]) {
                    [imgView setFrame:CGRectMake(14, heightOfObj, 23, 27.5)];
                }
                if ([arraOfInfosObj[idx] isEqualToString:@"quartier"]) {
                    [imgView setFrame:CGRectMake(14, heightOfObj, 20, 15)];
                }
                
                if([[arraOfInfosObj objectAtIndex:idx] containsString:@"XYZ"]) {
                    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[[[arraOfInfosObj objectAtIndex:idx] componentsSeparatedByString:@"XYZ"] objectAtIndex:0]];
                    [attributedString addAttribute: NSLinkAttributeName value: [[[arraOfInfosObj objectAtIndex:idx] componentsSeparatedByString:@"XYZ"] objectAtIndex:1] range: NSMakeRange(0, attributedString.length)];
                    lbl.attributedText = attributedString;
                    //                lbl.delegate = self;
                    lbl.dataDetectorTypes = UIDataDetectorTypeLink;
                }
                if([[arraOfInfosObj objectAtIndex:idx] containsString:@"title"]) {
                    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[[[arraOfInfosObj objectAtIndex:idx] componentsSeparatedByString:@"title"] objectAtIndex:0]];
                    [attributedString addAttribute: NSLinkAttributeName value: [[[arraOfInfosObj objectAtIndex:idx] componentsSeparatedByString:@"title"] objectAtIndex:1] range: NSMakeRange(0, attributedString.length)];
                    lbl.attributedText = attributedString;
                    
                    [lbl setFont:[UIFont fontWithName:@"Verdana-Bold" size:21]];
                    
                    lbl.dataDetectorTypes = UIDataDetectorTypeLink;
                    //                [lbl setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:153.0/255.0 alpha:1.0]]; doesn't work for some f***** reason. why so hard..
                    
                    
                }
                
                
                if ([arrayOfInfosImg[idx] isEqualToString:@"0"])  {
                    [lbl setFrame:CGRectMake(10, heightOfObj-2.5, screenWidth - 70, 36)];
                }else{
                    [lbl setFrame:CGRectMake(40, heightOfObj-2.5, screenWidth - 70, 36)]; }
                
                heightOfObj = lbl.frame.size.height + lbl.frame.origin.y + 25;

                [practicalInfos addSubview:imgView];
                [practicalInfos addSubview:lbl];
                [practicalInfos bringSubviewToFront:imgView];
                [practicalInfos bringSubviewToFront:lbl];
                
                heightForPracticalInfos = practicalInfos.frame;
                heightForPracticalInfos.size.height = lbl.frame.origin.y+lbl.frame.size.height;
                NSLog(@"1heightForPracticalInfos.size.height %f", heightForPracticalInfos.size.height);
            }
            
        }];
        return;
    }
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
        
        [arrayUsedInTable addObject:scheduleView];
        [arrayWithImagesUsedInTable addObject:@"0"];
        [self setttingSchedule:nil];
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
        
       
        
        [arrayUsedInTable addObject:[NSString stringWithFormat:@"adrs%@", [[[postInfo valueForKey:@"practical_infos"] valueForKey:@"locations"][i] valueForKey:@"address"]]];
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
    heightOfObj = 60;
  
    [arrayUsedInTable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:arrayWithImagesUsedInTable[idx]]];
//        practicalInfosLabel.text =  @"Infos Pratiques";
        if (obj == scheduleView) {
            [self setttingSchedule:nil];
            
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
            if ([obj containsString:@"adrs"]) {
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]init];
                [gesture addTarget:self action:@selector(tapedOnAddress:) ];
//                gesture.delegate = self;
                [lbl setUserInteractionEnabled:YES];
                [lbl addGestureRecognizer:gesture];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[lbl.text substringFromIndex:4]];
                [attributeString addAttribute:NSUnderlineStyleAttributeName
                                        value:[NSNumber numberWithInt:1]
                                        range:(NSRange){0,[attributeString length]}];
                lbl.attributedText = attributeString;
                
            }
            lbl.textContainer.maximumNumberOfLines = 2;
            lbl.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            [imgView setFrame:CGRectMake(10, heightOfObj, 22, 25)];
            
            if ([arrayWithImagesUsedInTable[idx] isEqualToString:@"phone"] ) {
            [imgView setFrame:CGRectMake(14, heightOfObj, 15, 25)];
            }
            if ([arrayWithImagesUsedInTable[idx] isEqualToString:@"location"]) {
                
                
                [imgView setFrame:CGRectMake(14, heightOfObj, 17, 27.5)];
             
            }
            if ([arrayWithImagesUsedInTable[idx] isEqualToString:@"quartier"]) {
                [imgView setFrame:CGRectMake(14, heightOfObj, 20, 15)];
            }
      
            if([[arrayUsedInTable objectAtIndex:idx] containsString:@"XYZ"]) {
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[[[arrayUsedInTable objectAtIndex:idx] componentsSeparatedByString:@"XYZ"] objectAtIndex:0]];
                [attributedString addAttribute: NSLinkAttributeName value: [[[arrayUsedInTable objectAtIndex:idx] componentsSeparatedByString:@"XYZ"] objectAtIndex:1] range: NSMakeRange(0, attributedString.length)];
               lbl.attributedText = attributedString;

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

        [practicalInfos addSubview:imgView];
        [practicalInfos addSubview:lbl];
      
            
            heightForPracticalInfos = practicalInfos.frame;
            heightForPracticalInfos.size.height = lbl.frame.origin.y+lbl.frame.size.height;
           NSLog(@"2heightForPracticalInfos.size.height %f", heightForPracticalInfos.size.height);
        }
       
    }];
    
    
}

-(void)tapedOnAddress:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
   UITextView *clickedView =  (UITextView *)view;
    NSLog(@"tapedOnAddress %@", clickedView.text);
    NSString *url = [NSString stringWithFormat: @"https://www.google.com/maps/search/?api=1&query=%@",
                     [clickedView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    // Do whatever you want here
//    NSLog(@"%@", URL); // URL is an instance of NSURL of the tapped link
//    return NO; // Return NO if you don't want iOS to open the link
//}
-(void)setttingSchedule:(NSMutableArray *)arrOfSchedule{
     bool opened = false;
    self.arrScheduleLabels = [[NSMutableArray alloc]initWithObjects:lundiSchedule, mardiSchedule, mercrediSchedule, jeudiSchedule, vendrediSchedule, samediSchedule, dimancheSchedule, nil];
    if (arrOfSchedule != nil) {
         NSUInteger index = 0;
        for (NSString *schedule in [arrOfSchedule subarrayWithRange:NSMakeRange(0, 7)]) {
            UILabel *lbl =  self.arrScheduleLabels[index];
            lbl.text = schedule;
            [lbl sizeToFit];
            index = index + 1;
        }
        [scheduleView setFrame:CGRectMake(scheduleView.frame.origin.x, heightOfObj, scheduleView.frame.size.width, scheduleView.frame.size.height)];
        [scheduleView setHidden:NO];
        heightOfObj = scheduleView.frame.size.height + scheduleView.frame.origin.y + 30;
        return;
    }
    
    NSMutableDictionary *schedule = [[postInfo valueForKey:@"practical_infos"]valueForKey:@"schedule"];
    if (schedule.count >0) {
        
   
    
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
        

    for (NSDictionary *dict in sortedArr) {
        UILabel *lbl =  self.arrScheduleLabels[index];
        
        if ([lbl.text isEqualToString:@" -  "] && [[sortedArr[index] valueForKey:@"status"] isEqualToString:@"closed"]) {
            lbl.text = @"Fermé";
            
            
        }
        else if ([lbl.text isEqualToString:@" -  "] && [[sortedArr[index] valueForKey:@"status"] isEqualToString:@"opened"]){
          
            lbl.text = @"Ouvert";
        }
        else if (![lbl.text isEqualToString:@" -  "]){
              opened = true;
            [scheduleView setHidden:NO];
         practicalInfosLabel.text =  @"Infos Pratiques";
        }
        [lbl sizeToFit];
        NSLog(@"lbl.text %@", lbl.text);
        [arrayOfSchedule addObject:lbl.text];
        index++;
       

    }
     }
    if (opened) {
         [scheduleView setFrame:CGRectMake(scheduleView.frame.origin.x, heightOfObj, scheduleView.frame.size.width, scheduleView.frame.size.height)];
         heightOfObj = scheduleView.frame.size.height + scheduleView.frame.origin.y + 30;
       
    } else {
         [scheduleView setFrame:CGRectMake(scheduleView.frame.origin.x, heightOfObj, scheduleView.frame.size.width, 0)];
         heightOfObj = scheduleView.frame.origin.y;
    }
   
    
   
}


-(void)finishedLoading{

    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]){
        [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, [postModel.heightForWKWebView floatValue])];
    }
    else{
    [wkWebView setFrame:CGRectMake(0, wkWebView.frame.origin.y, screenWidth, [[wkWebView scrollView]contentSize].height)];
        postModel.heightForWKWebView = @([[wkWebView scrollView]contentSize].height);
    }
    if ([[[postInfo valueForKey:@"practical_infos"]valueForKey:@"contact_form"]count]) {
          [self settingContactForm];
    }else{
        heightForObj = wkWebView.frame.size.height + wkWebView.frame.origin.y;
    }
  
   //40/////////////////////////////////400wkWebView.frame.size.height + wkWebView.frame.origin.y +
    [practicalInfos setFrame:CGRectMake(0,  viewForContactForm.frame.origin.y+viewForContactForm.frame.size.height + 40, screenWidth, heightForPracticalInfos.size.height)];
    NSLog(@"prac frame %@", NSStringFromCGRect(practicalInfos.frame));

    
    [mainScrollView addSubview:practicalInfos];
//    [mainScrollView addSubview:subm];
    
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
        [self settingPracticalInfos:postModel.arrayOfInfos arrayOfInfosImg:postModel.arrayOfInfosImg];
    }

  
    [self settingMap:postModel.postMapView];
    if ([[postInfo valueForKey:@"location"] count] || (unlockedIAP == YES && [SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost] && postModel.postMapView)) {
        [self.postMapView setFrame:CGRectMake(0, practicalInfos.frame.origin.y + heightForPracticalInfos.size.height + 30, self.view.frame.size.width, self.view.frame.size.height/2.5)];
        


        
        [mainScrollView addSubview:self.postMapView];

    }
    else{
         [self.postMapView setFrame:CGRectMake(0, practicalInfos.frame.origin.y + practicalInfos.frame.size.height + 30, self.view.frame.size.width, 0)];
    }

    longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(openMapPage:)];
      [self.postMapView addGestureRecognizer:longTap];
    

  

    tagsL = [[UILabel alloc]initWithFrame:CGRectMake(4, 10, 50, 50)];
 
    tagsL.text = @"TAGS:";
    tagsL.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
   
    
    tagsL.textColor = [UIColor blackColor];
    [tagsL setHidden:YES];
    float buttonWidth = 0.0;
    float buttonXpos = tagsL.frame.origin.x + tagsL.frame.size.width;
      viewForTags = [[UIView alloc]init];
       int yForNewTag = 0;
        if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
    for (int i = 0; i <= [postModel.tagsCount intValue]; i++) {
        if ([postModel.tagsCount intValue] == 0) {
                [viewForTags setFrame:CGRectMake(4, _postMapView.frame.origin.y + _postMapView.frame.size.height + 14, screenWidth, 100)];
            break;
        }
          [tagsL setHidden: NO];
       tag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [tag addTarget:self
                action:@selector(tagPressed:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [tag setTitle:[postModel.allTagsName[i] uppercaseString] forState:UIControlStateNormal];
        [tag setBackgroundColor:[UIColor colorWithRed:227.0/255.0 green:228.0/255.0 blue:234.0/255.0 alpha:1.0]];
        
        tag.frame = CGRectMake(buttonXpos + buttonWidth + 4,  tagsL.frame.origin.y + 5 + yForNewTag, 0, 50.0);
        //
        
        tag.layer.cornerRadius = tag.frame.size.height/5;
        tag.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:16];
        
        tag.titleLabel.textAlignment = NSTextAlignmentCenter;
        tag.titleLabel.adjustsFontSizeToFitWidth = true;
        tag.titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:76.0/255.0 blue:105.0/255.0 alpha:1.0];
        
        [tag sizeToFit];
        if (buttonXpos + buttonWidth + tag.frame.size.width  + 8 > screenWidth) {
            tag.frame = CGRectMake(10, tagsL.frame.origin.y + 45 , 0, 50.0);
            yForNewTag = 40;
            [tag sizeToFit];
        }
        CGRect size = tag.frame;
        size.size.width = size.size.width + 10;
        tag.frame = size;
        buttonWidth = tag.frame.size.width + 5;
        buttonXpos = tag.frame.origin.x;
        
        [tag setTag:i];
        
        
        
        
        
      
        [viewForTags setFrame:CGRectMake(4, _postMapView.frame.origin.y + _postMapView.frame.size.height + 14, screenWidth, 100)];
       
        
        [mainScrollView addSubview:viewForTags];

        [viewForTags addSubview:tag];
   
        
        [viewForTags addSubview:tagsL];

    }
        }
else{
    for (int i = 0; i <= [numberOfTags intValue]; i++) {
        if ([numberOfTags intValue] == 0) {
            [viewForTags setFrame:CGRectMake(4, _postMapView.frame.origin.y + _postMapView.frame.size.height + 14, screenWidth, 100)];
            break;
        }
        [tagsL setHidden: NO];
        
       
        tag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [tag addTarget:self
                   action:@selector(tagPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [tag setTitle:[[[postInfo valueForKey:@"tags"][i] valueForKey:@"name"]uppercaseString] forState:UIControlStateNormal];
        [tag setBackgroundColor:[UIColor colorWithRed:227.0/255.0 green:228.0/255.0 blue:234.0/255.0 alpha:1.0]];
     
        tag.frame = CGRectMake(buttonXpos + buttonWidth + 4,  tagsL.frame.origin.y + 5 + yForNewTag, 0, 50.0);
//
       
        tag.layer.cornerRadius = tag.frame.size.height/5;
        tag.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:16];
        
        tag.titleLabel.textAlignment = NSTextAlignmentCenter;
        tag.titleLabel.adjustsFontSizeToFitWidth = true;
        tag.titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:76.0/255.0 blue:105.0/255.0 alpha:1.0];
       
        [tag sizeToFit];
        if (buttonXpos + buttonWidth + tag.frame.size.width  + 8 > screenWidth) {
            tag.frame = CGRectMake(10, tagsL.frame.origin.y + 45 , 0, 50.0);
            yForNewTag = 40;
            [tag sizeToFit];
        }
        CGRect size = tag.frame;
        size.size.width = size.size.width + 10;
        tag.frame = size;
        buttonWidth = tag.frame.size.width + 5;
        buttonXpos = tag.frame.origin.x;
       
        [tag setTag:i];
        [viewForTags setFrame:CGRectMake(4, _postMapView.frame.origin.y + _postMapView.frame.size.height + 14, screenWidth, 100)];
        
        
        [mainScrollView addSubview:viewForTags];

        [viewForTags addSubview:tag];

        
        [viewForTags addSubview:tagsL];

    }
}
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
         [mainScrollView addSubview:self.tableView];
         [self.tableView setFrame:CGRectMake(0, viewForTags.frame.origin.y + 150, screenWidth, self.view.frame.size.width/3.5 * [postModel.suggestionsCount doubleValue])];
        [self.tableView setScrollEnabled:NO];
        //        mainScrollView.contentSize = CGSizeMake(screenWidth, self.tableView.frame.origin.y + self.tableView.frame.size.height + 100);
        
        [articlesSuggestions setFrame:CGRectMake(0, self.tableView.frame.origin.y - 50, screenWidth, 40)];
        [articlesSuggestions setHidden:NO];
        [mainScrollView addSubview:articlesSuggestions];
        [mainScrollView bringSubviewToFront:articlesSuggestions];
    }
    if (suggestionsCount) {
 
        [mainScrollView addSubview:self.tableView];
        
        
        [self.tableView setFrame:CGRectMake(0, viewForTags.frame.origin.y + 150, screenWidth, self.view.frame.size.width/3.5*suggestionsCount)];
        [self.tableView setScrollEnabled:NO];


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
    contentRect.size.height = contentRect.size.height+40;
    mainScrollView.contentSize = contentRect.size;
    
   
}
-(void)tagPressed :(UIButton *)button{
    [GlobalVariables getInstance].backToPostHasToBeHidden = YES;
    NSInteger index = button.tag;
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
        NSLog(@"local");
        NSLog(@"TAG CLICKED SLUG IS : %@",postModel.allTagsSlugs[index]);
        [GlobalVariables getInstance].slugName = postModel.allTagsName[index];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromAgendaTag"];
        [GlobalVariables getInstance].backGroundImageTag = nil;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",postModel.allTagsSlugs[index]] forKey:@"ComingFromPostTag"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CatsSubCatsController"]];
        return;
    }
    NSLog(@"TAG CLICKED SLUG IS : %@",allTagsSlugs[index]);
    [GlobalVariables getInstance].slugName = allTagsName[index];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromAgendaTag"];
    [GlobalVariables getInstance].backGroundImageTag = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",allTagsSlugs[index]] forKey:@"ComingFromPostTag"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CatsSubCatsController"]];
}
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return true;
}



- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
         UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75.f, 70.f)];
        imageview.image = postModel.imageHeader;
        if(!imageview.image){
            return nil;

        }
         return imageview;


    }else{
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75.f, 70.f)];
                [imageview sd_setImageWithURL:[postInfo valueForKey:@"post_thumbnail_url"] placeholderImage:[UIImage imageNamed: @"PlaceHolderImage"]];
        if(!imageview.image){
            return nil;

        }
               return imageview;
    }


}

- (void) mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    __block NSMutableDictionary *maxLatDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@0 , @"lat", nil];
    __block NSMutableDictionary *minLatDict =   [[NSMutableDictionary alloc]initWithObjectsAndKeys:@180, @"lat", nil];
    
    
    __block NSMutableDictionary *maxLongDict =  [[NSMutableDictionary alloc]initWithObjectsAndKeys:@0, @"long" , nil];
    __block NSMutableDictionary *minLongDict =  [[NSMutableDictionary alloc]initWithObjectsAndKeys:@180, @"long", nil];
    mapView.showsUserLocation = YES;
     if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
         if (postModel.annotations.count > 1) {
              MGLCoordinateBounds bounds;
             bounds.sw = CLLocationCoordinate2DMake((CLLocationDegrees)[[postModel.bounds valueForKey:@"sw.latitude"] doubleValue], (CLLocationDegrees)[[postModel.bounds valueForKey:@"sw.longitude"] doubleValue]);
             bounds.ne =  CLLocationCoordinate2DMake((CLLocationDegrees)[[postModel.bounds valueForKey:@"ne.latitude"] doubleValue], (CLLocationDegrees)[[postModel.bounds valueForKey:@"ne.longitude"] doubleValue]);
              [self.postMapView flyToCamera:[mapView cameraThatFitsCoordinateBounds:MGLCoordinateBoundsMake(bounds.sw, bounds.ne) edgePadding:UIEdgeInsetsMake(25, 10, 10, 10)] completionHandler:nil];
             
             
   
         }
         else{
             [self.postMapView setCenterCoordinate:CLLocationCoordinate2DMake(postModel.annotations.firstObject.coordinate.latitude, postModel.annotations.firstObject.coordinate.longitude) zoomLevel:16 animated:YES];
         }
         }
        
     else{
        
         
         [pointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

             MGLPointAnnotation *annotation = (MGLPointAnnotation*) obj;
             
             if (annotation.coordinate.latitude > [[maxLatDict objectForKey:@"lat"] doubleValue]) {
                 [maxLatDict setValue:[NSNumber numberWithDouble:annotation.coordinate.latitude] forKey:@"lat"];
                 

             }
             if (annotation.coordinate.latitude < [[minLatDict objectForKey:@"lat"]doubleValue]) {
                [minLatDict setValue:[NSNumber numberWithDouble:annotation.coordinate.latitude] forKey:@"lat"];
        
             }
             if (annotation.coordinate.longitude >[[maxLongDict objectForKey:@"long"] doubleValue]) {
                 [maxLongDict setValue:[NSNumber numberWithDouble:annotation.coordinate.longitude] forKey:@"long"];
           
             }
             if (annotation.coordinate.longitude<[[minLongDict objectForKey:@"long"]doubleValue]) {
                  [minLongDict setValue:[NSNumber numberWithDouble:annotation.coordinate.longitude] forKey:@"long"];
        
             }
             
             

        
             
         }];
         MGLCoordinateBounds bounds;
        
         NSMutableDictionary *coordinates = [NSMutableDictionary dictionary];
         bounds.sw = CLLocationCoordinate2DMake((CLLocationDegrees)[[minLatDict valueForKey:@"lat"] doubleValue], (CLLocationDegrees)[[minLongDict valueForKey:@"long"] doubleValue]);
         
         bounds.ne = CLLocationCoordinate2DMake((CLLocationDegrees)[[maxLatDict valueForKey:@"lat"] doubleValue], (CLLocationDegrees)[[maxLongDict valueForKey:@"long"] doubleValue]);
     
         [coordinates setValue:[NSNumber numberWithFloat:bounds.sw.latitude] forKey:@"sw.latitude"];
         [coordinates setValue:[NSNumber numberWithFloat:bounds.sw.longitude] forKey:@"sw.longitude"];
         [coordinates setValue:[NSNumber numberWithFloat:bounds.ne.latitude] forKey:@"ne.latitude"];
         [coordinates setValue:[NSNumber numberWithFloat:bounds.ne.longitude] forKey:@"ne.longitude"];
         [[NSUserDefaults standardUserDefaults]setObject:coordinates forKey:@"coordinates"];
         postModel.bounds = coordinates;
         if (self.postMapView.annotations.count > 1) {
                    [self.postMapView flyToCamera:[mapView cameraThatFitsCoordinateBounds:bounds edgePadding:UIEdgeInsetsMake(25, 10, 10, 10)] completionHandler:nil];
             
         }
         else{
              [self.postMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[postInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue] + 0.0002, [[[postInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue] - 0.00001) zoomLevel:16 direction:0 animated:YES];
         }
        

    
         

         postModel.postMapView = mapView;
         

        
     }
  
    

}

-(void)showMessage: (NSString *)content{
    
    demo = [[OLGhostAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", content] message:nil timeout:1.1 dismissible:YES];

    demo.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:14.0 ];
    demo.titleLabel.textColor = [UIColor whiteColor];
    demo.backgroundColor =  [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];;
    demo.bottomContentMargin = 50;
    demo.layer.cornerRadius = 7;
    
    [demo show];
    
    
}
-(void) openMapPage:(UIGestureRecognizer *)gestureRecognizer{

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ZoomMapPage"]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {

        [GlobalVariables getInstance].idOfPost = [NSString stringWithFormat:@"%@", postModel.identifier[indexPath.row]];
        [GlobalVariables getInstance].comingFrom = @"Posts";
        [GlobalVariables getInstance].comingFromViewController = @"PostViewController";
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
    }
    else{
    NSInteger tag = indexPath.row;
    NSLog(@"%lu", tag);
    [GlobalVariables getInstance].idOfPost = [[postInfo valueForKey:@"suggested_posts"] valueForKey:@"id"][tag];
    NSLog(@"[GlobalVariables getInstance].idOfPost %@ ", [GlobalVariables getInstance].idOfPost);
    [GlobalVariables getInstance].comingFrom = @"Posts";
    [GlobalVariables getInstance].comingFromViewController = @"PostViewController";
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
        return [postModel.suggestionsCount integerValue];
    }
    return suggestionsCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuggestionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (unlockedIAP && [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:[GlobalVariables getInstance].idOfPost]]) {
        cell.thumbnail.image = postModel.thumbnail[indexPath.row];
        cell.title.text = postModel.title[indexPath.row];
        cell.fragment.text = postModel.fragment[indexPath.row];
    }
    else{

        [cell.thumbnail sd_setImageWithURL:[[postInfo valueForKey:@"suggested_posts"][indexPath.row]valueForKey:@"thumbnail_url"] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
              [postModel.thumbnail addObject:cell.thumbnail.image];
        }];
    cell.title.text = [[postInfo valueForKey:@"suggested_posts"][indexPath.row]valueForKey:@"title"];
    cell.fragment.text = [[postInfo valueForKey:@"suggested_posts"][indexPath.row]valueForKey:@"excerpt"];
        [postModel.identifier addObject:[NSNumber numberWithInteger:[[[postInfo valueForKey:@"suggested_posts"][indexPath.row]valueForKey:@"id"]intValue]]] ;
      
        [postModel.title addObject:cell.title.text];
        [postModel.fragment addObject:cell.fragment.text];
    }
    
    
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
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
