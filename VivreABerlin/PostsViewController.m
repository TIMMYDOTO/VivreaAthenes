//
//  PostsViewController.m
//  VivreABerlin
//
//  Created by home on 05/05/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "PostsViewController.h"
#import "GlobalVariables.h"
#import "Reachability.h"
#import "TYMProgressBarView.h"
#import "Header.h"
#import "UIImageView+Network.h"
#import "JTMaterialSpinner.h"
#import "SimpleFilesCache.h"
#import "SimpleFilesCache.h"
#import <Social/Social.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "OLGhostAlertView.h"
#import "InfoPratiquesTableViewCell.h"
#import <Social/Social.h>

@interface PostsViewController ()

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height <= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
@end

@implementation PostsViewController
{
    TYMProgressBarView *progressView;
    NSMutableDictionary * postInfo;
    JTMaterialSpinner * spinner;
    JTMaterialSpinner * imagespinner;
    MGLPointAnnotation *point;
    UILabel *downloadMap;
    int numberOfStars;
    NSMutableArray *scrollImageUrls;
    BOOL withrequest;
    UIButton *backToTop;
    BOOL canAppear;
    OLGhostAlertView *demo;
    UIView *loadingScreen;
    UILabel *loadingText;
    NSMutableAttributedString *attributedString;
    NSMutableArray *allTagsSlugs;
    NSMutableArray *allTagsName;
    UITextView *postContent;
    
    UILabel *contentOfTheInfoPratiques;
    
    
    
    CGFloat initialpozitionOfBackButton;
    CGFloat initialpozitionOfOpenMenuButton;
    BOOL changeFrameOnce;
    BOOL changeFrameOnce1;
    NSMutableArray *arrayUsedInTable;
    NSMutableArray *arrayWithImagesUsedInTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@   id OF POST",[GlobalVariables getInstance].idOfPost);
    
  //  [GlobalVariables getInstance].idOfPost = @"36599";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoPratiquesTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoPratiquesTableViewCell"];
   
    
    self.tableView.scrollEnabled = false;
    arrayUsedInTable = [[NSMutableArray alloc] init];
    arrayWithImagesUsedInTable = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    self.changeImageView.backgroundColor = [UIColor colorWithRed:29/255.0f green:57/255.0f blue:84/255.0f alpha:0.7f];
    self.postScrollView.delegate = self;
    self.starsCollectionView.delegate = self;
    self.starsCollectionView.bounces = false;
    self.starsCollectionView.scrollEnabled = false;
    self.starsCollectionView.backgroundColor = [UIColor clearColor];
    self.starsCollectionView.hidden = true;
    self.postDetailsImageScroll.delegate = self;
    self.changeableBackgroundd.hidden = true;
    self.twittertw.hidden = true;
    self.facebookfb.hidden = true;
    self.tagsScrollView.delegate = self;
    self.tagsTitle.hidden = true;
    self.savedPostView.hidden = true;
    self.postNotSaved.hidden = true;
    self.SuggestedPostsTitleHeader.hidden = true;
    self.suggestedPostSeparator.hidden = true;
    self.suggestedPostImage.hidden = true;
    self.suggestedPostContent.hidden = true;
    self.suggestedPostTitle.hidden = true;
    self.logoIcon.hidden = true;
    self.rainbow.hidden = true;
    self.changeImageView.hidden = true;
    self.fontSizeImage.hidden = true;
    self.changeFontView.hidden = true;
    self.fontSizeImage.contentMode = UIViewContentModeScaleAspectFit;
    self.articleEnregistre.adjustsFontSizeToFitWidth = true;
    self.menuButton.hidden = true;
    self.backButton.hidden = true;
    self.okButton.hidden = true;
    
    
    
    //    loadingScreen = [[UIView alloc]initWithFrame:self.view.frame];
    //    loadingScreen.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:loadingScreen];
    //    [self.view bringSubviewToFront:loadingScreen];
    self.fontSizeImage.layer.cornerRadius = 2;
    self.fontSizeImage.clipsToBounds = true;
    [self.fontSizeImage.layer setBorderColor: [self colorWithHexString:@"D6D8E4"].CGColor];
    [self.fontSizeImage.layer setBorderWidth: 1.0];
    
    self.logoIcon.image = [UIImage imageNamed:@"Logo.png"];
    
    spinner = [[JTMaterialSpinner alloc] init];
    spinner.circleLayer.lineWidth = 4.0;
    spinner.frame = CGRectMake(self.view.center.x - 22, self.view.center.y - 10, 45, 45);
    spinner.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner beginRefreshing];
    
    self.logoIcon.image = [UIImage imageNamed:@"Logo.png"];
    self.logoIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.logoIcon.clipsToBounds = true;
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
    [self.postScrollView bringSubviewToFront:self.rainbow];
    [self.postScrollView bringSubviewToFront:self.logoIcon];
    
    //    loadingText = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 110, self.view.center.y - 100, 250, 50)];
    //    loadingText.textAlignment = UIStackViewAlignmentCenter;
    //    loadingText.font = [UIFont fontWithName:@"Montserrat-Regular" size:18];
    //    loadingText.textColor = [UIColor blackColor];
    //    loadingText.text = @"Chargement en cours.";
    //    [loadingScreen addSubview: loadingText];
    //    [loadingScreen bringSubviewToFront: loadingText];
    //    [self updateLoadingLabel];
    
     dispatch_async(dispatch_get_main_queue(), ^{
    initialpozitionOfOpenMenuButton = self.view.frame.size.height/12;
    initialpozitionOfBackButton = self.view.frame.size.height/5;
    changeFrameOnce = true;
    changeFrameOnce1 = true;
    
    CGRect frame = self.backButton.frame;
    frame.origin.y = initialpozitionOfBackButton;
    self.backButton.frame = frame;
    
    CGRect frame1 = self.menuButton.frame;
    frame1.origin.y = initialpozitionOfOpenMenuButton;
    self.menuButton.frame = frame1;
    
     });
    
    
    imagespinner = [[JTMaterialSpinner alloc] init];
    imagespinner.circleLayer.lineWidth = 4.0;
    imagespinner.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    imagespinner.frame = CGRectMake(self.view.center.x - 22, self.postDetailsImageScroll.center.y - 22, 45, 45);
    [self.postDetailsImageScroll addSubview: imagespinner];
    [self.postDetailsImageScroll bringSubviewToFront: imagespinner];
    
    
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
    
    
    
    
   // NSLog(@"%@",[[GlobalVariables getInstance].DictionaryWithAllPosts allKeys]);
    //  NSLog(@"%@",[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[GlobalVariables getInstance].idOfPost]);
    
    [GlobalVariables getInstance].DictionaryWithAllPosts = [[NSMutableDictionary alloc] initWithDictionary:[(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllPosts"]] mutableCopy]];
    //   NSLog(@"%@",[[GlobalVariables getInstance].DictionaryWithAllPosts allKeys]);
    
   // NSLog(@"%@ CONTINUTUL POSTULUi",[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[GlobalVariables getInstance].idOfPost]);
    
    if([[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[GlobalVariables getInstance].idOfPost] != nil || [self isInternet] == YES){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if([[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[GlobalVariables getInstance].idOfPost] == nil && [self isInternet] == YES){
                
                
                
                
                [self makingRequestForPostDetails:[NSString stringWithFormat:postDetailLink,[GlobalVariables getInstance].idOfPost]];
                
          //      NSLog(@"Cu request");
                withrequest = true;
                
                
            }
            else {
                withrequest = false;
         //       NSLog(@"FARA REQUEST");
                
                postInfo = [[NSMutableDictionary alloc]initWithDictionary:[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:[GlobalVariables getInstance].idOfPost] mutableCopy]];
                
                
                if([self isInternet] == YES && ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CanAddObjectToCarousel"] isEqualToString:@"YES"])){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        
                        [self makingRequestForPostDetails:[NSString stringWithFormat:postDetailLink,[GlobalVariables getInstance].idOfPost]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if([self isInternet] == YES){
                                [[GlobalVariables getInstance].DictionaryWithAllPosts removeObjectForKey:[GlobalVariables getInstance].idOfPost];
                                [[GlobalVariables getInstance].DictionaryWithAllPosts setObject:postInfo forKey:[GlobalVariables getInstance].idOfPost];
                                
                                
                                [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:[GlobalVariables getInstance].DictionaryWithAllPosts] withName:@"DictionaryWithAllPosts"];
                            }
                            
                            
                            
                            
                        });
                    });
                }
            }
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoIcon.hidden = false;
                self.rainbow.hidden = false;
                self.starsCollectionView.hidden = false;
                self.twittertw.hidden = false;
                self.facebookfb.hidden = false;
                numberOfStars = [[[postInfo valueForKey:@"ratings"] valueForKey:@"average"] intValue];
                self.tagsTitle.hidden = false;
                self.savedPostView.hidden = false;
                self.SuggestedPostsTitleHeader.hidden = false;
                self.changeImageView.hidden = false;
                self.fontSizeImage.hidden = false;
                self.menuButton.hidden = false;
                self.backButton.hidden = false;
                
                [self.starsCollectionView reloadData];
                
                
                scrollImageUrls = [[NSMutableArray alloc]init];
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"CanAddObjectToCarousel"] isEqualToString:@"YES"])
                    [[GlobalVariables getInstance].CarouselOfPostIds addObject:[GlobalVariables getInstance].idOfPost];
                
                
                
             //   NSLog(@"IDOFPOST : %@,  CAROUSELIDS: %@",[GlobalVariables getInstance].idOfPost, [GlobalVariables getInstance].CarouselOfPostIds);
                
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ViewPostOnHomeTapBar"];
                
                
                
                if(![[NSString stringWithFormat:@"%@",[postInfo valueForKey:@"post_thumbnail_url"]] isEqualToString:@"0"])
                    
                    [scrollImageUrls addObject:[NSString stringWithFormat:@"%@",[postInfo valueForKey:@"post_thumbnail_url"]]];
                
                
                
                CGFloat originOfImage = 0;
                
                
                for(int i = 0 ; i < scrollImageUrls.count; i++){
                    
                    UIView *image = [self generateImageForScroll:i];
                    
                    image.frame = CGRectMake(originOfImage, 0, image.frame.size.width, image.frame.size.height);
                    image.backgroundColor = [UIColor clearColor];
                    image.layer.cornerRadius = image.frame.size.height/5;
                    
                    [self.postDetailsImageScroll addSubview:image];
                    [self.postDetailsImageScroll bringSubviewToFront:image];
                    
                    self.postDetailsImageScroll.contentSize = CGSizeMake(originOfImage + image.frame.size.width, self.postDetailsImageScroll.frame.size.height);
                    
                    
                    originOfImage = originOfImage + image.frame.size.width;
                }
                
                self.postDetailsImageScroll.pagingEnabled = true;
                self.postDetailsImageScroll.bounces = false;
                self.postDetailsImageScroll.showsHorizontalScrollIndicator = false;
                
                if(scrollImageUrls.count == 0){
                    self.postDetailsImageScroll.scrollEnabled = false;
                    
                    UIView *image = [self generateImageForScroll:0];
                    
                    image.frame = CGRectMake(originOfImage, 0, image.frame.size.width, image.frame.size.height);
                    image.backgroundColor = [UIColor clearColor];
                    image.layer.cornerRadius = image.frame.size.height/5;
                    
                    [self.postDetailsImageScroll addSubview:image];
                    [self.postDetailsImageScroll bringSubviewToFront:image];
                    
                    self.postDetailsImageScroll.contentSize = CGSizeMake(originOfImage + image.frame.size.width, self.postDetailsImageScroll.frame.size.height);
                    
                    
                    originOfImage = originOfImage + image.frame.size.width;
                    
                    
                    
                }
                
                
                
                if([self isInternet] == YES){
                    [[GlobalVariables getInstance].DictionaryWithAllPosts removeObjectForKey:[GlobalVariables getInstance].idOfPost];
                    [[GlobalVariables getInstance].DictionaryWithAllPosts setObject:postInfo forKey:[GlobalVariables getInstance].idOfPost];
                    [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:[GlobalVariables getInstance].DictionaryWithAllPosts] withName:@"DictionaryWithAllPosts"];
                }
                
                
                
                
                
                self.postsBigTitle.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[postInfo valueForKey:@"post_title"]]];
                self.postsBigTitle.numberOfLines = 0;
                self.postsBigTitle.frame = CGRectMake(self.view.frame.size.width * 0.012, self.postsBigTitle.frame.origin.y, self.view.frame.size.width * 0.97, self.postsBigTitle.frame.size.height);
                [self.postsBigTitle sizeToFit];
                
                if([[postInfo valueForKey:@"post_thumbnail_caption"] length] != 0)
                    self.thumbnailAuthor.text = [NSString stringWithFormat:@"%@",[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[postInfo valueForKey:@"post_thumbnail_caption"]]]];
                else
                    self.changeImageView.hidden = true;
                
                
                self.thumbnailAuthor.numberOfLines = 2;
                //self.thumbnailAuthor.adjustsFontSizeToFitWidth = true;
                
                if([[NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_id"]] isEqualToString:@"0"]){
                    self.passage.text = [NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
                }
                else{
                    self.passage.text = [NSString stringWithFormat:@"%@ > %@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_name"],[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
                }
                
                
                
                self.passage.frame = CGRectMake(self.view.frame.size.width * 0.012, self.postsBigTitle.frame.origin.y + self.postsBigTitle.frame.size.height + 2, self.passage.frame.size.width, self.passage.frame.size.height);
                self.passage.numberOfLines = 0;
                [self.passage sizeToFit];
                
                
                self.starsCollectionView.frame = CGRectMake(self.view.frame.size.width * 0.012, self.passage.frame.origin.y + self.passage.frame.size.height + 5, self.starsCollectionView.frame.size.width, self.starsCollectionView.frame.size.height);
                
                
                postContent = [[ UITextView alloc] initWithFrame:CGRectMake(self.passage.frame.origin.x, self.view.frame.size.height * 0.8 , self.titleOfThePost.frame.size.width, self.titleOfThePost.frame.size.height)];
                postContent.backgroundColor = [UIColor clearColor];
                
                
                [UIView transitionWithView:postContent
                                  duration:0.4f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    
                                    
                                    NSString *text;
                                   
                                        text = [[[NSString stringWithFormat:@"%@",[postInfo valueForKey:@"post_content"]] stringByReplacingOccurrencesOfString:@"GOOGLE MAP" withString:@""] stringByReplacingOccurrencesOfString:@"<img" withString:@"<p></p><img"];
                                    
                                    
                                    
                                    if([text containsString:[NSString stringWithFormat:@"https://www.youtu%@",[self scanString:text startTag:@"https://www.youtub" endTag:@""]]])
                                        
                                        text = [text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"https://www.youtu%@",[self scanString:text startTag:@"https://www.youtub" endTag:@""]] withString:[NSString stringWithFormat:@"<p><a href=\"https://www.youtu%@\">Youtube Link</a></p>",[self scanString:text startTag:@"https://www.youtub" endTag:@""]]];
                                    
                                    
                                    
                                    if([text containsString:@"<h2>"])
                                        text = [text stringByReplacingOccurrencesOfString:@"<h2>" withString:@"<br></br><h2>"];
                                    if([text containsString:@"<h3>"])
                                        text = [text stringByReplacingOccurrencesOfString:@"<h3>" withString:@"<br></br><h3>"];
                                    if([text containsString:@"<h4>"])
                                        text = [text stringByReplacingOccurrencesOfString:@"<h4>" withString:@"<br></br><h4>"];
                                    
                                    
                                    
                                    if([SimpleFilesCache cachedDataWithName:[NSString stringWithFormat:@"%@-a",[GlobalVariables getInstance].idOfPost]] == nil){
                                        
                                        
                                        attributedString = [[NSMutableAttributedString alloc]
                                                            initWithData: [text dataUsingEncoding:NSUnicodeStringEncoding]
                                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                            documentAttributes: nil
                                                            error: nil
                                                            ];
                                        
                                        
                                        [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject: attributedString]
                                                                      withName:[NSString stringWithFormat:@"%@-a",[GlobalVariables getInstance].idOfPost]];
                                        
                                    }
                                    else{
                                        
                                        attributedString = [NSKeyedUnarchiver unarchiveObjectWithData: [SimpleFilesCache cachedDataWithName:[NSString stringWithFormat:@"%@-a",[GlobalVariables getInstance].idOfPost]]];
                                        
                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                            
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                NSMutableAttributedString *newAtt= [[NSMutableAttributedString alloc]  initWithData: [text dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                                                                 documentAttributes: nil
                                                                                                                              error: nil
                                                                                    ];
                                                ;
                                                
                                                
                                                [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject: newAtt]
                                                                              withName:[NSString stringWithFormat:@"%@-a",[GlobalVariables getInstance].idOfPost]];
                                                
                                                
                                                
                                                
                                            });
                                        });
                                    }
                                    
                                    
                 
                                               //else
                                               //    NSLog(@" KEY : %@", key);
     
                                    [attributedString enumerateAttribute:NSAttachmentAttributeName
                                                                 inRange:NSMakeRange(0, [attributedString length])
                                                                 options:0
                                                              usingBlock:^(id value, NSRange range, BOOL *stop)
                                     {
                                         if ([value isKindOfClass:[NSTextAttachment class]])
                                         {
                                             NSTextAttachment *attachment = (NSTextAttachment *)value;
                                             UIImage *image = nil;
                                             if ([attachment image])
                                                 image = [attachment image];
                                             else
                                                 image = [attachment imageForBounds:[attachment bounds]
                                                                      textContainer:nil
                                                                     characterIndex:range.location];
                                             
                                             CGSize size = image.size;
                                             if(size.width > postContent.frame.size.width){
                                                 
                                                 // calculate proportional height to width
                                                 float ratio = image.size.width /( postContent.frame.size.width + 25);
                                                 float height = image.size.height / ratio;
                                                 
                                                 size = CGSizeMake(postContent.frame.size.width , height);
                                                 
                                                 attachment.bounds = CGRectMake(0, 8, size.width, size.height);
                                                 
                                                 attachment.image = image;
                    
                                             }

                                         }
                                         
                                         
                                     }];
                                    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"]);
                                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"]){
                                        [GlobalVariables getInstance].fontsize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"] floatValue];
                                    }
                                    else{
                                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                                            [GlobalVariables getInstance].fontsize = 14;
                                        else
                                        [GlobalVariables getInstance].fontsize = 18;
                                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[GlobalVariables getInstance].fontsize] forKey:@"fontSize"];
                                    }
                                    
                                    
                                    
                                    NSMutableAttributedString *res = [attributedString mutableCopy];
                                    
                                    [res beginEditing];
                                    __block BOOL found = NO;
                                    [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                        if (value) {
                                            UIFont *oldFont = (UIFont *)value;
                                            UIFont *newFont;
                                            if((int)[GlobalVariables getInstance].fontsize == 0){
                                                
                                                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                                                   
                                                    
                                                    if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-BoldMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-Bold" size:17];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-Italic" size:14];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPSMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-Light" size:14];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-SemiBold" size:15];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@".SFUIText"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-SemiBold" size:15];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"CourierNewPSMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-ExtraLight" size:14];
                                                    else
                                                        newFont = [UIFont fontWithName:@"Montserrat-Regular" size:14];
                                                    
                                                    
                                                    self.fontSizeNumber.text = @"14";
                                                    
                                                }
                                                else {
                                                //oldFont.pointSize
                                                    
                                                    if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-BoldMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-Bold" size:21];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-Italic" size:18];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPSMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-Light" size:18];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-SemiBold" size:19];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@".SFUIText"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-SemiBold" size:19];
                                                    else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"CourierNewPSMT"])
                                                        newFont = [UIFont fontWithName:@"Montserrat-ExtraLight" size:18];
                                                    else
                                                        newFont = [UIFont fontWithName:@"Montserrat-Regular" size:18];
                                                    
                                                    
                                                    self.fontSizeNumber.text = @"18";
                                                
                                                }
                                                
                                            }
                                            else{
                                                
                                                if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-BoldMT"])
                                                    newFont = [UIFont fontWithName:@"Montserrat-Bold" size:[GlobalVariables getInstance].fontsize + 3];
                                                else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                                                    newFont = [UIFont fontWithName:@"Montserrat-Italic" size:[GlobalVariables getInstance].fontsize];
                                                else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPSMT"])
                                                    newFont = [UIFont fontWithName:@"Montserrat-Light" size:[GlobalVariables getInstance].fontsize];
                                                else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                                                    newFont = [UIFont fontWithName:@"Montserrat-SemiBold" size:[GlobalVariables getInstance].fontsize+1];
                                                else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@".SFUIText"])
                                                    newFont = [UIFont fontWithName:@"Montserrat-SemiBold" size:[GlobalVariables getInstance].fontsize+1];
                                                else if([[NSString stringWithFormat:@"%@",oldFont.fontName] isEqualToString:@"CourierNewPSMT"])
                                                    newFont = [UIFont fontWithName:@"Montserrat-ExtraLight" size:[GlobalVariables getInstance].fontsize];
                                                else
                                                    newFont = [UIFont fontWithName:@"Montserrat-Regular" size:[GlobalVariables getInstance].fontsize];
                                                
                                                self.fontSizeNumber.text = [NSString stringWithFormat:@"%d",(int)[GlobalVariables getInstance].fontsize];
                                                
                                            }
                                            
                                            [res removeAttribute:NSFontAttributeName range:range];
                                            [res addAttribute:NSFontAttributeName value:newFont range:range];
                                            found = YES;
                                            
                                            
                                            
                                            
                                        }
                                    }];
                                    if (!found) {
                                        // No font was found - do something else?
                                    }
                                    [res endEditing];
                                    
                                    
                                    
                                    //                                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                    //                                    paragraphStyle.headIndent = 10.0;
                                    //                                    paragraphStyle.firstLineHeadIndent = 0;
                                    //                                    paragraphStyle.tailIndent = -10.0;
                                    //                                    NSDictionary *attrsDictionary = @{NSParagraphStyleAttributeName: paragraphStyle};
                                    //                                    [res removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, [attributedString length])];
                                    //                                    [res addAttributes:attrsDictionary range:NSMakeRange(0, [attributedString length])];
                                    
                                    
                                    
                                    
                                    postContent.frame = CGRectMake(self.view.frame.size.width * 0.001, self.starsCollectionView.frame.size.height + self.starsCollectionView.frame.origin.y , self.view.frame.size.width * 0.985, self.titleOfThePost.frame.size.height);
                                    postContent.attributedText = res;
                                    [self.postScrollView addSubview:postContent];
                                    [self.postScrollView bringSubviewToFront:postContent];
                                    [postContent sizeToFit];
                                    
                                    
                                    
                                    // postContent.font = self.titleOfThePost.font;
                                    postContent.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
                                    postContent.textColor = [self colorWithHexString:@"343434"];
                                    postContent.scrollEnabled = false;
                                    postContent.editable = false;
                                    
                                    
                                    
                                    [self.postScrollView bringSubviewToFront:self.menuButton];
                                    [self.postScrollView bringSubviewToFront:self.changeFontView];
                                    
                                    
                                    NSString *metros = [[NSString alloc] init];
                                    NSString *typeOfResto = @"Types de resto :";
                                    NSString *schedule = @"Ouvert :";
                                    NSString *price = [[NSString alloc] init];
                                    
                                    if ([NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"practical_infos"] valueForKey:@"district"]].length >6) {
                                        [arrayUsedInTable addObject:[[postInfo valueForKey:@"practical_infos"] valueForKey:@"district"]];
                                        [arrayWithImagesUsedInTable addObject:@"quartier"];
                                    }
                                    
                                    if ([NSString stringWithFormat:@"%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"title"] valueForKey:@"text"]].length >4) {
                                        [arrayUsedInTable addObject:[NSString stringWithFormat:@"%@XYZ%@",[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"title"] valueForKey:@"text"],[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"title"] valueForKey:@"link"]]];
                                        [arrayWithImagesUsedInTable addObject:@"0"];
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
                                  
                                    if([[[postInfo valueForKey:@"practical_infos"] valueForKey:@"schedule"] isKindOfClass:[NSDictionary class]])
                                        for(NSString *key in [[[postInfo valueForKey:@"practical_infos"] valueForKey:@"schedule"] allKeys])
                                            if([[[[[postInfo valueForKey:@"practical_infos"] valueForKey:@"schedule"] valueForKey:key]  valueForKey:@"status"] isEqualToString:@"opened"]) {
                                                if([key isEqualToString:@"monday"])
                                                    schedule = [schedule stringByAppendingString: @" lundi"];
                                                else if([key isEqualToString:@"tuesday"])
                                                     schedule = [schedule stringByAppendingString: @", mardi"];
                                                else if([key isEqualToString:@"wednesday"])
                                                     schedule = [schedule stringByAppendingString: @", mercredi"];
                                                else if([key isEqualToString:@"thursday"])
                                                     schedule = [schedule stringByAppendingString: @", jeudi"];
                                                else if([key isEqualToString:@"friday"])
                                                    schedule = [schedule stringByAppendingString: @", vendredi"];
                                                else if([key isEqualToString:@"saturday"])
                                                     schedule = [schedule stringByAppendingString: @", samedi"];
                                                else if([key isEqualToString:@"sunday"])
                                                     schedule = [schedule stringByAppendingString: @", dimanche"];
                                            }
                                    if(schedule.length>8) {
                                        [arrayUsedInTable addObject:schedule];
                                        [arrayWithImagesUsedInTable addObject:@"horaires"];
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
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                   
                                    
                                    [self.tableView reloadData];
                                    if(arrayUsedInTable.count > 0) {
                                        CGRect newFrame = self.tableView.frame;
                                        newFrame.origin.y = postContent.frame.size.height + postContent.frame.origin.y;
                                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                                             newFrame.size.height = (arrayUsedInTable.count+1) * self.view.frame.size.width/15;
                                        else
                                        newFrame.size.height = (arrayUsedInTable.count+1) * self.view.frame.size.width/7;
                                       // newFrame.size.height = self.tableView.contentSize.height;
                                        self.tableView.frame = newFrame;
                                    }
                                    else {
                                        CGRect newFrame = self.tableView.frame;
                                        newFrame.size.height = 0;
                                        newFrame.origin.y = postContent.frame.size.height + postContent.frame.origin.y;
                                        self.tableView.frame = newFrame;
                                    }
                                    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                                    
                                    
                                } completion:nil];
                
 
                if(withrequest == true && ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CanAddObjectToCarousel"] isEqualToString:@"YES"])){
                    
                    
                    if([[GlobalVariables getInstance].currentViewController isEqualToString:@"PostViewController"]){
                        [self showMessage:@"Article mis à jour !"];
                        [self.view addSubview:demo];
                        demo.center = self.view.center;
                        [self.view bringSubviewToFront:demo];
                    }
                    
                }
                
                
               self.tableView.backgroundColor = [UIColor clearColor];
                
                self.fontSizeImage.contentMode = UIViewContentModeScaleAspectFit;
                
                UIButton *changeFontSize = [[UIButton alloc]initWithFrame:self.fontSizeImage.frame];
                [changeFontSize addTarget:self action:@selector(ChangeFontSize) forControlEvents:UIControlEventTouchUpInside];
                [self.postScrollView addSubview:changeFontSize];
                [self.postScrollView bringSubviewToFront:changeFontSize];
                
                
                [GlobalVariables getInstance].fontsize = [self.fontSizeNumber.text floatValue];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[GlobalVariables getInstance].fontsize] forKey:@"fontSize"];
                
                self.fontSizeNumber.adjustsFontSizeToFitWidth = true;
                
                
                NSURL *url = [NSURL URLWithString:@"mapbox://styles/mapbox/streets-v9"];
                self.postMapView = [[MGLMapView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height , self.view.frame.size.width, self.view.frame.size.height/2.5) styleURL:url];
                
                self.postMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                [self.postScrollView addSubview: self.postMapView];
                [self.postScrollView bringSubviewToFront: self.postMapView];
                self.postMapView.delegate = self;
                
                
                
                if([self isInternet] == NO){
                    
                    self.postMapView.maximumZoomLevel = 17;
                    
                }
                
                self.postMapView.logoView.alpha = 0.f;
                self.postMapView.attributionButton.alpha = 0.f;
                self.postMapView.compassView.hidden = false;
                self.postMapView.compassView.alpha = 0.f;
                self.postMapView.rotateEnabled = false;
                
                
                self.postMapView.tintColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];
                
                
                if([[postInfo valueForKey:@"location"] count] == 0){
                    [self.postMapView removeFromSuperview];
                    self.postMapView.frame =CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, 0 , 0);
                    
                }
                else{
                    point = [[MGLPointAnnotation alloc] init];
                    point.coordinate = CLLocationCoordinate2DMake([[[postInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue], [[[postInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue]);
                    point.title = [postInfo valueForKey:@"post_title"];
                    
                    if([[NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_id"]] isEqualToString:@"0"]){
                        point.subtitle = [NSString stringWithFormat:@"%@",[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
                    }
                    else{
                        point.subtitle = [NSString stringWithFormat:@"%@ > %@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_name"],[[postInfo valueForKey:@"category"]valueForKey:@"name"]];
                    }
                   // point.subtitle = [NSString stringWithFormat:@"%@ -> %@",[[postInfo valueForKey:@"category"]valueForKey:@"category_parent_name"], [[postInfo valueForKey:@"category"] valueForKey:@"name"]];
                    [self.postMapView addAnnotation:point];
                    
                    if([self isInternet] == NO){
                        dispatch_time_t popTimee = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                        dispatch_after(popTimee, dispatch_get_main_queue(), ^(void){
                            [self.postMapView setCenterCoordinate:point.coordinate zoomLevel:16 direction:0 animated:YES];
                            [spinner endRefreshing];
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
                    
                    
                    UIButton *openMapPage = [[UIButton alloc]initWithFrame:self.postMapView.frame];
                    [self.postScrollView addSubview:openMapPage];
                    [self.postScrollView bringSubviewToFront:openMapPage];
                    [openMapPage addTarget:self action:@selector(openMapPage) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                
                self.tagsScrollView.frame = CGRectMake(self.view.frame.size.width * 0.01, self.postMapView.frame.size.height + self.postMapView.frame.origin.y + 15, self.view.frame.size.width * 0.97, 55);
                
                CGFloat originOfTag = self.tagsTitle.frame.size.width+5;
                
                allTagsSlugs = [[NSMutableArray alloc] init];
                allTagsName = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < [[postInfo valueForKey:@"tags"] count]; i++){
                    
                    UIView *label = [self Content:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[[postInfo valueForKey:@"tags"][i]  valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"&OUML;" withString:@"Ö"]]] withTag:i];
                    
                    label.frame = CGRectMake(originOfTag, 0, label.frame.size.width, label.frame.size.height);
                    label.backgroundColor = [self colorWithHexString:@"e3e4ea"];
                    label.layer.cornerRadius = label.frame.size.height/5;
                    
                    [allTagsSlugs addObject:[[postInfo valueForKey:@"tags"][i]  valueForKey:@"slug"]];
                    [allTagsName addObject:[[postInfo valueForKey:@"tags"][i]  valueForKey:@"name"]];
                    
                    [self.tagsScrollView addSubview:label];
                    [self.tagsScrollView bringSubviewToFront:label];
                    
                    self.tagsScrollView.contentSize = CGSizeMake(originOfTag + label.frame.size.width, self.tagsScrollView.frame.size.height);
                    
                    
                    originOfTag = originOfTag + label.frame.size.width + 10;
                }
                if ( [[postInfo valueForKey:@"tags"] count] == 0){
                    self.tagsScrollView.frame = CGRectMake(self.tagsScrollView.frame.origin.x, self.tagsScrollView.frame.origin.y, self.tagsScrollView.frame.size.width, 0);
                }
                
                
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                self.savedPostView.frame = CGRectMake(self.view.frame.size.width * 0.012, self.tagsScrollView.frame.size.height + self.tagsScrollView.frame.origin.y , self.view.frame.size.width * 0.97, self.savedPostView.frame.size.height);
                else
                    self.savedPostView.frame = CGRectMake(self.view.frame.size.width * 0.012, self.tagsScrollView.frame.size.height + self.tagsScrollView.frame.origin.y + 20 , self.view.frame.size.width * 0.97, self.savedPostView.frame.size.height);
                    
                
                
                CGFloat heightOfView = 0;
                
                for(int i = 0; i < [[postInfo valueForKey:@"comments"] count]; i++){
                    
                    UIView *view = [self CommentView:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[postInfo valueForKey:@"comments"] valueForKey:@"author"][i]]] Content:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[postInfo valueForKey:@"comments"] valueForKey:@"content"][i]]] Date:[[postInfo valueForKey:@"comments"] valueForKey:@"date"][i]];
                    
                    view.frame = CGRectMake(view.frame.origin.x, self.savedPostView.frame.size.height + self.savedPostView.frame.origin.y + 20 + heightOfView , view.frame.size.width, view.frame.size.height);
                    
                    
                    heightOfView = heightOfView + view.frame.size.height;
                    
                    [self.postScrollView addSubview:view];
                    [self.postScrollView bringSubviewToFront:view];
                    
                    
                }
                
                
                self.SuggestedPostsTitleHeader.frame = CGRectMake(self.view.frame.size.width * 0.013, self.savedPostView.frame.size.height + self.savedPostView.frame.origin.y + 15 + heightOfView, self.view.frame.size.width * 0.97, self.SuggestedPostsTitleHeader.frame.size.height);
                
                
                
                CGFloat heightOfSuggestView = 0;
                
                
                for ( int i = 0 ; i < [[postInfo valueForKey:@"suggested_posts"] count]; i++){
                    
                    NSString* webName = [[[postInfo valueForKey:@"suggested_posts"] valueForKey:@"thumbnail_url"][i] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL* url = [NSURL URLWithString:webStringURL];
                    
                    UIView *view = [self CreateSuggestedPostView:url Title:[[postInfo valueForKey:@"suggested_posts"] valueForKey:@"title"][i] Content:[[postInfo valueForKey:@"suggested_posts"] valueForKey:@"excerpt"][i] CachingKey:[NSString stringWithFormat:@"%@Thumbnail",[[postInfo valueForKey:@"suggested_posts"] valueForKey:@"id"][i]] Tag:i] ;
                    
                    view.frame = CGRectMake(self.view.frame.size.width * 0.01, self.SuggestedPostsTitleHeader.frame.size.height + self.SuggestedPostsTitleHeader.frame.origin.y + 20 + heightOfSuggestView , self.view.frame.size.width * 0.97, view.frame.size.height);
                    
                    heightOfSuggestView = heightOfSuggestView + view.frame.size.height;
                    
                    [self.postScrollView addSubview:view];
                    [self.postScrollView bringSubviewToFront:view];
                    
                    
                    
                    
                }
                if(heightOfSuggestView == 0){
                    self.SuggestedPostsTitleHeader.frame = CGRectMake(self.SuggestedPostsTitleHeader.frame.origin.x, self.savedPostView.frame.size.height + self.savedPostView.frame.origin.y + heightOfView, self.SuggestedPostsTitleHeader.frame.size.width, 0);
                    self.SuggestedPostsTitleHeader.hidden = true;
                }
                
                
                
                self.postScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.SuggestedPostsTitleHeader.frame.size.height + self.SuggestedPostsTitleHeader.frame.origin.y + self.logoIcon.frame.size.height/2 + heightOfSuggestView);
                
                [spinner endRefreshing];
                
                
                
                
                [loadingScreen removeFromSuperview];
                
            });
        });
        
        
        
    }
    else{
        
        self.changeableBackgroundd.hidden = false;
        self.logoIcon.hidden = false;
        self.rainbow.hidden = false;
        
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 10.0f;
        animation.repeatCount = INFINITY;
        [self.rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
        
        
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger hour = [components hour];
        
        if(hour >=20){
            self.changeableBackgroundd.image =[UIImage imageNamed:@"BackgroundNight.png"];
            if (self.changeableBackgroundd.image == nil){
                self.changeableBackgroundd.image = [UIImage imageNamed:@"BackgroundDay.png"];
            }
        }
        else {
            self.changeableBackgroundd.image = [UIImage imageNamed:@"BackgroundDay.png"];
            if (self.changeableBackgroundd.image == nil){
                self.changeableBackgroundd.image = [UIImage imageNamed:@"BackgroundNight.png"];
            }
        }
        
        
        
        
        [spinner endRefreshing];
        self.postNotSaved.hidden = false;
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
}
-(void)ChangeFontSize{
    
    self.changeFontView.hidden = false;
    self.fontSizeImage.hidden = true;
    
    [self.postScrollView bringSubviewToFront:self.okButton];
    self.okButton.hidden = false;
    
    self.okButton.layer.cornerRadius = 2;
    self.okButton.clipsToBounds = true;
    [self.okButton.layer setBorderColor: [[self colorWithHexString:@"D6D8E4"] CGColor]];
    [self.okButton.layer setBorderWidth: 1.0];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.changeFontView && self.changeFontView.hidden == false){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
        
    }
    
    
}


- (void) updateLoadingLabel;
{
    if(loadingText) {
        if([loadingText.text isEqualToString:@"Chargement en cours..."]) {
            loadingText.text = @"Chargement en cours.";
        } else {
            loadingText.text = [NSString stringWithFormat:@"%@.",loadingText.text];
        }
        [self performSelector:@selector(updateLoadingLabel) withObject:nil afterDelay:0.55]; //each second
    }
    
}


-(void) openMapPage{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ZoomMapPage"]];
    
}
- (void) mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    
    mapView.showsUserLocation = YES;
    
    [self.postMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[postInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue] + 0.0002, [[[postInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue] - 0.00001) zoomLevel:16 direction:0 animated:YES];
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.postScrollView){
        
        
        if(canAppear != YES && self.postScrollView.contentOffset.y > self.postScrollView.contentSize.height * 0.38){
            
            
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
        else if(backToTop && self.postScrollView.contentOffset.y < self.postScrollView.contentSize.height * 0.38){
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
        
        
        if (scrollView.contentOffset.y < 0) {
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
        
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height == 812.0f) {
            
            
                if(changeFrameOnce1 == true && scrollView.contentOffset.y >= initialpozitionOfOpenMenuButton -37) {
                    
                    self.menuButton.frame = CGRectMake(self.backButton.frame.origin.x, 37, self.menuButton.frame.size.width, self.menuButton.frame.size.height);
                    
                    [self.view addSubview:self.menuButton];
                    [self.view bringSubviewToFront:self.menuButton];
                    
                    
                    changeFrameOnce1 = false;
                }
                else if(changeFrameOnce1 == false && scrollView.contentOffset.y < initialpozitionOfOpenMenuButton - 37) {
                    
                    self.menuButton.frame = CGRectMake(self.menuButton.frame.origin.x, initialpozitionOfOpenMenuButton, self.menuButton.frame.size.width, self.menuButton.frame.size.height);
                    
                    [self.postScrollView addSubview:self.menuButton];
                    [self.postScrollView bringSubviewToFront:self.menuButton];
                    
                    changeFrameOnce1 = true;
                }
                
                
                
                if(changeFrameOnce == true && scrollView.contentOffset.y  + self.menuButton.frame.size.height >= initialpozitionOfBackButton - self.backButton.frame.size.height ) {
                    
                    self.backButton.frame = CGRectMake(self.backButton.frame.origin.x, self.menuButton.frame.origin.y + self.menuButton.frame.size.height + 5, self.backButton.frame.size.width, self.backButton.frame.size.height);
                    
                    [self.view addSubview:self.backButton];
                    [self.view bringSubviewToFront:self.backButton];
                    
                    changeFrameOnce = false;
                    
                }
                else if(changeFrameOnce == false && scrollView.contentOffset.y < self.backButton.frame.origin.y - self.backButton.frame.size.height + 25) {
                    
                    self.backButton.frame = CGRectMake(self.backButton.frame.origin.x, initialpozitionOfBackButton, self.backButton.frame.size.width, self.backButton.frame.size.height);
                    
                    [self.postScrollView addSubview:self.backButton];
                    [self.postScrollView bringSubviewToFront:self.backButton];
                    
                    changeFrameOnce = true;
                    
                }
            }
            else{
                if(changeFrameOnce1 == true && scrollView.contentOffset.y >= initialpozitionOfOpenMenuButton ) {
                    
                    self.menuButton.frame = CGRectMake(self.backButton.frame.origin.x, 0, self.menuButton.frame.size.width, self.menuButton.frame.size.height);
                    
                    [self.view addSubview:self.menuButton];
                    [self.view bringSubviewToFront:self.menuButton];
                    
                    
                    changeFrameOnce1 = false;
                }
                else if(changeFrameOnce1 == false && scrollView.contentOffset.y < initialpozitionOfOpenMenuButton) {
                    
                    self.menuButton.frame = CGRectMake(self.menuButton.frame.origin.x, initialpozitionOfOpenMenuButton, self.menuButton.frame.size.width, self.menuButton.frame.size.height);
                    
                    [self.postScrollView addSubview:self.menuButton];
                    [self.postScrollView bringSubviewToFront:self.menuButton];
                    
                    changeFrameOnce1 = true;
                }
                
                
                
                if(changeFrameOnce == true && scrollView.contentOffset.y >= initialpozitionOfBackButton - self.backButton.frame.size.height - 6) {
                    
                    self.backButton.frame = CGRectMake(self.backButton.frame.origin.x, self.menuButton.frame.size.height + 3, self.backButton.frame.size.width, self.backButton.frame.size.height);
                    
                    [self.view addSubview:self.backButton];
                    [self.view bringSubviewToFront:self.backButton];
                    
                    changeFrameOnce = false;
                    
                }
                else if(changeFrameOnce == false && scrollView.contentOffset.y < initialpozitionOfBackButton - self.backButton.frame.size.height - 6) {
                    
                    self.backButton.frame = CGRectMake(self.backButton.frame.origin.x, initialpozitionOfBackButton, self.backButton.frame.size.width, self.backButton.frame.size.height);
                    
                    [self.postScrollView addSubview:self.backButton];
                    [self.postScrollView bringSubviewToFront:self.backButton];
                    
                    changeFrameOnce = true;
                    
                }
            }
            
        }
        
        

    
    
    
}
-(void)backToTop{
    
    [self.postScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"AM PRIMIT MEMORIE");
    // Dispose of any resources that can be recreated.
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

- (void)dealloc {
    // Remove offline pack observers.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIImage *) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Always try to show a callout when an annotation is tapped.
    return YES;
}
- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    if(![[NSString stringWithFormat:@"%@",[postInfo valueForKey:@"post_thumbnail_url"]] isEqualToString:@"0"]){
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75.f, 70.f)];
        
        NSString* webName = [[NSString stringWithFormat:@"%@", scrollImageUrls[0]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
        [imageview loadImageFromURL:url placeholderImage:nil cachingKey:[NSString stringWithFormat:@"%@Thumbnail",[GlobalVariables getInstance].idOfPost]];
        
        if(!imageview.image){
            return nil;
            
        }
        
        return imageview;
        
        
    }
    
    return nil;
    
    
}
//- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
//
//    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:[NSString stringWithFormat:@"%@",annotation.title]];
//
//    if (!annotationImage) {
//
//        UIImage *image = [UIImage imageNamed:@"blueMarker.png"];
//
//        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 32, 32)];
//
//        annotationImage = [MGLAnnotationImage annotationImageWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/2, image.size.height/2)] reuseIdentifier:[NSString stringWithFormat:@"%@",annotation.title]];
//    }
//
//    return annotationImage;
//}
-(void)makingRequestForPostDetails:(NSString *)url
{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    if([self isInternet] == YES)
        postInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"starCell";
    
    UICollectionViewCell *celll = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *star = [[UIImageView alloc]initWithFrame:celll.contentView.bounds];
    if(numberOfStars > 0){
        star.image = [UIImage imageNamed:@"starColour.png"];
        
        
    }
    else{
        star.image = [UIImage imageNamed:@"starIncolor.png"];
    }
    
    [celll.contentView addSubview:star];
    [celll.contentView bringSubviewToFront:star];
    
    
    star.contentMode = UIViewContentModeScaleAspectFit;
    celll.clipsToBounds = true;
    celll.backgroundColor = [UIColor clearColor];
    numberOfStars = numberOfStars - 1;
    return celll;
}

- (IBAction)openSideBar:(id)sender {
    
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
- (NSString *)scanString:(NSString *)string
                startTag:(NSString *)startTag
                  endTag:(NSString *)endTag
{
    
    NSString* scanString = @"";
    
    if (string.length > 0) {
        
        NSScanner* scanner = [[NSScanner alloc] initWithString:string];
        
        @try {
            [scanner scanUpToString:startTag intoString:nil];
            scanner.scanLocation += [startTag length];
            [scanner scanUpToString:endTag intoString:&scanString];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            return scanString;
        }
        
    }
    
    return scanString;
    
}

- (UIView *) generateImageForScroll:(NSInteger)contor {
    
    UIImageView *imageCatt;
    UIView *back_view;
    
    back_view = [[UIView alloc] initWithFrame: self.postDetailsImageScroll.frame];
    imageCatt = [[UIImageView alloc] initWithFrame: self.changeableBackgroundd.frame];
    
    if(scrollImageUrls.count > 0 ){
        [imagespinner beginRefreshing];
        
        
        
        NSString* webName = [[NSString stringWithFormat:@"%@", scrollImageUrls[contor]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
        [imageCatt loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] cachingKey:[NSString stringWithFormat:@"%@Thumbnailllll",[GlobalVariables getInstance].idOfPost]];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [imagespinner endRefreshing];
            
            
        });
        
        
    }
    else
        imageCatt.image  = [UIImage imageNamed:@"PlaceHolderImage.png"];
    
    
    imageCatt.contentMode = UIViewContentModeScaleAspectFill;
    imageCatt.clipsToBounds = true;
    
    UIButton *button = [[UIButton alloc] initWithFrame:back_view.frame];
    button.tag = contor;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self
               action:@selector(ClickAnImage:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.postScrollView addSubview:button];
    [self.postScrollView bringSubviewToFront: button];
    
    [self.postScrollView bringSubviewToFront:self.backButton];
    [self.postScrollView bringSubviewToFront:self.openSideBar];
    
    back_view.backgroundColor = [UIColor clearColor];
    [back_view addSubview: imageCatt];
    [back_view bringSubviewToFront: imageCatt];
    
    return back_view;
}

-(UIView *)CommentView:(NSString *)Author Content:(NSString *)content Date:(NSString *)Date{
    
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(self.titleOfThePost.frame.origin.x + 5, 0, self.titleOfThePost.frame.size.width, 0)];
    
    UILabel *commentAuthor = [[UILabel alloc]initWithFrame:CGRectMake(self.titleOfThePost.frame.origin.x + 5, 0, self.titleOfThePost.frame.size.width, 20)];
    commentAuthor.numberOfLines = 0;
    commentAuthor.textColor = [self colorWithHexString:@"304864"];
    
    
    UIFont *arialFont = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - ",Author] attributes: arialDict];
    
    UIFont *VerdanaFont = [UIFont fontWithName:@"Montserrat-Light" size:14.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",Date] attributes:verdanaDict];
    
    [vAttrString addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"304864"] range:(NSMakeRange(aAttrString.length, 0))];
    [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f] range:(NSMakeRange(0, vAttrString.length))];
    
    [aAttrString appendAttributedString:vAttrString];
    
    
    commentAuthor.attributedText = aAttrString;
    [commentAuthor sizeToFit];
    
    UILabel *commentContent = [[UILabel alloc] initWithFrame:CGRectMake(self.titleOfThePost.frame.origin.x + 5, commentAuthor.frame.size.height + 2, self.titleOfThePost.frame.size.width - self.titleOfThePost.frame.origin.x/2 , 30)];
    commentContent.text = content;
       if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
           commentContent.font = [UIFont fontWithName:@"Montserrat-Light" size:13.0 ];
    
           else
               commentContent.font = [UIFont fontWithName:@"Montserrat-Light" size:17.0 ];
    
    commentContent.textColor = [self colorWithHexString:@"6d7986"];
    commentContent.numberOfLines = 0;
    [commentContent sizeToFit];
    
    [commentView addSubview:commentAuthor];
    [commentView addSubview:commentContent];
    [commentView bringSubviewToFront:commentAuthor];
    [commentView bringSubviewToFront:commentContent];
    
    
    commentView.frame = CGRectMake(0, 0, self.titleOfThePost.frame.size.width, commentAuthor.frame.size.height + 10 + commentContent.frame.size.height+10);
    
    return commentView;
}

-(UIView *)Content:(NSString *)content withTag:(int)tag{
    
    UIView *view = [[UIView alloc]init];
    UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 0, 35)];
    tagLabel.backgroundColor = [self colorWithHexString:@"e3e4ea"];
    tagLabel.text = content;
    tagLabel.text = [tagLabel.text uppercaseString];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.adjustsFontSizeToFitWidth = true;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        tagLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:16];
    
    else
        tagLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:20];
    tagLabel.textColor = [self colorWithHexString:@"334c69"];
    tagLabel.numberOfLines =1;
    [tagLabel sizeToFit];
    view.frame = CGRectMake(0 , 0, tagLabel.frame.size.width + 20, tagLabel.frame.size.height + 20 );
    
    UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
    button.tag = tag;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self
               action:@selector(ClickATag:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:tagLabel];
    [view bringSubviewToFront:tagLabel];
    [view addSubview:button];
    [view bringSubviewToFront:button];
    
    return view;
}
-(void)ClickATag:(UIButton *)button{
    [GlobalVariables getInstance].backToPostHasToBeHidden = YES;
    NSInteger index = button.tag;
    NSLog(@"TAG CLICKED SLUG IS : %@",allTagsSlugs[index]);
    [GlobalVariables getInstance].slugName = allTagsName[index];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromAgendaTag"];
    [GlobalVariables getInstance].backGroundImageTag = nil;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",allTagsSlugs[index]] forKey:@"ComingFromPostTag"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CatsSubCatsController"]];
}

-(UIView *)CreateSuggestedPostView:(NSURL *)imageUrl Title:(NSString *)title Content:(NSString *)content CachingKey:(NSString *)cachingKey Tag:(int)tag{
    
    UIView *BigView = [[UIView alloc]initWithFrame:self.suggestedPostView.frame];
    
    UILabel *titleSuggested = [[UILabel alloc]initWithFrame:self.suggestedPostTitle.frame];
    titleSuggested.backgroundColor = [UIColor clearColor];
    titleSuggested.text = [NSString stringWithFormat:@"%@",title];
    titleSuggested.adjustsFontSizeToFitWidth = true;
    titleSuggested.font = self.suggestedPostTitle.font;
    titleSuggested.textColor = self.suggestedPostTitle.textColor;
    titleSuggested.numberOfLines = 2;
    [titleSuggested sizeToFit];
    
    UILabel *contentSuggested = [[UILabel alloc]initWithFrame:CGRectMake(titleSuggested.frame.origin.x, titleSuggested.frame.origin.y + titleSuggested.frame.size.height + 2, self.suggestedPostContent.frame.size.width, self.suggestedPostContent.frame.size.height)];
    contentSuggested.backgroundColor = [UIColor clearColor];
    contentSuggested.text = [NSString stringWithFormat:@"%@", content];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    contentSuggested.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
    else
        contentSuggested.font = [UIFont fontWithName:@"Montserrat-Regular" size:17];
    contentSuggested.textColor = self.suggestedPostContent.textColor;
    contentSuggested.numberOfLines = 0;
    
    UIImageView *imageSuggested = [[UIImageView alloc] initWithFrame:self.suggestedPostImage.frame];
    [imageSuggested loadImageFromURL: imageUrl placeholderImage:[UIImage imageNamed:@"noimage.png"] cachingKey:cachingKey];
    imageSuggested.layer.cornerRadius = imageSuggested.frame.size.height/2;
    imageSuggested.contentMode = UIViewContentModeScaleAspectFill;
    imageSuggested.clipsToBounds = true;
    
    
    [imageSuggested.layer setBorderColor:[self colorWithHexString:@"F69901"].CGColor];
    [imageSuggested.layer setBorderWidth: 2.75 * self.view.frame.size.width / 375];
    
    
    if(tag != [[postInfo valueForKey:@"suggested_posts"] count] - 1){
        UIView *separatorSuggested = [[UIView alloc] initWithFrame:self.suggestedPostSeparator.frame];
        separatorSuggested.backgroundColor = self.suggestedPostSeparator.backgroundColor;
        [BigView addSubview:separatorSuggested];
        [BigView bringSubviewToFront:separatorSuggested];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.suggestedPostView.frame.size.width, self.suggestedPostView.frame.size.height)];
    button.tag = tag;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self
               action:@selector(ClickAPost:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [BigView addSubview:titleSuggested];
    [BigView addSubview:contentSuggested];
    [BigView addSubview:imageSuggested];
    
    [BigView addSubview:button];
    [BigView bringSubviewToFront:titleSuggested];
    [BigView bringSubviewToFront:contentSuggested];
    [BigView bringSubviewToFront:imageSuggested];
    
    [BigView bringSubviewToFront:button];
    
    return BigView;
}

- (void) ClickAPost: (UIButton*) button {
    
    NSInteger tag = button.tag;
    [GlobalVariables getInstance].idOfPost = [[postInfo valueForKey:@"suggested_posts"] valueForKey:@"id"][tag];
    [GlobalVariables getInstance].comingFrom = @"Posts";
    [GlobalVariables getInstance].comingFromViewController = @"PostViewController";
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
}

-(void)ClickAnImage:(UIButton *) button{
    
    NSInteger z = button.tag;
    if(scrollImageUrls.count > 0)
        [GlobalVariables getInstance].urlOfImageClicked = scrollImageUrls[z];
    else
        [GlobalVariables getInstance].urlOfImageClicked = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ScrollImageController"]];
    
}
- (IBAction)facebook:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.facebookfb.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.facebookfb.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.facebookfb.transform = CGAffineTransformIdentity;
                
                NSString *textToShare = [NSString stringWithFormat:@"%@ - Vivre à %@ %@",[postInfo valueForKey:@"post_title" ],nameOfTheCity,[postInfo valueForKey:@"post_url"]];
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [controller setInitialText: textToShare];
                [self presentViewController:controller animated:YES completion:Nil];
                
                
                
            }];
            
        }];
        
    }];
    
}

- (IBAction)twitter:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.twittertw.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.twittertw.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.twittertw.transform = CGAffineTransformIdentity;
                
  
                    SLComposeViewController *tweetSheet = [SLComposeViewController
                                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ - Vivre à %@ %@",[postInfo valueForKey:@"post_title" ],nameOfTheCity,[postInfo valueForKey:@"post_url"]]];
                    [self presentViewController:tweetSheet animated:YES completion:nil];

                
            }];
            
        }];
        
    }];
}
-(void)showMessage: (NSString *)content{
    
    demo = [[OLGhostAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", content] message:nil timeout:1 dismissible:YES];
    demo.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:14.0 ];
    demo.titleLabel.textColor = [UIColor whiteColor];
    demo.backgroundColor =  [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];;
    demo.bottomContentMargin = 50;
    demo.layer.cornerRadius = 7;
    
    [demo show];
    
    
}

- (IBAction)facebook2:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.fb2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.fb2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.fb2.transform = CGAffineTransformIdentity;
                
                NSString *textToShare = [NSString stringWithFormat:@"%@ - Vivre à %@ %@",[postInfo valueForKey:@"post_title" ],nameOfTheCity,[postInfo valueForKey:@"post_url"]];
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [controller setInitialText: textToShare];
                [self presentViewController:controller animated:YES completion:Nil];
                
            }];
            
        }];
        
    }];
}

- (IBAction)twitter2:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.twiiter2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.twiiter2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.twiiter2.transform = CGAffineTransformIdentity;
                NSString *textToShare = [NSString stringWithFormat:@"%@ - Vivre à %@ %@",[postInfo valueForKey:@"post_title" ],nameOfTheCity,[postInfo valueForKey:@"post_url"]];
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [controller setInitialText: textToShare];
                
                [self presentViewController:controller animated:YES completion:Nil];
                
                
            }];
            
        }];
        
    }];
    
}


- (IBAction)increaseFontButton:(id)sender {
    if([GlobalVariables getInstance].fontsize >= 22)
        self.increaseFontSize.enabled = false;
    else{
        
        [GlobalVariables getInstance].fontsize ++;
        self.fontSizeNumber.text = [NSString stringWithFormat:@"%d",(int)[GlobalVariables getInstance].fontsize];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[GlobalVariables getInstance].fontsize] forKey:@"fontSize"];
}

- (IBAction)descreaseFontSize:(id)sender {
    
    if([GlobalVariables getInstance].fontsize <= 12)
        self.decreaseFontSize.enabled = false;
    else{
        [GlobalVariables getInstance].fontsize --;
        self.fontSizeNumber.text = [NSString stringWithFormat:@"%d",(int)[GlobalVariables getInstance].fontsize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[GlobalVariables getInstance].fontsize] forKey:@"fontSize"];
}

- (IBAction)getBackToRecentController:(id)sender {
    
    if([[GlobalVariables getInstance].comingFromViewController  isEqualToString:@"PostViewController"]){
        
        if([GlobalVariables getInstance].CarouselOfPostIds.count > 2){
            [[GlobalVariables getInstance].CarouselOfPostIds removeLastObject];
            
            
            
            [GlobalVariables getInstance].idOfPost = [[GlobalVariables getInstance].CarouselOfPostIds lastObject];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"CanAddObjectToCarousel"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: @"PostViewController"];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].CarouselOfPostIds firstObject]]];
        }
        
        
    }
    
    else if([[GlobalVariables getInstance].comingFromViewController isEqualToString:@"MapViewController"]){
        
        if([[postInfo valueForKey:@"location"] count] > 0){
            
            [GlobalVariables getInstance].lastLatitudine = [[[postInfo valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
            [GlobalVariables getInstance].lastLongitudine = [[[postInfo valueForKey:@"location"] valueForKey:@"lng"] doubleValue];
            [GlobalVariables getInstance].lastZoomLvl = 16;
            [GlobalVariables getInstance].PerSession = true;
            
            [GlobalVariables getInstance].comingFromPostView = true;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object:@"MapViewController"];
        
    }
    else if([[GlobalVariables getInstance].comingFromViewController isEqualToString:@"CatsSubCatsController"]){
        [GlobalVariables getInstance].backToPostHasToBeHidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"%@", [GlobalVariables getInstance].comingFromViewController]];
    }
    else {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"%@", [GlobalVariables getInstance].comingFromViewController]];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.postScrollView removeFromSuperview];
    [self.postDetailsImageScroll removeFromSuperview];
    [demo hide];
    [demo isHidden];
    [demo setHidden:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [demo hide];
        [demo isHidden];
        [demo setHidden:YES];
        
    });
    
}

- (IBAction)saveFontSize:(id)sender {
    // if([GlobalVariables getInstance].fontsize != postContent.font.pointSize)
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"CanAddObjectToCarousel"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
}

#pragma mark - TableView:
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayUsedInTable.count + 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return self.view.frame.size.width/15;
    else
    return self.view.frame.size.width/7;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//   // return self.view.frame.size.width/12;
//    if(indexPath.row == 0){
//        return additionalSpaceNeeded + [self heightForText:@"Infos Pratiques: ";];
//    }
//    else {
//    NSString * yourText = arrayUsedInTable[indexPath.row]; // or however you are getting the text
//    return additionalSpaceNeeded + [self heightForText:yourText];
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InfoPratiquesTableViewCell";
    InfoPratiquesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.row == 0) {
        cell.textView.text =  @"Infos Pratiques: ";
        cell.textView.textColor = [UIColor brownColor];
        cell.textView.font = [UIFont fontWithName:@"Montserrat-Bold" size:postContent.font.pointSize + 6];
        cell.textView.frame = CGRectMake(0, cell.textView.frame.origin.y, cell.textView.frame.size.width, cell.textView.frame.size.height);
        
    }
    else {
        if(![[arrayWithImagesUsedInTable objectAtIndex:indexPath.row-1] isEqualToString:@"0"]) {
            cell.myImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arrayWithImagesUsedInTable[indexPath.row-1]]];
            cell.myImage.contentMode = UIViewContentModeScaleAspectFit;
            cell.myImage.clipsToBounds = true;
        }
        else
            cell.textView.frame = CGRectMake(cell.myImage.frame.origin.x, cell.textView.frame.origin.y, cell.textView.frame.size.width, cell.textView.frame.size.height);
        
        if([[arrayUsedInTable objectAtIndex:indexPath.row-1] containsString:@"XYZ"]) {
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[[[arrayUsedInTable objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"XYZ"] objectAtIndex:0]];
        [attributedString addAttribute: NSLinkAttributeName value: [[[arrayUsedInTable objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"XYZ"] objectAtIndex:1] range: NSMakeRange(0, attributedString.length)];
        cell.textView.attributedText = attributedString;
        }
        else
            cell.textView.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[arrayUsedInTable objectAtIndex:indexPath.row-1]]];
        
        
        if([cell.textView.text containsString:@"@"])
            cell.textView.dataDetectorTypes = UIDataDetectorTypeAll;
        else
            cell.textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        
        if(postContent.font.pointSize < 16)
        cell.textView.font = [UIFont fontWithName:@"Montserrat-Regular" size:postContent.font.pointSize];
        else
          cell.textView.font = [UIFont fontWithName:@"Montserrat-Regular" size:16];;
        
        if(indexPath.row == 2) {
            if(postContent.font.pointSize < 16)
                cell.textView.font = [UIFont fontWithName:@"Montserrat-Bold" size:postContent.font.pointSize + 2];
            else
                cell.textView.font = [UIFont fontWithName:@"Montserrat-Bold" size:17];;
            
            cell.textView.textColor = [self colorWithHexString:@"333399"];
        }
        if([[NSString stringWithFormat:@"%@",[arrayUsedInTable objectAtIndex:indexPath.row-1]] containsString:@"LELOL"]) {
            cell.textView.text = [cell.textView.text stringByReplacingOccurrencesOfString:@"LELOL" withString:@""];
            cell.textView.textColor = [UIColor redColor];
        }
        else
            cell.textView.textColor = [UIColor darkGrayColor];
            
        //[cell.textView sizeToFit];
    }
   // cell.textView.numberOfLines = 1;
   // cell.textView.adjustsFontSizeToFitWidth = true;
    
   
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell setIndentationLevel:0];
    [cell setIndentationWidth:0];
    
    return cell;
    
    
}
@end
