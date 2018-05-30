//
//  MapCreditsController.m
//  VivreABerlin
//
//  Created by home on 21/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "MapCreditsController.h"
#import "GlobalVariables.h"
#import "SimpleFilesCache.h"
#import "AFNetworking.h"

@interface MapCreditsController (){
    WKWebView *wkWebView;
    UIActivityIndicatorView *activityView;
}

@end

@implementation MapCreditsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getCreditsPhotos];
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = self.view.center;
    [activityView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:activityView];

    wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(48, 190, 268, 300) configuration:[WKWebViewConfiguration new]];
    [wkWebView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:wkWebView];
    wkWebView.navigationDelegate = self;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    [GlobalVariables getInstance].filtresIconsCaption = [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"FiltresIconsCaption"]];
    
    self.creditsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)getCreditsPhotos{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://vivreathenes.com/wp-json/wp/v2/credits-photos"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSString *htmlStr = [responseObject valueForKey:@"content"];
            htmlStr = [@"<body>" stringByAppendingString:htmlStr];
            htmlStr = [htmlStr stringByAppendingString:@"<body>"];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"openCredits" ofType:@"css"];
            
            
            NSString *cssString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            
            htmlStr = [cssString stringByAppendingString:htmlStr];
            
            
            [wkWebView loadHTMLString:htmlStr baseURL:[NSBundle mainBundle].bundleURL];
            [activityView removeFromSuperview];
        }
    }];
    [dataTask resume];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
    if (!navigationAction.targetFrame) {
        NSURL *url = navigationAction.request.URL;
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[GlobalVariables getInstance].filtresIconsCaption[indexPath.row]];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.adjustsFontSizeToFitWidth = true;
    
    
    [self.creditsTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.creditsTable setSeparatorColor:[UIColor blueColor]];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.creditsTable)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
