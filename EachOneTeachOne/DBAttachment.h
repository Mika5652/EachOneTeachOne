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

@property (nonatomic) UIImage *thumbnailImage;
@property NSString *attachmentDescription;
@property NSString *mimeType;

- (NSData *)thumbnailDataForUpload;
+ (void)uploadAttachmentWithDescription:(NSString *)attachmentDescription mimeType:(NSString *)mimeType completion:(DBAttachmentUploadCompletion)completion;
+ (void)uploadAttachments:(NSArray *)dataArray toQuestion:(DBQuestion *)question completion:(DBAttachmentsUploadCompletion)completion;
+ (void)uploadFileWithKey:(NSString *)keyName data:(NSData *)data mimeType:(NSString *)mimeType completion:(DBAttachmentsUploadCompletion)completion;

@end

@protocol DBAttachmentProtocol <NSObject>

- (NSData *)dataForUpload;
- (NSString *)fileExtension;

@end
