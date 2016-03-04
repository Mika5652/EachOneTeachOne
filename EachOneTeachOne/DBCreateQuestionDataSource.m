//
//  DBCreateQuestionDataSource.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionDataSource.h"
#import "DBCreateQuestionTableViewCell.h"
#import "DBCreateQuestionTitleAndDescriptionTableViewCell.h"
#import "DBCreateQuestionPhotoTableViewCell.h"
#import "DBCreateQuestionVideoTableViewCell.h"
#import "DBQuestionVideoAttachment.h"
#import "DBQuestionPhotoAttachment.h"

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
    } else if ([self.items[indexPath.row-1] isKindOfClass:[DBQuestionPhotoAttachment class]]){
        DBQuestionPhotoAttachment *photoAttachment = self.items[indexPath.row-1];
        DBCreateQuestionPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBCreateQuestionPhotoTableViewCellIdentifier forIndexPath:indexPath];
        cell.questionPhotoAttachment = photoAttachment;
        [cell setConstrainsWithImage:photoAttachment.photoImage];
        cell.photoImageView.image = photoAttachment.photoImage;
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    } else {
        DBQuestionVideoAttachment *videoAtachment = self.items[indexPath.row-1];
        DBCreateQuestionVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBCreateQuestionVideoTableViewCellIdentifier forIndexPath:indexPath];
        [cell setContentWithQuestionVideoAttachment:videoAtachment];
        [cell setConstrainsWithImage:[videoAtachment thumbnailImageForVideo:videoAtachment.videoURL atTime:0]];
        cell.questionVideoAttachment = videoAtachment;
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    }
    
    return nil;
}

@end
