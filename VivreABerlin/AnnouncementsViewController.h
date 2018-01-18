//
//  AnnouncementsViewController.h
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementsViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *announcesScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *rainbow;
@property (weak, nonatomic) IBOutlet UIImageView *changeableBg;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *announcementTitle;
- (IBAction)addAnnouncement:(id)sender;
- (IBAction)editAnnouncement:(id)sender;
- (IBAction)searchAnnouncement:(id)sender;
- (IBAction)openSideMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *annButtons;
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;

@property (weak, nonatomic) IBOutlet UILabel *noAnnouncement;
@property (weak, nonatomic) IBOutlet UITableView *announcementsTable;

- (IBAction)openiAPController:(id)sender;
@end
