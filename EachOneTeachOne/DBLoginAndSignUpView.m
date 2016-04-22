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
@property UICollisionBehavior *leftCollisionBehavior;
@property UICollisionBehavior *rightCollisionBehavior;
@property UICollisionBehavior *leftBehindScreenCollisionBehavior;
@property UICollisionBehavior *rightBehindScreenCollisionBehavior;

@property UIGravityBehavior *signUpGravityBehavior;
@property UIGravityBehavior *logInGravityBehavior;

@property UIAttachmentBehavior *attachmentBehavior;

@property UIDynamicItemBehavior *dynamicItemBehavior;

@property NSLayoutConstraint *fbButtonConstraint;
@property NSLayoutConstraint *loginButtonConstraint;
@property NSLayoutConstraint *emailTextFieldConstraint;

@end

@implementation DBLoginAndSignUpView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        CGFloat leftCollisionBoundary = screenWidth / 5;
        CGFloat rightCollisionBoundary = (screenWidth / 5) * 4;
        CGFloat leftBehindScreenBoundary = -screenWidth;
        CGFloat rightBehindScreenBoundary = 2 * screenWidth;
        CGFloat itemWidth = leftCollisionBoundary * 3;
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_icon"]];
        [self addSubview:self.logoImageView];
// SignUp screen items
        _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(450, 150, itemWidth, 20)];
        self.emailTextField.backgroundColor = [UIColor yellowColor];
        self.emailTextField.placeholder = NSLocalizedString(@"Email", nil);
        self.emailTextField.layer.cornerRadius = 8;
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = YES;
        [self addSubview:self.emailTextField];
        
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(500, 180, itemWidth, 20)];
        self.passwordTextField.backgroundColor = [UIColor yellowColor];
        self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
        self.passwordTextField.layer.cornerRadius = 8;
        [self addSubview:self.passwordTextField];
        
        _againPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(550, 210, itemWidth, 20)];
        self.againPasswordTextField.backgroundColor = [UIColor yellowColor];
        self.againPasswordTextField.placeholder = NSLocalizedString(@"Password again", nil);
        self.againPasswordTextField.layer.cornerRadius = 8;
        [self addSubview:self.againPasswordTextField];
    
        _signUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.signUpButton.frame = CGRectMake(600, 250, itemWidth, 30);
        self.signUpButton.backgroundColor = [UIColor redColor];
        self.signUpButton.layer.cornerRadius = 8;
        [self.signUpButton setTitle:NSLocalizedString(@"SignUp", nil) forState:UIControlStateNormal];
        [self addSubview:self.signUpButton];
        
        _facebookButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(650, 290, itemWidth, 30)];
        [self addSubview:self.facebookButton];
        
        _mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Do you have account? SignIn", nil)];
        [self.mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(19, 8)];
        
        _underButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(700, 330, itemWidth, 20)];
//        self.underButtonLabel.text = NSLocalizedString(@"Do you have account?", nil);
        self.underButtonLabel.attributedText = self.mutableAttributedString;
        self.underButtonLabel.adjustsFontSizeToFitWidth = 0;
        self.underButtonLabel.minimumScaleFactor = 0;
        [self addSubview:self.underButtonLabel];
        
        _signInButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.signInButton.frame = CGRectMake(750, 360, itemWidth, 20);
        self.signInButton.backgroundColor = [UIColor redColor];
        [self.signInButton setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
        [self addSubview:self.signInButton];
        
        _loginMaterialEffectView = [[UIView alloc] initWithFrame:screenRect];
        self.loginMaterialEffectView.backgroundColor = [UIColor clearColor];
        self.loginMaterialEffectView.userInteractionEnabled = NO;
        [self addSubview:self.loginMaterialEffectView];

        self.initialStateConstraintsToDeactivate = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [self.logoImageView autoCenterInSuperview];
            [self.logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
            [self.logoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
        }];
// LogIn screen items
        _emailLogInTextField = [[UITextField alloc] initWithFrame:CGRectMake(700, 150, itemWidth, 20)];
        self.emailLogInTextField.backgroundColor = [UIColor yellowColor];
        self.emailLogInTextField.placeholder = NSLocalizedString(@"Email login", nil);
        self.emailLogInTextField.layer.cornerRadius = 8;
        self.emailLogInTextField.translatesAutoresizingMaskIntoConstraints = YES;
        [self addSubview:self.emailLogInTextField];
        
        _passwordLogInTextField = [[UITextField alloc] initWithFrame:CGRectMake(750, 180, itemWidth, 20)];
        self.passwordLogInTextField.backgroundColor = [UIColor yellowColor];
        self.passwordLogInTextField.placeholder = NSLocalizedString(@"Password login", nil);
        self.passwordLogInTextField.layer.cornerRadius = 8;
        [self addSubview:self.passwordLogInTextField];
        
        _logInButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.logInButton.frame = CGRectMake(800, 230, itemWidth, 30);
        self.logInButton.backgroundColor = [UIColor redColor];
        self.logInButton.layer.cornerRadius = 8;
        [self.logInButton setTitle:NSLocalizedString(@"LogIn", nil) forState:UIControlStateNormal];
        [self addSubview:self.logInButton];
        
        _backToSignUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.backToSignUpButton.frame = CGRectMake(850, 280, itemWidth, 30);
        self.backToSignUpButton.backgroundColor = [UIColor redColor];
        self.backToSignUpButton.layer.cornerRadius = 8;
        [self.backToSignUpButton setTitle:NSLocalizedString(@"Back to SignUP", nil) forState:UIControlStateNormal];
        [self addSubview:self.backToSignUpButton];

// Initial dynamic behaviors of UIKitDynamics
        
// Gravity Behaviors
        _signUpGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.emailTextField, self.passwordTextField, self.againPasswordTextField ,self.signUpButton, self.facebookButton, self.underButtonLabel, self.signInButton]];
        self.signUpGravityBehavior.gravityDirection = CGVectorMake(-1, 0);
        _logInGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.emailLogInTextField, self.passwordLogInTextField, self.logInButton, self.backToSignUpButton]];
        
// LeftCollisionBehavior with boundary invisible on screen
        _leftCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.emailTextField, self.passwordTextField, self.againPasswordTextField ,self.signUpButton, self.facebookButton, self.underButtonLabel, self.signInButton]];
        [self.leftCollisionBehavior addBoundaryWithIdentifier:@"leftBoundary" fromPoint:CGPointMake(leftCollisionBoundary, 0) toPoint:CGPointMake(leftCollisionBoundary, 2000)];
        
// LeftBehindScreenCollisionBehavior with boundary behind the screen
        _leftBehindScreenCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.emailTextField, self.passwordTextField, self.againPasswordTextField ,self.signUpButton, self.facebookButton, self.underButtonLabel, self.signInButton]];
        [self.leftBehindScreenCollisionBehavior addBoundaryWithIdentifier:@"leftBehindScreenBoundary" fromPoint:CGPointMake(leftBehindScreenBoundary , 0) toPoint:CGPointMake(leftBehindScreenBoundary , 2000)];
        
// RightCollisionBehavior with boundary invisible on screen
        _rightCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.emailTextField, self.passwordTextField, self.againPasswordTextField ,self.signUpButton, self.facebookButton, self.underButtonLabel, self.signInButton]];
        [self.rightCollisionBehavior addBoundaryWithIdentifier:@"rightBoundary" fromPoint:CGPointMake(rightCollisionBoundary, 0) toPoint:CGPointMake(rightCollisionBoundary, 2000)];
        
// RightBehindScreenCollisionBehavior with boundary behind the screen
        _rightBehindScreenCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.emailLogInTextField, self.passwordLogInTextField, self.logInButton, self.backToSignUpButton]];
        [self.rightBehindScreenCollisionBehavior addBoundaryWithIdentifier:@"rightBehindScreenBoundary" fromPoint:CGPointMake(rightBehindScreenBoundary , 0) toPoint:CGPointMake(rightBehindScreenBoundary , 2000)];
        
// Dynamic item behavior
        _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.emailTextField, self.passwordTextField, self.againPasswordTextField ,self.signUpButton, self.facebookButton, self.underButtonLabel, self.signInButton, self.emailLogInTextField, self.passwordLogInTextField, self.logInButton, self.backToSignUpButton]];
        self.dynamicItemBehavior.density = 0;
        self.dynamicItemBehavior.allowsRotation = NO;
//
//            [self.emailTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
//            [self.emailTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.6];
//            self.emailTextFieldConstraint = [self.emailTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self];
//        
//            [self.passwordTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
//            
//            [self.againPasswordTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
//            
//            [self.signUpButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
//        
//            [self.facebookButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
//            self.fbButtonConstraint = [self.facebookButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self];
//            
//            [self.underButtonLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:20];
            
        
//    =======================================================================================================================
        
//        [self.emailTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.emailTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.logoImageView withOffset:40];
//        [self.emailTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.7];
//        
//        [self.passwordTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.passwordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.emailTextField withOffset:20];
//        [self.passwordTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.7];
//        
//        [self.againPasswordTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.againPasswordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordTextField withOffset:20];
//        [self.againPasswordTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.7];
//        
//        [self.signUpButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.signUpButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.againPasswordTextField withOffset:20];
//        [self.signUpButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.7];
//        
////        [self.facebookButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.facebookButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];
//        [self.facebookButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self];
////        [self.facebookButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.signUpButton withOffset:20];
//        [self.facebookButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
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
        
        
        
//        [self.animator addBehavior:self.gravityBehavior];
//        [self.animator addBehavior:self.collisionBehavior];

        
        
//            [self.loginButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//            self.loginButtonConstraint = [self.loginButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self];
//        }];
        
    }
    return self;
}

- (void)dynamicAnimation {
    [self.animator addBehavior:self.signUpGravityBehavior];
    [self.animator addBehavior:self.leftCollisionBehavior];
    [self.animator addBehavior:self.dynamicItemBehavior];
    [self.animator addBehavior:self.leftBehindScreenCollisionBehavior];
}

- (void)removeBehavior {
    [self.leftCollisionBehavior removeItem:self.emailTextField];
    [self.leftCollisionBehavior removeItem:self.passwordTextField];
    [self.leftCollisionBehavior removeItem:self.againPasswordTextField];
    [self.leftCollisionBehavior removeItem:self.signUpButton];
    [self.leftCollisionBehavior removeItem:self.facebookButton];
    [self.leftCollisionBehavior removeItem:self.underButtonLabel];
    [self.leftCollisionBehavior removeItem:self.signInButton];
    
    [self.leftCollisionBehavior addItem:self.emailLogInTextField];
    [self.leftCollisionBehavior addItem:self.passwordLogInTextField];
    [self.leftCollisionBehavior addItem:self.logInButton];
    [self.leftCollisionBehavior addItem:self.backToSignUpButton];
    
    [self.animator addBehavior:self.logInGravityBehavior];
    [self.animator addBehavior:self.signUpGravityBehavior];
    [self.logInGravityBehavior setGravityDirection:CGVectorMake(-1, 0)];
    [self.signUpGravityBehavior setGravityDirection:CGVectorMake(-1, 0)];
}

- (void)backToSignUpBehavior {
    [self.signUpGravityBehavior setGravityDirection:CGVectorMake(1, 0)];
    [self.animator addBehavior:self.rightCollisionBehavior];
    [self.animator addBehavior:self.rightBehindScreenCollisionBehavior];
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {

        self.didSetupConstraints = YES;
    }
    
    if (self.shouldAnimateInitialAnimation) {
        [NSLayoutConstraint deactivateConstraints:self.initialStateConstraintsToDeactivate];
        [self.logoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.logoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
        [self.logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
        [self.logoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
        
        self.shouldAnimateInitialAnimation = NO;
    }
    
//    if (self.shouldAnimateTextFieldAndButtons) {
//        [NSLayoutConstraint deactivateConstraints:self.initialStateConstraintsToDeactivate];
//
//
//        self.shouldAnimateTextFieldAndButtons = NO;
//    }
    
    
    [super updateConstraints];
}

- (void)initialAnimation {
//
//    [NSLayoutConstraint deactivateConstraints:@[self.fbButtonConstraint]];
//    self.fbButtonConstraint = [self.facebookButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:150];
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//        self.facebookButton.alpha = 1;
////        [self setNeedsLayout];
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        
//    }];

//    [NSLayoutConstraint deactivateConstraints:@[self.loginButtonConstraint]];
//    self.loginButtonConstraint = [self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.facebookButton withOffset:40];
//    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
//        self.loginButton.alpha = 1;
////        [self setNeedsLayout];
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        
//    }];
    
//    [NSLayoutConstraint deactivateConstraints:@[self.loginButtonConstraint]];
//        self.loginButtonConstraint = [self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self withOffset:20];

    
    
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

    
    self.shouldAnimateInitialAnimation = YES;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:1.0
                          delay:0.3
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
        [self layoutIfNeeded];
    }
                     completion:^(BOOL finished) {
                         [self dynamicAnimation];
                     }];
}
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
//                     }

@end
