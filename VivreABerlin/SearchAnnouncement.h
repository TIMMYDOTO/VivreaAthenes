//
//  SearchAnnouncement.h
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchAnnouncement : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
- (IBAction)launchSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchFieldView;
//- (IBAction)addANn:(id)sender;
//- (IBAction)editAnn:(id)sender;
- (IBAction)getBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *searchScreenView;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (weak, nonatomic) IBOutlet UILabel *noAnnfound;

@end
