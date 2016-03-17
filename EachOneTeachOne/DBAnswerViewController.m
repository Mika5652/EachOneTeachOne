//
//  DBAnswerViewController.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 15/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAnswerViewController.h"
#import "UIViewController+DBAlerts.h"
#import "DBAnswerView.h"
#import "UIView+ActivityIndicatorView.h"
#import "DBActivityIndicatorView.h"
#import "DBQuestion.h"
#import "DBAttachment.h"
#import "DBAnswerDataSource.h"
#import "DBAnswerDescriptionTableViewCell.h"
#import "DBAnswerPhotoTableViewCell.h"
#import "DBAnswerVideoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DBAnswerViewController ()

@property UIImagePickerController *imagePickerController;
@property NSString *questionTitleString;
@property NSString *questionDescriptionString;

@end

@implementation DBAnswerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _answerQuestionDataSource = [[DBAnswerDataSource alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserve?r:self selector:@selector(receiveCreateQuestionDescriptionTextDidChangeNotification:) name:kCreateQuestionDescriptionTextDidChangeNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCreateQuestionTitleTextDidChangeNotification:) name:kCreateQuestionTitleTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)loadView {
    self.view = [[DBAnswerView alloc] init];
//    self.title = NSLocalizedString(@"Create a post", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //    self.navigationController.toolbarHidden = NO;
    //    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(captureVideo)];
    //    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
    //    self.toolbarItems = toolbarItems;
    
    self.answerQuestionView.tableView.dataSource = self.answerQuestionDataSource;
    self.answerQuestionView.tableView.delegate = self;
    [self.answerQuestionView.tableView registerClass:[DBAnswerDescriptionTableViewCell class] forCellReuseIdentifier:kDBAnswerDescriptionTableViewCellIdentifier];
    [self.answerQuestionView.tableView registerClass:[DBAnswerPhotoTableViewCell class] forCellReuseIdentifier:kDBAnswerPhotoTableViewCellIdentifier];
    [self.answerQuestionView.tableView registerClass:[DBAnswerVideoTableViewCell class] forCellReuseIdentifier:kDBAnswerVideoTableViewIdentifier];
}
- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(captureVideo)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
    self.toolbarItems = toolbarItems;
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
        
        [self.answerQuestionView.tableView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {
    
//    [self.view showActivityIndicatorViewWithTitle:@"Posting..."];
//    
//    if (self.questionTitleString) {
//        [DBQuestion uploadQuestionWithTitle:self.questionTitleString
//                         questionDesciption:self.questionDescriptionString
//                                  dataArray:self.answerQuestionDataSource.items
//                                 completion:^(DBQuestion *question, NSError *error) {
//                                     if (!error) {
//                                         dispatch_async(dispatch_get_main_queue(), ^{
//                                             [self.navigationController popViewControllerAnimated:YES];
//                                         });
//                                     } else {
//                                         [self showAlertWithTitle:NSLocalizedString(@"Something is broken", @"") message:NSLocalizedString(@"There is some error, please try post your question later", @"") dismissButtonText:@"OK BRO"];
//                                     }
//                                 }];
//    } else {
//        NSLog(@"Empty input");
//        [self.view hideActivityIndicatorView];
//    }
}

#pragma mark - Properties

- (DBAnswerView *)answerQuestionView {
    return (DBAnswerView *)self.view;
}

@end
