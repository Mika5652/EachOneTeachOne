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

// Frameworks
#import <AVFoundation/AVFoundation.h>

#import "DBS3Manager.h" // DELELTE
#import "DBParseManager.h"  // DELETE

@interface DBCreateQuestionViewController ()

@property UIImagePickerController *imagePickerController;
@property (copy, nonatomic, readonly) NSString *parseObjectID;      // ID objektu na Parsu
@property (nonatomic, readonly) NSData *dataToSend;
@property (nonatomic, readonly) NSString *mimeType;

@end

@implementation DBCreateQuestionViewController

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
            _mimeType = @"image/jpg";
            UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
            [self.createQuestionView.captureVideoButton setImage:chosenImage forState:UIControlStateNormal];
            _dataToSend = UIImageJPEGRepresentation(chosenImage, 1);
        } else {
            _mimeType = @"video/quicktime";
            [self.createQuestionView.captureVideoButton setImage:[DBCreateQuestionViewController thumbnailImageForVideo:info[UIImagePickerControllerMediaURL] atTime:0] forState:UIControlStateNormal];
            _dataToSend = [NSData dataWithContentsOfURL:info[UIImagePickerControllerMediaURL]];
        }

        self.createQuestionView.captureVideoButton.clipsToBounds = YES;
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UserAction

- (void)postButtonDidPress {

    NSString *title = self.createQuestionView.titleTextField.text;
    NSString *description = self.createQuestionView.descriptionTextView.text;
    
    NSArray *myArray = @[@"Nejake", @"Data"];
    if (_dataToSend != nil) {
        [DBParseManager uploadQuestionWithTitle:title questionDescription:description videosAndPhotosNames:myArray completionBlock:^(NSString *objectIDString, NSError *error) {
            _parseObjectID = objectIDString;
            [DBS3Manager uploadFileWithKey:
             ([self.mimeType  isEqual: @"image/jpg"]) ? ([self.parseObjectID stringByAppendingString:@".jpg"]) : ([self.parseObjectID stringByAppendingString:@".mov"])
                                    data:self.dataToSend
                                    mimeType:self.mimeType
                            completionBlock:^(BOOL succes, NSError *error) {
                
            }];
        }];
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
