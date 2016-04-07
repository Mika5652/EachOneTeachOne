//
//  DBQuestionDetailView.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 10/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBQuestion;
@class DBAnswerQuestionView;
@class DBAttachment;

@interface DBQuestionDetailView : UIView

@property UIScrollView *scrollView;
@property UIStackView *stackView;
@property DBAnswerQuestionView *answerQuestionView;
@property UIButton *userNameButton;

- (instancetype)initWithQuestion:(DBQuestion *)question;
- (void)addAnswerQuestionViewWithData:(DBAttachment *)attachment;

@end
