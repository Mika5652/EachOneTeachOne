//
//  DBParseManager.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^DBParseManagerCompletionBlock)(NSString *objectIDString, NSError *error);

@interface DBParseManager : NSObject

+ (void)uploadQuestionWithTitle:(NSString *)title questionDescription:(NSString *)questionDescription videosAndPhotosNames:(NSArray *)videosAndPhotosNames completionBlock:(DBParseManagerCompletionBlock)completionBlock;
@end
