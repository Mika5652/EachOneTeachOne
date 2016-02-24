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

static DBS3Manager *sharedManagerCenter = nil;

+ (DBS3Manager *)sharedManager {
    if (sharedManagerCenter == nil) {
        sharedManagerCenter = [[super allocWithZone:NULL] init];
    }
    return sharedManagerCenter;
}

- (id)init{
    if ( (self = [super init]) ) {
        // inicializace
    }
    return self;
}

//- (void)dealloc {
//    
//}

+ (void)download {
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];

    // Construct the NSURL for the download location.
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloadedTempTest1.png"];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    // Construct the download request.
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = @"eachoneteachonebucket";
    downloadRequest.key = @"myTempTest1.png";
    NSLog(@">>> >>> >>> %@", downloadingFileURL);
    
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    // Download the file.
    [[transferManager download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                           withBlock:^id(AWSTask *task) {
                                                               if (task.error){
                                                                   if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                       switch (task.error.code) {
                                                                           case AWSS3TransferManagerErrorCancelled:
                                                                           case AWSS3TransferManagerErrorPaused:
                                                                               break;
                                                                               
                                                                           default:
                                                                               NSLog(@"Error: %@", task.error);
                                                                               break;
                                                                       }
                                                                   } else {
                                                                       // Unknown error.
                                                                       NSLog(@"Error: %@", task.error);
                                                                   }
                                                               }
                                                               
                                                               if (task.result) {
                                                                   AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
                                                                   //File downloaded successfully.
                                                               }
                                                               return nil;
                                                           }];
    
}



+ (void)uploadFileWithKey:(NSString *)keyName data:(NSData *)data completionBlock:(DBS3ManagerUploadCompletionBlock)completionBlock {
    
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
                     contentType:@"image/jpg"
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
    
//    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
//
//    AWSS3TransferManagerUploadRequest *uploadRequest = [[AWSS3TransferManagerUploadRequest alloc] init];
////    AWSS3PutObjectRequest *uploadRequest = [AWSS3PutObjectRequest new];
//    uploadRequest.bucket = kBucketName;
//    uploadRequest.key = keyName;
////    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
////    uploadRequest.body = [[NSData alloc] init];
//    
//    NSString *uploadFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myImage.png"];
//    NSURL *uploadFileURL = [NSURL fileURLWithPath:uploadFilePath];
//    NSLog(@"%@", uploadFileURL);
//    uploadRequest.body = uploadFileURL;
//    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
//                                                       withBlock:^id(AWSTask *task) {
//                                                           if (task.error) {
//                                                               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
//                                                                   switch (task.error.code) {
//                                                                       case AWSS3TransferManagerErrorCancelled:
//                                                                       case AWSS3TransferManagerErrorPaused:
//                                                                           break;
//                                                                           
//                                                                       default:
//                                                                           NSLog(@"Error: %@", task.error);
//                                                                           break;
//                                                                   }
//                                                               } else {
//                                                                   // Unknown error.
//                                                                   NSLog(@"Error: %@", task.error);
//                                                               }
//                                                               if (completionBlock) {
//                                                                   completionBlock(NO, task.error);
//                                                               }
//                                                           }
//                                                           
//                                                           if (task.result) {
//                                                               AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
//                                                               // The file uploaded successfully.
//                                                               if (completionBlock) {
//                                                                   completionBlock(YES, nil);
//                                                               }
//                                                           }
//                                                           return nil;
//                                                       }];
}


@end