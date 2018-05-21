//
//  AstuceVC.m
//  VivreABerlin
//
//  Created by Artyom Schiopu on 4/22/18.
//  Copyright © 2018 Stoica Mihail. All rights reserved.
//

#import "AstuceVC.h"

@interface AstuceVC (){
    
    __weak IBOutlet UIView *astuceView;
    __weak IBOutlet UIImageView *wifiImage;
    __weak IBOutlet UILabel *headLabel;
    __weak IBOutlet UIButton *closeButton;
    __weak IBOutlet UILabel *topLabel;
    __weak IBOutlet UILabel *middleTextField;
    __weak IBOutlet UILabel *bottomLabel;
    __weak IBOutlet UIImageView *img;

}

@end

@implementation AstuceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    
    astuceView.frame = CGRectMake(screenWidth * 0.1, screenHeight * 0.05, screenWidth * 0.8, screenHeight * 0.93);
//    [astuceView setHidden:NO];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    middleTextField.layer.cornerRadius = 14.0;
    middleTextField.clipsToBounds = YES;
    
    astuceView.layer.cornerRadius = 10.0;
    astuceView.clipsToBounds = YES;
    
    wifiImage.frame = CGRectMake(astuceView.frame.size.width * 0.05, 8, 54, 54 );
    headLabel.frame = CGRectMake(astuceView.frame.size.width /2 - 50, 8, 100, 54);
    closeButton.frame = CGRectMake(astuceView.frame.size.width * 0.77, 12, 46, 46);
    
    topLabel.frame = CGRectMake(astuceView.frame.size.width * 0.05, wifiImage.frame.origin.y + 54 + 15, astuceView.frame.size.width * 0.9, 111);
    
    middleTextField.frame = CGRectMake(topLabel.frame.origin.x, topLabel.frame.origin.y + 111 + 20, topLabel.frame.size.width, 38);
    bottomLabel.frame = CGRectMake(astuceView.frame.size.width * 0.15, middleTextField.frame.origin.y + 38 + 20, astuceView.frame.size.width * 0.7 , 46);
   
    img.frame = CGRectMake(topLabel.frame.origin.x, bottomLabel.frame.origin.y + 50 + 20, astuceView.frame.size.width * 0.90, screenHeight/2.2);
}

- (IBAction)closeButton:(UIButton *)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}


@end
