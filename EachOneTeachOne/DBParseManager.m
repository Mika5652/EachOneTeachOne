//
//  DBParseManager.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 24/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBParseManager.h"
#import "DBQuestion.h"

@implementation DBParseManager

+ (void)uploadQuestionWithTitle:(NSString *)title questionDescription:(NSString *)questionDescription videosAndPhotosNames:(NSArray *)videosAndPhotosNames {

    DBQuestion *question = [DBQuestion object];
    
    question.title = title;
    question.questionDescription = questionDescription;
    question.videosAndPhotosNames = videosAndPhotosNames;
    
    [question saveInBackground];

}


@end
