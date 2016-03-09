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
    NSURL *photoURL = [NSURL URLWithString:[kAWSS3BaseURL stringByAppendingPathComponent:question.thumbnailName]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
        cell.photoImageView.image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
        });
    });
    
    return cell;
}

@end
