//
//  DBS3Manager.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBS3Manager.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>
#import <AWSS3/AWSS3TransferUtility.h>

NSString * const kBucketName = @"eachoneteachonebucket";

@implementation DBS3Manager

+ (void)uploadFileWithKey:(NSString *)keyName data:(NSData *)data mimeType:(NSString *)mimeType completionBlock:(DBS3ManagerUploadCompletionBlock)completionBlock {
//    keyName = ([mimeType  isEqual: @"image/jpg"]) ? ([keyName stringByAppendingString:@".jpg"]) : ([keyName stringByAppendingString:@".mov"]);
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = ^(AWSS3TransferUtilityTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Update a progress bar.
        });
    };
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Alert a user for transfer completion.
            // On failed uploads, `error` contains the error object.
        });
    };
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadData:data
                          bucket:kBucketName
                             key:keyName
                     contentType:mimeType
                      expression:expression
                completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            AWSS3TransferUtilityUploadTask *uploadTask = task.result;
            // Do something with uploadTask.
        }
        
        return nil;
    }];
    
}


@end