//
//  DBCreateFeedView.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBCreateQuestionView : UIScrollView

@property UITableView *tableView;

@property UITextField *titleTextField;
@property UITextView *descriptionTextView;

@property UILabel *titlePostLabel;
@property UILabel *descriptionLabel;

@property UIButton *captureVideoButton;


@end
