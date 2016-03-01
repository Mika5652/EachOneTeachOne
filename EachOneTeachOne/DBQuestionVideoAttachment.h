//
//  DBQuestionVideoAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const kMimeTypeVideoMOV;
extern NSString * const kMOVExtenstion;

@interface DBQuestionVideoAttachment : NSObject

@property NSURL *videoURL;
@property NSString *mimeType;
@property (nonatomic) UIImage *thumbnailImage;

@end
