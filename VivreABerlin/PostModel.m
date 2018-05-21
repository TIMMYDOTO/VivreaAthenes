//
//  PostModel.m
//  VivreABerlin
//
//  Created by Artyom Schiopu on 5/7/18.
//  Copyright © 2018 Stoica Mihail. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel
-(id)init{
    self = [super init];
        return  self;
    
}

-(PostModel *)initPostWithImageHeader:(UIImage *)imageHeader authorName:(NSString *)authorName htmlString: (NSString *)htmlString numberOfStars:(NSNumber *)numberOfStars passageText: (NSString *) passageText postTitleText:(NSString*)postTitleText {
    self.imageHeader = imageHeader;
    self.authorName = authorName;
    self.htmlString = htmlString;
    self.numberOfStars = numberOfStars;
    self.postTitleText = postTitleText;
    self.passageText = passageText;
  
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject: self.imageHeader forKey: @"imageHeader"];
    [aCoder encodeObject: self.authorName forKey: @"authorName"];
    [aCoder encodeObject: self.htmlString forKey: @"htmlString"];
    [aCoder encodeObject: self.numberOfStars forKey: @"numberOfStars"];
    [aCoder encodeObject: self.postMapView forKey: @"postMapView"];
    [aCoder encodeObject: self.annotations forKey: @"annotations"];
    [aCoder encodeObject: self.heightForWKWebView forKey: @"heightForWKWebView"];
    [aCoder encodeObject: self.postTitleText forKey: @"postTitleText"];
    [aCoder encodeObject: self.passageText forKey: @"passageText"];

    [aCoder encodeObject: self.arrayOfInfos forKey: @"arrayOfInfos"];
    [aCoder encodeObject: self.arrayOfInfosImg forKey: @"arrayOfInfosImg"];
    
    [aCoder encodeObject: self.arrayOfSchedule forKey: @"arrayOfSchedule"];
    
    [aCoder encodeObject: self.tagsCount forKey: @"tagsCount"];
     [aCoder encodeObject: self.allTagsSlugs forKey: @"allTagsSlugs"];
       [aCoder encodeObject: self.allTagsName forKey: @"allTagsName"];
    
        [aCoder encodeObject: self.suggestionsCount forKey: @"suggestionsCount"];
    
        [aCoder encodeObject: self.thumbnail forKey: @"thumbnail"];
        [aCoder encodeObject: self.title forKey: @"title"];
         [aCoder encodeObject: self.fragment forKey: @"fragment"];
         [aCoder encodeObject: self.identifier forKey: @"identifier"];
        [aCoder encodeObject: self.bounds forKey: @"bounds"];
    


}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super init]) {
        
        self.imageHeader = [aDecoder decodeObjectForKey: @"imageHeader"];
        self.authorName = [aDecoder decodeObjectForKey: @"authorName"];
        self.htmlString = [aDecoder decodeObjectForKey: @"htmlString"];
        self.numberOfStars = [aDecoder decodeObjectForKey: @"numberOfStars"];
        self.postMapView = [aDecoder decodeObjectForKey: @"postMapView"];
        self.annotations = [aDecoder decodeObjectForKey: @"annotations"];
        
        self.heightForWKWebView = [aDecoder decodeObjectForKey: @"heightForWKWebView"];
        self.postTitleText = [aDecoder decodeObjectForKey:@"postTitleText"];
        self.passageText = [aDecoder decodeObjectForKey:@"passageText"];
       
        self.arrayOfInfos = [aDecoder decodeObjectForKey: @"arrayOfInfos"];
        self.arrayOfInfosImg = [aDecoder decodeObjectForKey: @"arrayOfInfosImg"];
        self.arrayOfSchedule = [aDecoder decodeObjectForKey: @"arrayOfSchedule"];
        
        self.tagsCount = [aDecoder decodeObjectForKey: @"tagsCount"];
        self.allTagsSlugs = [aDecoder decodeObjectForKey: @"allTagsSlugs"];
         self.allTagsName = [aDecoder decodeObjectForKey: @"allTagsName"];
        
             self.suggestionsCount = [aDecoder decodeObjectForKey: @"suggestionsCount"];
                self.thumbnail = [aDecoder decodeObjectForKey: @"thumbnail"];
                self.title = [aDecoder decodeObjectForKey: @"title"];
                self.fragment = [aDecoder decodeObjectForKey: @"fragment"];
                self.identifier = [aDecoder decodeObjectForKey: @"identifier"];
         self.bounds = [aDecoder decodeObjectForKey: @"bounds"];
    }
    return self;
    
}
@end
