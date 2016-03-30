//
//  DBQuestion.m
//  EachOneTeachOne
//
//  Created by Michael Pohl on 27.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestion.h"
#import "DBAttachment.h"

NSString * const kAWSS3BaseURL = @"https://s3.eu-central-1.amazonaws.com/eachoneteachonebucket";

static NSInteger const kLimit = 2;

@implementation DBQuestion

@dynamic title;
@dynamic questionDescription;
@dynamic attachments;
@dynamic answers;
@dynamic thumbnail;

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
    [query includeKey:@"attachments"];
    [query includeKey:@"answers"];
    [query includeKey:@"answers.attachments"];
    [query includeKey:@"answers.comments"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *questions, NSError *error) {
        completion(questions, error);
    }];
}

+ (void)uploadQuestionWithTitle:(NSString *)questionTitle questionDesciption:(NSString *)questionDescription dataArray:(NSMutableArray *)dataArray completion:(DBUploadQuestionCompletion)completion {
    
    DBQuestion *question = [DBQuestion object];
    question.title = questionTitle;
    question.questionDescription = questionDescription;
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error && succeeded) {
            if (dataArray.count != 0) {
                id attachment = dataArray.firstObject;
                if ([attachment isKindOfClass:[DBAttachment class]]) {
                    DBAttachment *questionAttachment = (DBAttachment *)attachment;
                    question.thumbnail = [PFFile fileWithData:[questionAttachment thumbnailDataForUpload]];
                    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (!error) {
                            [DBAttachment uploadAttachments:dataArray toQuestion:question completion:^(BOOL success, NSError *error) {
                                completion(question, error);
                            }];
                        }
                    }];
                    /*
                    [DBAttachment uploadFileWithKey:questionThumbnailName data:[questionAttachment thumbnailDataForUpload] mimeType:kJPGExtenstion completion:^(BOOL success, NSError *error) {
                        if (!error) {
                            question.thumbnail = [PFFile fileWithName:questionThumbnailName data:[questionAttachment thumbnailDataForUpload]];
                            question.thumbnailName = questionThumbnailName;
                            [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                if (!error) {
                                    [DBAttachment uploadAttachments:dataArray toQuestion:question completion:^(BOOL success, NSError *error) {
                                        completion(question, error);
                                    }];
                                }
                            }];
                        } else {
                            completion(question, error);
                        }
                    }];
                    */
                } else {
                    completion(question, [NSError errorWithDomain:@"Unexpected object type in question attachments" code:0 userInfo:nil]);
                }
            } else {
                completion(question, error);
            }
        } else {
            completion(question, [NSError errorWithDomain:@"Error during uploading question to Parse" code:0 userInfo:nil]);
        }
    }];
    
}

@end
