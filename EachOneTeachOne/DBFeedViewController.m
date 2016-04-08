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
#import "DBQuestionDetailViewController.h"
#import "DBUserPreferencesViewController.h"
#import "UIView+ActivityIndicatorView.h"
#import "DBActivityIndicatorView.h"

#import "DBQuestion.h"

@interface DBFeedViewController () <UITableViewDelegate>

@property DBFeedDataSource *feedDataSource;
@property UIRefreshControl *refreshControl;
@property NSInteger skip;

@end

@implementation DBFeedViewController

#pragma mark - Lifecycles

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _feedDataSource = [[DBFeedDataSource alloc] init];
        _skip = 0;
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
    [self refreshTable];
    [self.feedView.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(userPreferencesToolbarButton)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarItem, nil];
    self.toolbarItems = toolbarItems;
}

#pragma mark - UserAction

- (void)rightBarButtonDidPress {
    DBCreateQuestionViewController *createQuestionViewController = [[DBCreateQuestionViewController alloc] init];
    [self.navigationController pushViewController:createQuestionViewController animated:YES];
}

- (void)userPreferencesToolbarButton {
    DBUserPreferencesViewController *userPreferencesViewController = [[DBUserPreferencesViewController alloc] initWithUser:[PFUser currentUser]];
    [self.navigationController pushViewController:userPreferencesViewController animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 40) {
        self.skip = self.skip + 10;
        [self.feedView showActivityIndicatorViewWithTitle:@""];
        [DBQuestion getNewQuestionsWithSkip:self.skip completion:^(NSArray *questions, NSError *error) {
            if (!error) {
                [self.feedDataSource.items addObjectsFromArray:questions];
                [self.feedView.tableView reloadData];
                [self.feedView hideActivityIndicatorView];
            }
        }];
    }
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
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBQuestionDetailViewController *questionDetailViewController = [[DBQuestionDetailViewController alloc] initWithQuestion:self.feedDataSource.items[indexPath.row]];
    [self.navigationController pushViewController:questionDetailViewController animated:YES];
}

@end
