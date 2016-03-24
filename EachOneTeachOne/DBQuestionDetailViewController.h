//
//  DBQuestionDetailViewController.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 11/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBQuestion;
@class DBAttachment;
@class DBQuestionDetailView;
@class DBAnswerQuestionDataSource;

@interface DBQuestionDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate>

@property (nonatomic) DBQuestionDetailView *questionDetailView;
@property DBAnswerQuestionDataSource *answerQuestionDataSource;

- (instancetype)initWithQuestion:(DBQuestion *)question;
//- (void)deleteAttachmentFromDataSource:(DBAttachment *)attachmentToDelete;

@end
