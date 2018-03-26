//
//  IAPViewController.h
//  VivreABerlin
//
//  Created by home on 21/06/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface IAPViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (weak, nonatomic) IBOutlet UIView *popUpView;
- (IBAction)closePopUp:(id)sender;
- (IBAction)purchaseButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *popUptitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *mapDescriptionText;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionText;
@property (weak, nonatomic) IBOutlet UIView *purchaseView;
- (IBAction)restoreIAP:(id)sender;


@end
