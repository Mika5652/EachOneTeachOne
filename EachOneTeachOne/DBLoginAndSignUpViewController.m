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

@interface DBLoginAndSignUpViewController ()

@end

@implementation DBLoginAndSignUpViewController

#pragma mark - LifeCycles

- (void)loadView {
    self.view = [[DBLoginAndSignUpView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - StatusBar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Properties

- (DBLoginAndSignUpView *)loginAndSignUpView {
    return (DBLoginAndSignUpView *)self.view;
}

@end
