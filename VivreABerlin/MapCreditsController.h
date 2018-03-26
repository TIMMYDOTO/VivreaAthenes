//
//  MapCreditsController.h
//  VivreABerlin
//
//  Created by home on 21/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCreditsController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *creditsTable;

@end
