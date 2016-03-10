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

#import "DBLoginAndSignUpView.h"

@interface DBLoginAndSignUpView ()

@property BOOL didSetupConstraints;
@property BOOL shouldAnimateInitialAnimation;

@property NSArray *initialStateConstraintsToDeactivate;
//@property NSArray *initialStateConstraintsToActivate;

@end

@implementation DBLoginAndSignUpView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_icon"]];
        [self addSubview:self.logoImageView];
        
        _facebookButton = [[FBSDKLoginButton alloc] init];
        [self addSubview:self.facebookButton];

        self.initialStateConstraintsToDeactivate = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [self.logoImageView autoCenterInSuperview];
            [self.logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
            [self.logoImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
            
            [self.facebookButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.facebookButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self];
        }];
    }
    return self;
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
        
        [self.facebookButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.facebookButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.logoImageView withOffset:30];
        [self.facebookButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
        
        self.shouldAnimateInitialAnimation = NO;
    }
    [super updateConstraints];
}

- (void)initialAnimation {
    self.shouldAnimateInitialAnimation = YES;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:2.0
                          delay:0.3
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
        [self layoutIfNeeded];
    }
                     completion:nil];
}

@end
