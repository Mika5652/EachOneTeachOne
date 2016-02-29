//
//  DBNetworkingManager.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBQuestion.h"

extern NSString * const kAWSS3BaseURL;

@interface DBNetworkingManager : NSObject

+ (void)uploadManager:(DBQuestion *)question data:(NSData *)data mimeType:(NSString *)mimeType;

@end
