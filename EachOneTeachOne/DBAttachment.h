//
//  DBQuestionAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 01/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@class DBAttachment;
@class DBQuestion;

typedef void (^DBAttachmentsUploadCompletion)(BOOL success, NSError *error);
typedef void (^DBAttachmentUploadCompletion)(DBAttachment *attachment, NSError *error);

extern NSString * const kMimeTypeImageJPG;
extern NSString * const kJPGExtenstion;
extern NSString * const kMimeTypeVideoMOV;
extern NSString * const kMOVExtenstion;
extern NSString * const kBucketName;

@interface DBAttachment : PFObject <PFSubclassing>

// UPLOADED TO PARSE
@property NSString *fileName;
@property NSString *attachmentDescription;
@property NSString *mimeType;

// NOT UPLOADED TO PARSE
@property (nonatomic) UIImage *thumbnailImage;
@property (nonatomic) NSURL *videoURL;
@property (nonatomic) UIImage *photoImage;

- (NSData *)dataForUpload;
- (NSData *)thumbnailDataForUpload;
- (NSString *)fileExtension;
- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
+ (void)uploadAttachments:(NSArray *)dataArray toQuestion:(DBQuestion *)question completion:(DBAttachmentsUploadCompletion)completion;
+ (void)uploadFileWithKey:(NSString *)keyName data:(NSData *)data mimeType:(NSString *)mimeType completion:(DBAttachmentsUploadCompletion)completion;

@end