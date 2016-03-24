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
        
    return self;
}

- (void)updateAttachmentTableViewCellConstraints {
    if (self.attachmentView) {
        [self.attachmentView removeFromSuperview];
        self.attachmentView = nil;
    }
    self.attachmentView = [[DBAttachmentView alloc] initWithAttachment:self.attachment isEditable:YES];
    [self.contentView addSubview:self.attachmentView];

    [self.attachmentView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.attachmentView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.attachmentView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [NSLayoutConstraint autoSetPriority:999 forConstraints:^{
        [self.attachmentView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    }];

    [super updateConstraints];
}

@end
