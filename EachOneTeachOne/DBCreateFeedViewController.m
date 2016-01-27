//
//  DBCreateFeedViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// View Controllers
#import "DBCreateFeedViewController.h"

// Views
#import "DBCreateFeedView.h"

@interface DBCreateFeedViewController ()

@property UIImagePickerController *imagePickerController;

@end

@implementation DBCreateFeedViewController

- (void)loadView {
    self.view = [[DBCreateFeedView alloc] init];
    self.title = NSLocalizedString(@"Create a post", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.createFeedView.titleTextField.delegate = self;
    self.createFeedView.descriptionTextView.delegate = self;
    [self.createFeedView.captureVideoButton addTarget:self action:@selector(captureVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.createFeedView.postButton addTarget:self action:@selector(postButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UIImagePickerControllerSourceType

- (IBAction)captureVideo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController =[[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie,nil];
        self.imagePickerController.allowsEditing = YES;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController  animated:YES completion:nil];
    }
    
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
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
        NSLog(@"Did finish picking");
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {
    NSString *titleString = self.createFeedView.titleTextField.text;
    NSString *descriptionString = self.createFeedView.descriptionTextView.text;
}

#pragma mark - Properties

- (DBCreateFeedView *)createFeedView {
    return (DBCreateFeedView *)self.view;
}

@end
