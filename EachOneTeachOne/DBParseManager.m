//
//  DBParseManager.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBParseManager.h"
#import "DBQuestion.h"
#import "DBAttachment.h"

static NSInteger const kLimit = 20;

@implementation DBParseManager

+ (void)uploadQuestionWithTitle:(NSString *)title questionDesciption:(NSString *)questionDesciption completion:(DBParseManagerUploadCompletion)completion {
    DBQuestion *question = [DBQuestion object];
    question.title = title;
    question.questionDescription = questionDesciption;
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(question, error);
    }];
}

+ (void)uploadAttachment:(NSString *)attachmentName attachmentDescription:(NSString *)attachmentDescription mimeType:(NSString *)mimeType completion:(DBParseManagerUploadAttachment)completion {
    DBAttachment *attachment = [DBAttachment object];
    attachment.attachmentDescription = attachmentDescription;

    
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
