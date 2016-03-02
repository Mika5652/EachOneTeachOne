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
        
        _tableView = [[UITableView alloc] init];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50;
        [self addSubview:self.tableView];
        [self.tableView autoPinEdgesToSuperviewEdges];
        
//        _titlePostLabel = [UILabel newAutoLayoutView];
//        self.titlePostLabel.text = @"Title";
//        [self.titlePostLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
//        [self addSubview:self.titlePostLabel];

        _titleTextField = [UITextField newAutoLayoutView];
        self.titleTextField.backgroundColor = [UIColor whiteColor];
        self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.titleTextField.autocorrectionType = NO;
        [self addSubview:self.titleTextField];
        
        _descriptionTextView = [UITextView newAutoLayoutView];
        self.descriptionTextView.backgroundColor = [UIColor whiteColor];
        self.descriptionTextView.layer.cornerRadius = 7;
        self.descriptionTextView.font = [UIFont boldSystemFontOfSize:20];
        self.descriptionTextView.autocorrectionType = NO;
        [self addSubview:self.descriptionTextView];
        
    }
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalSpacing];
        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.titleTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];
        
        [self.descriptionTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleTextField withOffset:kVerticalSpacing];
        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalSpacing];
        [self.descriptionTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalSpacing];

        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        
//// Background color
//        self.backgroundColor = [UIColor lightGrayColor];
//
//// Title label
//        _titlePostLabel = [[UILabel alloc] init];
//        self.titlePostLabel.text = NSLocalizedString(@"Title", @"");
//        self.titlePostLabel.font = [UIFont boldSystemFontOfSize:20];
//        [self addSubview:self.titlePostLabel];
//            
//// Title text field
//        _titleTextField = [[UITextField alloc] init];
//        self.titleTextField.backgroundColor = TEXT_FIELD_COLOR;
//        self.titleTextField.placeholder = NSLocalizedString(TITLE_PLACEHOLDER_TEXT, @"");
//        self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
//        self.titleTextField.autocorrectionType = NO;
//        [self addSubview:self.titleTextField];
//            
//// Capture video button
//        _captureVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.captureVideoButton setImage:[UIImage imageNamed:TAKE_VIDEO_ICON] forState:UIControlStateNormal];
//        [self addSubview:self.captureVideoButton];
//            
//// Description label
//        _descriptionLabel = [[UILabel alloc] init];
//        self.descriptionLabel.text = NSLocalizedString(@"Description", @"");
//        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:20];
//        [self addSubview:self.descriptionLabel];
//
//// Description text view
//        _descriptionTextView = [[UITextView alloc] init];
//        self.descriptionTextView.backgroundColor = TEXT_FIELD_COLOR;
//        self.descriptionTextView.layer.cornerRadius = 7;
//        self.descriptionTextView.font = [UIFont boldSystemFontOfSize:20];
//        self.descriptionTextView.autocorrectionType = NO;
//        [self addSubview:self.descriptionTextView];
//            
//        NSDictionary *metrics = @{@"TEXT_FIELD_SIDE_INDENTATION" : @TEXT_FIELD_SIDE_INDENTATION};
//            
//        TMALVariableBindingsAMNO(_titlePostLabel , _titleTextField, _captureVideoButton, _descriptionLabel, _descriptionTextView, metrics);
//// Title label
//        TMAL_ADDS_CENTERX(_titlePostLabel, self.titlePostLabel.superview);
//        TMAL_ADDS_VISUAL(@"V:|-80-[_titlePostLabel]");
//// Title text field
//        TMAL_ADDS_VISUALM(@"H:|-TEXT_FIELD_SIDE_INDENTATION-[_titleTextField(==220)]-TEXT_FIELD_SIDE_INDENTATION-|", metrics);
//        TMAL_ADDS_VISUAL(@"V:[_titlePostLabel]-10-[_titleTextField]");
//// Capture video button image
//        TMAL_ADDS_CENTERX(_captureVideoButton, self.captureVideoButton.superview);
//        TMAL_ADDS_VISUAL(@"H:[_captureVideoButton(==150)]");
//        TMAL_ADDS_VISUAL(@"V:[_titleTextField]-50-[_captureVideoButton(==150)]");
//// Description label
//        TMAL_ADDS_CENTERX(_descriptionLabel, self.descriptionLabel.superview);
//        TMAL_ADDS_VISUAL(@"V:[_captureVideoButton]-30-[_descriptionLabel]");
//// Description text field
//        TMAL_ADDS_VISUALM(@"H:|-TEXT_FIELD_SIDE_INDENTATION-[_descriptionTextView]-TEXT_FIELD_SIDE_INDENTATION-|", metrics);
//        TMAL_ADDS_VISUAL(@"V:[_descriptionLabel]-10-[_descriptionTextView(==150)]");
//        
//    }
//    return self;
//}

@end
