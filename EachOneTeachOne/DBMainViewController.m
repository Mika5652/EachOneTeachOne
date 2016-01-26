//
//  DBMainViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBMainViewController.h"
#import "DBMainView.h"
#import "DBCreateFeedViewController.h"

@interface DBMainViewController ()

@end

@implementation DBMainViewController

- (void)loadView {
    self.view = [[DBMainView alloc] init];
    self.title = NSLocalizedString(@"Feed", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

#pragma mark - UserAction

- (void)rightBarButtonDidPress {
    DBCreateFeedViewController *createFeedViewController = [[DBCreateFeedViewController alloc] init];
    [self.navigationController pushViewController:createFeedViewController animated:YES];
}

#pragma mark - Properties

- (DBMainView *)mainMenuView {
    return (DBMainView *) self.view;
}


@end
