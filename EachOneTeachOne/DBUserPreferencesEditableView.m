//
//  DBUserPreferencesView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 30/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBUserPreferencesEditableView.h"
#import <PureLayout/PureLayout.h>
#import "PFUser+Extensions.h"

static CGFloat const kVerticalSpacing = 4;
static CGFloat const kHorizontalSpacing = 4;

@interface DBUserPreferencesEditableView () //<UITextFieldDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DBUserPreferencesEditableView

- (instancetype)initWithUser:(PFUser *)user {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //        [self autoPinEdgesToSuperviewEdges];
        
        //        _scrollView = [[UIScrollView alloc] init];
        //        [self addSubview:self.scrollView];
        //        [self.scrollView autoPinEdgesToSuperviewEdges];
        //
        //        _stackView = [[UIStackView alloc] init];
        //        self.stackView.axis = UILayoutConstraintAxisVertical;
        //        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        //        self.stackView.alignment = UIStackViewAlignmentFill;
        //        self.stackView.spacing = 5;
        //        [self.scrollView addSubview:self.stackView];
        //        [self.stackView autoPinEdgesToSuperviewEdges];
        
        _userNameTextField = [UITextField newAutoLayoutView];
        self.userNameTextField.autocorrectionType = NO;
        _userNameTextField.text = user.username;
        [self addSubview:self.userNameTextField];
        
        _crewTextField = [UITextField newAutoLayoutView];
        self.crewTextField.autocorrectionType = NO;
        _crewTextField.text = [user getUserCrew:user];
        [self addSubview:self.crewTextField];
        
        _cityTextField = [UITextField newAutoLayoutView];
        self.cityTextField.autocorrectionType = NO;
        _cityTextField.text = [user getUserCity:user];
        [self addSubview:self.cityTextField];
        
        _userNameLabel = [UILabel newAutoLayoutView];
        self.userNameLabel.numberOfLines = 1;
        self.userNameLabel.text = @"User name:";
        [self addSubview:self.userNameLabel];
        
        _crewLabel = [UILabel newAutoLayoutView];
        self.crewLabel.numberOfLines = 1;
        self.crewLabel.text = @"Crew name:";
        [self addSubview:self.crewLabel];
        
        _cityLabel = [UILabel newAutoLayoutView];
        self.cityLabel.numberOfLines = 1;
        self.cityLabel.text = @"City name:";
        [self addSubview:self.cityLabel];
        
        _avatarPFImageView = [PFImageView newAutoLayoutView];
        self.avatarPFImageView.file = [user getUserAvatar:user];
        [self.avatarPFImageView loadInBackground];
        [self addSubview:self.avatarPFImageView];
        
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.self.avatarButton];
        
    }
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        CGFloat temporaryConstantForLabelAndTextFieldHeight = [UIScreen mainScreen].bounds.size.height * 0.05;
        
        [self.userNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing+64];
        [self.userNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.userNameLabel autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.userNameTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing+64];
        [self.userNameTextField autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.userNameLabel withOffset:kVerticalSpacing];
        [self.userNameTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.userNameTextField autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.crewLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userNameLabel withOffset:kVerticalSpacing];
        [self.crewLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.crewLabel autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.crewTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userNameTextField withOffset:kVerticalSpacing];
        [self.crewTextField autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.crewLabel withOffset:kHorizontalSpacing];
        [self.crewTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.crewTextField autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.cityLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.crewLabel withOffset:kVerticalSpacing];
        [self.cityLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.cityLabel autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.cityTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.crewTextField withOffset:kVerticalSpacing];
        [self.cityTextField autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.cityLabel withOffset:kHorizontalSpacing];
        [self.cityTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.cityTextField autoSetDimension:ALDimensionHeight toSize:temporaryConstantForLabelAndTextFieldHeight];
        
        [self.avatarPFImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cityLabel withOffset:kVerticalSpacing];
        [self.avatarPFImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.avatarPFImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.avatarPFImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing+64];
        
        [self.avatarButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cityLabel withOffset:kVerticalSpacing];
        [self.avatarButton autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.avatarButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.avatarButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing+64];
    }
    
    [super updateConstraints];
}

@end
