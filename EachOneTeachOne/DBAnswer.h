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

@interface DBAnswer : PFObject <PFSubclassing>

@property NSString *textOfAnswer;
@property NSMutableArray *attachments;

+ (void)uploadAnswerWithText:(NSString *)text attachemnts:(NSMutableArray *)dataArray completion:(DBUploadAnswerCompletion)completion;

@end
