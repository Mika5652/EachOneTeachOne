//
//  DBCreateFeedView.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// Framework
#import <PureLayout/PureLayout.h>

// View
#import "DBCreateQuestionView.h"

@implementation DBCreateQuestionView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];

        _tableView = [[UITableView alloc] init];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        [self addSubview:self.tableView];
        
        [self.tableView autoPinEdgesToSuperviewEdges];
        
    }
    return self;
}

@end
