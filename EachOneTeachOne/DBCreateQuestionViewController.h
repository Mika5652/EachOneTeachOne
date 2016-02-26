//
//  DBCreateFeedViewController.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

// Frameworks
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

// Macros
#define TAKE_VIDEO_ICON                 @"camera_icon"

@class DBCreateQuestionView;

@interface DBCreateQuestionViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate ,UITextViewDelegate>

@property (readonly) DBCreateQuestionView* createQuestionView;
@property NSString *titleTextString;
@property NSString *descriptionTextString;
@property UIImagePickerController *picker;

@end
