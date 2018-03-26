//
//  AnnouncementCell.m
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AnnouncementCell.h"

@implementation AnnouncementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.announcementContent.numberOfLines = 2;
    self.announcementImage.contentMode = UIViewContentModeScaleAspectFill;
    self.announcementImage.layer.cornerRadius = 5;
    self.announcementImage.clipsToBounds = true;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
