//
//  DBUserPreferencesViewController.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 07/04/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUserPreferencesView.h"

@interface DBUserPreferencesViewController :  UIViewController <UINavigationControllerDelegate>

@property (nonatomic) DBUserPreferencesView *userPreferencesView;
@property PFUser *user;

- (instancetype)initWithUser:(PFUser *)user;


@end