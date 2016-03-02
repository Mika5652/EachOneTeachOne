//
//  BDCreateQuestionTitleAndDescriptionTableViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 02/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDBCreateQuestionTitleAndDescritionTableViewCellIdentifier;

@interface BDCreateQuestionTitleAndDescriptionTableViewCell : UITableViewCell

@property UITextField *titleTextField;
@property UITextView *descriptionTextView;

@end
