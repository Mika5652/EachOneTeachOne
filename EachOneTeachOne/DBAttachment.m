//
//  DBQuestionAttachment.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 01/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAttachment.h"
#import "UIImage+DBResizing.h"

NSString * const kMimeTypeVideoMOV = @"video/quicktime";
NSString * const kMOVExtenstion = @"MOV";
NSString * const kMimeTypeImageJPG = @"image/jpg";
NSString * const kJPGExtenstion = @"jpg";

@implementation DBAttachment

@dynamic attachmentDescription;

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

@end
