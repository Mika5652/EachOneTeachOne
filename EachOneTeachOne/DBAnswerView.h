//
//  DBAnswerView.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 23/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAnswer;

@interface DBAnswerView : UIStackView

@property DBAnswer *answer;

- (instancetype)initWithAnswer:(DBAnswer *)answer;

@end
