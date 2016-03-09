//
//  ActivityView.m
//  Sentinel
//
//  Created by Daniel Krezelok on 28/01/15.
//  Copyright (c) 2015 Daniel Krezelok. All rights reserved.
//

#import "DBActivityIndicatorView.h"
#import "Core.h"

#define OVERALY_COLOR [UIColor blackColor]
#define OVERALY_ALPHA 0.7f
#define TITLE_FONT    [UIFont boldSystemFontOfSize:18.0f]
#define TITLE_COLOR   [UIColor whiteColor]

@interface DBActivityIndicatorView ()
@property (readonly) UIView *overalyView;
@property (readonly) UIActivityIndicatorView *activityView;
@end

@implementation DBActivityIndicatorView

#pragma mark - LifeCycles

- (instancetype)init {
  self = [super init];
  if ( self ) {
    _overalyView = [[UIView alloc] init];
    _overalyView.backgroundColor = OVERALY_COLOR;
    _overalyView.alpha = OVERALY_ALPHA;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = TITLE_FONT;
    _titleLabel.textColor = TITLE_COLOR;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_overalyView];
    [self addSubview:_activityView];
    [self addSubview:_titleLabel];
    
    TMALVariableBindingsAMNO( _overalyView, _activityView, _titleLabel );
    
    TMAL_ADDS_VISUAL( @"H:|-0-[_overalyView]-0-|" );
    TMAL_ADDS_VISUAL( @"V:|-0-[_overalyView]-0-|" );
    
    TMAL_ADDS_CENTERX( _activityView, _activityView.superview );
    TMAL_ADDS_CENTERY( _activityView, _activityView.superview );
    
    TMAL_ADDS_VISUAL( @"H:|-0-[_titleLabel]-0-|" );
    TMAL_ADDS_VISUAL( @"V:[_activityView]-5-[_titleLabel]" );
    
    [_activityView startAnimating];
  }
  
  return self;
}

- (UIColor *)blackColor {
    return [UIColor blackColor];
}

@end
