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
#import "DBPhotoAttachment.h"
#import "DBVideoAttachment.h"

NSString * const kAWSS3BaseURL = @"https://s3.eu-central-1.amazonaws.com/eachoneteachonebucket";

@implementation DBNetworkingManager

+ (void)uploadQuestionWithTitle:(NSString *)questionTitle questionDesciption:(NSString *)questionDesription dataArray:(NSMutableArray *)dataArray completion:(DBNetworkingManagerUploadQuestionCompletion)completion {
    [DBParseManager uploadQuestionWithTitle:questionTitle questionDesciption:questionDesription completion:^(DBQuestion *question, NSError *error) {
//        NSMutableArray *videosAndPhotosNamesArray = [[NSMutableArray alloc] init];
        
        if (error == nil) {
            if (dataArray.count != 0) {
                id attachment = dataArray.firstObject;
                if ([attachment conformsToProtocol:@protocol(DBAttachmentProtocol)] && [attachment isKindOfClass:[DBAttachment class]]) {
                    DBAttachment<DBAttachmentProtocol> *questionAttachment = (DBAttachment<DBAttachmentProtocol> *)attachment;
                    NSString *objectThumbnailName = [[question.objectId stringByAppendingString:@"_thumbnail"] stringByAppendingPathExtension:kJPGExtenstion];
                    [DBS3Manager uploadFileWithKey:objectThumbnailName data:[questionAttachment thumbnailDataForUpload] mimeType:kJPGExtenstion completion:^(BOOL success, NSError *error) {
                        question.thumbnailName = objectThumbnailName;
                        [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (error == nil) {
                                [self uploadAttachments:dataArray toQuestion:question completion:^(BOOL success, NSError *error) {
                                    
                                }];
                            }
                        }];
                    }];
                }
            } else {
                completion(question, error);
            }
            
//            for (int i = 0; i < [dataArray count]; i++) {
//                
//                id attachment = [dataArray objectAtIndex:i];
//                NSString *objectIDStringWithIndex = question.objectId;
//                NSString *objectThumbnailName;
//                
//                objectIDStringWithIndex = [objectIDStringWithIndex stringByAppendingString:[NSString stringWithFormat:@"_%d", i]];
//                if ([attachment conformsToProtocol:@protocol(DBAttachmentProtocol)] && [attachment isKindOfClass:[DBAttachment class]]) {
//                    DBAttachment<DBAttachmentProtocol> *questionAttachment = (DBAttachment<DBAttachmentProtocol> *)attachment;
//                    if (i == 0) {
//                        objectThumbnailName = [[question.objectId stringByAppendingString:@"_thumbnail"] stringByAppendingPathExtension:kJPGExtenstion];
//                        [DBS3Manager uploadFileWithKey:objectThumbnailName data:[questionAttachment thumbnailDataForUpload] mimeType:kJPGExtenstion completion:^(BOOL success, NSError *error) {
//                            question.thumbnailName = objectThumbnailName;
//                            [question saveInBackground];
//                        }];
//                    }
//                    objectIDStringWithIndex = [objectIDStringWithIndex stringByAppendingPathExtension:[questionAttachment fileExtension]];
//                    [DBS3Manager uploadFileWithKey:objectIDStringWithIndex
//                                              data:[questionAttachment dataForUpload]
//                                          mimeType:[questionAttachment mimeType]
//                                        completion:^(BOOL success, NSError *error) {
//                                            
//                                        }];
//                }
//                [videosAndPhotosNamesArray addObject:objectIDStringWithIndex];
//            
//            }
//            question.videosAndPhotosNames = videosAndPhotosNamesArray;
//            [question saveInBackground];
        
            
        } else {
            
        }
        
    }];
}

+ (void)uploadAttachments:(NSArray *)dataArray toQuestion:(DBQuestion *)question completion:(DBNetworkingManagerUploadAttachmentsCompletion)completion {
    id data = dataArray.firstObject;
    if ([data conformsToProtocol:@protocol(DBAttachmentProtocol)] && [data isKindOfClass:[DBAttachment class]]) {
        __block DBAttachment<DBAttachmentProtocol> *attachment = (DBAttachment<DBAttachmentProtocol> *)data;

        [DBParseManager uploadAttachmentWithDescription:attachment.attachmentDescription mimeType:attachment.mimeType completion:^(DBAttachment *attachment, NSError *error) {
            if (error == nil) {
//                NSString *fileName = [attachment.objectId stringByAppendingPathExtension:[attachment fileExtension]];
//                [DBS3Manager uploadFileWithKey: data:<#(NSData *)#> mimeType:<#(NSString *)#> completion:<#^(BOOL success, NSError *error)completion#>]
//                [question.attachments addObject:attachment];
//                if (dataArray.count > 1) {
//                    [DBNetworkingManager uploadAttachments:[dataArray subarrayWithRange:NSMakeRange(1, dataArray.count-1)] completion:completion];
//                } else {
//                    completion(YES, error);
//                }
            } else {
                completion(NO, error);
            }
        }];
    } else {
        completion(NO, [NSError errorWithDomain:@"Unexpected data in uploadAttachments method" code:0 userInfo:nil]);
    }
}

@end
