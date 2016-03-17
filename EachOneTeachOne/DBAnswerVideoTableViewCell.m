//
//  DBAnswerVideoTableViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 15/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAnswerVideoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <PureLayout/PureLayout.h>
#import "DBAttachment.h"
#import "AppDelegate.h"

NSString * const kDBAnswerVideoTableViewIdentifier = @"kDBAnswerVideoTableViewIdentifier";
static NSString * const descriptionTextViewText = @"Description...";
static CGFloat const kHorizontalSpacing = 4;
static CGFloat const kVerticalSpacing = 4;

@interface DBAnswerVideoTableViewCell () <UITextViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property AVPlayer *videoPlayer;
@property AVPlayerViewController *playerViewController;
@property NSArray *videoViewConstrainsArray;
@property UIButton *playButton;

@end

@implementation DBAnswerVideoTableViewCell

#pragma mark - Lifecycles

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _videoThumbnail = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:self.videoThumbnail];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"playButton"];
        [self.playButton setImage:buttonImage forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.playButton];
        
        _descriptionTextView = [UITextView newAutoLayoutView];
        self.descriptionTextView.layer.cornerRadius = 7;
        self.descriptionTextView.autocorrectionType = NO;
        self.descriptionTextView.delegate = self;
        self.descriptionTextView.text = descriptionTextViewText;
        self.descriptionTextView.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.descriptionTextView];
        
    }
    
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        [NSLayoutConstraint autoSetPriority:801 forConstraints:^{
            [self.videoThumbnail autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
            [self.videoThumbnail autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
            [self.videoThumbnail autoPinEdgeToSuperviewEdge:ALEdgeLeading];
            
            [self.playButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
            [self.playButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
            [self.playButton autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        }];
        [NSLayoutConstraint autoSetPriority:799 forConstraints:^{
            [self.descriptionTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.videoThumbnail withOffset:kVerticalSpacing];
            [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
            [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
            [self.descriptionTextView autoSetDimension:ALDimensionHeight toSize:50];
            [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing];
        }];
        self.didSetupConstraints = YES;
        
    }
    
    [super updateConstraints];
}

#pragma mark - User actions

- (void)playButtonDidPress {
    _playerViewController = [[AVPlayerViewController alloc] init];
    _videoPlayer = [AVPlayer playerWithURL:self.attachment.videoURL];
    self.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerViewController.player = self.videoPlayer;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    [navigationController.topViewController presentViewController:self.playerViewController animated:YES completion:nil];
}

- (void)setConstrainsWithImage:(UIImage *)image {
    [NSLayoutConstraint deactivateConstraints:self.videoViewConstrainsArray];
    self.videoViewConstrainsArray = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [self.videoThumbnail autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.height / image.size.width))];
        [self.playButton autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.height / image.size.width))];
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.attachment.attachmentDescription = self.descriptionTextView.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.descriptionTextView.text isEqualToString:descriptionTextViewText]) {
        self.descriptionTextView.text = @"";
        self.descriptionTextView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.descriptionTextView.text isEqualToString:@""]) {
        self.descriptionTextView.text = descriptionTextViewText;
        self.descriptionTextView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
