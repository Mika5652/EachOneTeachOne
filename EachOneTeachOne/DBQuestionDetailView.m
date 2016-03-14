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
#import "DBVideoPlayerButton.h"

@interface DBQuestionDetailView ()

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
        
        _questionDetailTitleLabel = [UILabel newAutoLayoutView];
        self.questionDetailTitleLabel.numberOfLines = 0;
        self.questionDetailTitleLabel.text = question.title;
        [self.questionDetailTitleLabel sizeToFit];
        [self.stackView addArrangedSubview:self.questionDetailTitleLabel];
        
        _questionDetailDescriptionLabel = [UILabel newAutoLayoutView];
        self.questionDetailDescriptionLabel.numberOfLines = 0;
        self.questionDetailDescriptionLabel.text = question.questionDescription;
        [self.questionDetailDescriptionLabel sizeToFit];
        [self.stackView addArrangedSubview:self.questionDetailDescriptionLabel];

        
        for (DBAttachment *attachment in question.attachments) {
            
            if ([attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
                __block UIImageView *questionDetailPhotoImageView = [UIImageView newAutoLayoutView];
//                self.questionDetailPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
                NSURL *photoURL = [NSURL URLWithString:[[kAWSS3BaseURL stringByAppendingPathComponent:attachment.objectId] stringByAppendingPathExtension:kJPGExtenstion]];
//                __weak DBQuestionDetailView *weakSelf = self;
                __weak UIImageView *weakQuestionDetailPhotoImageView = questionDetailPhotoImageView;
                [self.stackView addArrangedSubview:questionDetailPhotoImageView];
                [questionDetailPhotoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:photoURL]
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
                                               NSLog(@"Loaded successfully: %d", [response statusCode]);
                                               [weakQuestionDetailPhotoImageView setImage:image];
//                                               [weakQuestionDetailPhotoImageView autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.width / image.size.height))];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                               NSLog(@"failed loading: %@", error);
                                           }
                 ];
            } else if ([attachment.mimeType isEqualToString:kMimeTypeVideoMOV]) {
                DBVideoPlayerButton *videoPlayerButton = [[DBVideoPlayerButton alloc] initWithVideoURLString:attachment.objectId];
                [self.stackView addArrangedSubview:videoPlayerButton];
            } else {
                
            }
            
            UILabel *attachmentDescriptionLabel = [UILabel newAutoLayoutView];
            attachmentDescriptionLabel.numberOfLines = 0;
            attachmentDescriptionLabel.text = attachment.attachmentDescription;
            [attachmentDescriptionLabel sizeToFit];
            [self.stackView addArrangedSubview:attachmentDescriptionLabel];
        }
        
        [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
        
    }
    return self;
}

@end
