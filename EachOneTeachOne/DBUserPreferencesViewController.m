//
//  DBUserPreferencesViewController.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 30/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBUserPreferencesViewController.h"
#import <Parse/Parse.h>
#import "PFUser+Extensions.h"
#import "UIImage+DBResizing.h"
#import "UIViewController+DBAlerts.h"
#import "UIView+ActivityIndicatorView.h"
#import "DBActivityIndicatorView.h"

// Frameworks
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DBUserPreferencesViewController ()

@property UIImagePickerController *imagePickerController;

@end

@implementation DBUserPreferencesViewController

- (instancetype)initWithUser:(PFUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)loadView {
    self.view = [[DBUserPreferencesView alloc] initWithUser:self.user];
    self.title = NSLocalizedString(@"User preferences", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
//    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
//    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
//    self.toolbarItems = toolbarItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userPreferencesView.avatarButton addTarget:self action:@selector(avatarButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonWasPressed)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - User actions

- (void)saveButtonWasPressed {
    [self.view showActivityIndicatorViewWithTitle:@"Updating..."];
    
    [self.user setUserName:self.userPreferencesView.userNameTextField.text ofUser:self.user];
    [self.user setUserCrew:self.userPreferencesView.crewTextField.text ofUser:self.user];
    [self.user setUserCity:self.userPreferencesView.cityTextField.text ofUser:self.user];
    [self.user setUserAvatar:self.userPreferencesView.avatarPFImageView.file ofUser:self.user];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            [self.view hideActivityIndicatorView];
        } else {
            [self showAlertWithTitle:NSLocalizedString(@"Something is broken", @"") message:NSLocalizedString(@"There is some error, please try post your changes later", @"") dismissButtonText:@"OK"];
        }
    }];
}

- (void)avatarButtonWasPressed {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Action Sheet" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
//         Cancel button tappped do nothing.
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imagePickerController =[[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
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
            UIImage *newAvatarImage = [info[UIImagePickerControllerOriginalImage] photoResizedToSize:CGSizeMake(256,256)];
            NSData *fileData = UIImageJPEGRepresentation(newAvatarImage, 1);
            self.userPreferencesView.avatarPFImageView.file = [PFFile fileWithData:fileData];
            self.userPreferencesView.avatarPFImageView.image = newAvatarImage;
        }

        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Properties

- (DBUserPreferencesView *)userPreferencesView {
    return (DBUserPreferencesView *)self.view;
}

@end
