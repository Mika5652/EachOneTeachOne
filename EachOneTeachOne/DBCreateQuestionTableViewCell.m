//
//  DBCreateQuestionCollectionViewCell.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBCreateQuestionTableViewCell.h"
#import <PureLayout/PureLayout.h>

NSString * const kDBCreateQuestionTableViewCellIdentifier = @"kDBCreateQuestionTableViewCellIdentifier";

@interface DBCreateQuestionTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DBCreateQuestionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        _photoImageView = [UIImageView newAutoLayoutView];
//        [self.contentView addSubview:self.photoImageView];
//        
//        _descriptionLabel = [UILabel newAutoLayoutView];
//        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:14];
//        self.descriptionLabel.numberOfLines = 0;
//        self.descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [self.contentView addSubview:self.descriptionLabel];
    }
    
    return self;
}
//
//- (void)updateConstraints {
//    if (!self.didSetupConstraints) {
//        
////        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
////        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
////        [self.photoImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
////        
////        [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.photoImageView withOffset:4];
////        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading];
////        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
////        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//        
//        self.didSetupConstraints = YES;
//    }
//    
//    [super updateConstraints];
//}

@end
