//
//  DBAnswerPhotoTableViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 15/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAttachment;

extern NSString * const kDBAnswerPhotoTableViewCellIdentifier;

@interface DBAnswerPhotoTableViewCell : UITableViewCell

@property UIImageView *photoImageView;
@property UITextView *descriptionTextView;
@property (nonatomic) DBAttachment *attachment;

- (void)setConstrainsWithImage:(UIImage *)image;

@end
