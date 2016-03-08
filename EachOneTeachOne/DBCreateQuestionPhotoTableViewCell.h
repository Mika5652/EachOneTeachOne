//
//  DBCreateQuestionPhotoTableViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDBCreateQuestionPhotoTableViewCellIdentifier;

@class DBAttachment;

@interface DBCreateQuestionPhotoTableViewCell : UITableViewCell

@property UIImageView *photoImageView;
@property UITextView *descriptionTextView;
@property (nonatomic) DBAttachment *attachment;

- (void)setConstrainsWithImage:(UIImage *)image;

@end
