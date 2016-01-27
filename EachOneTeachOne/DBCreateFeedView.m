//
//  DBCreateFeedView.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

// View
#import "DBCreateFeedView.h"
// Core
#import "Core.h"
// Macros
#define TITLE_PLACEHOLDER_TEXT          @"Name of your post"
#define TAKE_VIDEO_ICON                 @"camera_icon"

#define TEXT_FIELD_SIDE_INDENTATION     50

#define TEXT_FIELD_COLOR                [UIColor whiteColor]

@implementation DBCreateFeedView

- (instancetype)init {
    self = [super init];
    if (self) {
        
// Background color
            self.backgroundColor = [UIColor lightGrayColor];
            
// Title label
        _titlePostLabel = [[UILabel alloc] init];
        self.titlePostLabel.text = NSLocalizedString(@"Title", @"");
        self.titlePostLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:self.titlePostLabel];
            
// Title text field
        _titleTextField = [[UITextField alloc] init];
        self.titleTextField.backgroundColor = TEXT_FIELD_COLOR;
        self.titleTextField.placeholder = NSLocalizedString(TITLE_PLACEHOLDER_TEXT, @"");
        self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.titleTextField.autocorrectionType = NO;
        [self addSubview:self.titleTextField];
            
// Capture video button
        _captureVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.captureVideoButton setImage:[UIImage imageNamed:TAKE_VIDEO_ICON] forState:UIControlStateNormal];
        [self addSubview:self.captureVideoButton];
            
// Description label
        _descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.text = NSLocalizedString(@"Description", @"");
        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:self.descriptionLabel];

// Description text view
        _descriptionTextView = [[UITextView alloc] init];
        self.descriptionTextView.backgroundColor = TEXT_FIELD_COLOR;
        self.descriptionTextView.layer.cornerRadius = 7;
        self.descriptionTextView.font = [UIFont boldSystemFontOfSize:20];
        self.descriptionTextView.autocorrectionType = NO;
        [self addSubview:self.descriptionTextView];
            
// Post button
        _postButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.postButton setTitle:NSLocalizedString(@"Post", @"") forState:UIControlStateNormal];
        [self.postButton.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [self addSubview:self.postButton];
            
        NSDictionary *metrics = @{@"TEXT_FIELD_SIDE_INDENTATION" : @TEXT_FIELD_SIDE_INDENTATION};
            
        TMALVariableBindingsAMNO(_titlePostLabel , _titleTextField, _captureVideoButton, _descriptionLabel, _descriptionTextView, metrics, _postButton);
// Title label
        TMAL_ADDS_CENTERX(_titlePostLabel, self.titlePostLabel.superview);
        TMAL_ADDS_VISUAL(@"V:|-80-[_titlePostLabel]");
// Title text field
        TMAL_ADDS_VISUALM(@"H:|-TEXT_FIELD_SIDE_INDENTATION-[_titleTextField]-TEXT_FIELD_SIDE_INDENTATION-|", metrics);
        TMAL_ADDS_VISUAL(@"V:[_titlePostLabel]-10-[_titleTextField]");
// Capture video button image
        TMAL_ADDS_CENTERX(_captureVideoButton, self.captureVideoButton.superview);
        TMAL_ADDS_VISUAL(@"V:[_titleTextField]-50-[_captureVideoButton]");
// Description label
        TMAL_ADDS_CENTERX(_descriptionLabel, self.descriptionLabel.superview);
        TMAL_ADDS_VISUAL(@"V:[_captureVideoButton]-30-[_descriptionLabel]");
// Description text field
        TMAL_ADDS_VISUALM(@"H:|-TEXT_FIELD_SIDE_INDENTATION-[_descriptionTextView]-TEXT_FIELD_SIDE_INDENTATION-|", metrics);
        TMAL_ADDS_VISUAL(@"V:[_descriptionLabel]-10-[_descriptionTextView(==150)]");
// Post button
        TMAL_ADDS_CENTERX(_postButton, self.postButton.superview);
        TMAL_ADDS_VISUAL(@"V:[_descriptionTextView]-30-[_postButton]");
        
    }
    return self;
}

@end
