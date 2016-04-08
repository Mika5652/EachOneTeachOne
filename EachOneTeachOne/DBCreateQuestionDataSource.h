//
//  DBCreateQuestionDataSource.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBCreateQuestionDataSource : NSObject <UITableViewDataSource>

@property NSMutableArray *items;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withHeight:(NSNumber *)number;

@end
