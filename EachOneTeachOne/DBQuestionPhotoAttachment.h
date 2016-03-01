//
//  DBQuestionPhotoAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const kMimeTypeImageJPG;
extern NSString * const kJPGExtenstion;

@interface DBQuestionPhotoAttachment : NSObject

@property (nonatomic) UIImage *photoImage;
@property NSString *mimeType;
@property (nonatomic) UIImage *thumbnailImage;

@end
