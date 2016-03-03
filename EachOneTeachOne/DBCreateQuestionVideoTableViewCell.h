//
//  DBCreateQuestionVideoTableViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBQuestionVideoAttachment;

extern NSString * const kDBCreateQuestionVideoTableViewCellIdentifier;

@interface DBCreateQuestionVideoTableViewCell : UITableViewCell

@property UITextView *descriptionTextView;
@property (nonatomic) DBQuestionVideoAttachment *questionVideoAttachment;

- (void)setContentWithQuestionVideoAttachment:(DBQuestionVideoAttachment *)videoAttachment;

@end
