//
//  DBLoginView.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 10.03.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBLoginAndSignUpView : UIView

@property UIImageView *logoImageView;

@property UIButton *facebookButton;

@property (nonatomic, strong) NSLayoutConstraint *logoImageViewEdgeConstraint;

- (void)initialAnimation;

@end
