//
//  TicketsViewController.h
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)openSideBar:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *rainbow;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *ticketsScroll;
@property (weak, nonatomic) IBOutlet UITableView *ticketTable;
@property (weak, nonatomic) IBOutlet UILabel *ticketsTopTitle;
@property (weak, nonatomic) IBOutlet UIButton *openSideMenu;
@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property (weak, nonatomic) IBOutlet UIImageView *ticketImage;
- (IBAction)openIAP:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ticketsSlug;



@end
