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
#import "DBQuestionVideoAttachment.h"
#import "DBQuestionPhotoAttachment.h"

// Data Sources
#import "DBCreateQuestionDataSource.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>

#import "DBNetworkingManager.h"

@interface DBCreateQuestionViewController ()

@property UIImagePickerController *imagePickerController;
@property (copy, nonatomic, readonly) NSString *parseObjectID;      // ID objektu na Parsu
@property DBCreateQuestionDataSource *createQuestionDataSource;
@property (nonatomic, readonly) NSData *dataToSend;     // DELETE = pouze test

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
    self.createQuestionView.titleTextField.delegate = self;
    self.createQuestionView.descriptionTextView.delegate = self;
    [self.createQuestionView.captureVideoButton addTarget:self action:@selector(captureVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.createQuestionView.postButton addTarget:self action:@selector(postButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
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
            DBQuestionPhotoAttachment *photoAttachment = [[DBQuestionPhotoAttachment alloc] init];
            photoAttachment.mimeType = kMimeTypeImageJPG;
            photoAttachment.photoImage = info[UIImagePickerControllerOriginalImage];
            photoAttachment.thumbnailImage = photoAttachment.photoImage;
            [self.createQuestionView.captureVideoButton setImage:photoAttachment.photoImage forState:UIControlStateNormal];
            [self.createQuestionDataSource.items addObject:photoAttachment];
        } else {
            DBQuestionVideoAttachment *videoAttachment = [[DBQuestionVideoAttachment alloc] init];
            videoAttachment.mimeType = kMimeTypeVideoMOV;
            videoAttachment.videoURL = info[UIImagePickerControllerMediaURL];
            videoAttachment.thumbnailImage = [DBCreateQuestionViewController thumbnailImageForVideo:videoAttachment.videoURL atTime:0];
            [self.createQuestionView.captureVideoButton setImage:videoAttachment.thumbnailImage forState:UIControlStateNormal];
            [self.createQuestionDataSource.items addObject:videoAttachment];
        }

        self.createQuestionView.captureVideoButton.clipsToBounds = YES;
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {
    DBQuestion *question = [DBQuestion object];
    
    question.title = self.createQuestionView.titleTextField.text;
    question.questionDescription = self.createQuestionView.descriptionTextView.text;

    NSArray *testArray = self.createQuestionDataSource.items;
    
    if (testArray != nil) {
        [DBNetworkingManager uploadQuestion:question dataArray:self.createQuestionDataSource.items];
    } else {
        NSLog(@"Nebylo nic zadano...");
    }
}

#pragma mark - Properties

- (DBCreateQuestionView *)createQuestionView {
    return (DBCreateQuestionView *)self.view;
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
