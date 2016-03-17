//
//  DBAnswerQuestionAttachmentView.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 17/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAttachmentView.h"
#import <PureLayout/PureLayout.h>
#import "DBAttachment.h"
#import "DBQuestion.h"
#import "UIImage+DBResizing.h"
#import "DBVideoPlayerButton.h"
#import <UIImageView+AFNetworking.h>

NSString * const kDescriptionTextViewText = @"Description...";

@interface DBAttachmentView () <UITextViewDelegate>

@end

@implementation DBAttachmentView

- (instancetype)initWithAttachment:(DBAttachment *)attachment {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _attachment = attachment;
        
        _stackView = [UIStackView newAutoLayoutView];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.spacing = 5;
        [self addSubview:self.stackView];
        [self.stackView autoPinEdgesToSuperviewEdges];
        
        if ([self.attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
            UIImageView *answerQuestionPhotoImageView = [UIImageView newAutoLayoutView];
            
            if (self.attachment.photoImage == nil) {
                
                if ([attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
                    __block UIImageView *answerQuestionPhotoImageView = [UIImageView newAutoLayoutView];                    
                    NSURL *photoURL = [NSURL URLWithString:[kAWSS3BaseURL stringByAppendingPathComponent:attachment.fileName]];
                    __weak UIImageView *weakQuestionDetailPhotoImageView = answerQuestionPhotoImageView;
                    [self.stackView addArrangedSubview:answerQuestionPhotoImageView];
                    [answerQuestionPhotoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:photoURL]
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
                    [self addAnswerAttachmentlabel];
                }
            } else {
                UIImage *image = self.attachment.photoImage;
                image = [image photoResizedToSize:CGSizeMake(kPhotoWidth, image.size.height*(kPhotoWidth/image.size.width))];
                [answerQuestionPhotoImageView setImage:image];
                [self.stackView addArrangedSubview:answerQuestionPhotoImageView];
                [answerQuestionPhotoImageView autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.height / image.size.width))];
                
                [self addAnswerDesctiptionTextView];
            }
        }else if ([self.attachment.mimeType isEqualToString:kMimeTypeVideoMOV]) {
            
            if (self.attachment.videoURL == nil) {
                DBVideoPlayerButton *videoPlayerButton = [[DBVideoPlayerButton alloc] initWithVideoURLFromS3:self.attachment.fileName];
                [self.stackView addArrangedSubview:videoPlayerButton];
                
                [self addAnswerAttachmentlabel];
                
            } else {
                DBVideoPlayerButton *videoPlayerButton = [[DBVideoPlayerButton alloc] initWithLocalVideoURL:self.attachment.videoURL];
                [self.stackView addArrangedSubview:videoPlayerButton];
                
                [self addAnswerDesctiptionTextView];
            }
        }
    }
    
    return self;
}

- (void)addAnswerDesctiptionTextView{
    _descriptionTextView = [UITextView newAutoLayoutView];
    self.descriptionTextView.layer.cornerRadius = 7;
    self.descriptionTextView.autocorrectionType = NO;
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.text = kDescriptionTextViewText;
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    self.descriptionTextView.backgroundColor = [UIColor greenColor];
    [self.descriptionTextView autoSetDimension:ALDimensionHeight toSize:50];
    [self.stackView addArrangedSubview:self.descriptionTextView];
}

- (void)addAnswerAttachmentlabel {
    UILabel *answerAttachmentLabel = [UILabel newAutoLayoutView];
    answerAttachmentLabel.numberOfLines = 0;
    answerAttachmentLabel.text = self.attachment.attachmentDescription;
    [answerAttachmentLabel sizeToFit];
    [self.stackView addArrangedSubview:answerAttachmentLabel];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.attachment.attachmentDescription = self.descriptionTextView.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.descriptionTextView.text isEqualToString:kDescriptionTextViewText]) {
        self.descriptionTextView.text = @"";
        self.descriptionTextView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.descriptionTextView.text isEqualToString:@""]) {
        self.descriptionTextView.text = kDescriptionTextViewText;
        self.descriptionTextView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
