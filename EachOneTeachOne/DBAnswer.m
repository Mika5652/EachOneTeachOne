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
@dynamic comments;
@dynamic upvotes;
@dynamic downvotes;

+ (NSString *)parseClassName
{
    return @"Answer";
}

+ (void)load
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
    
    PFUser *currentUser = [PFUser currentUser];
    
    // this means that user pressed plus button
    if (plusWasPressed == YES) {
        
        // case when it's first time voting for current user
        if (![answer.upvotes containsObject:currentUser] && ![answer.downvotes containsObject:currentUser]) {
            if (answer.upvotes) {
                NSMutableArray *newUpvotes = [NSMutableArray arrayWithArray:answer.upvotes];
                [newUpvotes addObject:currentUser];
                answer.upvotes = newUpvotes;
            } else {
                answer.upvotes = [[NSMutableArray alloc] initWithObjects:currentUser, nil];
            }
            
        // case when user previously voted with minus
        } else if (![answer.upvotes containsObject:currentUser] && [answer.downvotes containsObject:currentUser]) {
            if (answer.upvotes) {
                NSMutableArray *newUpvotes = [NSMutableArray arrayWithArray:answer.upvotes];
                [newUpvotes addObject:currentUser];
                answer.upvotes = newUpvotes;
            } else {
                answer.upvotes = [[NSMutableArray alloc] initWithObjects:currentUser, nil];
            }
            
            NSMutableArray *newDownvotes = [NSMutableArray arrayWithArray:answer.downvotes];
            [newDownvotes removeObject:currentUser];
            answer.downvotes = newDownvotes;
        }
        
    // this means that user pressed minus button
    } else if (plusWasPressed == NO) {
        
        // case when it's first time voting for current user
        if (![answer.downvotes containsObject:currentUser] && ![answer.upvotes containsObject:currentUser]) {
            if (answer.downvotes) {
                NSMutableArray *newDownvotes = [NSMutableArray arrayWithArray:answer.downvotes];
                [newDownvotes addObject:currentUser];
                answer.downvotes = newDownvotes;
            } else {
                answer.downvotes = [[NSMutableArray alloc] initWithObjects:currentUser, nil];
            }
            
        // case when user previously voted with plus
        } else if (![answer.downvotes containsObject:currentUser] && [answer.upvotes containsObject:currentUser]) {
            if (answer.downvotes) {
                NSMutableArray *newDownvotes = [NSMutableArray arrayWithArray:answer.downvotes];
                [newDownvotes addObject:currentUser];
                answer.downvotes = newDownvotes;
            } else {
                answer.downvotes = [[NSMutableArray alloc] initWithObjects:currentUser, nil];
            }
            
            NSMutableArray *newUpvotes = [NSMutableArray arrayWithArray:answer.upvotes];
            [newUpvotes removeObject:currentUser];
            answer.upvotes = newUpvotes;
        }
    }

    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (!error && succeeded) {
            completion((answer.upvotes.count - answer.downvotes.count), error);
        } else {
            completion((answer.upvotes.count - answer.downvotes.count), [NSError errorWithDomain:@"Error during uploading answer vote rating to Parse" code:0 userInfo:nil]);
        }
    }];
}

@end
