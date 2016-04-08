//
//  DBUserPreferencesView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 07/04/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBUserPreferencesView.h"
#import <PureLayout/PureLayout.h>
#import "PFUser+Extensions.h"

static CGFloat const kVerticalSpacing = 4;
static CGFloat const kHorizontalSpacing = 4;

@interface DBUserPreferencesView () //<UITextFieldDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DBUserPreferencesView

- (instancetype)initWithUser:(PFUser *)user {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _userNameLabel = [UILabel newAutoLayoutView];
        self.userNameLabel.numberOfLines = 1;
        self.userNameLabel.text = [NSString stringWithFormat:@"User name: %@", user.username];
        [self addSubview:self.userNameLabel];
        
        _crewLabel = [UILabel newAutoLayoutView];
        self.crewLabel.numberOfLines = 1;
        self.crewLabel.text = [NSString stringWithFormat:@"Crew name: %@", [user getUserCrew:user]];
        [self addSubview:self.crewLabel];
        
        _cityLabel = [UILabel newAutoLayoutView];
        self.cityLabel.numberOfLines = 1;
        self.cityLabel.text = [NSString stringWithFormat:@"City name: %@", [user getUserCity:user]];
        [self addSubview:self.cityLabel];
        
        _avatarPFImageView = [PFImageView newAutoLayoutView];
        self.avatarPFImageView.file = [user getUserAvatar:user];
        [self.avatarPFImageView loadInBackground];
        [self addSubview:self.avatarPFImageView];

    }
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        CGFloat temporaryConstantForLabelAndTextFieldHeight = [UIScreen mainScreen].bounds.size.height * 0.05;
        
        [self.userNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing+64];
        [self.userNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.userNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.userNameLabel autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.crewLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userNameLabel withOffset:kVerticalSpacing];
        [self.crewLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.crewLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.crewLabel autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.cityLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.crewLabel withOffset:kVerticalSpacing];
        [self.cityLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.cityLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.cityLabel autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.avatarPFImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cityLabel withOffset:kVerticalSpacing];
        [self.avatarPFImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.avatarPFImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.avatarPFImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing+64];

    }
    
    [super updateConstraints];
}

@end
