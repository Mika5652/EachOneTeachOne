//
//  DBCreateFeedViewController.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

// Macros
#define TAKE_VIDEO_ICON                 @"camera_icon"

@class DBCreateQuestionView;
@class DBCreateQuestionTitleAndDescriptionTableViewCell;

@interface DBCreateQuestionViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate>

@property (nonatomic) DBCreateQuestionView *createQuestionView;
@property (nonatomic) DBCreateQuestionTitleAndDescriptionTableViewCell *createQuestionTitleAndDescriptionTableViewCell;
@property NSString *titleTextString;
@property NSString *descriptionTextString;
@property UIImagePickerController *picker;

@end
