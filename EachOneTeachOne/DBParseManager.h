//
//  DBParseManager.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBQuestion;

typedef void (^DBParseManagerUploadCompletion)(DBQuestion *question, NSError *error);
typedef void (^DBParseManagerGetQuestionsCompletion)(NSArray *questions, NSError *error);

@interface DBParseManager : NSObject

+ (void)uploadQuestion:(DBQuestion *)question completion:(DBParseManagerUploadCompletion)completion;
+ (void)getNewQuestionsWithSkip:(NSInteger)skip completion:(DBParseManagerGetQuestionsCompletion)completion;

@end
