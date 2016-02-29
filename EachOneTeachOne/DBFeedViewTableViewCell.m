//
//  DBFeedViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// Framework
#import <PureLayout/PureLayout.h>

#import "DBFeedViewTableViewCell.h"
#import "Core.h"

NSString * const kDBFeedViewTableViewCellIdentifier = @"kDBFeedViewTableViewCellIdentifier";

CGFloat const kVerticalSpacing = 5;
CGFloat const kHorizontalSpacing = 5;

@interface DBFeedViewTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end


@implementation DBFeedViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _photoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photoImageView];
        
        _titleLabel = [UILabel newAutoLayoutView];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        [self.contentView addSubview:self.titleLabel];
        
        _descriptionLabel = [UILabel newAutoLayoutView];
        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:14];
        self.descriptionLabel.numberOfLines = 2;
//        self.descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.descriptionLabel];
    }
    
    return self;
}

- (void) updateConstraints {
    if (!self.didSetupConstraints) {
        
        [self.photoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.contentView withMultiplier:0.2];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing];
        [self.photoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.photoImageView];
        
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.titleLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.photoImageView withOffset:kHorizontalSpacing];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
//        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.photoImageView];
        //        [self.titleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.photoImageView withMultiplier:0.3];
        
        [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kVerticalSpacing];
        [self.descriptionLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.photoImageView withOffset:kHorizontalSpacing];
//        [self.descriptionLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.photoImageView];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
