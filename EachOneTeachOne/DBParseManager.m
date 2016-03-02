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

+ (void)uploadQuestion:(DBQuestion *)question completion:(DBParseManagerUploadCompletion)completion {
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(question, error);
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
