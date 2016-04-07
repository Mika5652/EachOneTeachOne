//
//  PFUser+Extensions.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 31/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "PFUser+Extensions.h"

@class DBQuestion;

@implementation PFUser (Extension)

- (NSString *)getUserCrew:(PFUser *)user {
    return [user objectForKey:@"crew"];
}

- (NSString *)getUserCity:(PFUser *)user {
    return [user objectForKey:@"city"];
}

- (PFFile *)getUserAvatar:(PFUser *)user {
    return [user objectForKey:@"avatar"];
}

- (void)setUserName:(NSString *)userName ofUser:(PFUser *)user {
    user.username = userName;
}

- (void)setUserCrew:(NSString *)crew ofUser:(PFUser *)user {
    user[@"crew"] = crew;
}

- (void)setUserCity:(NSString *)city ofUser:(PFUser *)user {
    user[@"city"] = city;
}

- (void)setUserAvatar:(PFFile *)avatar ofUser:(PFUser *)user {
    user[@"avatar"] = avatar;
}

- (void)getUserNameFromQuestion:(DBQuestion *)question {
    PFQuery *query = [PFUser query];
    
}

@end
