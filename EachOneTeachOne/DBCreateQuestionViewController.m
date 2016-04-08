//
//  DBcreateQuestionViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// View Controllers
#import "DBCreateQuestionViewController.h"
#import "UIViewController+DBAlerts.h"

// Views
#import "DBCreateQuestionView.h"
#import "UIView+ActivityIndicatorView.h"
#import "DBActivityIndicatorView.h"

// Entities
#import "DBQuestion.h"
#import "DBAttachment.h"

// Data Sources
#import "DBCreateQuestionDataSource.h"

// Cell
#import "DBCreateQuestionTitleAndDescriptionTableViewCell.h"
#import "DBCreateQuestionAttachmentTableViewCell.h"
#import "DBAttachmentView.h"

// Frameworks
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DBCreateQuestionViewController ()

@property UIImagePickerController *imagePickerController;
@property DBQuestion *question;

@end

@implementation DBCreateQuestionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _createQuestionDataSource = [[DBCreateQuestionDataSource alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCreateQuestionDescriptionTextViewDidChangeNotification:) name:kCreateQuestionDescriptionTextViewDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAttachmentViewWasDeletedNotification:) name:kAttachmentViewWasDeletedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAttachmentViewDescriptionTextViewDidChangeNotification:) name:kAttachmentViewDescriptionTextViewDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithQuestion:(DBQuestion *)question {
    self = [self init];
    if (self) {
        _createQuestionDataSource.question = question;
        _question = question;
        [self.createQuestionDataSource.items addObjectsFromArray:question.attachments];
    }
    return self;
}

- (void)loadView {
    self.view = [[DBCreateQuestionView alloc] init];
    self.title = NSLocalizedString(@"Create a post", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.createQuestionView.tableView.dataSource = self.createQuestionDataSource;
    self.createQuestionView.tableView.delegate = self;
    
    if (self.createQuestionDataSource.question) {
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateButtonDidPress)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    } else {
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonDidPress)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
//    self.createQuestionView.tableView.dataSource = self.createQuestionDataSource;
//    self.createQuestionView.tableView.delegate = self;
    [self.createQuestionView.tableView registerClass:[DBCreateQuestionTitleAndDescriptionTableViewCell class] forCellReuseIdentifier:kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier];
    [self.createQuestionView.tableView registerClass:[DBCreateQuestionAttachmentTableViewCell class] forCellReuseIdentifier:kDBCreateQuestionAttachmentTableViewCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(captureVideo)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
    self.toolbarItems = toolbarItems;
}

#pragma mark - Notification

- (void)receiveCreateQuestionDescriptionTextViewDidChangeNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kCreateQuestionDescriptionTextViewDidChangeNotification]) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.createQuestionView.tableView beginUpdates];
//        [self.createQuestionDataSource tableView:self.createQuestionView.tableView heightForRowAtIndexPath:indexPath withHeight:[notification.userInfo objectForKey:kCreateQuestionDescriptionTextViewKey]];
        [self.createQuestionView.tableView endUpdates];
    }
}

- (void)receiveAttachmentViewWasDeletedNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:kAttachmentViewWasDeletedNotification]) {
        DBAttachment *attachmentToDelete = [notification.userInfo objectForKey:kAttachmentViewWasDeletedObjectKey];
        for(DBAttachment *attachment in self.createQuestionDataSource.items) {
            if([attachment isEqual:attachmentToDelete]) {
                [self.createQuestionDataSource.items removeObject:attachment];
                break;
            }
        }
        [self.createQuestionView.tableView reloadData];
    }
}

- (void)receiveAttachmentViewDescriptionTextViewDidChangeNotification:(NSNotification *)notification {
    [self.createQuestionView.tableView beginUpdates];
    [self.createQuestionView.tableView endUpdates];
}

#pragma mark - UIImagePickerControllerSourceType

- (void)captureVideo {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Action Sheet" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
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
            [self.createQuestionDataSource.items addObject:attachment];
        } else {
            DBAttachment *attachment = [[DBAttachment alloc] init];
            attachment.mimeType = kMimeTypeVideoMOV;
            attachment.videoURL = info[UIImagePickerControllerMediaURL];
            attachment.photoImage = [attachment thumbnailImageForVideo:attachment.videoURL atTime:0];
            [self.createQuestionDataSource.items addObject:attachment];
        }
        
        [self.createQuestionView.tableView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {

    [self.view showActivityIndicatorViewWithTitle:@"Posting..."];
    
    if ([self.createQuestionDataSource questionTitleString]) {
        [DBQuestion uploadQuestionWithTitle:[self.createQuestionDataSource questionTitleString]
                         questionDesciption:[self.createQuestionDataSource questionDescriptionString]
                                  dataArray:self.createQuestionDataSource.items
                                 completion:^(DBQuestion *question, NSError *error) {
                                     if (!error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                         });
                                     } else {
                                         [self showAlertWithTitle:NSLocalizedString(@"Something is broken", @"") message:NSLocalizedString(@"There is some error, please try post your question later", @"") dismissButtonText:@"OK BRO"];
                                     }
         }];
    } else {
        NSLog(@"Empty input");
        [self showOKAlertWithTitle:NSLocalizedString(@"You can't upload question without title", @"") message:nil];
        [self.view hideActivityIndicatorView];
    }
}

- (void)updateButtonDidPress {
    
    [self.view showActivityIndicatorViewWithTitle:@"Posting..."];
    
    self.question.title = [self.createQuestionDataSource questionTitleString];
    self.question.questionDescription = [self.createQuestionDataSource questionDescriptionString];
    self.question.attachments = self.createQuestionDataSource.items;
    [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            //pop new controller with reload
//            self.createQuestionView.tableView.dataSource = self.createQuestionDataSource;
//            [self.createQuestionView.tableView reloadData];
            [self.navigationController popViewControllerAnimated:NO];
            [self.view hideActivityIndicatorView];
        } else {
            [self showAlertWithTitle:NSLocalizedString(@"Something is broken", @"") message:NSLocalizedString(@"Error occured during updating your questin, please try it again later", @"") dismissButtonText:@"OK"];
        }
    }];
}

#pragma mark - Properties

- (DBCreateQuestionView *)createQuestionView {
    return (DBCreateQuestionView *)self.view;
}

@end