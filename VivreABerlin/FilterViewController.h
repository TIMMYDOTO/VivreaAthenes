
//
//  FilterViewController.h
//  VivreABerlin
//
//  Created by home on 17/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController
- (IBAction)openSideMenu:(id)sender;
- (IBAction)openDistricts:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) IBOutlet UIImageView *filtersIcon;
@property (weak, nonatomic) IBOutlet UILabel *checkAllText;
@property (weak, nonatomic) IBOutlet UIImageView *checkAllImage;
- (IBAction)CheckAll:(id)sender;
- (IBAction)backToMap:(id)sender;
- (IBAction)closeFilters:(id)sender;

@end
