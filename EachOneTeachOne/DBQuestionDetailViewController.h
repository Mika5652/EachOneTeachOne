//
//  DBQuestionDetailViewController.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 11/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBQuestion;

@interface DBQuestionDetailViewController : UIViewController

- (instancetype)initWithQuestion:(DBQuestion *)question;

@end
