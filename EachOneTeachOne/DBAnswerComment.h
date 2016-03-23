//
//  DBAnswerComment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 23/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>

@class DBAnswerComment;
@class DBAnswer;

typedef void (^DBUploadAnswerCommentCompletion)(DBAnswerComment *answerComment, NSError *error);

@interface DBAnswerComment : PFObject <PFSubclassing>

@property NSString *textOfComment;

+ (void)uploadAnswerCommentWithText:(NSString *)text toAnswer:(DBAnswer *)answer completion:(DBUploadAnswerCommentCompletion)completion;

@end