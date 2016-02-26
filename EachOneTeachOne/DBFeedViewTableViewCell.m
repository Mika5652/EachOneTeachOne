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
        
        _titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.titleLabel];
        
        _descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.descriptionLabel];

        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:5];
        [self.photoImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.descriptionLabel withOffset:5];
        [self.photoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.photoImageView];
        
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];

        [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:5];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    }
    
    return self;
}

@end
