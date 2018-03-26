//
//  CreditsViewController.m
//  VivreABerlin
//
//  Created by home on 24/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "CreditsViewController.h"
#import "Header.h"
#import "JTMaterialSpinner.h"
@interface CreditsViewController ()

@end

@implementation CreditsViewController
{
    UIWebView *webViewCustom;
    JTMaterialSpinner *creditSpinner;
    
    BOOL rulesOnce;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.bigView.layer.cornerRadius = self.bigView.frame.size.width/23;
    self.bigView.clipsToBounds = true;
    
    
    
    creditSpinner = [[JTMaterialSpinner alloc] init];
    creditSpinner.frame = CGRectMake(self.view.frame.size.width * 0.3, self.view.frame.size.height * 0.1, 45, 45);
    creditSpinner.center = self.view.center;
    creditSpinner.circleLayer.lineWidth = 4.0;
    creditSpinner.circleLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    
    
    webViewCustom = [[UIWebView alloc]initWithFrame:self.view.frame];
    webViewCustom.backgroundColor = [UIColor clearColor];
    webViewCustom.delegate = self;
    webViewCustom.scrollView.delegate = self;
    rulesOnce = true;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.bigView)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
    
}
- (IBAction)firstButton:(id)sender {
//    [self.view addSubview:webViewCustom];
//    [self.view bringSubviewToFront:webViewCustom];
//    [webViewCustom addSubview:creditSpinner];
//    [webViewCustom bringSubviewToFront:creditSpinner];
//    [creditSpinner beginRefreshing];
//    
//    
//    NSURL *url = [NSURL URLWithString:ContactsetCredits];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [webViewCustom loadRequest:urlRequest];

    
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ContactsetCredits]  options:@{} completionHandler:nil];
//    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ContactsetCredits]])
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ContactsetCredits]];
//              [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(rulesOnce){
    [webViewCustom.scrollView setContentOffset:CGPointMake(0, self.view.frame.size.height/4)];
    rulesOnce = false;
    }
    dispatch_time_t popTimee = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_after(popTimee, dispatch_get_main_queue(), ^(void){
    [creditSpinner endRefreshing];

    });
}


- (IBAction)secondButton:(id)sender {
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:Mentionslegales]  options:@{} completionHandler:nil];
//    [self.view addSubview:webViewCustom];
//    [self.view bringSubviewToFront:webViewCustom];
//    [webViewCustom addSubview:creditSpinner];
//    [webViewCustom bringSubviewToFront:creditSpinner];
//    [creditSpinner beginRefreshing];
//
//    NSURL *url = [NSURL URLWithString:Mentionslegales];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [webViewCustom loadRequest:urlRequest];
//
//
//    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:Mentionslegales]])
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Mentionslegales]];
//              [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
}

- (IBAction)thirdButton:(id)sender {
//
//    [self.view addSubview:webViewCustom];
//    [self.view bringSubviewToFront:webViewCustom];
//    [webViewCustom addSubview:creditSpinner];
//    [webViewCustom bringSubviewToFront:creditSpinner];
//    [creditSpinner beginRefreshing];
//
//    NSURL *url = [NSURL URLWithString:PartenairesPub];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [webViewCustom loadRequest:urlRequest];
    
////
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:PartenairesPub]  options:@{} completionHandler:nil];
//    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PartenairesPub]]){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PartenairesPub]];
//              [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
//    }
}

- (IBAction)forthButton:(id)sender {
    
//    [self.view addSubview:webViewCustom];
//    [self.view bringSubviewToFront:webViewCustom];
//    [webViewCustom addSubview:creditSpinner];
//    [webViewCustom bringSubviewToFront:creditSpinner];
//    [creditSpinner beginRefreshing];
//
//    NSURL *url = [NSURL URLWithString:Quisommesnous];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [webViewCustom loadRequest:urlRequest];
//
//    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:Quisommesnous]]){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Quisommesnous]];
//
//              [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
//    }
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:Quisommesnous]  options:@{} completionHandler:nil];
}

- (IBAction)closePopUp:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
          //[[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y < self.view.frame.size.height/4){
        [scrollView setContentOffset:CGPointMake(0, self.view.frame.size.height/4)];
    }
    if(scrollView.contentOffset.y > webViewCustom.scrollView.contentSize.height - self.view.frame.size.height )
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
        
}
@end
