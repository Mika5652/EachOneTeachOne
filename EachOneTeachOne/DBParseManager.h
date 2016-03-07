//
//  DBParseManager.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBQuestion;
@class DBAttachment;

typedef void (^DBParseManagerUploadCompletion)(DBQuestion *question, NSError *error);
typedef void (^DBParseManagerUploadAttachment)(DBAttachment *attachment, NSError *error);
typedef void (^DBParseManagerGetQuestionsCompletion)(NSArray *questions, NSError *error);

@interface DBParseManager : NSObject

+ (void)uploadQuestionWithTitle:(NSString *)title questionDesciption:(NSString *)questionDesciption completion:(DBParseManagerUploadCompletion)completion;
+ (void)uploadAttachmentWithDescription:(NSString *)attachmentDescription mimeType:(NSString *)mimeType completion:(DBParseManagerUploadAttachment)completion;
+ (void)getNewQuestionsWithSkip:(NSInteger)skip completion:(DBParseManagerGetQuestionsCompletion)completion;

@end
