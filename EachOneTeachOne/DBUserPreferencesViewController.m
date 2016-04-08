//
//  DBUserPreferencesViewController.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 07/04/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>
#import "PFUser+Extensions.h"
#import "DBUserPreferencesViewController.h"
#import "DBUserPreferencesEditableViewController.h"

@interface DBUserPreferencesViewController ()

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
//    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(logoutButtonWasPressed)];
//    NSArray *toolbarItems = [NSArray arrayWithObjects:flexible, toolbarItem, nil];
//    self.toolbarItems = toolbarItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.user == [PFUser currentUser]) {
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonDidPress)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

#pragma mark - User actions

- (void)editButtonDidPress {
    
//    DBUserPreferencesEditableViewController *controller = [[DBUserPreferencesEditableViewController alloc] initWithUser:[PFUser currentUser]];
//    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
    DBUserPreferencesEditableViewController *userPreferencesEditableViewController = [[DBUserPreferencesEditableViewController alloc] initWithUser:[PFUser currentUser]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.navigationController pushViewController:userPreferencesEditableViewController animated:NO];
}

#pragma mark - Properties

- (DBUserPreferencesView *)userPreferencesView {
    return (DBUserPreferencesView *)self.view;
}


@end
