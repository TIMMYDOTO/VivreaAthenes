//
//  CatsSubCatsController.h
//  VivreABerlin
//
//  Created by home on 14/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatsSubCatsController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *catsSubCatsTable;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *rainbow;
@property (weak, nonatomic) IBOutlet UIButton *openSideMenu;
@property (weak, nonatomic) IBOutlet UIImageView *changableBackground;
@property (weak, nonatomic) IBOutlet UILabel *noArticlesFound;
- (IBAction)openSideMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *catsSubCatsScroll;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
- (IBAction)openiAPController:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;
@property (weak, nonatomic) IBOutlet UIButton *backToPost;
- (IBAction)backToPost:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *authorOfBg;
@property (weak, nonatomic) IBOutlet UIView *authorView;

@end
