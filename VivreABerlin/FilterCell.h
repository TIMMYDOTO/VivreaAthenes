//
//  FilterCell.h
//  VivreABerlin
//
//  Created by home on 19/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *box;
@property (weak, nonatomic) IBOutlet UILabel *titletext;
@property (weak, nonatomic) IBOutlet UIImageView *expandArrow;
@property (weak, nonatomic) IBOutlet UIButton *expandAllButton;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end
