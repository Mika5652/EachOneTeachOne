//
//  DBMainViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBFeedViewController.h"
#import "DBFeedView.h"
#import "DBCreateQuestionViewController.h"
#import "DBFeedDataSource.h"
#import "DBFeedViewTableViewCell.h"
#import "DBParseManager.h"
#import <PureLayout/PureLayout.h>

@interface DBFeedViewController ()

@property DBFeedDataSource *feedDataSource;

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
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.title = NSLocalizedString(@"Feed", @"");
    self.feedView.tableView.dataSource = self.feedDataSource;
    self.feedView.tableView.delegate = self;
    [self.feedView.tableView registerClass:[DBFeedViewTableViewCell class] forCellReuseIdentifier:kDBFeedViewTableViewCellIdentifier];
    [DBParseManager getNewQuestionsWithSkip:0 completion:^(NSArray *questions, NSError *error) {
        [self.feedDataSource.items addObjectsFromArray:questions];
        [self.feedView.tableView reloadData];
    }];
    [self.feedView.tableView autoPinToBottomLayoutGuideOfViewController:self withInset:5];
    
}

#pragma mark - UserAction

- (void)rightBarButtonDidPress {
    DBCreateQuestionViewController *createFeedViewController = [[DBCreateQuestionViewController alloc] init];
    [self.navigationController pushViewController:createFeedViewController animated:YES];
}

#pragma mark - Properties

- (DBFeedView *)feedView {
    return (DBFeedView *)self.view;
}


@end
