//
//  DBCreateQuestionPhotoTableViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionPhotoTableViewCell.h"
#import <PureLayout/PureLayout.h>
#import "DBQuestionPhotoAttachment.h"

NSString * const kDBCreateQuestionPhotoTableViewCellIdentifier = @"kDBCreateQuestionPhotoTableViewCellIdentifier";
static CGFloat const kVerticalSpacing = 4;
static CGFloat const kHorizontalSpacing = 4;

@interface DBCreateQuestionPhotoTableViewCell () <UITextViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DBCreateQuestionPhotoTableViewCell

#pragma mark - Life Cycles

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _photoImageView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:self.photoImageView];
        
        _descriptionTextView = [UITextView newAutoLayoutView];
        self.descriptionTextView.delegate = self;
        [self.contentView addSubview:self.descriptionTextView];
        
    }
    
    return self;
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.photoImageView autoSetDimension:ALDimensionHeight toSize:50];
        
        [self.descriptionTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.photoImageView withOffset:kVerticalSpacing];
        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];

}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.questionPhotoAttachment.questionAttachmentDescription = self.descriptionTextView.text;
}

@end
