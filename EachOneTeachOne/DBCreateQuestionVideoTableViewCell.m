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

@interface DBCreateQuestionVideoTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property AVPlayer *videoPlayer;
@property AVPlayerViewController *playerViewController;

@end

@implementation DBCreateQuestionVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _playerViewController = [[AVPlayerViewController alloc] init];
        [self.contentView addSubview:self.playerViewController.view];
        
        _descriptionLabel = [UILabel newAutoLayoutView];
        [self.contentView addSubview:self.descriptionLabel];
        
    }
    
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {

        [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.playerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.playerViewController.view autoSetDimension:ALDimensionHeight toSize:50];
        
        [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.playerViewController.view withOffset:kVerticalSpacing];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)setContentWithQuestionVideoAttachment:(DBQuestionVideoAttachment *)videoAttachment {
    _videoPlayer = [[AVPlayer alloc] init];
}

@end
