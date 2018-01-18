//
//  GlobalVariables.h
//  GuessIt
//
//  Created by home on 10/13/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JTMaterialSpinner.h"

@interface GlobalVariables : NSObject

@property(nonatomic) NSString* idOfPost;
@property(nonatomic) NSString* idOfAnnouncement;
@property(nonatomic) NSString* currentViewController;
@property(nonatomic) NSString* comingFrom;
@property(nonatomic) NSString* comingFromViewController;
@property(nonatomic) NSString* idOfcatSubCat;
@property(nonatomic) NSString* subCatSlugNumber;
@property(nonatomic) NSString* nameOfcatSubCat;
@property(nonatomic) NSString* comingFromForAgenda;
@property(nonatomic) NSString* urlOfImageClicked;
@property(nonatomic) NSString* announcementImageUrl;
@property(nonatomic) NSString* categoryColor;
@property(nonatomic) NSString* backGroundImageTag;
@property(nonatomic) NSString* currentAnnouncementScreen;
@property(nonatomic) NSString* currentPopUpAnnouncementScreen;
@property(nonatomic) NSString* currentPopUpAnnouncementScreenForEditer;
@property(nonatomic) BOOL editerClicked;
@property(nonatomic) BOOL zoomingImageClickedFromTagAgenda;
@property(nonatomic) NSMutableArray* categoriesOfMenu;
@property(nonatomic) NSMutableDictionary * MapPageInfos;
@property(nonatomic) CLLocation * lastUserLocation;
@property(nonatomic) NSMutableArray * arrayWithAnnotations;
@property(nonatomic) NSMutableArray * Annotations;
@property(nonatomic) NSMutableArray * deleteAnnotationsArray;
@property(nonatomic) NSMutableArray * CarouselOfPostIds;
@property(nonatomic) NSMutableArray * allCategoriesName;
@property(nonatomic) NSDictionary * myLaunchOptions;
@property(nonatomic) NSMutableArray * allCategoriesSlugs;
@property(nonatomic) NSString* slugName;
@property(nonatomic) NSMutableDictionary * DictionaryWithAllPosts;
@property(nonatomic) NSMutableDictionary * DictionaryWithAllAnnouncements;
@property(nonatomic) BOOL  canFilter;
@property(nonatomic) BOOL  canDisplayInterstitials;
@property(nonatomic) int  delayBetweenInterstitials;
@property(nonatomic) BOOL  finishedLoading;
@property(nonatomic) BOOL  PerSession;
@property(nonatomic) BOOL  PerSessionForFilters;
@property(nonatomic) BOOL  isUserSearchingOnSideBar;
@property(nonatomic) BOOL  backToPostHasToBeHidden;
@property(nonatomic) float latitudine;
@property(nonatomic) float longitudine;
@property(nonatomic) float zoomLvl;
@property(nonatomic) float lastLatitudine;
@property(nonatomic) float lastLongitudine;
@property(nonatomic) float lastZoomLvl;
@property(nonatomic) BOOL  comingFromPostView;
@property(nonatomic) NSString *textSearched;
@property(nonatomic) NSMutableArray *filtresIconsCaption;
@property(nonatomic) NSMutableArray *agendaArticleInfo;
@property(nonatomic) float fontsize;

@property(nonatomic) BOOL  canDisplayTicketsWebView;
@property(nonatomic) NSString *sectionTagTickets;
@property(nonatomic) NSString *sectionTagNameTickets;
+(GlobalVariables*) getInstance;

@end
