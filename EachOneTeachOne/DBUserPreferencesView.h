//
//  DBUserPreferencesView.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 30/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DBUserPreferencesView : UIView

@property PFFile *avatar;
@property UITextField *userNameTextField;
@property UITextField *crewTextField;
@property UITextField *cityTextField;

@end
