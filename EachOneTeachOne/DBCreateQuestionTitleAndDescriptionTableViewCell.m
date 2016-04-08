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
#import "DBAttachmentView.h"

NSString * const kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier = @"kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier";
NSString * const kCreateQuestionDescriptionTextViewDidChangeNotification = @"kCreateQuestionDescriptionTextViewDidChangeNotification";
NSString * const kCreateQuestionDescriptionTextDidChangeNotification = @"CreateQuestionDescriptionTextDidChangeNotification";
NSString * const kCreateQuestionTitleTextDidChangeNotification = @"CreateQuestionTitleTextDidChangeNotification";
NSString * const kCreateQuestionDescriptionTextViewKey = @"kCreateQuestionDescriptionTextViewKey";
NSString * const kCreateQuestionDescriptionTextKey = @"CreateQuestionDescriptionTextKey";
NSString * const kCreateQuestionTitleTextKey = @"CreateQuestionTitleTextKey";
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
        [self.descriptionTextView setScrollEnabled:NO];
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
//        [self.descriptionTextView autoSetDimension:ALDimensionHeight toSize:self.descriptionTextView.frame.size.height];
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
//    [self scrollToCursorForTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView isEqual:self.descriptionTextView]) {
        if ([self.descriptionTextView.text isEqualToString:@""]) {
            self.descriptionTextView.text = kDescriptionTextViewText;
            self.descriptionTextView.textColor = [UIColor lightGrayColor];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCreateQuestionDescriptionTextDidChangeNotification object:nil userInfo:@{kCreateQuestionDescriptionTextKey : @""}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCreateQuestionDescriptionTextDidChangeNotification object:nil userInfo:@{kCreateQuestionDescriptionTextKey : self.descriptionTextView.text}];
        }
    }
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    if (!(textView.frame.size.height == newFrame.size.height)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateQuestionDescriptionTextViewDidChangeNotification object:nil userInfo:@{kCreateQuestionDescriptionTextViewKey : @(newFrame.size.height + self.titleTextField.frame.size.height+12)}];
    }
    
    textView.frame = newFrame;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.titleTextField]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateQuestionTitleTextDidChangeNotification object:nil userInfo:@{kCreateQuestionTitleTextKey : self.titleTextField.text}];
    }
    [textField resignFirstResponder];
}

@end
