//
//  DBS3Manager.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 22/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// Amazon S3
#import <Foundation/Foundation.h>

typedef void (^DBS3ManagerUploadCompletionBlock)(BOOL success, NSError *error);

@interface DBS3Manager : NSObject

+ (void)uploadFileWithKey:(NSString *)keyName data:(NSData *)data completionBlock:(DBS3ManagerUploadCompletionBlock)completionBlock;

@end