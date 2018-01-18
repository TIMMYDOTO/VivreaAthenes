//
//  GlobalVariables.m
//  GuessIt
//
//  Created by home on 10/13/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables


static GlobalVariables *instance = nil;

+(GlobalVariables *) getInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance= [GlobalVariables new];
        }
    }
    return instance;
}

@end
