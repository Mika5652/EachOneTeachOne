//
//  DBQuestionPhotoAttachment
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionPhotoAttachment.h"
#import "UIImage+DBResizing.h"

NSString * const kMimeTypeImageJPG = @"image/jpg";
NSString * const kJPGExtenstion = @"jpg";

@implementation DBQuestionPhotoAttachment

#pragma mark - Constants

+ (CGSize)kImageSize {
    return CGSizeMake(1024,1024);
}

+ (CGSize)kThumbnailImageSize {
    return CGSizeMake(256, 256);
}

#pragma mark - Variables

- (void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = [photoImage photoResizedToSize:[DBQuestionPhotoAttachment kImageSize]];
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = [thumbnailImage photoResizedToSize:[DBQuestionPhotoAttachment kThumbnailImageSize]];
}


@end
