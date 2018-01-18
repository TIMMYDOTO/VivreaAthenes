//
//  UIImageView+Network.m
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import "UIImageView+Network.h"
#import <objc/runtime.h>
#import "SimpleFilesCache.h"

static char URL_KEY;


@implementation UIImageView(Network)

@dynamic imageURL;

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key {
    
	self.imageURL = url;
	self.image = placeholder;
    
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@":" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"." withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
	NSData *cachedData = [SimpleFilesCache cachedDataWithName:key];
    
	if (cachedData) {   
 	   self.imageURL   = nil;
 	   self.image      = [UIImage imageWithData:cachedData];
        
	   return;
	}

    
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSData *data = [NSData dataWithContentsOfURL:url];
        
		
		UIImage *imageFromData = [UIImage imageWithData:data];
		
        
        
		[SimpleFilesCache saveToCacheDirectory:data withName:key];

		if (imageFromData) {
			if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					self.image = imageFromData;
                   

				});
			} else {
                NSLog(@"%@ URL NEBUUUUUN",url);
			}
		}
        else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.image = [UIImage imageNamed:@"PlaceHolderImage.png"];
                
            });
            
        }

		self.imageURL = nil;
	});
    
}

- (void) setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
	return objc_getAssociatedObject(self, &URL_KEY);
}


@end
