//
//  DBCreateQuestionVideoTableViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionVideoTableViewCell.h"
#import "DBVideoAttachment.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <PureLayout/PureLayout.h>

NSString * const kDBCreateQuestionVideoTableViewCellIdentifier = @"kDBCreateQuestionVideoTableViewCellIdentifier";
static NSString * const descriptionTextViewText = @"Description...";
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
            [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
            [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
            [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeLeading];
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

- (void)setContentWithQuestionVideoAttachment:(DBVideoAttachment *)videoAttachment {
    _videoPlayer = [AVPlayer playerWithURL:videoAttachment.videoURL];
    self.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerViewController.player = self.videoPlayer;
}

- (void)setConstrainsWithImage:(UIImage *)image {
    [NSLayoutConstraint deactivateConstraints:self.videoViewConstrainsArray];
    self.videoViewConstrainsArray = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [self.playerViewController.view autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.height / image.size.width))];
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.questionVideoAttachment.attachmentDescription = self.descriptionTextView.text;
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
