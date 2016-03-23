//
//  DBAnswerView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 23/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "DBAnswerView.h"
#import "DBAnswer.h"
#import "DBAttachmentView.h"
#import "DBAttachment.h"

@interface DBAnswerView () <UITextViewDelegate>

@property UIStackView *voteStackView;
@property UIButton *plusButton;
@property UIButton *minusButton;
@property UIButton *replyButton;
@property UILabel *voteLabel;
@property UITextView *commentAnswerTextView;
@property (nonatomic, assign) BOOL replyButtonWasPressed;

@end

@implementation DBAnswerView

- (instancetype)initWithAnswer:(DBAnswer *)answer {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _answer = answer;
        
        self.axis = UILayoutConstraintAxisVertical;
        self.distribution = UIStackViewDistributionEqualSpacing;
        self.alignment = UIStackViewAlignmentFill;
        self.spacing = 5;
        
        UILabel *answerDescriptionLabel = [UILabel newAutoLayoutView];
        answerDescriptionLabel.numberOfLines = 0;
        answerDescriptionLabel.text = answer.textOfAnswer;
        [answerDescriptionLabel sizeToFit];
        [self addArrangedSubview:answerDescriptionLabel];
        
        for (DBAttachment *attachment in answer.attachments) {
            [self addArrangedSubview:[[DBAttachmentView alloc] initWithAttachment:attachment isEditable:NO]];
        }
        
        [self addVoteStackViewToAnswer];
    }
    
    return self;
}

- (void)addVoteStackViewToAnswer {
        
    _voteStackView = [[UIStackView alloc] init];
    self.voteStackView.axis = UILayoutConstraintAxisHorizontal;
    self.voteStackView.distribution = UIStackViewDistributionFillEqually;
    self.voteStackView.alignment = UIStackViewAlignmentFill;
    self.voteStackView.spacing = 5;
    [self addArrangedSubview:self.voteStackView];
    
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.backgroundColor = [UIColor greenColor];
    [self.plusButton setTitle:@"+" forState:UIControlStateNormal];
    [self.plusButton addTarget:self action:@selector(plusButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    [self.voteStackView addArrangedSubview:self.plusButton];
    [self.plusButton autoSetDimension:ALDimensionHeight toSize:50];
    
    _voteLabel = [UILabel newAutoLayoutView];
    self.voteLabel.backgroundColor = [UIColor yellowColor];
    self.voteLabel.numberOfLines = 0;
    self.voteLabel.text = [NSString stringWithFormat:@"%d", self.answer.vote];
    self.voteLabel.textAlignment = NSTextAlignmentCenter;
    [self.voteLabel sizeToFit];
    [self.voteStackView addArrangedSubview:self.voteLabel];
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minusButton.backgroundColor = [UIColor redColor];
    [self.minusButton setTitle:@"-" forState:UIControlStateNormal];
    [self.minusButton addTarget:self action:@selector(minusButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    [self.voteStackView addArrangedSubview:self.minusButton];
    [self.minusButton autoSetDimension:ALDimensionHeight toSize:50];
    
    _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replyButton.backgroundColor = [UIColor redColor];
    [self.replyButton setTitle:@"Reply" forState:UIControlStateNormal];
    [self.replyButton addTarget:self action:@selector(replyButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    [self.voteStackView addArrangedSubview:self.replyButton];
    [self.replyButton autoSetDimension:ALDimensionHeight toSize:50];
    
    [self.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
}

#pragma mark - User Action

- (void)plusButtonDidPress {
    [DBAnswer changeAnswerVoteRating:self.answer wasPlusPressed:YES completion:^(int voteRating, NSError *error) {
        if (!error) {
            self.voteLabel.text = [NSString stringWithFormat:@"%d", voteRating];
        }
    }];
}

- (void)minusButtonDidPress {
    [DBAnswer changeAnswerVoteRating:self.answer wasPlusPressed:NO completion:^(int voteRating, NSError *error) {
        if (!error) {
            self.voteLabel.text = [NSString stringWithFormat:@"%d", voteRating];
        }
    }];
}

- (void)replyButtonDidPress {
    if (!self.replyButtonWasPressed) {
        
        _commentAnswerTextView = [UITextView newAutoLayoutView];
        self.commentAnswerTextView.layer.cornerRadius = 7;
        self.commentAnswerTextView.autocorrectionType = NO;
        self.commentAnswerTextView.delegate = self;
        self.commentAnswerTextView.text = kDescriptionTextViewText;
        self.commentAnswerTextView.textColor = [UIColor lightGrayColor];
        self.commentAnswerTextView.backgroundColor = [UIColor cyanColor];
        [self.commentAnswerTextView setScrollEnabled:NO];
        [self addArrangedSubview:self.commentAnswerTextView];
        
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.backgroundColor = [UIColor blackColor];
        [commentButton setTitle:@"Comment this Shit" forState:UIControlStateNormal];
//        [commentButton addTarget:self action:@selector(replyButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
        [self addArrangedSubview:commentButton];
        [commentButton autoSetDimension:ALDimensionHeight toSize:30];
        
        self.replyButtonWasPressed = YES;
    }
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
    if ([self.commentAnswerTextView.text isEqualToString:kDescriptionTextViewText]) {
        self.commentAnswerTextView.text = @"";
        self.commentAnswerTextView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.commentAnswerTextView.text isEqualToString:@""]) {
        self.commentAnswerTextView.text = kDescriptionTextViewText;
        self.commentAnswerTextView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
