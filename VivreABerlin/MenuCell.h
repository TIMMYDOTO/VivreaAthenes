//
//  MenuCell.h
//  VivreABerlin
//
//  Created by home on 26/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoriesName;
@property (weak, nonatomic) IBOutlet UIImageView *expandCell;
@property (weak, nonatomic) IBOutlet UIImageView *descriptivePicture;
@property (weak, nonatomic) IBOutlet UIButton *checkedCategory;

@end
