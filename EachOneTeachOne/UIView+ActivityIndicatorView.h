//
//  UIView+Activity.h
//  Sentinel
//
//  Created by Daniel Krezelok on 28/01/15.
//  Copyright (c) 2015 Daniel Krezelok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ActivityIndicatorView)
- (void)showActivityIndicatorViewWithTitle:(NSString *)title;
- (void)hideActivityIndicatorView;
- (void)updateTitle:(NSString *)title;
@end
