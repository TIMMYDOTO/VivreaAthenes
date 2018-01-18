//
//  ScrollImageController.h
//  VivreABerlin
//
//  Created by home on 22/06/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollImageController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *zoomingScroll;
@property (weak, nonatomic) IBOutlet UIImageView *zoomingImage;
@property (weak, nonatomic) IBOutlet UILabel *authorOfImage;

@end
