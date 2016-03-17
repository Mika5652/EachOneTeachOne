//
//  DBAnswerView.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 16/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAttachmentView;
@class DBAttachment;

@interface DBAnswerQuestionView : UIView

@property UITextView *answerQuestionTextView;
@property UIStackView *stackView;
@property DBAttachmentView *answerQuestionAttachmentView;

- (void)answerQuestionAttachmentsView:(DBAttachment *)attachment;

@end
