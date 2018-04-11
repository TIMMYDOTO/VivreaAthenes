//
//  OnboardingFirstViewController.m
//  VivreABerlin
//
//  Created by home on 17/11/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "OnboardingFirstViewController.h"
#import "Header.h"
#import "Reachability.h"
#import "JTMaterialSpinner.h"
#import "OLGhostAlertView.h"

@interface OnboardingFirstViewController ()

@end

@implementation OnboardingFirstViewController
{
     JTMaterialSpinner * spinner;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.redCircle.layer.cornerRadius = self.redCircle.frame.size.height/2;
    self.redCircle.clipsToBounds = true;
    self.leftView.layer.cornerRadius = self.leftView.frame.size.height/2;
    self.leftView.clipsToBounds = true;
    self.rigthView.layer.cornerRadius = self.rigthView.frame.size.height/2;
    self.rigthView.clipsToBounds = true;
    self.midView.layer.cornerRadius = self.midView.frame.size.height/2;
    self.midView.clipsToBounds = true;
    [self.registerNewsLetter.layer setCornerRadius:5];
    [self.registerNewsLetter setClipsToBounds:YES];
    
    self.emailField.delegate = self;
    self.nameField.delegate = self;
    
    spinner = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 22, 45, 45)];
    spinner.circleLayer.lineWidth = 4.0;
    spinner.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    spinner.center = self.bigImageNewsLetter.center;
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    
    self.registerNewsLetter.layer.masksToBounds = NO;
    self.registerNewsLetter.layer.shadowOffset = CGSizeMake(0, 5);
    self.registerNewsLetter.layer.shadowRadius = 3;
    self.registerNewsLetter.layer.shadowOpacity = 0.25;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.gradientView.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor whiteColor].CGColor,
                            //(id)[UIColor whiteColor].CGColor,
                            (id)[UIColor colorWithRed:255/255.0f green:222/255.0f blue:200/255.0f alpha:1.0f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               // [NSNumber numberWithFloat:0.3f],
                               [NSNumber numberWithFloat:0.7f],
                               nil];
    
    [self.gradientView.layer addSublayer:gradientLayer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)nextPage:(id)sender {
    [self.redCircle removeFromSuperview];
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteSecondScreen" object: [NSString stringWithFormat:@"DeleteSecondScreen"]];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteFirstScreen" object: [NSString stringWithFormat:@"DeleteFirstScreen"]];
  
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"showStartUpScreens"];
    
    
}
- (IBAction)previousPage:(id)sender {

    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                           self.view.alpha = 0;
                       } completion:^(BOOL finished){
                           [self willMoveToParentViewController:nil];
                           [self.view removeFromSuperview];
                           [self removeFromParentViewController];
                       }];
    
}
- (IBAction)registerNewsLetter:(id)sender {
    
    if(self.emailField.text.length != 0 || self.nameField.text.length != 0){
        
    if([self isInternet] ==  YES) {
        [spinner beginRefreshing];
        [self sendingAnHTTPPOSTRequestOniOSWithUserkey:subscribeKey withEmail:self.emailField.text withName:self.nameField.text];
    }
    else
        [self showMessage:@"Connexion internet requise"];
    }
    else{
         [self showMessage:@"Attention : merci de remplir tous les champs pour valider"];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    
    if (sender == self.emailField){
        self.emailField.text = @"";
        self.emailField.textColor = [UIColor blackColor];
    }
    else {
        self.nameField.text = @"";
        self.nameField.textColor = [UIColor blackColor];
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
        
       
        
        if ([[responseDict valueForKey:@"message"] isEqualToString:@"already_confirmed"]){
            
             [self showMessage:@"Déjà inscrit !"];
        }
        else if ([[responseDict valueForKey:@"message"] isEqualToString:@"Wrong email"]){
      
      
            [self showMessage:@"Wrong email"];
        }
        else {
    
            [self showMessage:@"Confirmation envoyée"];
            
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteSecondScreen" object: [NSString stringWithFormat:@"DeleteSecondScreen"]];
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteFirstScreen" object: [NSString stringWithFormat:@"DeleteFirstScreen"]];
            
            [self dismissViewControllerAnimated:NO completion:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"showStartUpScreens"];
        }
        
        [spinner endRefreshing];
        
    }];
    [dataTask resume];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.emailField resignFirstResponder];
        [self.nameField resignFirstResponder];
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
@end
