//
//  lastPostCellHomeView.m
//  VivreABerlin
//
//  Created by home on 28/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "lastPostCellHomeView.h"

@implementation lastPostCellHomeView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lastCategoryNameTable.adjustsFontSizeToFitWidth = true;
    self.backgroundColor = [UIColor clearColor];
    self.lastPostContentTable.clipsToBounds =  true;
    self.lastPostContentTable.numberOfLines = 5;
    self.lastPostPicutreTable.contentMode = UIViewContentModeScaleAspectFill;
    self.lastPostPicutreTable.layer.cornerRadius = 4;
    self.lastPostPicutreTable.clipsToBounds = true;
    self.cellBackground.layer.cornerRadius = 7;
    self.cellBackground.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
