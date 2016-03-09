//
//  DBMainViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// Framework
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

// Views and ViewControllers
#import "DBFeedViewController.h"
#import "DBFeedView.h"
#import "DBCreateQuestionViewController.h"
#import "DBFeedDataSource.h"
#import "DBFeedViewTableViewCell.h"

#import "DBQuestion.h"

@interface DBFeedViewController ()

@property DBFeedDataSource *feedDataSource;
@property UIRefreshControl *refreshControl;

@end

@implementation DBFeedViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _feedDataSource = [[DBFeedDataSource alloc] init];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[DBFeedView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.title = NSLocalizedString(@"Feed", @"");
    self.feedView.tableView.dataSource = self.feedDataSource;
    self.feedView.tableView.delegate = self;
    [self.feedView.tableView registerClass:[DBFeedViewTableViewCell class] forCellReuseIdentifier:kDBFeedViewTableViewCellIdentifier];
    [DBQuestion getNewQuestionsWithSkip:0 completion:^(NSArray *questions, NSError *error) {
        [self.feedDataSource.items addObjectsFromArray:questions];
        [self.feedView.tableView reloadData];
    }];
    [self.feedView.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
    self.toolbarItems = toolbarItems;
}

#pragma mark - UserAction

- (void)rightBarButtonDidPress {
    DBCreateQuestionViewController *createQuestionViewController = [[DBCreateQuestionViewController alloc] init];
    [self.navigationController pushViewController:createQuestionViewController animated:YES];
}

#pragma mark - Properties

- (DBFeedView *)feedView {
    return (DBFeedView *)self.view;
}

#pragma mark - Private
- (void)refreshTable {
    [DBQuestion getNewQuestionsWithSkip:0 completion:^(NSArray *questions, NSError *error) {
        self.feedDataSource.items = [questions mutableCopy];
        [self.feedView.tableView reloadData];
    }];
    [self.refreshControl endRefreshing];
}

@end
