//
//  DBAnswerViewController.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 15/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAnswerView;
@class DBAnswerDataSource;

@interface DBAnswerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate>

@property (nonatomic) DBAnswerView *answerQuestionView;
@property DBAnswerDataSource *answerQuestionDataSource;
//@property NSString *titleTextString;
@property NSString *descriptionTextString;
@property UIImagePickerController *picker;

@end