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
        
        _stackView = [[UIStackView alloc] init];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.spacing = 5;
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
            
            if ([attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
                __block UIImageView *questionDetailPhotoImageView = [UIImageView newAutoLayoutView];
                NSURL *photoURL = [NSURL URLWithString:[kAWSS3BaseURL stringByAppendingPathComponent:attachment.fileName]];
                __weak UIImageView *weakQuestionDetailPhotoImageView = questionDetailPhotoImageView;
                [self.stackView addArrangedSubview:questionDetailPhotoImageView];
                [questionDetailPhotoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:photoURL]
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
                                               NSLog(@"Loaded successfully: %ld", (long)[response statusCode]);
                                               [weakQuestionDetailPhotoImageView setImage:image];
//                                               [weakQuestionDetailPhotoImageView autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.width / image.size.height))];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                               NSLog(@"failed loading: %@", error);
                                           }
                 ];
            } else if ([attachment.mimeType isEqualToString:kMimeTypeVideoMOV]) {
                DBVideoPlayerButton *videoPlayerButton = [[DBVideoPlayerButton alloc] initWithVideoURLFromS3:attachment.fileName];
                [self.stackView addArrangedSubview:videoPlayerButton];
            }
            
            UILabel *attachmentDescriptionLabel = [UILabel newAutoLayoutView];
            attachmentDescriptionLabel.numberOfLines = 0;
            attachmentDescriptionLabel.text = attachment.attachmentDescription;
            [attachmentDescriptionLabel sizeToFit];
            [self.stackView addArrangedSubview:attachmentDescriptionLabel];
        }
        
        for (DBAnswer *answer in question.answers) {
            
            UILabel *answerDescriptionLabel = [UILabel newAutoLayoutView];
            answerDescriptionLabel.numberOfLines = 0;
            answerDescriptionLabel.text = answer.textOfAnswer;
            [answerDescriptionLabel sizeToFit];
            [self.stackView addArrangedSubview:answerDescriptionLabel];
            
            for (DBAttachment *attachment in answer.attachments) {
                [self.stackView addArrangedSubview:[[DBAttachmentView alloc] initWithAttachment:attachment]];
            }
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
