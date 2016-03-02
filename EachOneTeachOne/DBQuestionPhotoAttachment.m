//
//  DBQuestionPhotoAttachment
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionPhotoAttachment.h"
#import "UIImage+DBResizing.h"

@implementation DBQuestionPhotoAttachment

#pragma mark - Constants

+ (CGSize)kImageSize {
    return CGSizeMake(1024,1024);
}

#pragma mark - DBQuestionAttachmentProtocol

- (NSData *)dataForUpload {
    return UIImageJPEGRepresentation(self.photoImage, 1);
}

- (NSString *)fileExtension {
    return kMimeTypeImageJPG;
}

- (NSString *)mimeType {
    return kMimeTypeImageJPG;
}

#pragma mark - Variables

- (void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = [photoImage photoResizedToSize:[DBQuestionPhotoAttachment kImageSize]];
    self.thumbnailImage = photoImage;
}

@end
