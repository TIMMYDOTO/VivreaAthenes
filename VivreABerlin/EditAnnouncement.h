//
//  EditAnnouncement.h
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAnnouncement : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bigView;
- (IBAction)getBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *tokenView;
@property (weak, nonatomic) IBOutlet UITextField *emailfield;
@property (weak, nonatomic) IBOutlet UITextField *tokenField;
- (IBAction)continue:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;


@end
