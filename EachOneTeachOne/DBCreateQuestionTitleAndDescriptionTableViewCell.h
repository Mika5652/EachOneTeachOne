//
//  BDCreateQuestionTitleAndDescriptionTableViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier;
extern NSString * const kCreateQuestionDescriptionTextDidChangeNotification;
extern NSString * const kCreateQuestionTitleTextDidChangeNotification;
extern NSString * const kCreateQuestionDescriptionTextKey;
extern NSString * const kCreateQuestionTitleTextKey;

@interface DBCreateQuestionTitleAndDescriptionTableViewCell : UITableViewCell

@property UITextField *titleTextField;
@property UITextView *descriptionTextView;

@end
