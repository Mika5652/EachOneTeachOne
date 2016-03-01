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
#import "DBQuestionPhotoAttachment.h"
#import "DBQuestionVideoAttachment.h"

NSString * const kAWSS3BaseURL = @"https://s3.eu-central-1.amazonaws.com/eachoneteachonebucket";

@implementation DBNetworkingManager

+ (void)uploadQuestion:(DBQuestion *)question dataArray:(NSMutableArray *)dataArray {
    [DBParseManager uploadQuestion:question completion:^(DBQuestion *question, NSError *error) {
        NSMutableArray *videosAndPhotosNamesArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [dataArray count]; i++) {
            NSString *objectIDStringWithIndex = [question.objectId stringByAppendingString:[NSString stringWithFormat:@"_%d", i]];
            
            id attachment = [dataArray objectAtIndex:i];
            
            if ([attachment isKindOfClass:[DBQuestionVideoAttachment class]]) {
                [objectIDStringWithIndex stringByAppendingPathExtension:kMOVExtenstion];
                DBQuestionVideoAttachment *videoAttachment = (DBQuestionVideoAttachment *)attachment;
                [DBS3Manager uploadFileWithKey:objectIDStringWithIndex
                                          data:[NSData dataWithContentsOfURL:videoAttachment.videoURL]
                                      mimeType:videoAttachment.mimeType
                               completionBlock:^(BOOL success, NSError *error) {
                                   
                               }];
            } else {
                [objectIDStringWithIndex stringByAppendingPathExtension:kJPGExtenstion];
                DBQuestionPhotoAttachment *photoAttachment = attachment;
                [DBS3Manager uploadFileWithKey:objectIDStringWithIndex
                                          data:UIImageJPEGRepresentation(photoAttachment.photoImage, 1)
                                      mimeType:photoAttachment.mimeType
                               completionBlock:^(BOOL success, NSError *error) {
                                   
                               }];
            }
            [videosAndPhotosNamesArray addObject:objectIDStringWithIndex];
            
        }
        question.videosAndPhotosNames = videosAndPhotosNamesArray;
        [question saveInBackground];
    }];
}

@end
