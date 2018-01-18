//
//  EditAnnouncement.m
//  VivreABerlin
//
//  Created by home on 16/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "EditAnnouncement.h"
#import "GlobalVariables.h"
#import "OLGhostAlertView.h"
#import "AddAnnouncement.h"
#import "Header.h"
#import "Reachability.h"

@interface EditAnnouncement ()

@end

@implementation EditAnnouncement
{
    BOOL keyboardIsShowing;
    JTMaterialSpinner *spinnerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bigView.layer.cornerRadius = 5;
    self.bigView.clipsToBounds = true;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.emailView.layer.cornerRadius = self.emailView.frame.size.height/2;
    self.emailView.clipsToBounds = true;
    self.tokenView.layer.cornerRadius = self.tokenView.frame.size.height/2;
    self.emailView.clipsToBounds = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    keyboardIsShowing = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getBack:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(keyboardIsShowing == YES)
    {
        [self.emailfield resignFirstResponder];
        [self.tokenField resignFirstResponder];
    }
    else{
        UITouch *touch=[[event allTouches] anyObject];
        if([touch view] != self.bigView)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        }
    }
}
-(void)showMessage: (NSString *)content{
    
    OLGhostAlertView *demo = [[OLGhostAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", content] message:nil timeout:1 dismissible:YES];
    demo.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:14.0 ];
    demo.titleLabel.textColor = [UIColor whiteColor];
    demo.backgroundColor =  [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];;
    demo.bottomContentMargin = 50;
    demo.layer.cornerRadius = 7;
    
    [demo show];
    
    
}
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    keyboardIsShowing = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    keyboardIsShowing = NO;
    
    
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
-(void)sendingAnHTTPPOSTRequestEditAnnWithToken: (NSString *)token withEmail: (NSString *)email {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:adminAjax];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *params = [NSString stringWithFormat:@"action=dgab_edit_petites_annonces&ad_key=%@&contact_email=%@",token,email];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
     //   NSLog(@"%@",responseDict);
        
        if([responseDict count]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BRAVO !"
                                                            message:@"Vous pouvez éditer votre annonce"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            
            AddAnnouncement * child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAnnouncement"];
            child2.titleeeee = [responseDict valueForKey:@"title"];
            child2.emailContact = [responseDict valueForKey:@"contact_email"];
            child2.contactName = [responseDict valueForKey:@"contact_name"];
            child2.adID = [responseDict valueForKey:@"ad_id"];
            child2.adKey = [responseDict valueForKey:@"ad_key"];
            child2.details = [responseDict valueForKey:@"details"];
            child2.view.frame = self.view.bounds;
            
            
            [UIView transitionWithView:self.view duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                   [self addChildViewController:child2];
                                   [child2 didMoveToParentViewController:self];
                                   child2.view.frame = self.view.bounds;
                                   [self.view addSubview:child2.view];
                                   [self.view bringSubviewToFront:child2.view];
                               } completion:nil];

            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR!"
                                                            message:@"Merci de vérifier les infos saisies dans les champs"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        [spinnerView endRefreshing];
        [self.tokenField resignFirstResponder];
        [self.emailfield resignFirstResponder];
        self.continueButton.hidden = false;
    }];
    [dataTask resume];
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

- (IBAction)continue:(id)sender {
//    if([self isInternet] == NO){
//        [self showMessage:@"Connexion internet requise"];
//    }
//    else if(![self NSStringIsValidEmail:self.emailfield.text]){
//        [self showMessage:@"Invalid Email"];
//    }
//    else if(self.emailfield.text.length > 0 && self.tokenField.text.length > 0)
//    {
        [GlobalVariables getInstance].editerClicked = YES;
        
        spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0,0,35,35)];
        spinnerView.circleLayer.lineWidth = 3.0;
        spinnerView.center = self.continueButton.center;
        spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
        
        [self.bigView addSubview:spinnerView];
        [self.bigView bringSubviewToFront:spinnerView];
        
        self.continueButton.hidden = true;
        [spinnerView beginRefreshing];
        
        [self sendingAnHTTPPOSTRequestEditAnnWithToken:self.tokenField.text withEmail:self.emailfield.text];
        
        
        
        
//    }
//    else{
//        [self showMessage:@"Merci de remplir tous les champs"];
//    }

}
@end
