//
//  DBCreateFeedViewController.h
//  EachOneTeachOne
//
//  Created by Michael Pohl on 19.01.16.
//  Copyright © 2016 Michael Pohl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@class DBCreateFeedView;

@interface DBCreateFeedViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (readonly) DBCreateFeedView* createFeedView;

@property UIImagePickerController *picker;

- (IBAction)captureVideo:(id)sender;

@end
