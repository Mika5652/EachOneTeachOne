//
//  DBParseManager.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBParseManager.h"
#import "DBQuestion.h"

static NSInteger const kLimit = 20;

@implementation DBParseManager

+ (void)uploadQuestionWithTitle:(NSString *)title questionDescription:(NSString *)questionDescription videosAndPhotosNames:(NSArray *)videosAndPhotosNames completion:(DBParseManagerUploadCompletion)completion {

    DBQuestion *question = [DBQuestion object];
    
    question.title = title;
    question.questionDescription = questionDescription;
    question.videosAndPhotosNames = videosAndPhotosNames;
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(question.objectId, error);
    }];
}

+ (void)getNewQuestionsWithSkip:(NSInteger)skip completion:(DBParseManagerGetQuestionsCompletion)completion {
    PFQuery *query = [PFQuery queryWithClassName:[DBQuestion parseClassName]];
    
    query.skip = skip;
    query.limit = kLimit;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *questions, NSError *error) {
        completion(questions, error);
    }];
}

@end
