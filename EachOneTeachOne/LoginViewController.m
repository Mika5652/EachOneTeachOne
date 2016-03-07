//
//  LoginViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 07.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "LoginViewController.h"

@interface LoginViewController () <PFLogInViewControllerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
