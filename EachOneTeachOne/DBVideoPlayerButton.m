//
//  DBVideoPlayerButton.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 14/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBVideoPlayerButton.h"
#import "DBQuestion.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AppDelegate.h"
#import <PureLayout/PureLayout.h>

@interface DBVideoPlayerButton ()

@property AVPlayer *videoPlayer;
@property AVPlayerViewController *playerViewController;
@property UIButton *playButton;
@property UIImageView *videoThumbnail;

@end

@implementation DBVideoPlayerButton

- (instancetype)initWithVideoURLString:(NSString *)videoURL {
    self = [super init];
    if (self) {
        
        _videoURL = videoURL;
        
        _videoThumbnail = [UIImageView newAutoLayoutView];
        NSURL *attachmentVideoURL = [NSURL URLWithString:[[kAWSS3BaseURL stringByAppendingPathComponent:self.videoURL] stringByAppendingPathExtension:@"MOV"]];
        [self.videoThumbnail setImage:[self thumbnailImageForVideo:attachmentVideoURL atTime:0]];
        [self addSubview:self.videoThumbnail];
        [self.videoThumbnail autoPinEdgesToSuperviewEdges];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"playButton"];
        [self.playButton setImage:buttonImage forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(questionDetailPlayButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        [self.playButton autoPinEdgesToSuperviewEdges];
        
    }
    return self;
}

- (void)questionDetailPlayButtonDidPress {
    _playerViewController = [[AVPlayerViewController alloc] init];
    NSURL *attachmentVideoURL = [NSURL URLWithString:[[kAWSS3BaseURL stringByAppendingPathComponent:self.videoURL] stringByAppendingPathExtension:@"MOV"]];
    _videoPlayer = [AVPlayer playerWithURL:attachmentVideoURL];
    self.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerViewController.player = self.videoPlayer;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    [navigationController.topViewController presentViewController:self.playerViewController animated:YES completion:nil];
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

@end

