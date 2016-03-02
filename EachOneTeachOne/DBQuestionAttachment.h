//
//  DBQuestionAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 01/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kMimeTypeImageJPG;
extern NSString * const kJPGExtenstion;
extern NSString * const kMimeTypeVideoMOV;
extern NSString * const kMOVExtenstion;

@interface DBQuestionAttachment : NSObject

@property (nonatomic) UIImage *thumbnailImage;

- (NSData *)thumbnailDataForUpload;

@end

@protocol DBQuestionAttachmentProtocol <NSObject>

- (NSData *)dataForUpload;
- (NSString *)mimeType;
- (NSString *)fileExtension;

@end
