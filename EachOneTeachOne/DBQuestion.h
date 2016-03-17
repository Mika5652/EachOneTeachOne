//
//  DBQuestion.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 27.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>

@class DBQuestion;

typedef void (^DBGetQuestionsCompletion)(NSArray *questions, NSError *error);
typedef void (^DBUploadQuestionCompletion)(DBQuestion *question, NSError *error);

extern NSString * const kAWSS3BaseURL;

@interface DBQuestion : PFObject <PFSubclassing>

@property NSString *title;
@property NSString *questionDescription;
@property NSMutableArray *attachments;
@property NSMutableArray *answers;
@property NSString *thumbnailName;

+ (void)getNewQuestionsWithSkip:(NSInteger)skip completion:(DBGetQuestionsCompletion)completion;
+ (void)uploadQuestionWithTitle:(NSString *)questionTitle questionDesciption:(NSString *)questionDescription dataArray:(NSMutableArray *)dataArray completion:(DBUploadQuestionCompletion)completion;

@end
