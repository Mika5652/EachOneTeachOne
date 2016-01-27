//
//  DBMainViewController.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBMainViewController.h"
#import "DBMainView.h"
#import "DBCreateFeedViewController.h"

@interface DBMainViewController ()

@end

@implementation DBMainViewController
{
    NSArray *feedTableData;
}

- (void)loadView {
    self.view = [[DBMainView alloc] init];
    self.title = NSLocalizedString(@"Feed", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPress)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    feedTableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [feedTableData objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UserAction

- (void)rightBarButtonDidPress {
    DBCreateFeedViewController *createFeedViewController = [[DBCreateFeedViewController alloc] init];
    [self.navigationController pushViewController:createFeedViewController animated:YES];
}

#pragma mark - Properties

- (DBMainView *)mainMenuView {
    return (DBMainView *) self.view;
}


@end
