//
//  UIImage+DBResizing.m
//  EachOneTeachOne
//
//  Created by Vojtěch Czepiec on 01/03/16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import "UIImage+DBResizing.h"

@implementation UIImage (DBResizing)

- (UIImage *)photoResizedToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
