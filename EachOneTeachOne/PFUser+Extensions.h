//
//  PFUser+Extensions.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 31/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PFUser (Extension)

- (NSString *)getUserCrew:(PFUser *)user;
- (NSString *)getUserCity:(PFUser *)user;
- (PFFile *)getUserAvatar:(PFUser *)user;
- (void)setUserName:(NSString *)userName ofUser:(PFUser *)user;
- (void)setUserCrew:(NSString *)crew ofUser:(PFUser *)user;
- (void)setUserCity:(NSString *)city ofUser:(PFUser *)user;
- (void)setUserAvatar:(PFFile *)avatar ofUser:(PFUser *)user;


@end
