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

// Frameworks
#import <AVFoundation/AVFoundation.h>

#import "DBS3Manager.h" // DELELTE
#import "DBParseManager.h"  // DELETE

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
    [self.createFeedView.captureVideoButton addTarget:self action:@selector(captureVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.createFeedView.postButton addTarget:self action:@selector(postButtonDidPress) forControlEvents:UIControlEventTouchUpInside];

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
        NSString *fileKey;
        NSData *dataToSend;
        NSString *mimeType;
        if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
            mimeType = @"image/jpg";
            UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
            [self.createFeedView.captureVideoButton setImage:chosenImage forState:UIControlStateNormal];
            dataToSend = UIImageJPEGRepresentation(chosenImage, 1);
            fileKey = @"testFromApp.jpg";
        } else {
            mimeType = @"video/quicktime";
            [self.createFeedView.captureVideoButton setImage:[DBCreateFeedViewController thumbnailImageForVideo:info[UIImagePickerControllerMediaURL] atTime:0] forState:UIControlStateNormal];
            dataToSend = [NSData dataWithContentsOfURL:info[UIImagePickerControllerMediaURL]];
            fileKey = @"testFromApp.mov";
        }

        self.createFeedView.captureVideoButton.clipsToBounds = YES;
        [DBS3Manager uploadFileWithKey:fileKey data:dataToSend mimeType:mimeType completionBlock:^(BOOL success, NSError *error) {
            
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {

    // TEST DBParseManager - DELETE
//    NSString *myTitle = self.createFeedView.titleTextField.text;
//    NSString *myDescription = self.createFeedView.descriptionTextView.text;
//    
//    NSArray *myArray = @[@"Nejake", @"Data"];
//    
//    
//    [DBParseManager uploadQuestionWithTitle:myTitle questionDescription:myDescription videosAndPhotosNames:myArray];

}

#pragma mark - Properties

- (DBCreateFeedView *)createFeedView {
    return (DBCreateFeedView *)self.view;
}

#pragma mark - Private

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
}

@end
