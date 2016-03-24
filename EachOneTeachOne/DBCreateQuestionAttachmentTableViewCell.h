//
//  DBCreateQuestionAttachmentViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 20/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDBCreateQuestionAttachmentTableViewCellIdentifier;

@class DBAttachmentView;
@class DBAttachment;

@interface DBCreateQuestionAttachmentTableViewCell : UITableViewCell

@property DBAttachmentView *attachmentView;
@property (nonatomic) DBAttachment *attachment;

- (void)updateAttachmentTableViewCellConstraints;

@end
