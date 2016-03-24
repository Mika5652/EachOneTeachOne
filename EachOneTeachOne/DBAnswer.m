//
//  DBAnswer.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 15/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAnswer.h"
#import "DBAttachment.h"

@implementation DBAnswer

@dynamic textOfAnswer;
@dynamic attachments;
@dynamic vote;
@dynamic comments;

+ (NSString *)parseClassName
{
    return @"Answer";
}

+ (void) load
{
    [self registerSubclass];
}

+ (void)uploadAnswerWithText:(NSString *)text attachemnts:(NSMutableArray *)dataArray completion:(DBUploadAnswerCompletion)completion {
    
    DBAnswer *answer = [DBAnswer object];
    answer.textOfAnswer = text;
    
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error && succeeded) {
            if (dataArray.count != 0) {
                id attachment = dataArray.firstObject;
                if ([attachment isKindOfClass:[DBAttachment class]]) {
                    [DBAttachment uploadAttachments:dataArray toAnswer:answer completion:^(BOOL success, NSError *error) {
                        completion(answer, error);
                    }];
                } else {
                    completion(answer, [NSError errorWithDomain:@"Unexpected object type in question attachments" code:0 userInfo:nil]);
                }
            } else {
                completion(answer, error);
            }
        } else {
            completion(answer, [NSError errorWithDomain:@"Error during uploading question to Parse" code:0 userInfo:nil]);
        }
    }];
    
}

+ (void)changeAnswerVoteRating:(DBAnswer *)answer wasPlusPressed:(BOOL)plusWasPressed completion:(DBAnswerVoteCompletion)completion{
    int i = answer.vote;
    
    if (plusWasPressed == YES) {
        i++;
    } else {
        i--;
    }
    
    answer.vote = i;
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (!error && succeeded) {
            completion(answer.vote, error);
        } else {
            completion(answer.vote, [NSError errorWithDomain:@"Error during uploading answer vote rating to Parse" code:0 userInfo:nil]);
        }
    }];
}

@end
