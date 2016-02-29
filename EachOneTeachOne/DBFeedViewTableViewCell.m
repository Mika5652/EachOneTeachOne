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

@implementation DBFeedViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _photoImageView = [[UIImageView alloc] init];
        [self addSubview:self.photoImageView];
        
        _titleLabel = [UILabel newAutoLayoutView];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:26]];
        self.titleLabel.minimumScaleFactor = 0;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLabel];
        
        _descriptionLabel = [UILabel newAutoLayoutView];
        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:20];
        self.descriptionLabel.numberOfLines = 0;
//        self.descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.descriptionLabel.minimumScaleFactor = 0.6;
        self.descriptionLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.descriptionLabel];
        
        [self.photoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:5];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [self.photoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.photoImageView];
        
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.titleLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.photoImageView withOffset:10];
        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.photoImageView];
//        [self.titleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.photoImageView withMultiplier:0.3];
        
        [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:5];
        [self.descriptionLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.photoImageView withOffset:10];
        [self.descriptionLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.photoImageView];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];

    }
    
    return self;
}

@end
