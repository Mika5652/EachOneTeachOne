//
//  DBFeedDataSource.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBFeedDataSource.h"
#import "DBFeedViewTableViewCell.h"
#import "DBQuestion.h"
#import <UIImageView+AFNetworking.h>

@implementation DBFeedDataSource

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBFeedViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBFeedViewTableViewCellIdentifier forIndexPath:indexPath];
    DBQuestion *question = self.items[indexPath.row];
    cell.titleLabel.text = question.title;
    cell.descriptionLabel.text = question.questionDescription;
    cell.photoImageView.file = question.thumbnail;
    [cell.photoImageView loadInBackground];
//    [question.thumbnail getDataInBackgroundWithBlock:^(NSData * data, NSError *error) {
//        if (!error) {
//            [cell.photoImageView setImage:[UIImage imageWithData:data]];
//        }
//    }];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

@end
