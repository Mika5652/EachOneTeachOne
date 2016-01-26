//
//  AppDelegate.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "AppDelegate.h"
#import "DBMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    DBMainViewController *mainViewController = [[DBMainViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
