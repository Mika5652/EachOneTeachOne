//
//  DBMainViewController.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class DBFeedView;

@interface DBFeedViewController : UIViewController <UITableViewDelegate> //PFLogInViewControllerDelegate

@property (nonatomic) DBFeedView *feedView;

@end
