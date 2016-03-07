//
//  DBQuestionAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 01/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

extern NSString * const kMimeTypeImageJPG;
extern NSString * const kJPGExtenstion;
extern NSString * const kMimeTypeVideoMOV;
extern NSString * const kMOVExtenstion;

@interface DBAttachment : PFObject <PFSubclassing>

@property (nonatomic) UIImage *thumbnailImage;
@property NSString *attachmentDescription;
@property NSString *mimeType;

- (NSData *)thumbnailDataForUpload;

@end

@protocol DBAttachmentProtocol <NSObject>

- (NSData *)dataForUpload;
- (NSString *)fileExtension;

@end
