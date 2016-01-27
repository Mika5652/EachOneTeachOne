//
//  AppDelegate.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//
// Framworks
#import <Parse/Parse.h>

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
    
    [Parse enableLocalDatastore];
    
// Initialize Parse.
    [Parse setApplicationId:@"4r4yg2bzVPWpjL6yRXa4AuwrDSgTbYl8D3JyDmFN"
                  clientKey:@"dcpKWAw63tUxJF2MXP2bCE1RNyqEu634vjm2NCki"];
    
// [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

@end
