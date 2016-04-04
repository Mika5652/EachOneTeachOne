//
//  DBAnswer.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 15/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>

@class DBAnswer;

typedef void (^DBUploadAnswerCompletion)(DBAnswer *answer, NSError *error);
typedef void (^DBAnswerVoteCompletion)(int voteRating, NSError *error);

@interface DBAnswer : PFObject <PFSubclassing>

@property NSString *textOfAnswer;
@property NSMutableArray *attachments;
@property NSMutableArray *comments;
@property NSMutableArray *upvotes;
@property NSMutableArray *downvotes;

+ (void)uploadAnswerWithText:(NSString *)text attachemnts:(NSMutableArray *)dataArray completion:(DBUploadAnswerCompletion)completion;
+ (void)changeAnswerVoteRating:(DBAnswer *)answer wasPlusPressed:(BOOL)plusWasPressed completion:(DBAnswerVoteCompletion)completion;

@end
