//
//  DBCreateQuestionAttachmentViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 20/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionAttachmentTableViewCell.h"
#import "DBAttachmentView.h"
#import <PureLayout/PureLayout.h>

NSString * const kDBCreateQuestionAttachmentTableViewCellIdentifier = @"kDBCreateQuestionAttachmentTableViewCellIdentifier";

@implementation DBCreateQuestionAttachmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    _attachmentView = [DBAttachmentView alloc];
    
    return self;
}

- (void)updateAttachmentTableViewCellConstraints {
    if (self.attachmentView) {
        [self.attachmentView removeFromSuperview];   
    }
    self.attachmentView = [[DBAttachmentView alloc] initWithAttachment:self.attachment isEditable:YES];
//    self.attachmentView = [self.attachmentView initWithAttachment:self.attachment isEditable:YES];
    [self.contentView addSubview:self.attachmentView];
    [self.attachmentView autoPinEdgesToSuperviewEdges];
}

@end
