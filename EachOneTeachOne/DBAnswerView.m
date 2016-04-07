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
#import "DBAnswerComment.h"
#import "UIView+ActivityIndicatorView.h"
#import "UIViewController+DBAlerts.h"
#import "DBActivityIndicatorView.h"

NSString * const kAnswerViewCommentAnswerButtonWasPressedNotification = @"AnswerViewCommentAnswerButtonWasPressedNotification";
NSString * const kAnswerViewCommentAnswerButtonWasPressedCommentTextObjectKey = @"AnswerViewCommentAnswerButtonWasPressedCommentTextObjectKey";
NSString * const kAnswerViewCommentAnswerButtonWasPressedAnswertObjectKey = @"AnswerViewCommentAnswerButtonWasPressedAnswertObjectKey";

@interface DBAnswerView () <UITextViewDelegate>

@property UIStackView *voteStackView;
@property UIButton *plusButton;
@property UIButton *minusButton;
@property UIButton *replyButton;
@property UIButton *commentButton;
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
        
        for (DBAnswerComment *answerComment in answer.comments) {
            UILabel *answerCommentLabel = [UILabel newAutoLayoutView];
            answerCommentLabel.numberOfLines = 0;
            answerCommentLabel.text = answerComment.textOfComment;
            answerCommentLabel.textColor = [UIColor cyanColor];
            [answerCommentLabel sizeToFit];
            [self addArrangedSubview:answerCommentLabel];
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
    self.voteLabel.text = [NSString stringWithFormat:@"%ld", (self.answer.upvotes.count - self.answer.downvotes.count)];
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
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton.backgroundColor = [UIColor blackColor];
        [self.commentButton setTitle:@"Comment this Shit" forState:UIControlStateNormal];
        [self.commentButton addTarget:self action:@selector(commentbuttonDidPress) forControlEvents:UIControlEventTouchUpInside];
        [self addArrangedSubview:self.commentButton];
        [self.commentButton autoSetDimension:ALDimensionHeight toSize:30];
        
        self.replyButtonWasPressed = YES;
    }
}

- (void)commentbuttonDidPress {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kAnswerViewCommentAnswerButtonWasPressedNotification object:nil userInfo:@{kAnswerViewCommentAnswerButtonWasPressedCommentTextObjectKey : self.commentAnswerTextView.text, kAnswerViewCommentAnswerButtonWasPressedAnswertObjectKey : self.answer}];
    
    [self.superview showActivityIndicatorViewWithTitle:@"Posting..."];


    if (![self.commentAnswerTextView.text isEqual:kDescriptionTextViewText]) {
        [DBAnswerComment uploadAnswerCommentWithText:self.commentAnswerTextView.text
                                            toAnswer:self.answer
                                          completion:^(DBAnswerComment *answerComment, NSError *error) {
                                              if (!error) {
                                                  
                                                  [self removeArrangedSubview:self.commentAnswerTextView];
                                                  [self.commentAnswerTextView removeFromSuperview];
                                                  [self removeArrangedSubview:self.commentButton];
                                                  [self.commentButton removeFromSuperview];
                                                  
                                                  UILabel *newAnswerCommentLabel = [UILabel newAutoLayoutView];
                                                  newAnswerCommentLabel.numberOfLines = 0;
                                                  newAnswerCommentLabel.text = answerComment.textOfComment;
                                                  newAnswerCommentLabel.textColor = [UIColor cyanColor];
                                                  [newAnswerCommentLabel sizeToFit];

                                                  // atIndex handle that subview is insert above VoteStackView
                                                  [self insertArrangedSubview:newAnswerCommentLabel atIndex:self.arrangedSubviews.count-1];
                                                  
                                                  self.commentAnswerTextView = nil;
                                                  self.commentButton = nil;
                                                  self.replyButtonWasPressed = NO;
                                                  
                                              } else {
//                                                  [self showOKAlertWithTitle:NSLocalizedString(@"Error during posting comment", @"") message:error.localizedDescription];
                                              }
                                              [self.superview hideActivityIndicatorView];
                                          }];
    } else {
//        [self showOKAlertWithTitle:NSLocalizedString(@"Please enter description", @"") message:nil];
        [self.superview hideActivityIndicatorView];
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
