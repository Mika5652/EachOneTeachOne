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
#import "DBQuestion.h"

@interface DBCreateQuestionDataSource ()

@property NSString *localQuestionTitleString;
@property NSString *localQuestionDescriptionString;

@end

@implementation DBCreateQuestionDataSource

#pragma mark - Lifecycles

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _items = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCreateQuestionDescriptionTextDidChangeNotification:) name:kCreateQuestionDescriptionTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCreateQuestionTitleTextDidChangeNotification:) name:kCreateQuestionTitleTextDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        DBCreateQuestionTitleAndDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier forIndexPath:indexPath];
        
        if (self.question) {
            cell.titleTextField.text = self.question.title;
            cell.descriptionTextView.text = self.question.questionDescription;
            cell.descriptionTextView.textColor = [UIColor blackColor];
        } else {
            cell.titleTextField.text = self.localQuestionTitleString;
            if (self.localQuestionDescriptionString) {
                cell.descriptionTextView.text = self.localQuestionDescriptionString;
            }
        }
        
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

#pragma mark - public

- (NSString *)questionTitleString {
    if (self.question) {
        return self.question.title;
    } else {
        return self.localQuestionTitleString;
    }
}

- (NSString *)questionDescriptionString {
    if (self.question) {
        return self.question.questionDescription;
    } else {
        return self.localQuestionDescriptionString;
    }
}


#pragma mark - Notification

- (void)receiveCreateQuestionTitleTextDidChangeNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:kCreateQuestionTitleTextDidChangeNotification]) {
        if (self.question) {
            self.question.title = [notification.userInfo objectForKey:kCreateQuestionTitleTextKey];
        } else {
            self.localQuestionTitleString = [notification.userInfo objectForKey:kCreateQuestionTitleTextKey];
        }
    }
}

- (void)receiveCreateQuestionDescriptionTextDidChangeNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:kCreateQuestionDescriptionTextDidChangeNotification]) {
        if (self.question) {
            self.question.questionDescription = [notification.userInfo objectForKey:kCreateQuestionDescriptionTextKey];
        } else {
            self.localQuestionDescriptionString = [notification.userInfo objectForKey:kCreateQuestionDescriptionTextKey];
        }
    }
}

@end
