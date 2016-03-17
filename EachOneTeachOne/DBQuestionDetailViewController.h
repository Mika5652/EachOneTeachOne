//
//  DBQuestionDetailViewController.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 11/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBQuestion;
@class DBAnswerQuestionDataSource;
@class DBQuestionDetailView;

@interface DBQuestionDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate>

@property (nonatomic) DBQuestionDetailView *questionDetailView;
@property DBAnswerQuestionDataSource *answerQuestionDataSource;

- (instancetype)initWithQuestion:(DBQuestion *)question;

@end
