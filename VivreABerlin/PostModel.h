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
@property (strong, nonatomic) NSMutableArray <MGLPointAnnotation *> *annotations;
@property (strong, nonatomic) NSDictionary *bounds;

@property (strong, nonatomic) NSString* phoneNumber;
@property (strong, nonatomic) NSNumber* heightForWKWebView;

@property (strong, nonatomic) NSMutableArray* arrayOfInfos;
@property (strong, nonatomic) NSMutableArray* arrayOfInfosImg;
@property (strong, nonatomic) NSMutableArray* arrayOfSchedule;

@property (assign, nonatomic) NSNumber *tagsCount;
@property (strong, nonatomic) NSMutableArray *allTagsSlugs;
@property (strong, nonatomic) NSMutableArray *allTagsName;

@property (strong, nonatomic) NSMutableArray *thumbnail;
@property (strong, nonatomic) NSMutableArray *title;
@property (strong, nonatomic) NSMutableArray *fragment;
@property (strong, nonatomic) NSMutableArray *identifier;



@property (assign, nonatomic) NSNumber* suggestionsCount;
-(PostModel *)initPostWithImageHeader:(UIImage *)imageHeader authorName:(NSString *)authorName htmlString: (NSString *)htmlString numberOfStars:(NSNumber *)numberOfStars passageText: (NSString *) passageText postTitleText:(NSString*)postTitleText ;
@end
