//
//  AgendaCell.m
//  VivreABerlin
//
//  Created by home on 28/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AgendaCell.h"

@implementation AgendaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.elementImage.contentMode = UIViewContentModeScaleAspectFill;
    self.elementImage.layer.cornerRadius = 3;
    self.elementImage.clipsToBounds = true;
    self.elementImage.image = [UIImage imageNamed:@"BackgroundDay.png"];
    
    
    self.elementNom.numberOfLines = 4;
    self.elementNom.adjustsFontSizeToFitWidth = true;
    
    self.elementDate.numberOfLines = 4;
    self.elementDate.adjustsFontSizeToFitWidth = true;
    
    
    self.elementAuthor.adjustsFontSizeToFitWidth = true;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
