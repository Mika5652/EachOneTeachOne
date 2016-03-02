//
//  DBCreateFeedView.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// Framework
#import <PureLayout/PureLayout.h>

// View
#import "DBCreateQuestionView.h"

// Core
#import "Core.h"

static CGFloat const kVerticalSpacing = 4;
static CGFloat const kHorizontalSpacing = 4;

@interface DBCreateQuestionView ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end


@implementation DBCreateQuestionView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];

//        _tableView = [[UITableView alloc] init];
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//        self.tableView.estimatedRowHeight = 50;
//        [self addSubview:self.tableView];
//
//        _titleTextField = [UITextField newAutoLayoutView];
//        self.titleTextField.backgroundColor = [UIColor greenColor];
//        self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
//        self.titleTextField.placeholder = NSLocalizedString(@"Title ", nil);
//        self.titleTextField.autocorrectionType = NO;
//        [self addSubview:self.titleTextField];
//
//        _descriptionTextView = [UITextView newAutoLayoutView];
//        self.descriptionTextView.backgroundColor = [UIColor redColor];
//        self.descriptionTextView.layer.cornerRadius = 7;
//        self.descriptionTextView.autocorrectionType = NO;
//        [self addSubview:self.descriptionTextView];
        
    }
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
//        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing+64];
//        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
//        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
//        [self.titleTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
//        
//        [self.descriptionTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleTextField withOffset:kVerticalSpacing];
//        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
//        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
//        [self.descriptionTextView autoSetDimension:ALDimensionHeight toSize:50];
//        
//        [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.descriptionTextView];
//        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kVerticalSpacing];
//        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kVerticalSpacing];
//        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];

        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
