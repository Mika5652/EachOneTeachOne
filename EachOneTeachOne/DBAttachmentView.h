//
//  DBAnswerQuestionAttachmentView.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 17/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAttachment;

extern NSString * const kDescriptionTextViewText;
extern NSString * const kAttachmentViewDescriptionTextViewDidChangeNotification;
extern NSString * const kAttachmentViewWasDeletedNotification;
extern NSString * const kAttachmentViewWasDeletedObjectKey;

@interface DBAttachmentView : UIStackView

@property (nonatomic) UITextView *descriptionTextView;
@property (nonatomic) DBAttachment *attachment;

- (instancetype)initWithAttachment:(DBAttachment *)attachment isEditable:(BOOL)isEditable;

@end
