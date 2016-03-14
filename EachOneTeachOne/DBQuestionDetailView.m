//
//  DBQuestionDetailView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 10/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "DBQuestionDetailView.h"
#import "DBQuestion.h"
#import "DBAttachment.h"
#import <UIImageView+AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AppDelegate.h"

@interface DBQuestionDetailView ()

@property AVPlayer *videoPlayer;
@property AVPlayerViewController *playerViewController;
@property UIButton *playButton;

@end

@implementation DBQuestionDetailView

- (instancetype)initWithQuestion:(DBQuestion *)question {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _scrollView = [[UIScrollView alloc] init];
//        self.scrollView.backgroundColor = [UIColor redColor];
        [self addSubview:self.scrollView];
        [self.scrollView autoPinEdgesToSuperviewEdges];
        
        _stackView = [[UIStackView alloc] init];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.spacing = 5;
        [self.scrollView addSubview:self.stackView];
        [self.stackView autoPinEdgesToSuperviewEdges];
        
        _questionDetailTitleLabel = [UILabel newAutoLayoutView];
        self.questionDetailTitleLabel.numberOfLines = 0;
        self.questionDetailTitleLabel.text = question.title;
        [self.questionDetailTitleLabel sizeToFit];
        [self.stackView addArrangedSubview:self.questionDetailTitleLabel];
        
        _questionDetailDescriptionLabel = [UILabel newAutoLayoutView];
        self.questionDetailDescriptionLabel.numberOfLines = 0;
        self.questionDetailDescriptionLabel.text = question.questionDescription;
        [self.questionDetailDescriptionLabel sizeToFit];
        [self.stackView addArrangedSubview:self.questionDetailDescriptionLabel];

        
        for (DBAttachment *attachment in question.attachments) {
            
            if ([attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
                _questionDetailPhotoImageView = [UIImageView newAutoLayoutView];
                self.questionDetailPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
                NSURL *photoURL = [NSURL URLWithString:[[kAWSS3BaseURL stringByAppendingPathComponent:attachment.objectId] stringByAppendingPathExtension:kJPGExtenstion]];
//                [self.questionDetailPhotoImageView setImageWithURL:photoURL];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:photoURL];
                [request addValue:@"jpg" forHTTPHeaderField:@"Accept"];
                [self.questionDetailPhotoImageView setImageWithURLRequest:request placeholderImage:nil success:nil failure:nil];
                
//                NSData *pData = [NSData dataWithContentsOfURL:photoURL];
////                UIImage *pImage = [UIImage imageWithData:pData];
////                [self.questionDetailPhotoImageView setImage:pImage];
//                self.questionDetailPhotoImageView.image = [UIImage imageWithData:pData];
//                CGFloat oldWidth = self.questionDetailPhotoImageView.image.size.width;
//                CGFloat oldHeight = self.questionDetailPhotoImageView.image.size.height;
//                [self.questionDetailPhotoImageView autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (oldHeight / oldWidth))];
                
                //            NSURL *pURL = [NSURL URLWithString:@"https:/s3.eu-central-1.amazonaws.com/eachoneteachonebucket/4BTE4Ouex3_thumbnail.jpg"];
                //            NSURL *pURL = [NSURL URLWithString:@"https://s3.eu-central-1.amazonaws.com/eachoneteachonebucket/36fIm2G3ZK.jpg"];
//                            [self.questionDetailPhotoImageView setImageWithURL:photoURL];
//                            CGFloat oldWidth = self.questionDetailPhotoImageView.frame.size.width;
//                            CGFloat oldHeight = self.questionDetailPhotoImageView.frame.size.height;
//                            [self.questionDetailPhotoImageView autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (oldHeight / oldWidth))];
                
                [self.stackView addArrangedSubview:self.questionDetailPhotoImageView];
                
            } else if ([attachment.mimeType isEqualToString:kMimeTypeVideoMOV]) {
                _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *buttonImage = [UIImage imageNamed:@"playButton"];
                [self.playButton setImage:buttonImage forState:UIControlStateNormal];
                [self.playButton addTarget:self action:@selector(questionDetailPlayButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
                [self.stackView addArrangedSubview:self.playButton];
                
            } else {
                
            }
        }
        
        [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
//        [self.stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
        
    }
    return self;
}

- (void)questionDetailPlayButtonDidPress:(NSString *)attachmentObjectID {
    _playerViewController = [[AVPlayerViewController alloc] init];
    NSURL *attachmentVideoURL = [NSURL URLWithString:[[kAWSS3BaseURL stringByAppendingPathComponent:attachmentObjectID] stringByAppendingPathExtension:@"MOV"]];
    _videoPlayer = [AVPlayer playerWithURL:attachmentVideoURL];
    self.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerViewController.player = self.videoPlayer;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    [navigationController.topViewController presentViewController:self.playerViewController animated:YES completion:nil];
}

@end
