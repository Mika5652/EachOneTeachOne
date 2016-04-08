//
//  DBQuestionDetailView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 10/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import <UIKit/UIKit.h>
#import "DBQuestionDetailView.h"
#import "DBQuestion.h"
#import "DBAttachment.h"
#import <UIImageView+AFNetworking.h>
#import "DBVideoPlayerButton.h"
#import "DBAnswerQuestionDataSource.h"
#import "UIImage+DBResizing.h"
#import "DBAnswerQuestionView.h"
#import "UIView+ActivityIndicatorView.h"
#import "DBActivityIndicatorView.h"
#import "DBAnswer.h"
#import "DBQuestionDetailViewController.h"
#import "DBAttachmentView.h"
#import "DBAnswerView.h"
#import "DBUserPreferencesEditableViewController.h"

@interface DBQuestionDetailView () <UITextViewDelegate>

@end

@implementation DBQuestionDetailView

- (instancetype)initWithQuestion:(DBQuestion *)question {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
        [self.scrollView autoPinEdgesToSuperviewEdges];
//        [self.scrollView setContentInset:UIEdgeInsetsMake(64, 0, 64, 0)];
        
        _stackView = [[UIStackView alloc] init];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.spacing = 0;
        [self.scrollView addSubview:self.stackView];
        [self.stackView autoPinEdgesToSuperviewEdges];
        
        UILabel *questionDetailTitleLabel = [UILabel newAutoLayoutView];
        questionDetailTitleLabel.numberOfLines = 0;
        questionDetailTitleLabel.text = question.title;
        [questionDetailTitleLabel sizeToFit];
        [self.stackView addArrangedSubview:questionDetailTitleLabel];
        
        UILabel *questionDetailDescriptionLabel = [UILabel newAutoLayoutView];
        questionDetailDescriptionLabel.numberOfLines = 0;
        questionDetailDescriptionLabel.text = question.questionDescription;
        [questionDetailDescriptionLabel sizeToFit];
        [self.stackView addArrangedSubview:questionDetailDescriptionLabel];
        
        for (DBAttachment *attachment in question.attachments) {
            [self.stackView addArrangedSubview:[[DBAttachmentView alloc] initWithAttachment:attachment isEditable:NO]];
        }
        
        _userNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.userNameButton setTitle:question.user.username forState:UIControlStateNormal];
        [self.userNameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.userNameButton sizeToFit];
        [self.stackView addArrangedSubview:self.userNameButton];
        
        for (DBAnswer *answer in question.answers) {
            [self.stackView addArrangedSubview:[[DBAnswerView alloc] initWithAnswer:answer]];
        }
        
        _answerQuestionView = [DBAnswerQuestionView newAutoLayoutView];
        [self.stackView addArrangedSubview:self.answerQuestionView];
        
        [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
        
    }
    return self;
}

- (void)addAnswerQuestionViewWithData:(DBAttachment *)attachment {
    [self.stackView removeArrangedSubview:self.answerQuestionView];
    [self.answerQuestionView removeFromSuperview];
    [self.answerQuestionView answerQuestionAttachmentsView:attachment];
    [self.stackView addArrangedSubview:self.answerQuestionView];
}



@end
