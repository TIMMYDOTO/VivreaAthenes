//
//  CatsSubCatsCell.h
//  VivreABerlin
//
//  Created by home on 30/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatsSubCatsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *articleImage;
@property (strong, nonatomic) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UILabel *articleContent;
@property (strong, nonatomic) IBOutlet UIImageView *didSelectImage;
@property (strong, nonatomic) IBOutlet UIView *separatorView;

@end
