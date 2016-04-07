//
//  DBLoginAndSignUpViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 07.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//
#import <PureLayout/PureLayout.h>
#import <QuartzCore/QuartzCore.h>

#import "DBLoginAndSignUpView.h"
#import "DBLoginAndSignUpViewController.h"

#import <Parse/Parse.h>
#import "UIView+ActivityIndicatorView.h"
#import "UIViewController+DBAlerts.h"
#import "DBFeedViewController.h"

@interface DBLoginAndSignUpViewController ()

@end

@implementation DBLoginAndSignUpViewController

#pragma mark - LifeCycles

- (void)loadView {
    self.view = [[DBLoginAndSignUpView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginAndSignUpView.loginButton addTarget:self action:@selector(loginButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.loginAndSignUpView.signUpButton addTarget:self action:@selector(signUpButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.loginAndSignUpView initialAnimation];
//    [self.loginAndSignUpView dynamicAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - StatusBar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Properties

- (DBLoginAndSignUpView *)loginAndSignUpView {
    return (DBLoginAndSignUpView *)self.view;
}

#pragma mark - User Action

- (void)loginButtonWasPressed {
    [PFUser logInWithUsernameInBackground:self.loginAndSignUpView.emailTextField.text password:self.loginAndSignUpView.passwordTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (user && !error) {
            if ([[user objectForKey:@"emailVerified"] boolValue]) {
                DBFeedViewController *feedViewController = [[DBFeedViewController alloc] init];
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController setViewControllers:[NSArray arrayWithObject:feedViewController] animated:YES];
            } else {
                [self showAlertWithTitle:NSLocalizedString(@"Login failed", @"") message:NSLocalizedString(@"Email not verified", @"") dismissButtonText:@"I see..."];
            }
        } else {
            [self showAlertWithTitle:NSLocalizedString(@"Login failed", @"") message:NSLocalizedString(@"Check your credentials and try again", @"") dismissButtonText:@"YES SIR!"];
        }
    }];
}

- (void)signUpButtonWasPressed {
    PFUser *user = [PFUser user];
    
    if (![self.loginAndSignUpView.emailTextField.text isEqualToString:@""]) {
        user.username = self.loginAndSignUpView.emailTextField.text;
        user.email = self.loginAndSignUpView.emailTextField.text;
        
        if (![self.loginAndSignUpView.passwordTextField.text isEqualToString:@""]) {
            if ([self.loginAndSignUpView.passwordTextField.text isEqualToString:self.loginAndSignUpView.againPasswordTextField.text]) {
                user.password = self.loginAndSignUpView.passwordTextField.text;
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        self.loginAndSignUpView.emailTextField.text = @"";
                        self.loginAndSignUpView.passwordTextField.text = @"";
                        self.loginAndSignUpView.againPasswordTextField.text = @"";
                        [self showOKAlertWithTitle:NSLocalizedString(@"Thanks. Your account has been created. Please verify your email so you can sign in and use our app.", @"") message:nil];
                    } else {
                        [self showOKAlertWithTitle:NSLocalizedString(@"Invalid email address", @"") message:nil];
                    }
                }];
            } else {
                [self showOKAlertWithTitle:NSLocalizedString(@"Password doesn't match", @"") message:nil];
            }
        } else {
            [self showOKAlertWithTitle:NSLocalizedString(@"Password is required", @"") message:nil];
        }
    } else {
        [self showOKAlertWithTitle:NSLocalizedString(@"Email is required", @"") message:nil];
    }
        
}

@end
