//
//  OnboardingFirstViewController.h
//  VivreABerlin
//
//  Created by home on 17/11/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingFirstViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *midView;
- (IBAction)nextPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *rigthView;
- (IBAction)previousPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *redCircle;
- (IBAction)registerNewsLetter:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerNewsLetter;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageNewsLetter;


@end
