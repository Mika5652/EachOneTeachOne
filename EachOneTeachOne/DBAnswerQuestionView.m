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
        
        self.axis = UILayoutConstraintAxisVertical;
        self.distribution = UIStackViewDistributionEqualSpacing;
        self.alignment = UIStackViewAlignmentFill;
        self.spacing = 5;
        
        _answerQuestionTextView = [UITextView newAutoLayoutView];
        self.answerQuestionTextView.autocorrectionType = NO;
        self.answerQuestionTextView.delegate = self;
        self.answerQuestionTextView.text = kDescriptionTextViewText;
        self.answerQuestionTextView.textColor = [UIColor lightGrayColor];
        self.answerQuestionTextView.backgroundColor = [UIColor redColor];
        [self.answerQuestionTextView setScrollEnabled:NO];
        [self addArrangedSubview:self.answerQuestionTextView];
        
    }
    return self;
}

- (void)answerQuestionAttachmentsView:(DBAttachment *)attachment {
    _attachmentView = [[DBAttachmentView alloc] initWithAttachment:attachment isEditable:YES];
    [self addArrangedSubview:self.attachmentView];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

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

