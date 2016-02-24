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

// Entities
#import "DBQuestion.h"

#import "DBS3Manager.h" // DELELTE

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
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        [self.createFeedView.captureVideoButton setImage:chosenImage forState:UIControlStateNormal];
        self.createFeedView.captureVideoButton.clipsToBounds = YES;
        [DBS3Manager uploadFileWithKey:@"testFromAppp.jpg" data:UIImageJPEGRepresentation(chosenImage, 1) completionBlock:^(BOOL success, NSError *error) {
            
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {
    DBQuestion *question = [DBQuestion object];
    NSArray *testArray = @[@"Nejake", @"Data"];
//    NSString *testName = question.parseClassName;
//    NSLog(@"question name: %@\ntitle name: %@", testName, self.createFeedView.titleTextField.text);
    question.title = self.createFeedView.titleTextField.text;
    question.questionDescription = self.createFeedView.descriptionTextView.text;
    
//    zatim jen testovaci pole - zmenit pote co se zprovozni S3
    question.videosAndPhotos = testArray;
    
    [question saveInBackground];
}

#pragma mark - Properties

- (DBCreateFeedView *)createFeedView {
    return (DBCreateFeedView *)self.view;
}

@end



































