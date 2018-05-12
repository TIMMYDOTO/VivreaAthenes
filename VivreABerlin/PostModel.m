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
    [aCoder encodeObject: self.point forKey: @"point"];
    [aCoder encodeObject: self.heightForWKWebView forKey: @"heightForWKWebView"];
    [aCoder encodeObject: self.postTitleText forKey: @"postTitleText"];
    [aCoder encodeObject: self.passageText forKey: @"passageText"];
   
    //    [aCoder encodeObject: self.content forKey: @"content"];
    //    [aCoder encodeObject: self.content forKey: @"content"];

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super init]) {
        
        self.imageHeader = [aDecoder decodeObjectForKey: @"imageHeader"];
        self.authorName = [aDecoder decodeObjectForKey: @"authorName"];
        self.htmlString = [aDecoder decodeObjectForKey: @"htmlString"];
        self.numberOfStars = [aDecoder decodeObjectForKey: @"numberOfStars"];
        self.postMapView = [aDecoder decodeObjectForKey: @"postMapView"];
        self.point = [aDecoder decodeObjectForKey: @"point"];
        
        self.heightForWKWebView = [aDecoder decodeObjectForKey: @"heightForWKWebView"];
        self.postTitleText = [aDecoder decodeObjectForKey:@"postTitleText"];
        self.passageText = [aDecoder decodeObjectForKey:@"passageText"];
       
        //        self.content = [aDecoder decodeObjectForKey: @"content"];
        //        self.content = [aDecoder decodeObjectForKey: @"content"];
        //        self.content = [aDecoder decodeObjectForKey: @"content"];
        
    }
    return self;
    
}
@end
