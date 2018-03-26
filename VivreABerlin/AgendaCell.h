//
//  AgendaCell.h
//  VivreABerlin
//
//  Created by home on 28/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *elementImage;
@property (weak, nonatomic) IBOutlet UILabel *elementAuthor;
@property (weak, nonatomic) IBOutlet UILabel *elementDate;
@property (weak, nonatomic) IBOutlet UILabel *elementNom;

@end
