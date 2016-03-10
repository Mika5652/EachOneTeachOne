//
//  BDCreateQuestionTitleAndDescriptionTableViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionTitleAndDescriptionTableViewCell.h"
#import <PureLayout/PureLayout.h>
#import "DBCreateQuestionDataSource.h"

NSString * const kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier = @"kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier";
static NSString * const kDescriptionTextViewText = @"Description...";
static CGFloat const kVerticalSpacing = 4;
static CGFloat const kHorizontalSpacing = 4;

@interface DBCreateQuestionTitleAndDescriptionTableViewCell () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DBCreateQuestionTitleAndDescriptionTableViewCell

#pragma mark - Lifecycles

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleTextField = [UITextField newAutoLayoutView];
        self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.titleTextField.placeholder = NSLocalizedString(@"Title ", nil);
        self.titleTextField.autocorrectionType = NO;
        self.titleTextField.delegate = self;
        [self.contentView addSubview:self.titleTextField];
        
        _descriptionTextView = [UITextView newAutoLayoutView];
        self.descriptionTextView.layer.cornerRadius = 7;
        self.descriptionTextView.autocorrectionType = NO;
        self.descriptionTextView.delegate = self;
        self.descriptionTextView.text = kDescriptionTextViewText;
        self.descriptionTextView.textColor = [UIColor lightGrayColor];
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

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView isEqual:self.descriptionTextView]) {
        if ([self.descriptionTextView.text isEqualToString:kDescriptionTextViewText]) {
            self.descriptionTextView.text = @"";
            self.descriptionTextView.textColor = [UIColor blackColor];
        }
        [textView becomeFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView isEqual:self.descriptionTextView]) {
        if ([self.descriptionTextView.text isEqualToString:@""]) {
            self.descriptionTextView.text = kDescriptionTextViewText;
            self.descriptionTextView.textColor = [UIColor lightGrayColor];
            self.dataSource.questionDescription = @"";
        } else {
            self.dataSource.questionDescription = self.descriptionTextView.text;
        }
    }
    [textView resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.titleTextField]) {
        self.dataSource.questionTitle = textField.text;
    }
}

@end
