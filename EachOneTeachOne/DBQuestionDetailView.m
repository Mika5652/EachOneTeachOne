//
//  DBQuestionDetailView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 10/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "DBQuestionDetailView.h"
#import "DBQuestion.h"
#import "DBAttachment.h"
#import <UIImageView+AFNetworking.h>

@interface DBQuestionDetailView ()

@end

@implementation DBQuestionDetailView

- (instancetype)initWithQuestion:(DBQuestion *)question {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor redColor];
        [self addSubview:self.scrollView];
        [self.scrollView autoPinEdgesToSuperviewEdges];
        
        _stackView = [[UIStackView alloc] init];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
//        self.stackView.alignment = UIStackViewAlignmentCenter;
        self.stackView.spacing = 5;
        [self.scrollView addSubview:self.stackView];
        [self.stackView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:64];
        [self.stackView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self];
        [self.stackView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self];
        [self.stackView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        
        _questionDetailTitleLabel = [UILabel newAutoLayoutView];
        self.questionDetailTitleLabel.text = question.title;
        [self.stackView addArrangedSubview:self.questionDetailTitleLabel];
        
        _questionDetailDescriptionLabel = [UILabel newAutoLayoutView];
        self.questionDetailDescriptionLabel.text = question.questionDescription;
        [self.stackView addArrangedSubview:self.questionDetailDescriptionLabel];

        for (DBAttachment *attachment in question.attachments) {
            _questionDetailPhotoImageView = [UIImageView newAutoLayoutView];
            NSURL *photoURL = [NSURL URLWithString:[[kAWSS3BaseURL stringByAppendingPathComponent:attachment.objectId] stringByAppendingPathExtension:@"jpg"]];
            [self.questionDetailPhotoImageView setImageWithURL:photoURL placeholderImage:nil];
            [self.stackView addArrangedSubview:self.questionDetailPhotoImageView];
        }
        
//        [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
//        [self.stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
        
    }
    return self;
}

@end
