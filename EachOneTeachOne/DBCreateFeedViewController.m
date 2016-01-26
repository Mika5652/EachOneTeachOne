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

@end

@implementation DBCreateFeedViewController

- (void)loadView {
    self.view = [[DBCreateFeedView alloc] init];
    self.title = NSLocalizedString(@"Create a post", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.createFeedView.captureVideoButton addTarget:self action:@selector(captureVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.createFeedView.postButton addTarget:self action:@selector(savePostButtonPresssed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UIImagePickerControllerSourceType

- (IBAction)captureVideo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerCamera =[[UIImagePickerController alloc] init];
        imagePickerCamera.delegate = self;
        imagePickerCamera.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie,nil];
        imagePickerCamera.allowsEditing = YES;
        imagePickerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerCamera  animated:YES completion:nil];
    }
    
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerAlbum =[[UIImagePickerController alloc] init];
        imagePickerAlbum.delegate = self;
        imagePickerAlbum.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePickerAlbum.allowsEditing = YES;
        imagePickerAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerAlbum animated:YES completion:nil];
    }
}
#pragma mark - UserAction

- (IBAction) savePostButtonPresssed : (id) sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString* textField1Text = self.createFeedView.titleTextField.text;
    [defaults setObject:textField1Text forKey:@"textField1Text"];
    
    NSString* temp = [defaults objectForKey:@"textField1Text"];
    
    NSLog(@"%@",temp);
}

#pragma mark - Properties

- (DBCreateFeedView *)createFeedView {
    return (DBCreateFeedView *)self.view;
}

@end
