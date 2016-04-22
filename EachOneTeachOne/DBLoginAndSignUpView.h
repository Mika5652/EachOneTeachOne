//
//  DBLoginView.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 10.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

extern NSString * const kLoginAndSignUpViewLoginButtonWasPressedNotification;

@interface DBLoginAndSignUpView : UIView <UICollisionBehaviorDelegate>

// SignUp items
@property UIImageView *logoImageView;

@property UIView *testView;
@property UIView *loginMaterialEffectView;

@property UITextField *emailTextField;
@property UITextField *passwordTextField;
@property UITextField *againPasswordTextField;

@property UILabel *underButtonLabel;

@property NSMutableAttributedString *mutableAttributedString;

@property UIButton *signUpButton;
@property UIButton *facebookButton;
@property UIButton *signInButton;
@property UIButton *backToSignUpButton;

// LogIn items
@property UITextField *emailLogInTextField;
@property UITextField *passwordLogInTextField;

@property UIButton *logInButton;

@property (nonatomic, strong) NSLayoutConstraint *logoImageViewEdgeConstraint;
@property (strong, nonatomic) NSArray *loginScreenItems;

- (void)initialAnimation;
- (void)dynamicAnimation;
- (void)removeBehavior;
- (void)backToSignUpBehavior;

@end
