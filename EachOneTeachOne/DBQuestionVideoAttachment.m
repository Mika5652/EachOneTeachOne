//
//  DBQuestionVideoAttachment.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionVideoAttachment.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>

@implementation DBQuestionVideoAttachment

#pragma mark - DBQuestionAttachmentProtocol

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    self.thumbnailImage = [self thumbnailImageForVideo:videoURL atTime:0];
}

- (NSData *)dataForUpload {
    return [NSData dataWithContentsOfURL:self.videoURL];
}

- (NSString *)fileExtension {
    return kMOVExtenstion;
}

- (NSString *)mimeType {
    return kMimeTypeVideoMOV;
}

#pragma mark - Private

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

@end
