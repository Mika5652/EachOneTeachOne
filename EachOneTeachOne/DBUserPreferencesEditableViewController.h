//
//  DBUserPreferencesViewController.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 30/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUserPreferencesEditableView.h"

@interface DBUserPreferencesEditableViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) DBUserPreferencesEditableView *userPreferencesEditableView;
@property PFUser *user;

- (instancetype)initWithUser:(PFUser *)user;

@end
