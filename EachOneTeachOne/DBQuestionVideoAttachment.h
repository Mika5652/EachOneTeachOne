//
//  DBQuestionVideoAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBQuestionAttachment.h"

@interface DBQuestionVideoAttachment : DBQuestionAttachment <DBQuestionAttachmentProtocol>

@property (nonatomic) NSURL *videoURL;

@end
