//
//  LeftViewController.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
- (IBAction)openCredits:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *accueilText;
@property (weak, nonatomic) IBOutlet UIImageView *logoAppIcon;
@property (weak, nonatomic) IBOutlet UILabel *settingsText;
@property (weak, nonatomic) IBOutlet UILabel *contactEtCreditsText;
- (IBAction)openAppsPopup:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *worldIcon;
@property (weak, nonatomic) IBOutlet UIImageView *instagram;
@property (weak, nonatomic) IBOutlet UIImageView *tumblr;
@property (weak, nonatomic) IBOutlet UIButton *openCategory;
@property (weak, nonatomic) IBOutlet UISearchBar *searchArticles;

@property (weak, nonatomic) IBOutlet UIImageView *twitter;
- (IBAction)toMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *facebook;

- (IBAction)InapoiLaPaginaPrincipala:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *catAndSubcatsTable;
- (IBAction)openFacebook:(id)sender;
- (IBAction)openTwitter:(id)sender;
- (IBAction)openInstagram:(id)sender;
- (IBAction)openTumblr:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *socialsView;
@property (weak, nonatomic) IBOutlet UIButton *openSearchBar;
- (IBAction)openHomePage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *quickSearchView;
@property (weak, nonatomic) IBOutlet UITableView *resultsSearchTable;
@property (weak, nonatomic) IBOutlet UIButton *seeAll;
@property (weak, nonatomic) IBOutlet UILabel *SeeAllResults;
@property (weak, nonatomic) IBOutlet UILabel *noArticlesFound;
- (IBAction)seeAllResults:(id)sender;
@end
