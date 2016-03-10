//
//  UIView+Activity.m
//  Sentinel
//
//  Created by Daniel Krezelok on 28/01/15.
//  Copyright (c) 2015 Daniel Krezelok. All rights reserved.
//

#import "UIView+ActivityIndicatorView.h"
#import "DBActivityIndicatorView.h"
#import "Core.h"

NSTimeInterval const kAnimationDuration = 0.25f;

static NSUInteger kActivityTag = 999;

@implementation UIView (ActivityIndicatorView)

#pragma mark - Public

- (void)showActivityIndicatorViewWithTitle:(NSString *)title {
    DBActivityIndicatorView *activityIndicatorView = [[DBActivityIndicatorView alloc] init];
    activityIndicatorView.titleLabel.text = title;
    activityIndicatorView.alpha = 0.0f;
    activityIndicatorView.tag = kActivityTag;
    [self addSubview:activityIndicatorView];
    
    TMALVariableBindingsAMNO( activityIndicatorView );
    TMAL_ADDS_VISUAL( @"H:|-0-[activityIndicatorView]-0-|" );
    TMAL_ADDS_VISUAL( @"V:|-0-[activityIndicatorView]-0-|" );
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        activityIndicatorView.alpha = 1.0f;
    }];
}

- (void)updateTitle:(NSString *)title {
    DBActivityIndicatorView *activityIndicatorView = (DBActivityIndicatorView *)[self viewWithTag:kActivityTag];
    activityIndicatorView.titleLabel.text = title;
}

- (void)hideActivityIndicatorView {
    __block UIView *activityView = [self viewWithTag:kActivityTag];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        activityView.alpha = 0;
    } completion:^(BOOL finished) {
        [activityView removeFromSuperview];
        activityView = nil;
    }];
}

@end
