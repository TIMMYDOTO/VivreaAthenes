//
//  ListOfPostsController.h
//  VivreABerlin
//
//  Created by home on 03/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfPostsController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *allPostsSearched;
- (IBAction)openSideMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *changeableBackground;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *noArticleFounded;
@property (weak, nonatomic) IBOutlet UIImageView *rainbow;
@property (weak, nonatomic) IBOutlet UIScrollView *searchScreenScroll;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchedFieldArticle;
- (IBAction)openiAPController:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;

@end
