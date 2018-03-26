//
//  PopUpNewsletterController.h
//  VivreABerlin
//
//  Created by Stoica Mihail on 06/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpNewsletterController : UIViewController <UITextFieldDelegate>
- (IBAction)submitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *enterEmailFiel;
@property (weak, nonatomic) IBOutlet UITextField *enterNameField;
@property (weak, nonatomic) IBOutlet UIView *newsletterView;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsletterText;

@end
