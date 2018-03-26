//
//  AddAnnouncement.h
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddAnnouncement : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleSearchfieldView;
@property (weak, nonatomic) IBOutlet UIView *bigTitleview;
@property (weak, nonatomic) IBOutlet UIView *addannouncementView;
- (IBAction)closePopUp:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIView *contaNameView;
@property (weak, nonatomic) IBOutlet UITextField *contactNameField;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UILabel *bittitle;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextview;
- (IBAction)SUIVANT:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *emailDesc;
@property (weak, nonatomic) IBOutlet UILabel *titletitle;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *emailTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (assign, nonatomic) BOOL keyboardIsShowing;

@property (assign, nonatomic) BOOL canBeDeleted;

@property (weak, nonatomic) IBOutlet UIButton *exitView;
- (IBAction)DeleteAD:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *suivant;
@property (weak, nonatomic) IBOutlet UIButton *deleteAd;
@property (weak, nonatomic) NSString *titleeeee;
@property (weak, nonatomic) NSString *adID;
@property (weak, nonatomic) NSString *contactName;
@property (strong, nonatomic) NSString *adKey;
@property (weak, nonatomic) NSString *emailContact;
@property (weak, nonatomic) NSString *details;
@end
