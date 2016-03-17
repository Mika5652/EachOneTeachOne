//
//  DBAnswerQuestionDataSource.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 16/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAnswerQuestionDataSource.h"

@implementation DBAnswerQuestionDataSource

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
