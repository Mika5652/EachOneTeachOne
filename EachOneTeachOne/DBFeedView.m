//
//  DBMainView.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//
// Framework
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "DBFeedView.h"
#import <PureLayout/PureLayout.h>

@implementation DBFeedView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc] init];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50;
        [self addSubview:self.tableView];
        [self.tableView autoPinEdgesToSuperviewEdges];

// Blur Effect
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bottomBlurView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
// BottomView
        _bottomBlurView = [[UIView alloc] init];
        self.bottomBlurView.backgroundColor = [UIColor clearColor];
        
        [self.bottomBlurView addSubview:blurEffectView];
        [self.tableView addSubview:self.bottomBlurView];
        
// Facebook login button
        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectZero];
        [self.bottomBlurView addSubview:loginButton];
        
// PureLayout
        [loginButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.bottomBlurView];
        [loginButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:4];
        [loginButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.bottomBlurView withMultiplier:0.2];
        
        [self.bottomBlurView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [self.bottomBlurView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [self.bottomBlurView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [self.bottomBlurView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self withMultiplier:0.15];
        
    }
    return self;
}

@end
