    //
//  SimpleFilesCache.m
//

#import <UIKit/UIKit.h>

#import "SimpleFilesCache.h"

@implementation SimpleFilesCache
{
    NSString *_cacheNamespace;
}

#pragma mark - Supporting Methods

///
/// Gets the base NSCachesDirectory path
///
+(NSString *)cachesDirectoryName
{
    static NSString *cachePath = nil;
    if(!cachePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cachePath = [paths objectAtIndex:0];
    }
    
    return cachePath;
}

///
/// Builds paths for identifiers in the cache directory
///
+(NSString *)pathForName:(NSString *)name
{
    NSLog(@"name12 %@", name);
    NSLog(@"fornamepath %@", [SimpleFilesCache cachesDirectoryName]);
    NSString *cachePath = [SimpleFilesCache cachesDirectoryName];
    NSString *path = [cachePath stringByAppendingPathComponent:name];
    return path;
}

#pragma mark - NSData Cache methods

///
/// Saves the given data to the cache directory
///
+(void)saveToCacheDirectory:(NSData *)data withName:(NSString *)name
{
    NSString *path = [SimpleFilesCache pathForName:name];
    [data writeToFile:path atomically:YES];
}

///
/// Returns the cached data with the given name; otherwise, returns false
///
+(NSData *)cachedDataWithName:(NSString *)name
{
    
    NSString *path = [SimpleFilesCache pathForName:name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if(fileExists) {
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        return data;
        
    } else {
        return nil;
    }
}

#pragma mark - UIImage cache methods

///
/// Saves the given image to the cache directory using the given name identifier
///
+(void)saveImageToCacheDirectory:(UIImage *)image withName:(NSString *)name
{
    NSData *imgData = UIImagePNGRepresentation(image);
    [SimpleFilesCache saveToCacheDirectory:imgData withName:name];
}

///
/// Returns the cached image if found; otherwise, returns nil
///
+(UIImage *)cachedImageWithName:(NSString *)name
{
    NSData *data = [SimpleFilesCache cachedDataWithName:name];
    
    if(data) {
        
        UIImage *img = [UIImage imageWithData:data];
        return img;
        
    } else {
        
        return nil;
    }
}

#pragma mark - Instance Methods

-(NSString *)applyNamespaceToName:(NSString *)name
{
    return [_cacheNamespace stringByAppendingString:name];
}

-(id)initWithNamespace:(NSString *)cacheNamespace
{
    self = [super init];
    
    if(self) {
        _cacheNamespace = cacheNamespace;
    }
    
    return self;
}

-(void)saveToCacheDirectory:(NSData *)data withName:(NSString *)name
{
    name = [self applyNamespaceToName:name];
    [SimpleFilesCache saveToCacheDirectory:data withName:name];
}

-(NSData *)cachedDataWithName:(NSString *)name
{
    name = [self applyNamespaceToName:name];
    return [SimpleFilesCache cachedDataWithName:name];
}

-(void)saveImageToCacheDirectory:(UIImage *)image withName:(NSString *)name
{
    name = [self applyNamespaceToName:name];
    [SimpleFilesCache saveImageToCacheDirectory:image withName:name];
}

-(UIImage *)cachedImageWithName:(NSString *)name
{
    name = [self applyNamespaceToName:name];
    return [SimpleFilesCache cachedImageWithName:name];
}

@end
