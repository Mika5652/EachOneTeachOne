//
//  DBQuestion.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 27.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestion.h"

@implementation DBQuestion

@dynamic title;
@dynamic questionDescription;
@dynamic videosAndPhotos;

+ (NSString *)parseClassName
{
    return @"Question";
}

+ (void) load
{
    [self registerSubclass];
}

@end
