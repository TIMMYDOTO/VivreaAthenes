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

@interface PopUpNewsletterController ()

@end

@implementation PopUpNewsletterController {
    
    JTMaterialSpinner * spinner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.popupView)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseDict);
        
        self.resultLabel.hidden = false;
        
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
        }
        [spinner endRefreshing];
        
    }];
    [dataTask resume];
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
