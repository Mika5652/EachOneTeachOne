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

// Entities
#import "DBQuestion.h"
#import "DBAttachment.h"

// Data Sources
#import "DBCreateQuestionDataSource.h"

// Cell
#import "DBCreateQuestionTitleAndDescriptionTableViewCell.h"
#import "DBCreateQuestionPhotoTableViewCell.h"
#import "DBCreateQuestionVideoTableViewCell.h"

// Frameworks
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DBCreateQuestionViewController ()

@property UIImagePickerController *imagePickerController;
@property (copy, nonatomic, readonly) NSString *parseObjectID;      // ID objektu na Parsu
@property DBCreateQuestionDataSource *createQuestionDataSource;

@end

@implementation DBCreateQuestionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _createQuestionDataSource = [[DBCreateQuestionDataSource alloc] init];
    }
    return self;
}

- (void)loadView {
    self.view = [[DBCreateQuestionView alloc] init];
    self.title = NSLocalizedString(@"Create a post", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;

//    self.navigationController.toolbarHidden = NO;
//    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(captureVideo)];
//    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
//    self.toolbarItems = toolbarItems;
    
    self.createQuestionView.tableView.dataSource = self.createQuestionDataSource;
    self.createQuestionView.tableView.delegate = self;
    [self.createQuestionView.tableView registerClass:[DBCreateQuestionTitleAndDescriptionTableViewCell class] forCellReuseIdentifier:kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier];
    [self.createQuestionView.tableView registerClass:[DBCreateQuestionPhotoTableViewCell class] forCellReuseIdentifier:kDBCreateQuestionPhotoTableViewCellIdentifier];
    [self.createQuestionView.tableView registerClass:[DBCreateQuestionVideoTableViewCell class] forCellReuseIdentifier:kDBCreateQuestionVideoTableViewCellIdentifier];
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
        self.imagePickerController.allowsEditing = YES;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController  animated:YES completion:nil];
    }
    
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imagePickerController =[[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        self.imagePickerController.allowsEditing = YES;
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
            [self.createQuestionDataSource.items addObject:attachment];
        } else {
            DBAttachment *attachment = [[DBAttachment alloc] init];
            attachment.mimeType = kMimeTypeVideoMOV;
            attachment.videoURL = info[UIImagePickerControllerMediaURL];
            [self.createQuestionDataSource.items addObject:attachment];
        }
        
        [self.createQuestionView.tableView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)rightBarButtonDidPress {

    if (![self.createQuestionTitleAndDescriptionTableViewCell.titleTextField.text isEqualToString:@""]) {
        [DBQuestion uploadQuestionWithTitle:[self createQuestionTitleAndDescriptionTableViewCell].titleTextField.text
                         questionDesciption:[self createQuestionTitleAndDescriptionTableViewCell].descriptionTextView.text
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
    }
}

#pragma mark - Properties

- (DBCreateQuestionView *)createQuestionView {
    return (DBCreateQuestionView *)self.view;
}

- (DBCreateQuestionTitleAndDescriptionTableViewCell *)createQuestionTitleAndDescriptionTableViewCell {
//    return (DBCreateQuestionTitleAndDescriptionTableViewCell *)[self.createQuestionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    return (DBCreateQuestionTitleAndDescriptionTableViewCell *)[self.createQuestionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end