//
//  DBQuestionDetailViewController.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 11/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionDetailViewController.h"
#import "DBQuestionDetailView.h"
#import "DBQuestion.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "DBAttachment.h"
#import "DBAnswerQuestionDataSource.h"
#import "UIView+ActivityIndicatorView.h"
#import "DBAnswerQuestionView.h"
#import "DBAttachmentView.h"
#import "DBAnswer.h"
#import "DBAnswerComment.h"
#import "DBAnswerView.h"
#import "UIViewController+DBAlerts.h"
#import "DBUserPreferencesViewController.h"
#import "DBCreateQuestionViewController.h"

@interface DBQuestionDetailViewController ()

@property DBQuestion *question;
@property UIImagePickerController *imagePickerController;

@end

@implementation DBQuestionDetailViewController

- (instancetype)initWithQuestion:(DBQuestion *)question {
    self = [super init];
    if (self) {
        _question = question;
        _answerQuestionDataSource = [[DBAnswerQuestionDataSource alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAttachmentViewWasDeletedNotification:) name:kAttachmentViewWasDeletedNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAnswerViewCommentAnswerButtonWasPressedNotification:) name:kAnswerViewCommentAnswerButtonWasPressedNotification object:nil];
    }
    return self;
}

- (void)loadView {
    self.view = [[DBQuestionDetailView alloc] initWithQuestion:self.question];
    self.title = NSLocalizedString(@"Question detail", @"");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *addAttachment = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(captureVideo)];
    NSArray *toolbarItems;
    
    if (self.question.user == [PFUser currentUser]) {
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *editQuestion = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editQuestion)];
        toolbarItems = [NSArray arrayWithObjects:addAttachment, flexible, editQuestion, nil];

    } else {
        toolbarItems = [NSArray arrayWithObjects:addAttachment, nil];
    }
    
    self.toolbarItems = toolbarItems;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self reloadInputViews];
//    [self.view setNeedsDisplay];
//    [self.view layoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.questionDetailView. addTarget:self action:@selector(avatarButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.questionDetailView.userNameButton addTarget:self action:@selector(userNameButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Answer" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - UIImagePickerControllerSourceType

- (void)captureVideo {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Action Sheet" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        //         Cancel button tappped do nothing.
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imagePickerController =[[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie, kUTTypeImage, nil];
        self.imagePickerController.allowsEditing = NO;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController  animated:YES completion:nil];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imagePickerController =[[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        self.imagePickerController.allowsEditing = NO;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([picker isEqual:self.imagePickerController]) {
        if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
            DBAttachment *attachment = [[DBAttachment alloc] init];
            attachment.mimeType = kMimeTypeImageJPG;
            attachment.photoImage = info[UIImagePickerControllerOriginalImage];
            [self.answerQuestionDataSource.items addObject:attachment];
        } else {
            DBAttachment *attachment = [[DBAttachment alloc] init];
            attachment.mimeType = kMimeTypeVideoMOV;
            attachment.videoURL = info[UIImagePickerControllerMediaURL];
            attachment.photoImage = [attachment thumbnailImageForVideo:attachment.videoURL atTime:0];
            [self.answerQuestionDataSource.items addObject:attachment];
        }
        
        [self.questionDetailView addAnswerQuestionViewWithData:self.answerQuestionDataSource.items.lastObject];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {
    
    [self.questionDetailView showActivityIndicatorViewWithTitle:@"Posting..."];
    
    if (![self.questionDetailView.answerQuestionView.answerQuestionTextView.text isEqual:kDescriptionTextViewText]) {
        [DBAnswer uploadAnswerWithText:self.questionDetailView.answerQuestionView.answerQuestionTextView.text
                           attachemnts:self.answerQuestionDataSource.items
                            completion:^(DBAnswer *answer, NSError *error) {
                                if (self.question.answers) {
                                    NSMutableArray *newAnswers = [NSMutableArray arrayWithArray:self.question.answers];
                                    [newAnswers addObject:answer];
                                    self.question.answers = newAnswers;
                                } else {
                                    self.question.answers = [[NSMutableArray alloc] initWithObjects:answer, nil];
                                }
                                [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    if (!error) {
                                        
                                        // atIndex handle that subview is insert above answer textField
                                        [self.questionDetailView.stackView insertArrangedSubview:[[DBAnswerView alloc] initWithAnswer:answer] atIndex:self.questionDetailView.stackView.arrangedSubviews.count-1];
                                       
                                        [self.questionDetailView hideActivityIndicatorView];
                                    } else {
                                        [self showOKAlertWithTitle:NSLocalizedString(@"Error during posting answer", @"") message:error.localizedDescription];
                                    }
                                }];
                            }];
    } else {
        [self showOKAlertWithTitle:NSLocalizedString(@"Please enter description", @"") message:nil];
        [self.questionDetailView hideActivityIndicatorView];
    }
}

- (void)userNameButtonDidPress {
    DBUserPreferencesViewController *userPreferencesViewController = [[DBUserPreferencesViewController alloc] initWithUser:self.question.user];
    [self.navigationController pushViewController:userPreferencesViewController animated:YES];
}

- (void)editQuestion {
    DBCreateQuestionViewController *createQuestionViewController = [[DBCreateQuestionViewController alloc] initWithQuestion:self.question];
    [self.navigationController pushViewController:createQuestionViewController animated:NO];
}

#pragma mark - Notification

- (void)receiveAttachmentViewWasDeletedNotification:(NSNotification *)notification {
   
    if ([[notification name] isEqualToString:kAttachmentViewWasDeletedNotification]) {
        DBAttachment *attachmentToDelete = [notification.userInfo objectForKey:kAttachmentViewWasDeletedObjectKey];
        for(DBAttachment *attachment in self.answerQuestionDataSource.items) {
            if([attachment isEqual:attachmentToDelete]) {
                [self.answerQuestionDataSource.items removeObject:attachment];
                break;
            }
        }
    }
}

//- (void)receiveAnswerViewCommentAnswerButtonWasPressedNotification:(NSNotification *)notification {
//    
//    [self.questionDetailView showActivityIndicatorViewWithTitle:@"Posting..."];
//    
//    if ([[notification name] isEqualToString:kAnswerViewCommentAnswerButtonWasPressedNotification]) {
//        
//        if (![[notification.userInfo objectForKey:kAnswerViewCommentAnswerButtonWasPressedCommentTextObjectKey] isEqual:kDescriptionTextViewText]) {
//            [DBAnswerComment uploadAnswerCommentWithText:[notification.userInfo objectForKey:kAnswerViewCommentAnswerButtonWasPressedCommentTextObjectKey]
//                                                toAnswer:[notification.userInfo objectForKey:kAnswerViewCommentAnswerButtonWasPressedAnswertObjectKey]
//                                              completion:^(DBAnswerComment *answerComment, NSError *error) {
//                                                  if (!error) {
//                                                      self.view = [[DBQuestionDetailView alloc] initWithQuestion:self.question];
//                                                  } else {
//                                                      [self showOKAlertWithTitle:NSLocalizedString(@"Error during posting comment", @"") message:error.localizedDescription];
//                                                  }
//                                                  [self.questionDetailView hideActivityIndicatorView];
//                                              }];
//        } else {
//            [self showOKAlertWithTitle:NSLocalizedString(@"Please enter description", @"") message:nil];
//            [self.questionDetailView hideActivityIndicatorView];
//        }
//        
//    }
//    
//}

#pragma mark - Properties

- (DBQuestionDetailView *)questionDetailView {
    return (DBQuestionDetailView *)self.view;
}

@end
