//
//  DBLoginView.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 10.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBLoginAndSignUpView : UIView <UICollisionBehaviorDelegate>

@property UIImageView *logoImageView;

@property UITextField *emailTextField;
@property UITextField *passwordTextField;
@property UITextField *againPasswordTextField;

@property UILabel *underButtonLabel;

@property UIButton *signUpButton;
@property UIButton *facebookButton;
@property UIButton *loginButton;

@property (nonatomic, strong) NSLayoutConstraint *logoImageViewEdgeConstraint;
@property (strong, nonatomic) NSArray *loginScreenItems;

- (void)initialAnimation;

@end
