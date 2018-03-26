//
//  AnnouncementArticleView.h
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementArticleView : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *annScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *changeableBg;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *rainbow;
- (IBAction)openSideMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *exitAnn;
- (IBAction)searchAnn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *editAnn;
- (IBAction)editerAnn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addAnn;
- (IBAction)addAnno:(id)sender;
- (IBAction)exitAnnounce:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewsView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfViews;
- (IBAction)shareFB:(id)sender;
- (IBAction)shareTwet:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleOfAnnounce;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScroll;
@property (weak, nonatomic) IBOutlet UIImageView *imageinScroll;
@property (weak, nonatomic) IBOutlet UIView *announceButtons;
@property (weak, nonatomic) IBOutlet UILabel *notSaved;
- (IBAction)openiAPController:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;


@end
