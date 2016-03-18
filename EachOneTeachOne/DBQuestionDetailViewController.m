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
#import "UIViewController+DBAlerts.h"

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
    }
    return self;
}

- (void)loadView {
    self.view = [[DBQuestionDetailView alloc] initWithQuestion:self.question];
    self.title = NSLocalizedString(@"Question detail", @"");
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(captureVideo)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
    self.toolbarItems = toolbarItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Answer" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - UIImagePickerControllerSourceType

- (void)captureVideo {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController =[[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie, kUTTypeImage, nil];
        self.imagePickerController.allowsEditing = NO;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController  animated:YES completion:nil];
    }
    
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imagePickerController =[[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        self.imagePickerController.allowsEditing = NO;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
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
                                        self.view = [[DBQuestionDetailView alloc] initWithQuestion:self.question];
                                    } else {
                                        [self showOKAlertWithTitle:NSLocalizedString(@"Error during posting answer", @"") message:error.localizedDescription];
                                    }
                                }];
                                
                                [self.questionDetailView hideActivityIndicatorView];
                            }];
    } else {
        [self showOKAlertWithTitle:NSLocalizedString(@"Please enter description", @"") message:nil];
        [self.questionDetailView hideActivityIndicatorView];
    }
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

#pragma mark - Properties

- (DBQuestionDetailView *)questionDetailView {
    return (DBQuestionDetailView *)self.view;
}

@end
