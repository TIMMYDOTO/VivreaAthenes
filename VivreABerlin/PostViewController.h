//
//  PostViewController.h
//  VivreABerlin
//
//  Created by Artyom Schiopu on 4/26/18.
//  Copyright © 2018 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@import Mapbox;
@interface PostViewController : UIViewController <MGLMapViewDelegate, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextViewDelegate>
@property(retain, nonatomic) IBOutletCollection(UILabel) NSMutableArray *arrScheduleLabels;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MGLMapView *postMapView;
@property (weak, nonatomic) IBOutlet UILabel *articleEnregistre;


@property (retain, nonatomic) NSMutableArray *arrOfId;
@end
