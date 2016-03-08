#import "DBAttachment.h"
#import "UIImage+DBResizing.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>
#import <AWSS3/AWSS3TransferUtility.h>
#import "DBQuestion.h"

NSString * const kMimeTypeVideoMOV = @"video/quicktime";
NSString * const kMOVExtenstion = @"MOV";
NSString * const kMimeTypeImageJPG = @"image/jpg";
NSString * const kJPGExtenstion = @"jpg";
NSString * const kBucketName = @"eachoneteachonebucket";

@implementation DBAttachment

@dynamic attachmentDescription;
@dynamic mimeType;

@synthesize thumbnailImage = _thumbnailImage;

#pragma mark - Constants

+ (CGSize)kThumbnailImageSize {
    return CGSizeMake(256, 256);
}

#pragma mark - Properties

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = [thumbnailImage photoResizedToSize:[DBAttachment kThumbnailImageSize]];
}

- (NSData *)thumbnailDataForUpload {
    return UIImageJPEGRepresentation(self.thumbnailImage, 1);
}

+ (NSString *)parseClassName
{
    return @"Attachment";
}

+ (void) load
{
    [self registerSubclass];
}

+ (void)uploadAttachmentWithDescription:(NSString *)attachmentDescription mimeType:(NSString *)mimeType completion:(DBAttachmentUploadCompletion)completion {
    DBAttachment *attachment = [DBAttachment object];
    attachment.attachmentDescription = attachmentDescription;
    attachment.mimeType = mimeType;
    
    [attachment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        completion(attachment, error);
    }];
    
}

+ (void)uploadAttachments:(NSArray *)dataArray toQuestion:(DBQuestion *)question completion:(DBAttachmentsUploadCompletion)completion {
    //    id data = dataArray.firstObject;
    //    if ([data conformsToProtocol:@protocol(DBAttachmentProtocol)] && [data isKindOfClass:[DBAttachment class]]) {
    //        DBAttachment<DBAttachmentProtocol> *attachment = (DBAttachment<DBAttachmentProtocol> *)data;
    //
    //        [DBParseManager uploadAttachmentWithDescription:attachment.attachmentDescription mimeType:attachment.mimeType completion:^(DBAttachment *attachment, NSError *error) {
    //            if (error == nil) {
    //                NSString *fileName = [attachment.objectId stringByAppendingPathExtension:[attachment fileExtension]];
    //                [DBS3Manager uploadFileWithKey: data:<#(NSData *)#> mimeType:<#(NSString *)#> completion:<#^(BOOL success, NSError *error)completion#>]
    //                [question.attachments addObject:attachment];
    //                if (dataArray.count > 1) {
    //                    [DBNetworkingManager uploadAttachments:[dataArray subarrayWithRange:NSMakeRange(1, dataArray.count-1)] completion:completion];
    //                } else {
    //                    completion(YES, error);
    //                }
    //            } else {
    //                completion(NO, error);
    //            }
    //        }];
    //    } else {
    //        completion(NO, [NSError errorWithDomain:@"Unexpected data in uploadAttachments method" code:0 userInfo:nil]);
    //    }
}


+ (void)uploadFileWithKey:(NSString *)keyName data:(NSData *)data mimeType:(NSString *)mimeType completion:(DBAttachmentsUploadCompletion)completion {
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
            completion(YES, task.error);
        }
        
        return nil;
    }];
    
}

@end

