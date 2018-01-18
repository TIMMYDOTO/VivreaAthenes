//
//  AnnouncementCell.h
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *announcementImage;
@property (weak, nonatomic) IBOutlet UILabel *announcementTitle;
@property (weak, nonatomic) IBOutlet UILabel *announcementDate;
@property (weak, nonatomic) IBOutlet UILabel *announcementContent;

@end
