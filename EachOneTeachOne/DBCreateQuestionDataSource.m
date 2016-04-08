//
//  DBCreateQuestionDataSource.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionDataSource.h"
#import "DBCreateQuestionTitleAndDescriptionTableViewCell.h"
#import "DBAttachment.h"
#import "DBCreateQuestionAttachmentTableViewCell.h"

@implementation DBCreateQuestionDataSource

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        DBCreateQuestionTitleAndDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier forIndexPath:indexPath];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    } else {
        DBAttachment *attachment = (DBAttachment *)self.items[indexPath.row-1];
        DBCreateQuestionAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBCreateQuestionAttachmentTableViewCellIdentifier forIndexPath:indexPath];
        cell.attachment = attachment;
        [cell updateAttachmentTableViewCellConstraints];
        [cell setNeedsUpdateConstraints];
        [cell updateFocusIfNeeded];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withHeight:(NSNumber *)number
{
//    return UITableViewAutomaticDimension;
    if (indexPath.row == 0) {
        return [number floatValue];
    } else {
        return UITableViewAutomaticDimension;
    }
}

@end
