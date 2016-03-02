//
//  DBFeedViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDBFeedViewTableViewCellIdentifier;

@interface DBFeedViewTableViewCell : UITableViewCell

@property UIImageView *photoImageView;
@property UILabel *titleLabel;
@property UILabel *descriptionLabel;

- (void)setFonts;
    
@end
