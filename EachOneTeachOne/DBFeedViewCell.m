//
//  DBFeedViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBFeedViewCell.h"
#import "Core.h"

@implementation DBFeedViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _photoImageView = [[UIImageView alloc] init];
        [self addSubview:self.photoImageView];
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:self.titleLabel];
        
        _descriptionLabel = [[UILabel alloc] init];
        [self addSubview:self.descriptionLabel];
        
        
    }
    
    return self;
}

@end
