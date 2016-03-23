//
//  DBLoginView.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 10.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//
#import <PureLayout/PureLayout.h>
#import <SpriteKit/SpriteKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DBLoginAndSignUpView.h"
#import "DBLoginAndSignUpViewController.h"

#import "Core.h"

@interface DBLoginAndSignUpView ()

@property BOOL didSetupConstraints;
@property BOOL shouldAnimateInitialAnimation;
@property BOOL shouldAnimateTextFieldAndButtons;

@property NSArray *initialStateConstraintsToDeactivate;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property UICollisionBehavior *collisionBehavior;
@property UIGravityBehavior *gravityBehavior;
@property UIAttachmentBehavior *attachmentBehavior;

@property NSLayoutConstraint *fbButtonConstraint;
@property NSLayoutConstraint *loginButtonConstraint;

@end

@implementation DBLoginAndSignUpView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_icon"]];
        [self addSubview:self.logoImageView];
        
        _emailTextField = [[UITextField alloc] init];
        self.emailTextField.backgroundColor = [UIColor yellowColor];
        self.emailTextField.placeholder = NSLocalizedString(@"Email", nil);
        self.emailTextField.layer.cornerRadius = 8;
        [self addSubview:self.emailTextField];
        
        _passwordTextField = [[UITextField alloc] init];
        self.passwordTextField.backgroundColor = [UIColor yellowColor];
        self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
        self.passwordTextField.layer.cornerRadius = 8;
        [self addSubview:self.passwordTextField];
        
        _againPasswordTextField = [[UITextField alloc] init];
        self.againPasswordTextField.backgroundColor = [UIColor yellowColor];
        self.againPasswordTextField.placeholder = NSLocalizedString(@"Password again", nil);
        self.againPasswordTextField.layer.cornerRadius = 8;
        [self addSubview:self.againPasswordTextField];
        
        _signUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.signUpButton.backgroundColor = [UIColor redColor];
        self.signUpButton.layer.cornerRadius = 8;
        [self.signUpButton setTitle:NSLocalizedString(@"SignUp", nil) forState:UIControlStateNormal];
        [self addSubview:self.signUpButton];
        
        _underButtonLabel = [[UILabel alloc] init];
        self.underButtonLabel.text = NSLocalizedString(@"Do you have account?", nil);
        self.underButtonLabel.adjustsFontSizeToFitWidth = 0;
        self.underButtonLabel.minimumScaleFactor = 0;
        [self addSubview:self.underButtonLabel];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.loginButton.alpha = 0;
        self.loginButton.backgroundColor = [UIColor redColor];
        [self.loginButton setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
        [self addSubview:self.loginButton];
        
        _facebookButton = [[FBSDKLoginButton alloc] init];
        self.facebookButton.alpha = 0;
        [self addSubview:self.facebookButton];

//        self.initialStateConstraintsToDeactivate = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [self.logoImageView autoCenterInSuperview];
            [self.logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
            [self.logoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
            
            [self.emailTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
            
            [self.passwordTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
            
            [self.againPasswordTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
            
            [self.signUpButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
        
            [self.facebookButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
            self.fbButtonConstraint = [self.facebookButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self];
            
            [self.underButtonLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
        
            [self.loginButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
            self.loginButtonConstraint = [self.loginButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self];
//        }];
        
//        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
//        self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.facebookButton, self.emailTextField]];
//        self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.facebookButton, self.emailTextField]];
        
        
    }
    return self;
}


//- (void)updateConstraints {
//    if (!self.didSetupConstraints) {
//
//        self.didSetupConstraints = YES;
//    }
//    
//    if (self.shouldAnimateInitialAnimation) {
//        [NSLayoutConstraint deactivateConstraints:self.initialStateConstraintsToDeactivate];
//        [self.logoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.logoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
//        [self.logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
//        [self.logoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
//        
//        self.shouldAnimateInitialAnimation = NO;
//    }
//    
//    if (self.shouldAnimateTextFieldAndButtons) {
//        [NSLayoutConstraint deactivateConstraints:self.initialStateConstraintsToDeactivate];
//        [self.emailTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.emailTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.logoImageView withOffset:40];
//        [self.emailTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.6];
//        
//        [self.passwordTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.passwordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.emailTextField withOffset:20];
//        [self.passwordTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.6];
//        
//        [self.againPasswordTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.againPasswordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordTextField withOffset:20];
//        [self.againPasswordTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.6];
//        
//        [self.signUpButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.signUpButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.againPasswordTextField withOffset:20];
//        [self.signUpButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.6];
//        
//        [self.facebookButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.facebookButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.signUpButton withOffset:20];
//        [self.facebookButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.6];
//        
//        [self.underButtonLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.facebookButton withOffset:5];
//        [self.underButtonLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.facebookButton withOffset:20];
//        [self.underButtonLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.facebookButton withMultiplier:0.7];
//        [self.underButtonLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.underButtonLabel withMultiplier:0.1];
//        
//        [self.loginButton autoAlignAxis:ALAxisBaseline toSameAxisOfView:self.underButtonLabel];
//        [self.loginButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.facebookButton];
//        [self.loginButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.underButtonLabel];
//        [self.loginButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.underButtonLabel withOffset:5];
//    
//        self.shouldAnimateTextFieldAndButtons = NO;
//    }
//    
//    
//    [super updateConstraints];
//}

- (void)initialAnimation {

    [NSLayoutConstraint deactivateConstraints:@[self.fbButtonConstraint]];
    self.fbButtonConstraint = [self.facebookButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:150];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.facebookButton.alpha = 1;
//        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    [NSLayoutConstraint deactivateConstraints:@[self.loginButtonConstraint]];
    self.loginButtonConstraint = [self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.facebookButton withOffset:40];
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.loginButton.alpha = 1;
//        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
//    CGRect loginButtonFrame = self.loginButton.frame;
//    loginButtonFrame.origin.x = 100;
//    loginButtonFrame.origin.y = 130;
//    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
//        self.loginButton.frame = loginButtonFrame;
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//    [UIView animateWithDuration:1.0
//                          delay:0.5
//         usingSpringWithDamping:0.3
//          initialSpringVelocity:0.2
//                        options:UIViewAnimationOptionLayoutSubviews
//                     animations:^{
//                         self.loginButton.frame = loginButtonFrame;
//                     } completion:nil];

    
//    self.shouldAnimateInitialAnimation = YES;
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//    [UIView animateWithDuration:1.0
//                          delay:0.3
//         usingSpringWithDamping:0.8
//          initialSpringVelocity:0.6
//                        options:UIViewAnimationOptionLayoutSubviews
//                     animations:^{
//        [self layoutIfNeeded];
//    }
//                     completion:^(BOOL finished) {
//                         self.shouldAnimateTextFieldAndButtons = YES;
//                         [self setNeedsUpdateConstraints];
//                         [self updateConstraintsIfNeeded];
//                         [UIView animateWithDuration:1.0
//                                               delay:0.0
//                              usingSpringWithDamping:0.4
//                               initialSpringVelocity:0.0
//                                             options:UIViewAnimationOptionLayoutSubviews
//                                          animations:^{
//                                              [self layoutIfNeeded];
//                                          }
//                                          completion:nil];
//                     }];
}

@end
