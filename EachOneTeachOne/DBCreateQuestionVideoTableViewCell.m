//
//  DBCreateQuestionVideoTableViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionVideoTableViewCell.h"
#import "DBQuestionVideoAttachment.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <PureLayout/PureLayout.h>

NSString * const kDBCreateQuestionVideoTableViewCellIdentifier = @"kDBCreateQuestionVideoTableViewCellIdentifier";
static CGFloat const kHorizontalSpacing = 4;
static CGFloat const kVerticalSpacing = 4;

@interface DBCreateQuestionVideoTableViewCell () <UITextViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property AVPlayer *videoPlayer;
@property AVPlayerViewController *playerViewController;
@property NSArray *videoViewConstrainsArray;

@end

@implementation DBCreateQuestionVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _playerViewController = [[AVPlayerViewController alloc] init];
        [self.contentView addSubview:self.playerViewController.view];
        
        _descriptionTextView = [UITextView newAutoLayoutView];
        self.descriptionTextView.backgroundColor = [UIColor lightGrayColor];
        self.descriptionTextView.layer.cornerRadius = 7;
        self.descriptionTextView.autocorrectionType = NO;
        self.descriptionTextView.delegate = self;
        [self.contentView addSubview:self.descriptionTextView];
        
    }
    
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {

        [NSLayoutConstraint autoSetPriority:801 forConstraints:^{
            [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
            [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
            [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        }];
        [NSLayoutConstraint autoSetPriority:799 forConstraints:^{
            [self.descriptionTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.playerViewController.view withOffset:kVerticalSpacing];
            [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
            [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
            [self.descriptionTextView autoSetDimension:ALDimensionHeight toSize:50];
            [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing];
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)setContentWithQuestionVideoAttachment:(DBQuestionVideoAttachment *)videoAttachment {
    _videoPlayer = [AVPlayer playerWithURL:videoAttachment.videoURL];
    self.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerViewController.player = self.videoPlayer;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.questionVideoAttachment.questionAttachmentDescription = self.descriptionTextView.text;
}

- (void)setConstrainsWithImage:(UIImage *)image {
    [NSLayoutConstraint deactivateConstraints:self.videoViewConstrainsArray];
    self.videoViewConstrainsArray = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [self.playerViewController.view autoMatchDimension:ALDimensionHeight toDimension:(ALDimensionWidth * (image.size.height / image.size.width)) ofView:self.contentView];
    }];
}

@end
