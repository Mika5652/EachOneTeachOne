//
//  DBAnswerComment.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 23/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAnswerComment.h"
#import "DBAnswer.h"

@implementation DBAnswerComment

@dynamic textOfComment;

+ (NSString *)parseClassName
{
    return @"AnswerComment";
}

+ (void) load
{
    [self registerSubclass];
}

+ (void)uploadAnswerCommentWithText:(NSString *)text toAnswer:(DBAnswer *)answer completion:(DBUploadAnswerCommentCompletion)completion {
    DBAnswerComment *answerComment = [DBAnswerComment object];
    answerComment.textOfComment = text;
    
    [answerComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error && succeeded) {
            if (answer.comments) {
                NSMutableArray *newComments = [NSMutableArray arrayWithArray:answer.comments];
                [newComments addObject:answerComment];
                answer.comments = newComments;
            } else {
                answer.comments = [[NSMutableArray alloc] initWithObjects:answerComment, nil];
            }
            [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error && succeeded) {
                    completion(answerComment, nil);
                } else {
                    completion(answerComment, [NSError errorWithDomain:@"Error during uploading answer comments to parse" code:0 userInfo:nil]);
                }
            }];
            
        } else {
            completion(answerComment, [NSError errorWithDomain:@"Error during uploading answerComment to Parse" code:0 userInfo:nil]);
        }
    }];
}


@end