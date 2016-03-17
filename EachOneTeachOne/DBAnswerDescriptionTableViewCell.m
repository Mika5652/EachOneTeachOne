//
//  DBAnswerDescriptionTableViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 15/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAnswerDescriptionTableViewCell.h"
#import <PureLayout/PureLayout.h>

NSString * const kDBAnswerDescriptionTableViewCellIdentifier = @"kDBAnswerDescriptionTableViewCellIdentifier";
static NSString * const kDescriptionTextViewText = @"Description...";
static CGFloat const kVerticalSpacing = 4;
static CGFloat const kHorizontalSpacing = 4;

@interface DBAnswerDescriptionTableViewCell () <UITextViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DBAnswerDescriptionTableViewCell

#pragma mark - Lifecycles

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _answerDescriptionTextView = [UITextView newAutoLayoutView];
        self.answerDescriptionTextView.autocorrectionType = NO;
        self.answerDescriptionTextView.delegate = self;
        self.answerDescriptionTextView.text = kDescriptionTextViewText;
        self.answerDescriptionTextView.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.answerDescriptionTextView];
    }
    
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        [self.answerDescriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
        [self.answerDescriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.answerDescriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        [self.answerDescriptionTextView autoSetDimension:ALDimensionHeight toSize:50];
        [NSLayoutConstraint autoSetPriority:999 forConstraints:^{
            [self.answerDescriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalSpacing];
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - UITextViewDelegate

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    if ([textView isEqual:self.answerDescriptionTextView]) {
//        if ([self.answerDescriptionTextView.text isEqualToString:kDescriptionTextViewText]) {
//            self.answerDescriptionTextView.text = @"";
//            self.answerDescriptionTextView.textColor = [UIColor blackColor];
//        }
//        [textView becomeFirstResponder];
//    }
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    if ([textView isEqual:self.answerDescriptionTextView]) {
//        if ([self.answerDescriptionTextView.text isEqualToString:@""]) {
//            self.answerDescriptionTextView.text = kDescriptionTextViewText;
//            self.answerDescriptionTextView.textColor = [UIColor lightGrayColor];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kCreateQuestionDescriptionTextDidChangeNotification object:nil userInfo:@{kCreateQuestionDescriptionTextKey : @""}];
//        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kCreateQuestionDescriptionTextDidChangeNotification object:nil userInfo:@{kCreateQuestionDescriptionTextKey : self.descriptionTextView.text}];
//        }
//    }
//    [textView resignFirstResponder];
//}

@end
