//
//  CreditsViewController.h
//  VivreABerlin
//
//  Created by home on 24/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditsViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bigView;
- (IBAction)firstButton:(id)sender;
- (IBAction)secondButton:(id)sender;
- (IBAction)thirdButton:(id)sender;
- (IBAction)forthButton:(id)sender;
- (IBAction)closePopUp:(id)sender;

@end
