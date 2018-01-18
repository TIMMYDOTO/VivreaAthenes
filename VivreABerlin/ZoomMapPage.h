//
//  ZoomMapPage.h
//  VivreABerlin
//
//  Created by home on 13/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Mapbox;
@interface ZoomMapPage : UIViewController <MGLMapViewDelegate>
- (IBAction)closeZoomMapPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeZoomMapPage;
@property (strong, nonatomic) MGLMapView * ZoomMapView;
@end
