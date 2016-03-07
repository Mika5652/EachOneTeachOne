//
//  DBQuestion.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 27.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Parse/Parse.h>

@interface DBQuestion : PFObject <PFSubclassing>

@property NSString *title;
@property NSString *questionDescription;
@property NSMutableArray *attachments;
@property NSString *thumbnailName;

@end
