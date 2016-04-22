//
//  DBLoginAndSignUpViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 07.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//
#import <PureLayout/PureLayout.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

#import "DBLoginAndSignUpView.h"
#import "DBLoginAndSignUpViewController.h"

#import "UIView+ActivityIndicatorView.h"
#import "UIViewController+DBAlerts.h"
#import "DBFeedViewController.h"
#import "UIView+MaterialDesign.h"

@interface DBLoginAndSignUpViewController ()

@end

@implementation DBLoginAndSignUpViewController

#pragma mark - LifeCycles

- (void)loadView {
    self.view = [[DBLoginAndSignUpView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginAndSignUpView.signInButton addTarget:self action:@selector(loginButtonDidPress:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginAndSignUpView.signUpButton addTarget:self action:@selector(signUpButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    [self.loginAndSignUpView.backToSignUpButton addTarget:self action:@selector(backToSignUpButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)signUpButtonDidPress {
    [self.loginAndSignUpView removeBehavior];
}

- (void)backToSignUpButtonDidPress {
    [self.loginAndSignUpView backToSignUpBehavior];
}

// Toto je pouze pro rychlejší login přes SignIn button
- (void)loginButtonDidPress:(UIControl *)sender event:(UIEvent *)event {
    CGPoint position = [[[event allTouches] anyObject] locationInView:self.loginAndSignUpView];
    [self.loginAndSignUpView.loginMaterialEffectView mdInflateAnimatedFromPoint:position backgroundColor:[UIColor greenColor] duration:0.8 completion:^{
        DBFeedViewController *feedViewController = [[DBFeedViewController alloc] init];
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:feedViewController];
        feedViewController.navigationController.providesPresentationContextTransitionStyle = YES;
        feedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    }];
    
}

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
