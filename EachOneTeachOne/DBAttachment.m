#import "DBAttachment.h"
#import "UIImage+DBResizing.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>
#import <AWSS3/AWSS3TransferUtility.h>
#import <AVFoundation/AVFoundation.h>
#import "DBQuestion.h"

NSString * const kMimeTypeVideoMOV = @"video/quicktime";
NSString * const kMOVExtenstion = @"MOV";
NSString * const kMimeTypeImageJPG = @"image/jpg";
NSString * const kJPGExtenstion = @"jpg";
NSString * const kBucketName = @"eachoneteachonebucket";
CGFloat const kPhotoWidth = 1024;
CGFloat const kThumbnailWidth = 256;

@implementation DBAttachment

@dynamic attachmentDescription;
@dynamic mimeType;

@synthesize videoURL = _videoURL;
@synthesize photoImage = _photoImage;
@synthesize fileName = _fileName;
@synthesize thumbnailImage = _thumbnailImage;

#pragma mark - Properties

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = [thumbnailImage photoResizedToSize:CGSizeMake(kThumbnailWidth,  thumbnailImage.size.height*(kThumbnailWidth/thumbnailImage.size.width))];
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    self.thumbnailImage = [self thumbnailImageForVideo:videoURL atTime:0];
}

- (void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = [photoImage photoResizedToSize:CGSizeMake(kPhotoWidth, photoImage.size.height*(kPhotoWidth/photoImage.size.width))];
    self.thumbnailImage = photoImage;
}

#pragma mark - Public

- (NSData *)thumbnailDataForUpload {
    return UIImageJPEGRepresentation(self.thumbnailImage, 1);
}

- (NSString *)fileExtension {
    if ([self.mimeType isEqualToString:kMimeTypeImageJPG]) {
        return kJPGExtenstion;
    } else if ([self.mimeType isEqualToString:kMimeTypeVideoMOV]) {
        return kMOVExtenstion;
    } else {
        return nil;
    }
}

-(NSData *)dataForUpload {
    if ([self.mimeType isEqualToString:kMimeTypeImageJPG]) {
        return UIImageJPEGRepresentation(self.photoImage, 1);
    } else if ([self.mimeType isEqualToString:kMimeTypeVideoMOV]) {
        return [NSData dataWithContentsOfURL:self.videoURL];
    } else {
        return nil;
    }
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
}

#pragma mark - Parse

+ (NSString *)parseClassName
{
    return @"Attachment";
}

+ (void) load
{
    [self registerSubclass];
}

#pragma mark - Networking

+ (void)uploadAttachments:(NSArray *)attachments toQuestion:(DBQuestion *)question completion:(DBAttachmentsUploadCompletion)completion {
    id firstObjectFromAttachments = attachments.firstObject;
    if ([firstObjectFromAttachments isKindOfClass:[DBAttachment class]]) {
        DBAttachment *attachment = (DBAttachment *)firstObjectFromAttachments;
        [attachment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (!error) {
                attachment.fileName = [attachment.objectId stringByAppendingPathExtension:[attachment fileExtension]];
                [DBAttachment uploadFileWithKey:attachment.fileName data:[attachment dataForUpload] mimeType:attachment.mimeType completion:^(BOOL success, NSError *error) {
                    if (question.attachments) {
                        NSMutableArray *newAttachments = [NSMutableArray arrayWithArray:question.attachments];
                        [newAttachments addObject:attachment];
                        question.attachments = newAttachments;
                    } else {
                        question.attachments = [[NSMutableArray alloc] initWithObjects:attachment, nil];
                    }
                    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (!error) {
                            if (attachments.count > 1) {
                                [DBAttachment uploadAttachments:[attachments subarrayWithRange:NSMakeRange(1, attachments.count-1)] toQuestion:question completion:completion];
                            } else {
                                completion(YES, error);
                            }
                        } else {
                            completion(NO, error);
                        }
                    }];
                }];
            } else {
                completion(NO, error);
            }
        }];
    } else {
        completion(NO, [NSError errorWithDomain:@"Unexpected data in uploadAttachments method" code:0 userInfo:nil]);
    }
}

+ (void)uploadFileWithKey:(NSString *)keyName data:(NSData *)data mimeType:(NSString *)mimeType completion:(DBAttachmentsUploadCompletion)completion {
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = ^(AWSS3TransferUtilityTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Update a progress bar.
        });
    };
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [transferUtility uploadData:data bucket:kBucketName key:keyName contentType:kJPGExtenstion expression:expression completionHander:^(AWSS3TransferUtilityUploadTask * _Nonnull task, NSError * _Nullable error) {
        if (!error) {
            completion(YES, error);
        } else {
            completion(NO, error);
        }
    }];
}

@end

