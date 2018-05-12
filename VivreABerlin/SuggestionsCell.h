//
//  SuggestionsCell.h
//  VivreABerlin
//
//  Created by Artyom Schiopu on 5/3/18.
//  Copyright © 2018 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *fragment;
@property (weak, nonatomic)NSString *identifier;
@end
