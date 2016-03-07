//
//  UIViewController+DBAlerts.m
//  PhotoBox
//
//  Created by Vojtech Belovsky on 22/02/16.
//  Copyright © 2016 iDevBand s.r.o. All rights reserved.
//

#import "UIViewController+DBAlerts.h"

@implementation UIViewController (DBAlerts)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissButtonText:(NSString *)dismissButtonText {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:dismissButtonText style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showOKAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithTitle:title message:message dismissButtonText:NSLocalizedString(@"OK", @"")];
}

@end
