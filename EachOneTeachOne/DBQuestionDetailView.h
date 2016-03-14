//
//  DBQuestionDetailView.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 10/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBQuestion;

@interface DBQuestionDetailView : UIView

@property UIScrollView *scrollView;
@property UIStackView *stackView;

@property UILabel *questionDetailTitleLabel;
@property UILabel *questionDetailDescriptionLabel;

- (instancetype)initWithQuestion:(DBQuestion *)question;

@end
