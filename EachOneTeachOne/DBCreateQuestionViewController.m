//
//  DBcreateQuestionViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// View Controllers
#import "DBCreateQuestionViewController.h"

// Views
#import "DBCreateQuestionView.h"

// Entities
#import "DBQuestion.h"
#import "DBVideoAttachment.h"
#import "DBPhotoAttachment.h"

// Data Sources
#import "DBCreateQuestionDataSource.h"

// Manager
#import "DBNetworkingManager.h"

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
            DBPhotoAttachment *photoAttachment = [[DBPhotoAttachment alloc] init];
            photoAttachment.photoImage = info[UIImagePickerControllerOriginalImage];
            [self.createQuestionDataSource.items addObject:photoAttachment];
        } else {
            DBVideoAttachment *videoAttachment = [[DBVideoAttachment alloc] init];
            videoAttachment.videoURL = info[UIImagePickerControllerMediaURL];
            [self.createQuestionDataSource.items addObject:videoAttachment];
        }
        
        [self.createQuestionView.tableView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)rightBarButtonDidPress {

    if (![self.createQuestionTitleAndDescriptionTableViewCell.titleTextField.text isEqualToString:@""]) {
        [DBNetworkingManager uploadQuestionWithTitle:[self createQuestionTitleAndDescriptionTableViewCell].titleTextField.text
                                  questionDesciption:[self createQuestionTitleAndDescriptionTableViewCell].descriptionTextView.text
                                           dataArray:self.createQuestionDataSource.items];
    } else {
        NSLog(@"Nebylo nic zadano...");
    }
}

#pragma mark - Properties

- (DBCreateQuestionView *)createQuestionView {
    return (DBCreateQuestionView *)self.view;
}

- (DBCreateQuestionTitleAndDescriptionTableViewCell *)createQuestionTitleAndDescriptionTableViewCell {
    return (DBCreateQuestionTitleAndDescriptionTableViewCell *)self.view;
}

@end