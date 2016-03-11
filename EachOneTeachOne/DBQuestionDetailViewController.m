//
//  DBQuestionDetailViewController.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 11/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionDetailViewController.h"
#import "DBQuestionDetailView.h"
#import "DBQuestion.h"

@interface DBQuestionDetailViewController ()

@property DBQuestion *question;

@end

@implementation DBQuestionDetailViewController

- (instancetype)initWithQuestion:(DBQuestion *)question {
    self = [super init];
    if (self) {
        _question = question;
    }
    return self;
}

- (void)loadView {
    self.view = [[DBQuestionDetailView alloc] initWithQuestion:self.question];
    self.title = NSLocalizedString(@"Question detail", @"");
}

@end
