//
//  DBQuestionVideoAttachment.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionVideoAttachment.h"
#import "UIImage+DBResizing.h"

NSString * const kMimeTypeVideoMOV = @"video/quicktime";
NSString * const kMOVExtenstion = @"MOV";

@implementation DBQuestionVideoAttachment

#pragma mark - Constants

+ (CGSize)kThumbnailImageSize {
    return CGSizeMake(256, 256);
}

#pragma mark - Properties

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = [thumbnailImage photoResizedToSize:[DBQuestionVideoAttachment kThumbnailImageSize]];
}

@end
