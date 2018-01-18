//
//  DistrictsViewController.h
//  VivreABerlin
//
//  Created by home on 17/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistrictsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *districtsTable;
- (IBAction)openSideMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *districtsBackColor;
- (IBAction)filtersButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *filtresBackColor;
@property (weak, nonatomic) IBOutlet UIImageView *districtsIcon;
- (IBAction)closeDistricts:(id)sender;

@end
