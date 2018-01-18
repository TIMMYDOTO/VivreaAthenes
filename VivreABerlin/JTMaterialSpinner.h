//
//  JTMaterialSpinner.h
//  JTMaterialSpinner
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>hgtw345rtcfgvx zerbgt5u7i8

@interface JTMaterialSpinner : UIView

@property (nonatomic, readonly) CAShapeLayer *circleLayer;
@property (nonatomic) BOOL isAnimating;

/*!
 * Force the start of the animation. When an app is closed the animatin is stopped but `isAnimating` is still at `YES`.
 */
- (void)forceBeginRefreshing;

/*!
 * Start the animation if `isAnimating` is at `NO`
 */
- (void)beginRefreshing;

/*!
 * Stop the animation
 */
- (void)endRefreshing;

@end
