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

@interface DBAttachmentView : UIView

@property UITextView *descriptionTextView;
@property (nonatomic) DBAttachment *attachment;
@property UIStackView *stackView;

- (instancetype)initWithAttachment:(DBAttachment *)attachment;

@end
