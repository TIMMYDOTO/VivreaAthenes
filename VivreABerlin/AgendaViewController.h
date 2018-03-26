//
//  AgendaViewController.h
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AgendaViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *changeableBg;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *rainbow;
@property (weak, nonatomic) IBOutlet UILabel *titleOfContent;
@property (weak, nonatomic) IBOutlet UILabel *passage;
@property (weak, nonatomic) IBOutlet UIView *viewWithTitles;
@property (weak, nonatomic) IBOutlet UIView *agendaContentView;
@property (weak, nonatomic) IBOutlet UITextView *agendaPreviewContent;
- (IBAction)openiAPController:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *dossiersTable;
@property (weak, nonatomic) IBOutlet UIButton *closeDossiersView;
@property (weak, nonatomic) IBOutlet UIView *dossiersView;
- (IBAction)closeDossiers:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dossiersHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *nosDossires;
@property (weak, nonatomic) IBOutlet UITableView *agendaPostsTableView;
@property (weak, nonatomic) IBOutlet UILabel *slugLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadScreen;
- (IBAction)reloadScreen:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *agendaScrollView;
@property (weak, nonatomic) IBOutlet UIView *searchfieldView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *agendaTable;
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;
@property (weak, nonatomic) IBOutlet UITextView *noArticle;
- (IBAction)openSideMenu:(id)sender;
@end
