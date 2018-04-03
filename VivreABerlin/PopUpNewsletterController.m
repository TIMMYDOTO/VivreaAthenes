//
//  PopUpNewsletterController.m
//  VivreABerlin
//
//  Created by Stoica Mihail on 06/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "PopUpNewsletterController.h"
#import "Header.h"
#import "JTMaterialSpinner.h"
#import "Reachability.h"

@interface PopUpNewsletterController (){
    
    __weak IBOutlet UIView *nameView;
    __weak IBOutlet UIView *emailView;
}

@end

@implementation PopUpNewsletterController {
 
    JTMaterialSpinner * spinner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    emailView.layer.cornerRadius = emailView.frame.size.height/2;
    emailView.clipsToBounds = true;
    nameView.layer.cornerRadius = emailView.frame.size.height/2;
    nameView.clipsToBounds = true;
    
    self.enterEmailFiel.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"VOTRE MAIL"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                                 NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Light" size:17.0]
                                                 }
     ];
    
    self.enterNameField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"VOTRE NOM"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                                 NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Light" size:17.0]
                                                 }
     ];
    self.enterEmailFiel.adjustsFontSizeToFitWidth = true;
    self.enterNameField.adjustsFontSizeToFitWidth = true;
    
    // Do any additional setup after loading the view.
    self.newsletterText.adjustsFontSizeToFitWidth = true;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    self.newsletterView.layer.cornerRadius = self.newsletterView.frame.size.height/2;
    self.newsletterView.clipsToBounds = true;
    
    self.popupView.layer.cornerRadius = self.popupView.frame.size.height/23;
    self.popupView.clipsToBounds = true;
    
    self.enterNameField.text = @"";
    self.enterEmailFiel.text = @"";
    self.enterEmailFiel.textColor = [UIColor blackColor];
    
    spinner = [[JTMaterialSpinner alloc] init];
    spinner.circleLayer.lineWidth = 4.0;
    spinner.circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    
    [self.popupView addSubview:spinner];
    [self.popupView bringSubviewToFront: spinner];
    
    
    CGRect newFrame = CGRectMake(self.enterNameField.frame.size.width/2+self.enterNameField.frame.origin.x - 22, self.enterEmailFiel.frame.origin.y + self.enterEmailFiel.frame.size.height -3, 45, 45);
    spinner.frame = newFrame;
    
    self.enterNameField.delegate = self;
    self.enterEmailFiel.delegate = self;
    
    self.resultLabel.hidden = true;
    
}

+(BOOL) validateStringContainsAlphabetsOnly:(NSString*)strng
{
    NSCharacterSet *strCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];//1234567890_"];
    
    strCharSet = [strCharSet invertedSet];
    //And you can then use a string method to find if your string contains anything in the inverted set:
    
    NSRange r = [strng rangeOfCharacterFromSet:strCharSet];
    if (r.location != NSNotFound) {
        
        
        
        return NO;
    }
    else
     
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.popupView)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}



- (IBAction)submitButton:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.submitLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.submitLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.submitLabel.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    if ([self NSStringIsValidEmail:self.enterEmailFiel.text] == NO || self.enterEmailFiel.text.length == 0) {
        [emailView.layer setBorderColor:[UIColor redColor].CGColor];
        [emailView.layer setBorderWidth:1.5f];
        return;
    }
    else {
         [emailView.layer setBorderWidth:0.f];
    }
    if ([PopUpNewsletterController validateStringContainsAlphabetsOnly:self.enterNameField.text] == false || self.enterNameField.text.length == 0) {
            [nameView.layer setBorderColor:[UIColor redColor].CGColor];
            [nameView.layer setBorderWidth:1.5f];
        return;
        }
    else{
        [nameView.layer setBorderWidth:0.f];
    }
   
    
    
    
    
    if([self isInternet] ==  YES) {
    [spinner beginRefreshing];
    [self sendingAnHTTPPOSTRequestOniOSWithUserkey:subscribeKey withEmail:self.enterEmailFiel.text withName:self.enterNameField.text];
    }
    else {
        self.resultLabel.hidden = false;
        self.resultLabel.textColor = [UIColor redColor];
        self.resultLabel.text = @"No internet";
        [self shakeAnimation:self.resultLabel];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    self.resultLabel.hidden = true;
    
    if (sender == self.enterEmailFiel){
        self.enterEmailFiel.text = @"";
        self.enterEmailFiel.textColor = [UIColor blackColor];
    }
    else {
        self.enterNameField.text = @"";
        self.enterNameField.textColor = [UIColor blackColor];
    }


}

-(void)sendingAnHTTPPOSTRequestOniOSWithUserkey: (NSString *)key withEmail: (NSString *)email withName: (NSString* )name{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:adminAjax];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *params = [NSString stringWithFormat:@"action=dgab_newsletter_subscribe&nk=%@&ne=%@&nn=%@",key,email,name];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response %@", response);
        NSLog(@"error %@", error);
        NSDictionary *responseDict = [NSDictionary dictionary];
       responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseDict);
        
        self.resultLabel.hidden = false;
//        NSLog(@"%@", [responseDict valueForKey:@"message"] );
        if (responseDict != 0) {
            if ([[responseDict valueForKey:@"message"] isEqualToString:@"already_confirmed"]){
                self.resultLabel.textColor = [UIColor orangeColor];
                self.resultLabel.text = @"Already a subscriber";
                [self shakeAnimation:self.resultLabel];
                
            }
            else if ([[responseDict valueForKey:@"message"] isEqualToString:@"Wrong email"]){
                self.resultLabel.textColor = [UIColor redColor];
                self.resultLabel.text = @"Wrong email";
                [self shakeAnimation:self.resultLabel];
            }
            else {
                self.resultLabel.textColor = [UIColor greenColor];
                self.resultLabel.text = @"Confirmation sent";
                [self shakeAnimation:self.resultLabel];
                
           
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                });
                
            }
        }
      
        [spinner endRefreshing];
        
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
-(void)shakeAnimation:(UILabel*) label
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:3];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(label.center.x - 5,label.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(label.center.x + 5, label.center.y)]];
    [label.layer addAnimation:shake forKey:@"position"];
}

-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
        NSLog(@"User has internet");
        return YES;
        
    }
    
    else {
        NSLog(@"User doesn't have internet");
        
        return NO;
    }
}
@end
