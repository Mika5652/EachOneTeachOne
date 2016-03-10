//
//  DBCreateQuestionVideoTableViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAttachment;

extern NSString * const kDBCreateQuestionVideoTableViewCellIdentifier;

@interface DBCreateQuestionVideoTableViewCell : UITableViewCell

@property UITextView *descriptionTextView;
@property (nonatomic) DBAttachment *attachment;
@property UIImageView *videoThumbnail;

- (void)setConstrainsWithImage:(UIImage *)image;

@end
