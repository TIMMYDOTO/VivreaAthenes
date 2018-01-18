//
//  PopUpApplicationsController.h
//  VivreABerlin
//
//  Created by Stoica Mihail on 06/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpApplicationsController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *secondPicture;
@property (weak, nonatomic) IBOutlet UIImageView *thirdPicture;
@property (weak, nonatomic) IBOutlet UIImageView *firstPicture;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *SecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstArrow;
@property (weak, nonatomic) IBOutlet UIImageView *secondArrow;
@property (weak, nonatomic) IBOutlet UIImageView *thirdArrow;

@property (weak, nonatomic) IBOutlet UIImageView *closePopUp;
- (IBAction)closePopUpButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *popupviewApp;
@end
