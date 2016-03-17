//
//  DBAnswerView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 16/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAnswerQuestionView.h"
#import <PureLayout/PureLayout.h>
#import "DBAnswerQuestionDataSource.h"
#import "DBAttachment.h"
#import "UIImage+DBResizing.h"
#import "DBVideoPlayerButton.h"
#import "DBAttachmentView.h"

@interface DBAnswerQuestionView () <UITextViewDelegate>

@end

@implementation DBAnswerQuestionView 

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _stackView = [UIStackView newAutoLayoutView];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.spacing = 5;
        [self addSubview:self.stackView];
        [self.stackView autoPinEdgesToSuperviewEdges];
        
        _answerQuestionTextView = [UITextView newAutoLayoutView];
        self.answerQuestionTextView.autocorrectionType = NO;
        self.answerQuestionTextView.delegate = self;
        self.answerQuestionTextView.text = kDescriptionTextViewText;
        self.answerQuestionTextView.textColor = [UIColor lightGrayColor];
        self.answerQuestionTextView.backgroundColor = [UIColor redColor];
        [self.answerQuestionTextView autoSetDimension:ALDimensionHeight toSize:50];
        [self.stackView addArrangedSubview:self.answerQuestionTextView];
        
    }
    return self;
}

- (void)answerQuestionAttachmentsView:(DBAttachment *)attachment {
    [self.stackView addArrangedSubview:[[DBAttachmentView alloc] initWithAttachment:attachment]];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.answerQuestionTextView.text isEqualToString:kDescriptionTextViewText]) {
        self.answerQuestionTextView.text = @"";
        self.answerQuestionTextView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.answerQuestionTextView.text isEqualToString:@""]) {
        self.answerQuestionTextView.text = kDescriptionTextViewText;
        self.answerQuestionTextView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end

