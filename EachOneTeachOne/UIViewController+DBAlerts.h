//
//  UIViewController+DBAlerts.h
//  PhotoBox
//
//  Created by Vojtech Belovsky on 22/02/16.
//  Copyright © 2016 iDevBand s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DBAlerts)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissButtonText:(NSString *)dismissButtonText;
- (void)showOKAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
