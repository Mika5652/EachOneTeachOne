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

@interface DBAnswerQuestionView : UIStackView

@property UITextView *answerQuestionTextView;
@property DBAttachmentView *attachmentView;

- (void)answerQuestionAttachmentsView:(DBAttachment *)attachment;

@end
