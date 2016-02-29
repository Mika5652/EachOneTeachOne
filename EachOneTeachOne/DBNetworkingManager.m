//
//  DBNetworkingManager.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBNetworkingManager.h"
#import "DBParseManager.h"
#import "DBS3Manager.h"

NSString * const kAWSS3BaseURL = @"https://s3.eu-central-1.amazonaws.com/eachoneteachonebucket";

@implementation DBNetworkingManager

+ (void)uploadManager:(DBQuestion *)question data:(NSData *)data mimeType:(NSString *)mimeType {
    [DBParseManager uploadQuestionWithTitle:question.title questionDescription:question.questionDescription videosAndPhotosNames:question.videosAndPhotosNames completion:^(NSString *objectIDString, NSError *error) {
        [DBS3Manager uploadFileWithKey:objectIDString
                                  data:data
                              mimeType:mimeType
                       completionBlock:^(BOOL success, NSError *error) {
                           
                       }];
    }];
}

@end
