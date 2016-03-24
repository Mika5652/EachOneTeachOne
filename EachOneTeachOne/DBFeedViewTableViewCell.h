//
//  DBFeedViewCell.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

extern NSString * const kDBFeedViewTableViewCellIdentifier;

@interface DBFeedViewTableViewCell : UITableViewCell

@property UILabel *titleLabel;
@property UILabel *descriptionLabel;
@property PFImageView *photoImageView;

- (void)setFonts;
    
@end
