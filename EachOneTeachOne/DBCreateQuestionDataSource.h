//
//  DBCreateQuestionDataSource.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBQuestion;

@interface DBCreateQuestionDataSource : NSObject <UITableViewDataSource>

@property NSMutableArray *items;
@property DBQuestion *question;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withHeight:(NSNumber *)number;
- (NSString *)questionTitleString;
- (NSString *)questionDescriptionString;

@end
