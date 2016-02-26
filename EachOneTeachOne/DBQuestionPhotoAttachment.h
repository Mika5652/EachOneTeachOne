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

@interface DBQuestionPhotoAttachment : NSObject

@property UIImage *photo;
@property NSString *mimeType;

@end
