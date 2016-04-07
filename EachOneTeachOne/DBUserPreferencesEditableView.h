//
//  DBUserPreferencesView.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 30/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface DBUserPreferencesEditableView : UIView

@property UITextField *userNameTextField;
@property UITextField *crewTextField;
@property UITextField *cityTextField;
@property UILabel *userNameLabel;
@property UILabel *crewLabel;
@property UILabel *cityLabel;
@property UIButton *avatarButton;
@property PFImageView *avatarPFImageView;

@property UIStackView *stackView;
@property UIScrollView *scrollView;

- (instancetype)initWithUser:(PFUser *)user;

@end
