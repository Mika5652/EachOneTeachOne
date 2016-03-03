//
//  BDCreateQuestionTitleAndDescriptionTableViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionTitleAndDescriptionTableViewCell.h"
#import <PureLayout/PureLayout.h>

NSString * const kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier = @"kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier";
static CGFloat const kVerticalSpacing = 4;
static CGFloat const kHorizontalSpacing = 4;

@interface DBCreateQuestionTitleAndDescriptionTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DBCreateQuestionTitleAndDescriptionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleTextField = [UITextField newAutoLayoutView];
        self.titleTextField.backgroundColor = [UIColor greenColor];
        self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.titleTextField.placeholder = NSLocalizedString(@"Title ", nil);
        self.titleTextField.autocorrectionType = NO;
        [self.contentView addSubview:self.titleTextField];
        
        _descriptionTextView = [UITextView newAutoLayoutView];
        self.descriptionTextView.backgroundColor = [UIColor redColor];
        self.descriptionTextView.layer.cornerRadius = 7;
        self.descriptionTextView.autocorrectionType = NO;
        [self.contentView addSubview:self.descriptionTextView];
    }
    
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        
        [self.descriptionTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleTextField withOffset:kVerticalSpacing];
        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.descriptionTextView autoSetDimension:ALDimensionHeight toSize:50];
        [NSLayoutConstraint autoSetPriority:999 forConstraints:^{
            [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing];
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
