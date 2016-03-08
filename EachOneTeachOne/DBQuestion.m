//
//  DBQuestion.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 27.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestion.h"
#import "DBAttachment.h"
#import "DBConstants.h"

NSString * const kAWSS3BaseURL = @"https://s3.eu-central-1.amazonaws.com/eachoneteachonebucket";

static NSInteger const kLimit = 20;

@implementation DBQuestion

@dynamic title;
@dynamic questionDescription;
@dynamic attachments;
@dynamic thumbnailName;

+ (NSString *)parseClassName
{
    return @"Question";
}

+ (void) load
{
    [self registerSubclass];
}

#pragma mark - Networking

+ (void)getNewQuestionsWithSkip:(NSInteger)skip completion:(DBGetQuestionsCompletion)completion {
    PFQuery *query = [PFQuery queryWithClassName:[DBQuestion parseClassName]];
    
    query.skip = skip;
    query.limit = kLimit;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *questions, NSError *error) {
        completion(questions, error);
    }];
}

+ (void)uploadQuestionWithTitle:(NSString *)questionTitle questionDesciption:(NSString *)questionDescription dataArray:(NSMutableArray *)dataArray completion:(DBUploadQuestionCompletion)completion {
    
    DBQuestion *question = [DBQuestion object];
    question.title = questionTitle;
    question.questionDescription = questionDescription;
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error == nil) {
            if (dataArray.count != 0) {
                id attachment = dataArray.firstObject;
                if ([attachment conformsToProtocol:@protocol(DBAttachmentProtocol)] && [attachment isKindOfClass:[DBAttachment class]]) {
                    DBAttachment<DBAttachmentProtocol> *questionAttachment = (DBAttachment<DBAttachmentProtocol> *)attachment;
                    NSString *objectThumbnailName = [[question.objectId stringByAppendingString:@"_thumbnail"] stringByAppendingPathExtension:kJPGExtenstion];
                    [DBAttachment uploadFileWithKey:objectThumbnailName data:[questionAttachment thumbnailDataForUpload] mimeType:kJPGExtenstion completion:^(BOOL success, NSError *error) {
                        question.thumbnailName = objectThumbnailName;
                        [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (error == nil) {
                                [DBAttachment uploadAttachments:dataArray toQuestion:question completion:^(BOOL success, NSError *error) {
                                    
                                }];
                            }
                        }];
                    }];
                }
            } else {
                completion(question, error);
            }
            
        } else {
            
        }
    }];
    
}

@end
