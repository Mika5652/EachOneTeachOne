//
//  DBVideoPlayerButton.h
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 14/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBVideoPlayerButton : UIView

@property NSString *videoURL;

- (instancetype)initWithVideoURLString:(NSString *)videoURL;

@end
