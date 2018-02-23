//
//  AddAnnouncement.m
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AddAnnouncement.h"
#import "Reachability.h"
#import "OLGhostAlertView.h"
#import "GlobalVariables.h"
#import "AddAnnouncementNextStep.h"
#import "Header.h"
#import "OLGhostAlertView.h"
#import "AnnouncementsViewController.h"
#import "AnnouncementArticleView.h"
#import "TicketsViewController.h"
@interface AddAnnouncement (){
    
    __weak IBOutlet UIView *arrowsView;
}

@end

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height <= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

@implementation AddAnnouncement
{
    OLGhostAlertView *demo;
    CGRect frameOfPopUp;
    CGRect keyboardFrameBeginRect;
    CGFloat heightOfKeyboard;
    CGRect exitButtonOrigin;
    JTMaterialSpinner *spinnerView;
    int cases;
    int CASES2;
    NSMutableArray *textFields;
    __weak IBOutlet UIButton *arrowUp;
    __weak IBOutlet UIButton *arrowDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
   
    self.contentTextview.inputAccessoryView = arrowsView;
    self.contactNameField.inputAccessoryView = arrowsView;
    self.emailField.inputAccessoryView = arrowsView;
    self.titleField.inputAccessoryView = arrowsView;

  
    
    if([GlobalVariables getInstance].editerClicked == NO){
//        self.deleteAd.enabled = false;
      //  NSLog(@"NU Vin din editer");
    }
    else{
      //  NSLog(@"Vin din editer %@",self.adKey);
        
        self.titleField.text = self.titleeeee;
        self.contactNameField.text = self.contactName;
        self.emailField.text = self.emailContact;
        self.contentTextview.text = self.details;
        
//        [self.titleField becomeFirstResponder];
        
    }
    
    [self addNotificationsOnScreen];
    
    self.titleSearchfieldView.layer.cornerRadius = self.titleSearchfieldView.frame.size.height/2;
    self.titleSearchfieldView.clipsToBounds = true;
    self.contaNameView.layer.cornerRadius = self.titleSearchfieldView.frame.size.height/2;
    self.contaNameView.clipsToBounds = true;
    self.emailView.layer.cornerRadius = self.titleSearchfieldView.frame.size.height/2;
    self.emailView.clipsToBounds = true;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = true;
    self.addannouncementView.layer.cornerRadius = 5;
    self.addannouncementView.clipsToBounds = true;
    self.bigTitleview.layer.cornerRadius = 3;
    self.bigTitleview.clipsToBounds = true;
    self.emailDesc.adjustsFontSizeToFitWidth = true;
    
    self.keyboardIsShowing = NO;
    frameOfPopUp = self.addannouncementView.frame;
    
    self.contentTextview.delegate = self;
    
    self.contentTextview.delegate = self;
    self.contactNameField.delegate = self;
    self.emailField.delegate = self;
    self.titleField.delegate = self;
    
    exitButtonOrigin = self.exitView.frame;
    

    textFields = [[NSMutableArray alloc] init];
    [textFields addObject:self.titleField];
    [textFields addObject:self.contactNameField];
    [textFields addObject:self.emailField];
    [textFields addObject:self.contentTextview];
    
    
    
}



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"self.addannouncementView.frame %@",NSStringFromCGRect(self.addannouncementView.frame) );
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.15 animations:^{
        NSLog(@"frameOfPopUp %@", NSStringFromCGRect(frameOfPopUp));
        self.addannouncementView.frame = frameOfPopUp;
        self.exitView.frame = exitButtonOrigin;
    } completion:nil];
    return NO;
}
- (IBAction)closePopUp:(id)sender {
    [self.view setHidden:YES];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.keyboardIsShowing == YES)
    {
       
        [self.contentTextview resignFirstResponder];
        [self.contactNameField resignFirstResponder];
        [self.emailField resignFirstResponder];
        [self.titleField resignFirstResponder];
        
        [UIView animateWithDuration:0.15 animations:^{
                NSLog(@"%@", NSStringFromCGRect(frameOfPopUp));
            self.addannouncementView.frame = frameOfPopUp;
        
            self.exitView.frame = exitButtonOrigin;
        } completion:nil];
    }
    
}
- (IBAction)SUIVANT:(id)sender {
   self.emailField.text = [self.emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.contentTextview resignFirstResponder];
    [self.contactNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.titleField resignFirstResponder];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.addannouncementView.frame = frameOfPopUp;
        self.exitView.frame = exitButtonOrigin;
    } completion:nil];
    
    
    if([self isInternet] == NO)
        [self showMessage:@"Connexion internet requise"];
    if (self.contentTextview.text.length == 0 || self.contentTextview.text.length == 0 || self.contactNameField.text.length == 0 || self.titleField.text.length == 0 || [self NSStringIsValidEmail:self.emailField.text] == NO || self.emailField.text.length == 0) {
        if(self.contentTextview.text.length == 0){
            self.bittitle.text = @"Attention : merci de remplir tous les champs pour valider";
            self.bigTitleview.backgroundColor = [self colorWithHexString:@"FF5260"];
            [self.contentView.layer setBorderColor:[UIColor redColor].CGColor];
            [self.contentView.layer setBorderWidth:1.5f];
        }
        else {
                [self.contentView.layer setBorderWidth:0.f];
            }
             if (self.contactNameField.text.length == 0){
                self.bittitle.text = @"Attention : merci de remplir tous les champs pour valider";
                self.bigTitleview.backgroundColor = [self colorWithHexString:@"FF5260"];
                [self.contaNameView.layer setBorderColor:[UIColor redColor].CGColor];
                [self.contaNameView.layer setBorderWidth:1.5f];
            }
             else {
                 [self.contaNameView.layer setBorderWidth:0.f];
             }
            if (self.titleField.text.length == 0){
                self.bittitle.text = @"Attention : merci de remplir tous les champs pour valider";
                self.bigTitleview.backgroundColor = [self colorWithHexString:@"FF5260"];
                [self.titleSearchfieldView.layer setBorderColor:[UIColor redColor].CGColor];
                [self.titleSearchfieldView.layer setBorderWidth:1.5f];
            }
            else {
                [self.titleSearchfieldView.layer setBorderWidth:0.f];
            }
            if([self NSStringIsValidEmail:self.emailField.text] == NO || self.emailField.text.length == 0){
        
        
                [self.emailView.layer setBorderColor:[UIColor redColor].CGColor];
                [self.emailView.layer setBorderWidth:1.5f];

            }
            else{
                 [self.emailView.layer setBorderWidth:0.f];
            }
    }

   
   
    else if([GlobalVariables getInstance].editerClicked == NO && [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer == nil && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementsViewController"] && [[GlobalVariables getInstance].currentPopUpAnnouncementScreen isEqualToString:@"AnnouncementSearchView"]){
       
        
        
      //  NSLog(@"Am dat click pe add Announcement de pe pagina principala din meniul search");
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        self.suivant.hidden = true;
        cases = 0;
        [self sendingAnHTTPPOSTRequestOnPostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text];
        
    }
    else if([GlobalVariables getInstance].editerClicked == NO && [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer == nil && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementsViewController"] && [[GlobalVariables getInstance].currentPopUpAnnouncementScreen isEqualToString:@"AnnouncementsViewController"]){
      //  NSLog(@"Am dat click pe add Announcement de pe pagina principala");
        
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        self.suivant.hidden = true;
        cases = 1;
        [self sendingAnHTTPPOSTRequestOnPostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text];
        
        
        
    }
    else if([GlobalVariables getInstance].editerClicked == NO && [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer == nil && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementArticleView"] && [[GlobalVariables getInstance].currentPopUpAnnouncementScreen isEqualToString:@"AnnouncementArticleView"]){
        
      //  NSLog(@"Am dat click pe add Announcement din AritcleView");
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        self.suivant.hidden = true;
        cases = 2;
        [self sendingAnHTTPPOSTRequestOnPostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text];
        
    }
    else if([GlobalVariables getInstance].editerClicked == NO && [GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer == nil && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementArticleView"] && [[GlobalVariables getInstance].currentPopUpAnnouncementScreen isEqualToString:@"AnnouncementSearchView"]) {
        
     //   NSLog(@"Am dat click pe add Announcement din AritcleView din meniul search");
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        self.suivant.hidden = true;
        cases = 3;
        [self sendingAnHTTPPOSTRequestOnPostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text];
        
    }
    if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"editAnnClickedOnHomePage"]){
        
     //   NSLog(@"Am dat click pe editer din Ecranul principal %@",self.adKey);
        
        self.suivant.hidden = true;
//        self.deleteAd.enabled = false;
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        
        CASES2 = 0;
        
        [self sendingAnHTTPPOSTRequestOnUpdatePostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text withToken:self.adKey withAdID:self.adID];
    }
    else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnSearchPage"] && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementsViewController"]){
        
     //   NSLog(@"Am dat click pe editer din Ecranul principal din meniul search");
        
        
        self.suivant.hidden = true;
//        self.deleteAd.enabled = false;
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        
        CASES2 = 1;
        
        [self sendingAnHTTPPOSTRequestOnUpdatePostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text withToken:self.adKey withAdID:self.adID];
        
    }
    else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnSearchPage"] && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementArticleView"]){
        
        
     //   NSLog(@"Am dat click pe editer din ArticleView din meniul Search");
        
        self.suivant.hidden = true;
//        self.deleteAd.enabled = false;
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        
        CASES2 = 2;
        
        [self sendingAnHTTPPOSTRequestOnUpdatePostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text withToken:self.adKey withAdID:self.adID];
        
    }
    else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnArtcilePage"]){
        
        
      //  NSLog(@" dat click pe editer din ArticleView");
        
        self.suivant.hidden = true;
//        self.deleteAd.enabled = false;
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.suivant.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.addannouncementView addSubview:spinnerView];
        [self.addannouncementView bringSubviewToFront:spinnerView];
        
        [spinnerView beginRefreshing];
        
        CASES2 = 3;
        
        [self sendingAnHTTPPOSTRequestOnUpdatePostAnn:self.contactNameField.text withEmail:self.emailField.text withTitle:self.titleField.text withDetails:self.contentTextview.text withToken:self.adKey withAdID:self.adID];
    }
    

    
}
-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
        
        return YES;
        
    }
    
    else {
        
        
        return NO;
    }
}
-(void)showMessage: (NSString *)content{
    
    demo = [[OLGhostAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", content] message:nil timeout:1 dismissible:YES];
    demo.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:14.0 ];
    demo.titleLabel.textColor = [UIColor whiteColor];
    demo.backgroundColor =  [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];;
    demo.bottomContentMargin = 50;
    demo.layer.cornerRadius = 7;
    
    [demo show];
    
    
}
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSLog(@"keyboardWillShow");
   
    self.keyboardIsShowing = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.keyboardIsShowing = NO;
    
    
}
- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    heightOfKeyboard = keyboardFrameBeginRect.size.height;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",heightOfKeyboard] forKey:@"keyboardHeight"];
    
}

    



- (void)doneWithKeyboard{
    
    [self.contentTextview resignFirstResponder];
    [self.contactNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.titleField resignFirstResponder];
    [self.contentTextview resignFirstResponder];
    [UIView animateWithDuration:0.15 animations:^{
        self.addannouncementView.frame = frameOfPopUp;
        self.exitView.frame = exitButtonOrigin;
    } completion:nil];

    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
//       [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [UIView animateWithDuration:0.15 animations:^{
//        self.addannouncementView.frame = frameOfPopUp;
//        self.exitView.frame = exitButtonOrigin;
//    } completion:nil];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
//       [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [UIView animateWithDuration:0.15 animations:^{
//        self.addannouncementView.frame = frameOfPopUp;
//        self.exitView.frame = exitButtonOrigin;
//    } completion:nil];
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (IBAction)DeleteAD:(id)sender {
    if (self.canBeDeleted) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Confimez-vous la suppression de votre annonce ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *non = [UIAlertAction actionWithTitle:@"NON" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return;
            }];
            UIAlertAction *oui = [UIAlertAction actionWithTitle:@"OUI" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
                UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:@"Announcement Deleted!" message: nil preferredStyle:UIAlertControllerStyleAlert];
        
        
                [self presentViewController:confirmationAlert animated:YES completion:nil];
               [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:2];
        
                if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"editAnnClickedOnHomePage"]){
        
        
                    self.deleteAd.hidden = true;
                    self.suivant.enabled = false;
        
                    spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
                    spinnerView.circleLayer.lineWidth = 3.0;
                    spinnerView.center = self.deleteAd.center;
                    spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
                    [self.addannouncementView addSubview:spinnerView];
                    [self.addannouncementView bringSubviewToFront:spinnerView];
        
                    [spinnerView beginRefreshing];
        
                    CASES2 = 0;
        
                    [self sendingAnHTTPPOSTRequestOnDeletePostAnnwithToken:self.adKey withAdID:self.adID];
                }
                else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnSearchPage"] && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementsViewController"]){
        
                    //  NSLog(@"Am dat click pe delete din Ecranul principal din meniul search");
        
        
                    self.deleteAd.hidden = true;
                    self.suivant.enabled = false;
        
                    spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
                    spinnerView.circleLayer.lineWidth = 3.0;
                    spinnerView.center = self.deleteAd.center;
                    spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
                    [self.addannouncementView addSubview:spinnerView];
                    [self.addannouncementView bringSubviewToFront:spinnerView];
        
                    [spinnerView beginRefreshing];
        
                    CASES2 = 1;
        
                    [self sendingAnHTTPPOSTRequestOnDeletePostAnnwithToken:self.adKey withAdID:self.adID];
        
                }
                else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnSearchPage"] && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementArticleView"]){
        
        
                    //  NSLog(@"Am dat click pe delete din ArticleView din meniul Search");
        
                    self.deleteAd.hidden = true;
                    self.suivant.enabled = false;
        
                    spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
                    spinnerView.circleLayer.lineWidth = 3.0;
                    spinnerView.center = self.deleteAd.center;
                    spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
                    [self.addannouncementView addSubview:spinnerView];
                    [self.addannouncementView bringSubviewToFront:spinnerView];
        
                    [spinnerView beginRefreshing];
        
                    CASES2 = 2;
        
                    [self sendingAnHTTPPOSTRequestOnDeletePostAnnwithToken:self.adKey withAdID:self.adID];
        
                }
                else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnArtcilePage"]){
        
        
                    // NSLog(@" dat click pe delete din ArticleView");
        
                    self.deleteAd.hidden = true;
                    self.suivant.enabled = false;
        
                    spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
                    spinnerView.circleLayer.lineWidth = 3.0;
                    spinnerView.center = self.deleteAd.center;
                    spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
                    [self.addannouncementView addSubview:spinnerView];
                    [self.addannouncementView bringSubviewToFront:spinnerView];
        
                    [spinnerView beginRefreshing];
        
                    CASES2 = 3;
        
                    [self sendingAnHTTPPOSTRequestOnDeletePostAnnwithToken:self.adKey withAdID:self.adID];
        
                }
            }];
            [alert addAction:non];    
            [alert addAction:oui];
            [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    }

}
-(void)dismissAlert{
    [self dismissViewControllerAnimated:YES completion:nil];


                AnnouncementsViewController * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementsViewController"];

                child2.view.frame = self.view.bounds;

                [UIView transitionWithView:self.view duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                      
                                       [self addChildViewController:child2];
                                       [child2 didMoveToParentViewController:self];
                                       child2.view.frame = self.view.bounds;
                                       [self.view addSubview:child2.view];
                                       [self.view bringSubviewToFront:child2.view];
                                   } completion:^(BOOL finished) {
                                       if (finished){
                                   
                                       }
                                   }];
}
- (IBAction)upButtonPressed:(UIButton *)sender {
    
    if (self.contactNameField.isFirstResponder ) { [self.titleField becomeFirstResponder];
//        [arrowUp setBackgroundImage:[UIImage imageNamed:@"arrow up gray"] forState:UIControlStateNormal];
        return;}
    if (self.emailField.isFirstResponder ) { [self.contactNameField becomeFirstResponder]; return;}
    if (self.contentTextview.isFirstResponder ) { [self.emailField becomeFirstResponder];
//        [arrowDown setBackgroundImage:[UIImage imageNamed:@"arrow down"] forState:UIControlStateNormal];
          return;}
}
- (IBAction)downButtonPressed:(UIButton *)sender {
    if (self.titleField.isFirstResponder ) { [self.contactNameField becomeFirstResponder];
//        [arrowUp setBackgroundImage:[UIImage imageNamed:@"arrow up"] forState:UIControlStateNormal];
        return;}
    if (self.contactNameField.isFirstResponder ) { [self.emailField becomeFirstResponder]; return;}
    if (self.emailField.isFirstResponder ) { [self.contentTextview becomeFirstResponder];
//         [arrowDown setBackgroundImage:[UIImage imageNamed:@"arrow down gray"] forState:UIControlStateNormal];
        return;}

}

- (IBAction)okButtonPressed:(UIButton *)sender {
    
   [self.view endEditing:YES];
}

-(void)sendingAnHTTPPOSTRequestOnPostAnn: (NSString *)contact_name withEmail: (NSString *)email withTitle:(NSString *)title withDetails:(NSString *)details{
    if([self isInternet] == YES){
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url = [NSURL URLWithString:adminAjax];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        NSString *params = [NSString stringWithFormat:@"action=dgab_add_petites_annonces&contact_name=%@&contact_email=%@&title=%@&details=%@",contact_name,email,title,details];
        
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
        //    NSLog(@"%@",responseDict);
            
            if([[NSString stringWithFormat:@"%@",responseDict] isEqualToString:@"1"]){
            
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"NOUS AVONS BIEN REÇU VOTRE ANNONCE !"
                                                                                         message:@"\n• Vous devez vérifier l'adresse email \b du contact pour cette annonce. L'annonce restera désactivée tant que vous n'aurez pas fait la vérification. Un email de vérification vous a été envoyé.\n\n• Les petites annonces doivent d'abord être approuvées par un administrateur du site, avant d'être visibles en ligne. Dès qu'un administrateur aura approuvé votre petite annonce, celle-ci sera visible en ligne. Merci pour votre patience !"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [alertController addAction:actionOk];
                [self presentViewController
                 :alertController animated:YES completion:nil];
                
                NSArray *viewArray = [[[[[[[[[[[[alertController view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
                UILabel *alertMessage = viewArray[1];
                alertMessage.textAlignment = NSTextAlignmentLeft;
                
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                message:@"ERREUR"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
            [spinnerView endRefreshing];
            self.suivant.hidden = false;
            if(cases == 0){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearch" object: [NSString stringWithFormat:@"closeSearch"]];
            }
            else if(cases == 1){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
            }
            else if(cases == 2){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearch" object: [NSString stringWithFormat:@"closeSearch"]];
                
                
            }
            
        }];
        [dataTask resume];
    }
}

-(void)sendingAnHTTPPOSTRequestOnUpdatePostAnn: (NSString *)contact_name withEmail: (NSString *)email withTitle:(NSString *)title withDetails:(NSString *)details withToken:(NSString *)token withAdID:(NSString *)addID{
    
    if([self isInternet] ==  YES){
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url = [NSURL URLWithString:adminAjax];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        NSString *params = [NSString stringWithFormat:@"action=dgab_update_petites_annonces&contact_name=%@&contact_email=%@&title=%@&details=%@&ad_key=%@&ad_id=%@",contact_name,email,title,details,token,addID];
        
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
        //    NSLog(@"%@",responseDict);
            
            if([[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"success"]] isEqualToString:@"1"]){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nous avons bien reçu votre annonce !"
                                                                message:@"Annonce mise à jour"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [GlobalVariables getInstance].idOfAnnouncement = addID;
                if(CASES2 == 0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                }
                else if(CASES2 == 1){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                }
                else if(CASES2 == 2){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearch" object: [NSString stringWithFormat:@"closeSearch"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                    
                    
                }
                else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                    
                }
                
                [alert show];
                
                
                [self.contentTextview resignFirstResponder];
                [self.contactNameField resignFirstResponder];
                [self.emailField resignFirstResponder];
                [self.titleField resignFirstResponder];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                message:@"ERREUR"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
            [spinnerView endRefreshing];
            self.suivant.hidden = false;
            self.deleteAd.enabled = true;
            
            
            
        }];
        [dataTask resume];
    }
}
-(void)sendingAnHTTPPOSTRequestOnDeletePostAnnwithToken:(NSString *)token withAdID:(NSString *)addID{
    if([self isInternet] == YES) {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url = [NSURL URLWithString:adminAjax];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        NSString *params = [NSString stringWithFormat:@"action=dgab_remove_petites_annonces&ad_key=%@&ad_id=%@",token,addID];
        
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
       //     NSLog(@"%@",responseDict);
            
            if([[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"success"]] isEqualToString:@"1"]){
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Annonce supprimée !"
//                                                                message:@"Votre annonce a bien été supprimée."
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
                
                
                if(CASES2 == 0) {
                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                }
                else if(CASES2 == 1){
                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearch" object: [NSString stringWithFormat:@"closeSearch"]];
                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                }
                else if(CASES2 == 2){
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearch" object: [NSString stringWithFormat:@"closeSearch"]];
                    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
                    //   [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                    
                    
                }
                else{
                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearch" object: [NSString stringWithFormat:@"closeSearch"]];
                    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
                    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
                    
                }
                
//                [alert show];
                
                
                
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                                message:@"ERREUR"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
            [spinnerView endRefreshing];
            self.suivant.hidden = false;
            
            
            
            
        }];
        [dataTask resume];
    }
}

-(UIColor*)colorWithHexString:(NSString*)hex {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - Keyboard stuff

- (void)addNotificationsOnScreen {
    
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)removeNotificationFromScreen {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardOnScreen: (NSNotification *)notification {
    NSLog(@"keyboardOnScreen");
       [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.keyboardIsShowing = YES;

    
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame = self.addannouncementView.frame;
NSLog(@"%@", NSStringFromCGRect(self.addannouncementView.frame));
       frame.origin.y =   self.view.frame.size.height  - self.addannouncementView.frame.size.height - keyboardFrame.size.height;
        //frame.origin.y = -135;
        self.addannouncementView.frame = frame;
        
        CGRect frame1 = self.exitView.frame;
        frame1.origin.y =   self.view.frame.size.height  - self.addannouncementView.frame.size.height - keyboardFrame.size.height;
        NSLog(@"frame1.origin.y %f", frame1.origin.y);
        self.exitView.frame = frame1;
        
    } completion:nil];
    
    
}


-  (void)keyboardOffScreen: (NSNotification *)notification {
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.15 animations:^{
            NSLog(@"%@", NSStringFromCGRect(frameOfPopUp));
        self.addannouncementView.frame = frameOfPopUp;
        self.exitView.frame = exitButtonOrigin;
    } completion:nil];
    
}

@end
