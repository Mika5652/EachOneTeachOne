//
//  DBQuestionPhotoAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionAttachment.h"

@interface DBQuestionPhotoAttachment : DBQuestionAttachment <DBQuestionAttachmentProtocol>

@property (nonatomic) UIImage *photoImage;

@end
