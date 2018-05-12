//
//  PostModel.h
//  VivreABerlin
//
//  Created by Artyom Schiopu on 5/7/18.
//  Copyright © 2018 Stoica Mihail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Mapbox;
@interface PostModel : NSObject
@property (strong, nonatomic) UIImage* imageHeader;
@property (strong, nonatomic) NSString* authorName;
@property (strong, nonatomic) NSString* htmlString;
@property (strong, nonatomic) NSNumber* numberOfStars;
@property (strong, nonatomic) NSString* passageText;
@property (strong, nonatomic) NSString* postTitleText;

@property (strong, nonatomic) MGLMapView *postMapView;
@property (strong, nonatomic) MGLPointAnnotation *point;
@property (assign, nonatomic) NSNumber *hasInfos;
@property (strong, nonatomic) NSString* phoneNumber;
@property (strong, nonatomic) NSNumber* heightForWKWebView;
-(PostModel *)initPostWithImageHeader:(UIImage *)imageHeader authorName:(NSString *)authorName htmlString: (NSString *)htmlString numberOfStars:(NSNumber *)numberOfStars passageText: (NSString *) passageText postTitleText:(NSString*)postTitleText ;
@end
