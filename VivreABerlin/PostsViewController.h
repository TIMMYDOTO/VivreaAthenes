//
//  PostsViewController.h
//  VivreABerlin
//
//  Created by home on 05/05/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Mapbox;
#import <CoreLocation/CoreLocation.h>


@interface PostsViewController : UIViewController <MGLMapViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate,UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *openSideBar;
@property (weak, nonatomic) IBOutlet UILabel *titleOfThePost;
@property (weak, nonatomic) IBOutlet UIScrollView *postScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *changeableBackgroundd;
- (IBAction)openSideBar:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;
@property (weak, nonatomic) IBOutlet UICollectionView *starsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *passage;
@property (weak, nonatomic) IBOutlet UILabel *postsBigTitle;
@property (weak, nonatomic) IBOutlet UIImageView *rainbow;
@property (weak, nonatomic) IBOutlet UIScrollView *postDetailsImageScroll;
- (IBAction)facebook:(id)sender;
- (IBAction)twitter:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *facebookfb;
@property (weak, nonatomic) IBOutlet UIButton *twittertw;
@property (weak, nonatomic) IBOutlet UIScrollView *tagsScrollView;
@property (weak, nonatomic) IBOutlet UILabel *tagsTitle;
@property (weak, nonatomic) IBOutlet UIView *savedPostView;

@property (weak, nonatomic) IBOutlet UIButton *fb2;
- (IBAction)facebook2:(id)sender;
- (IBAction)twitter2:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *SuggestedPostsTitleHeader;
@property (weak, nonatomic) IBOutlet UIView *suggestedPostView;
@property (weak, nonatomic) IBOutlet UIImageView *suggestedPostImage;
@property (weak, nonatomic) IBOutlet UILabel *suggestedPostTitle;
@property (weak, nonatomic) IBOutlet UILabel *suggestedPostContent;
@property (weak, nonatomic) IBOutlet UIView *suggestedPostSeparator;
@property (weak) NSArray* threePageScroller_Views;
@property (weak, nonatomic) IBOutlet UILabel *thumbnailAuthor;
@property (weak, nonatomic) IBOutlet UIImageView *fontSizeImage;
@property (weak, nonatomic) IBOutlet UIButton *increaseFontSize;

@property (weak, nonatomic) IBOutlet UIView *changeImageView;
@property (weak, nonatomic) IBOutlet UIView *changeFontView;
- (IBAction)saveFontSize:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *decreaseFontSize;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *articleEnregistre;
- (IBAction)increaseFontButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeNumber;
- (IBAction)descreaseFontSize:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (IBAction)getBackToRecentController:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *postNotSaved;
@property (strong, nonatomic) MGLMapView * postMapView;
@property (weak, nonatomic) IBOutlet UIView *transparentBackground;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
