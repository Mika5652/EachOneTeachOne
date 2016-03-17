//
//  DBVideoPlayerButton.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 14/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBVideoPlayerButton : UIView

@property NSString *videoURLSFromS3;
@property NSURL *videoURL;

- (instancetype)initWithVideoURLFromS3:(NSString *)videoURLSFromS3;
- (instancetype)initWithLocalVideoURL:(NSURL *)videoURL;

@end
