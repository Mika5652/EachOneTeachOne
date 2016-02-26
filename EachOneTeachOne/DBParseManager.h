//
//  DBParseManager.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DBParseManagerUploadCompletion)(NSString *objectIDString, NSError *error);
typedef void (^DBParseManagerGetQuestionsCompletion)(NSArray *questions, NSError *error);

@interface DBParseManager : NSObject

+ (void)uploadQuestionWithTitle:(NSString *)title questionDescription:(NSString *)questionDescription videosAndPhotosNames:(NSArray *)videosAndPhotosNames completion:(DBParseManagerUploadCompletion)completion;
+ (void)getNewQuestionsWithSkip:(NSInteger)skip completion:(DBParseManagerGetQuestionsCompletion)completion;

@end
