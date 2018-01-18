//
//  ViewController.h
//  VivreABerlin
//
//  Created by Stoica Mihail on 19/04/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *changeableBackground;
@property (weak, nonatomic) IBOutlet UIImageView *newsLetter;
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;
@property (weak, nonatomic) IBOutlet UITableView *randomLastPostPerCategory;
- (IBAction)openNewsletter:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *rainbowHome;
@property (weak, nonatomic) IBOutlet UIImageView *sliderImage;
@property (weak, nonatomic) IBOutlet UILabel *sliderText;
@property (weak, nonatomic) IBOutlet UIScrollView *viewControllerSrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *sliderScrollView;
@property (weak, nonatomic) IBOutlet UILabel *sliderTitlePost;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDots;
@property (weak, nonatomic) IBOutlet UIView *postTitleSubView;
@property (weak, nonatomic) IBOutlet UIImageView *openIapImage;




- (IBAction)openMenu:(id)sender;

- (NSString *)stringByStrippingHTML:(NSString *)inputString;
@end

