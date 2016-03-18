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

NSString * const kAttachmentViewWasDeletedNotification = @"AttachmentViewWasDeletedNotification";
NSString * const kAttachmentViewWasDeletedObjectKey = @"AttachmentViewWasDeletedObjectKey";
NSString * const kDescriptionTextViewText = @"Description...";

@interface DBAttachmentView () <UITextViewDelegate>

@property UIButton *deleteButton;

@end

@implementation DBAttachmentView

- (instancetype)initWithAttachment:(DBAttachment *)attachment isEditable:(BOOL)isEditable {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _attachment = attachment;
        
        self.axis = UILayoutConstraintAxisVertical;
        self.distribution = UIStackViewDistributionEqualSpacing;
        self.alignment = UIStackViewAlignmentFill;
        self.spacing = 5;
        
        if ([self.attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
            UIImageView *answerQuestionPhotoImageView = [UIImageView newAutoLayoutView];
            
            if (self.attachment.photoImage == nil) {
                
                if ([attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
                    __block UIImageView *answerQuestionPhotoImageView = [UIImageView newAutoLayoutView];                    
                    NSURL *photoURL = [NSURL URLWithString:[kAWSS3BaseURL stringByAppendingPathComponent:attachment.fileName]];
                    __weak UIImageView *weakQuestionDetailPhotoImageView = answerQuestionPhotoImageView;
                    [self addArrangedSubview:answerQuestionPhotoImageView];
                    [answerQuestionPhotoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:photoURL]
                                                        placeholderImage:nil
                                                                 success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
                                                                     NSLog(@"Loaded successfully: %ld", (long)[response statusCode]);
                                                                     [weakQuestionDetailPhotoImageView setImage:image];
                                                                     NSLog(@"%f > %f",([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height));
                                                                     [weakQuestionDetailPhotoImageView autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.height / image.size.width))];
                                                                     NSLog(@"%f > %f", weakQuestionDetailPhotoImageView.frame.size.width, weakQuestionDetailPhotoImageView.frame.size.height);
                                                                 }
                                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                                     NSLog(@"failed loading: %@", error);
                                                                 }
                     ];
                }
            } else {
                UIImage *image = self.attachment.photoImage;
                image = [image photoResizedToSize:CGSizeMake(kPhotoWidth, image.size.height*(kPhotoWidth/image.size.width))];
                [answerQuestionPhotoImageView setImage:image];
                [self addArrangedSubview:answerQuestionPhotoImageView];
                [answerQuestionPhotoImageView autoSetDimension:ALDimensionHeight toSize:([UIScreen mainScreen].bounds.size.width * (image.size.height / image.size.width))];
            }
            [self addAnswerDescription:isEditable];
            [self addDeleteButton:isEditable];
            
        }else if ([self.attachment.mimeType isEqualToString:kMimeTypeVideoMOV]) {
            
            if (self.attachment.videoURL == nil) {
                DBVideoPlayerButton *videoPlayerButton = [[DBVideoPlayerButton alloc] initWithVideoURLFromS3:self.attachment.fileName];
                [self addArrangedSubview:videoPlayerButton];
            } else {
                DBVideoPlayerButton *videoPlayerButton = [[DBVideoPlayerButton alloc] initWithLocalVideoURL:self.attachment.videoURL];
                [self addArrangedSubview:videoPlayerButton];
            }
            [self addAnswerDescription:isEditable];
            [self addDeleteButton:isEditable];
        }
    }
    
    return self;
}

- (void)addAnswerDescription:(BOOL)isEditable {
    
    if (isEditable == YES) {
        _descriptionTextView = [UITextView newAutoLayoutView];
        self.descriptionTextView.layer.cornerRadius = 7;
        self.descriptionTextView.autocorrectionType = NO;
        self.descriptionTextView.delegate = self;
        self.descriptionTextView.text = kDescriptionTextViewText;
        self.descriptionTextView.textColor = [UIColor lightGrayColor];
        self.descriptionTextView.backgroundColor = [UIColor greenColor];
        [self.descriptionTextView setScrollEnabled:NO];
        [self addArrangedSubview:self.descriptionTextView];
    } else {
        UILabel *answerAttachmentLabel = [UILabel newAutoLayoutView];
        answerAttachmentLabel.numberOfLines = 0;
        answerAttachmentLabel.text = self.attachment.attachmentDescription;
        [answerAttachmentLabel sizeToFit];
        [self addArrangedSubview:answerAttachmentLabel];
    }
}

-(void)addDeleteButton:(BOOL)isEditable {
    
    if (isEditable == YES) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.backgroundColor = [UIColor redColor];
//        UIImage *buttonImage = [UIImage imageNamed:@"playButton"];
//        [self.deleteButton setImage:buttonImage forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
        [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.deleteButton autoSetDimension:ALDimensionHeight toSize:50];
        [self.deleteButton autoSetDimension:ALDimensionWidth toSize:50];
    }
}

- (void)deleteButtonDidPress {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAttachmentViewWasDeletedNotification object:nil userInfo:@{kAttachmentViewWasDeletedObjectKey : self.attachment}];
    [self removeFromSuperview];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.attachment.attachmentDescription = self.descriptionTextView.text;
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
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
