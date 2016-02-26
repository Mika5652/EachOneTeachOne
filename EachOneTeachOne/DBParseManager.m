//
//  DBParseManager.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBParseManager.h"
#import "DBQuestion.h"

@implementation DBParseManager

+ (void)uploadQuestionWithTitle:(NSString *)title questionDescription:(NSString *)questionDescription videosAndPhotosNames:(NSArray *)videosAndPhotosNames  completionBlock:(DBParseManagerUploadCompletionBlock)completionBlock {

    DBQuestion *question = [DBQuestion object];
    
    question.title = title;
    question.questionDescription = questionDescription;
    question.videosAndPhotosNames = videosAndPhotosNames;
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionBlock(question.objectId, error);
    }];
}

+ (void)numberOfObjectsOnParse:(NSString *)className completionBlock:(DBParseManagerCountCompletionBlock)completionBlock {
    PFQuery *query = [PFQuery queryWithClassName:className];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        completionBlock(count, error);
    }];
}

@end
