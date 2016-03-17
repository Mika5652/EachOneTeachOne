//
//  DBLoginAndSignUpViewController.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 07.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBLoginAndSignUpView;

@interface DBLoginAndSignUpViewController : UIViewController

@property (nonatomic, assign) BOOL isAnimatingToEndState;
@property (nonatomic, strong) NSLayoutConstraint *logoImageViewEdgeConstraint;
@property (readonly, strong) DBLoginAndSignUpView *loginAndSignUpView;

@end
