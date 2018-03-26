//
//  InfoPratiquesTableViewCell.m
//  VivreABerlin
//
//  Created by Stoica Mihail on 28/12/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "InfoPratiquesTableViewCell.h"

@implementation InfoPratiquesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.scrollEnabled = false;
    self.backgroundColor = [UIColor clearColor];
    self.textView.editable = false;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
