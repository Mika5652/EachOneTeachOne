//
//  DBQuestionPhotoAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAttachment.h"

@interface DBPhotoAttachment : DBAttachment <DBAttachmentProtocol>

@property (nonatomic) UIImage *photoImage;

@end
