//
//  lastPostCellHomeView.h
//  VivreABerlin
//
//  Created by home on 28/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lastPostCellHomeView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lastCategoryNameTable;
@property (weak, nonatomic) IBOutlet UILabel *lastCategoryTitleTable;
@property (weak, nonatomic) IBOutlet UIImageView *lastPostPicutreTable;
@property (weak, nonatomic) IBOutlet UILabel *lastPostContentTable;
@property (weak, nonatomic) IBOutlet UIView *cellBackground;

@end
