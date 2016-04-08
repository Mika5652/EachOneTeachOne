//
//  DBUserPreferencesViewController.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 30/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBUserPreferencesEditableViewController.h"
#import <Parse/Parse.h>
#import "PFUser+Extensions.h"
#import "UIImage+DBResizing.h"
#import "UIViewController+DBAlerts.h"
#import "UIView+ActivityIndicatorView.h"
#import "DBActivityIndicatorView.h"
#import "DBLoginAndSignUpViewController.h"

// Frameworks
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DBUserPreferencesEditableViewController ()

@property UIImagePickerController *imagePickerController;

@end

@implementation DBUserPreferencesEditableViewController

- (instancetype)initWithUser:(PFUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)loadView {
    self.view = [[DBUserPreferencesEditableView alloc] initWithUser:self.user];
    self.title = NSLocalizedString(@"User preferences", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(logoutButtonWasPressed)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:flexible, toolbarItem, nil];
    self.toolbarItems = toolbarItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userPreferencesEditableView.avatarButton addTarget:self action:@selector(avatarButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonWasPressed)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - User actions

- (void)logoutButtonWasPressed {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Do you want to logout?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        //         Cancel button tappped do nothing.
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            if (!error) {
                DBLoginAndSignUpViewController *loginViewController = [[DBLoginAndSignUpViewController alloc] init];
                self.navigationController.navigationBarHidden = NO;
                self.navigationController.toolbarHidden = YES;
                [self.navigationController setViewControllers:[NSArray arrayWithObject:loginViewController] animated:YES];
            } else {
                [self showAlertWithTitle:NSLocalizedString(@"Something is broken", @"") message:NSLocalizedString(@"There is some error, please try logout later", @"") dismissButtonText:@"OK"];
            }
        }];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)saveButtonWasPressed {
    [self.view showActivityIndicatorViewWithTitle:@"Updating..."];
    
    [self.user setUserName:self.userPreferencesEditableView.userNameTextField.text ofUser:self.user];
    [self.user setUserCrew:self.userPreferencesEditableView.crewTextField.text ofUser:self.user];
    [self.user setUserCity:self.userPreferencesEditableView.cityTextField.text ofUser:self.user];
    [self.user setUserAvatar:self.userPreferencesEditableView.avatarPFImageView.file ofUser:self.user];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            [self.view hideActivityIndicatorView];
            [self.navigationController popViewControllerAnimated:NO];
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
            self.userPreferencesEditableView.avatarPFImageView.file = [PFFile fileWithData:fileData];
            self.userPreferencesEditableView.avatarPFImageView.image = newAvatarImage;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Properties

- (DBUserPreferencesEditableView *)userPreferencesEditableView {
    return (DBUserPreferencesEditableView *)self.view;
}

@end
