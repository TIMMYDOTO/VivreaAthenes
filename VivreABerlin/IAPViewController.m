//
//  IAPViewController.m
//  VivreABerlin
//
//  Created by home on 21/06/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "IAPViewController.h"
#import "GlobalVariables.h"
#import "Header.h"
#import "JTMaterialSpinner.h"
#import "Reachability.h"
#import "OLGhostAlertView.h"


@interface IAPViewController ()

@end

@implementation IAPViewController

{
    JTMaterialSpinner *spinner;
    BOOL popUpappeared;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.subtitle.adjustsFontSizeToFitWidth = true;
    self.popUptitle.adjustsFontSizeToFitWidth = true;
    self.mapDescriptionText.adjustsFontSizeToFitWidth = true;
    self.postDescriptionText.adjustsFontSizeToFitWidth = true;
    popUpappeared = true;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.popUpView && [touch view] != self.purchaseView  && popUpappeared == true)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    
}


- (IBAction)closePopUp:(id)sender {
//    if(popUpappeared == true)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    

}

- (IBAction)purchaseButton:(id)sender {
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) ){
    popUpappeared = false;
  //  NSLog(@"User requests to unlock category");
    
    self.purchaseView.hidden = true;
    spinner = [[JTMaterialSpinner alloc] init];
    spinner.circleLayer.lineWidth = 4.0;
    spinner.frame = CGRectMake(self.popUpView.frame.size.width/2 - 22, self.postDescriptionText.frame.size.height + self.postDescriptionText.frame.origin.y + 10, 45, 45);
    spinner.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    [self.popUpView addSubview:spinner];
    [self.popUpView bringSubviewToFront:spinner];
    [spinner beginRefreshing];



    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] init];
        
        productsRequest = [productsRequest initWithProductIdentifiers:[NSSet setWithObject:IAPID]];
        
        
        productsRequest.delegate = self;
        [productsRequest start];
        
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }

        
    }
    else{
        [self showMessage:@"Connexion internet requise"];
    }
    
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}


- (void)purchase:(SKProduct *)product{
    
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        //if you have multiple in app purchases in your app,
        //you can get the product identifier of this transaction
        //by using transaction.payment.productIdentifier
        //
        //then, check the identifier against the product IDs
        //that you have defined to check which product the user
        //just purchased
        
  
        
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
            {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [spinner endRefreshing];
                    [spinner removeFromSuperview];
                    self.purchaseView.hidden = false;
                    popUpappeared = true;
                    
                });
            }
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"MapViewController"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"startDownloadingMap"]];
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"didUserPurchasedIap"];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UserBoughtTheMap"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");

                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}


- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");

 
            
//            NSString *productID = transaction.payment.productIdentifier;
//            NSLog (@"product id is %@" , productID);

            self.purchaseView.hidden = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"MapViewController"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"startDownloadingMap"]];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"didUserPurchasedIap"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UserBoughtTheMap"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ONcetime"];
            
            
            //[self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (IBAction)restoreIAP:(id)sender {
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) ){
    popUpappeared = false;
    self.purchaseView.hidden = true;
    spinner = [[JTMaterialSpinner alloc] init];
    spinner.circleLayer.lineWidth = 4.0;
    spinner.frame = CGRectMake(self.popUpView.frame.size.width/2 - 22, self.postDescriptionText.frame.size.height + self.postDescriptionText.frame.origin.y + 10, 45, 45);
    spinner.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    [self.popUpView addSubview:spinner];
    [self.popUpView bringSubviewToFront:spinner];
    [spinner beginRefreshing];

    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [spinner endRefreshing];
        [spinner removeFromSuperview];
        self.purchaseView.hidden = false;
        popUpappeared = true;
        
    });
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
    }
    else{
        [self showMessage:@"Connexion internet requise"];
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
