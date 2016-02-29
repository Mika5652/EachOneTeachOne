//
//  DBMainView.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBFeedView.h"
#import <PureLayout/PureLayout.h>

@implementation DBFeedView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc] init];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50;
        [self addSubview:self.tableView];
        
        [self.tableView autoPinEdgesToSuperviewEdges];
    }
    return self;
}

@end
