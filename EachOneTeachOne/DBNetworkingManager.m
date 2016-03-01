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
            
            id attachment = [dataArray objectAtIndex:i];
            NSString *objectIDStringWithIndex = question.objectId;
            NSString *objectThumbnailName;
            
            objectIDStringWithIndex = [objectIDStringWithIndex stringByAppendingString:[NSString stringWithFormat:@"_%d", i]];
            if ([attachment conformsToProtocol:@protocol(DBQuestionAttachmentProtocol)] && [attachment isKindOfClass:[DBQuestionAttachment class]]) {
                DBQuestionAttachment<DBQuestionAttachmentProtocol> *questionAttachment = (DBQuestionAttachment<DBQuestionAttachmentProtocol> *)attachment;
                if (i == 0) {
                    objectThumbnailName = [[question.objectId stringByAppendingString:@"_thumbnail"] stringByAppendingPathExtension:kJPGExtenstion];
                    [DBS3Manager uploadFileWithKey:objectThumbnailName data:[questionAttachment thumbnailDataForUpload] mimeType:kJPGExtenstion completionBlock:^(BOOL success, NSError *error) {
                        question.thumbnailName = objectThumbnailName;
                        [question saveInBackground];
                    }];
                }
                objectIDStringWithIndex = [objectIDStringWithIndex stringByAppendingPathExtension:[questionAttachment fileExtension]];
                [DBS3Manager uploadFileWithKey:objectIDStringWithIndex
                                          data:[questionAttachment dataForUpload]
                                      mimeType:[questionAttachment mimeType]
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
