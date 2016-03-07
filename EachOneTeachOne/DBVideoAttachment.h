//
//  DBQuestionVideoAttachment.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 26/02/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "DBAttachment.h"

@interface DBVideoAttachment : DBAttachment <DBAttachmentProtocol>

@property (nonatomic) NSURL *videoURL;

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end
