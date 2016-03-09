//
//  DBCreateQuestionDataSource.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionDataSource.h"
#import "DBCreateQuestionTitleAndDescriptionTableViewCell.h"
#import "DBCreateQuestionPhotoTableViewCell.h"
#import "DBCreateQuestionVideoTableViewCell.h"
#import "DBAttachment.h"

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
        if ([attachment.mimeType isEqualToString:kMimeTypeImageJPG]) {
            DBCreateQuestionPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBCreateQuestionPhotoTableViewCellIdentifier forIndexPath:indexPath];
            [cell setConstrainsWithImage:attachment.photoImage];
            cell.photoImageView.image = attachment.photoImage;
            cell.attachment = attachment;
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            return cell;
        } else {
            DBCreateQuestionVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBCreateQuestionVideoTableViewCellIdentifier forIndexPath:indexPath];
            [cell setContentWithQuestionVideoAttachment:attachment];
            [cell setConstrainsWithImage:attachment.thumbnailImage];
            cell.attachment = attachment;
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            return cell;
        }
    }
    
    return nil;
}

@end
