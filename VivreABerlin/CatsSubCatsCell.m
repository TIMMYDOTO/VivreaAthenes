//
//  CatsSubCatsCell.m
//  VivreABerlin
//
//  Created by home on 30/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "CatsSubCatsCell.h"

@implementation CatsSubCatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.articleTitle.numberOfLines = 2;
    self.articleTitle.adjustsFontSizeToFitWidth = true;
    self.articleContent.numberOfLines = 5;
  //  self.articleContent.adjustsFontSizeToFitWidth = true;
    self.articleImage.contentMode = UIViewContentModeScaleAspectFill;
    self.articleImage.layer.cornerRadius = 5;
    [self.articleImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [self.articleImage.layer setBorderWidth: 0.5];
    self.articleImage.clipsToBounds = true;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
