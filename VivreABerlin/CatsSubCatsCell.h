//
//  CatsSubCatsCell.h
//  VivreABerlin
//
//  Created by home on 30/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatsSubCatsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleContent;
@property (weak, nonatomic) IBOutlet UIImageView *didSelectImage;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
