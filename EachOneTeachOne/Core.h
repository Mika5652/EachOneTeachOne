//
//  Core.h
//  FastWhisper
//
//  Created by Marek Pohl on 14.07.15.
//  Copyright (c) 2015 iDevBand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef FastWhisper_Core_h
#define FastWhisper_Core_h

#pragma mark - Core

// error
#define DB_ALERT( __message ) \
UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString( @"Error", @"" ) message:__message preferredStyle:UIAlertControllerStyleAlert]; \
UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]; \
[alertController addAction:okAction]; \
[self presentViewController:alertController animated:YES completion:nil];

// success
#define DB_SUCCESS( __message ) \
UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString( @"Success", @"" ) message:__message preferredStyle:UIAlertControllerStyleAlert]; \
UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]; \
[alertController addAction:okAction]; \
[self presentViewController:alertController animated:YES completion:nil];

// localizeable strings
#define L(A) NSLocalizedString(A, nil)

// blocks
#define DK_CALL_BLOCK( __ptr, ... ) { \
if ( __ptr ) { \
__ptr( __VA_ARGS__ ); \
}}

#pragma mark - UIView helper

#define VIEW_CLASS_NAME UIView

#define WHITE_COLOR [UIColor whiteColor]
#define CLEAR_COLOR [UIColor clearColor]

static inline NSDictionary *__TMDictionaryOfVariableBindings( BOOL autoresizingMaskOff, unsigned int count, ... ) {
  if ( count <= 0 ) {
    return nil;
  }
  
  va_list ap;
  va_start( ap, count );
  
  NSString *allNames = va_arg( ap, NSString * );
  NSArray *names = [allNames componentsSeparatedByString:@","];
  
  if ( names.count != count ) {
    return nil;
  }
  
  NSMutableDictionary *result = [@{} mutableCopy];
  id arg;
  for ( unsigned int i = 0 ; i < count ; i ++ ) {
    if ( ( arg = va_arg( ap, id ) ) ) {
      result[ [names[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ] = arg;
      if ( autoresizingMaskOff && [arg isKindOfClass:[VIEW_CLASS_NAME class]] ) {
        [( VIEW_CLASS_NAME * )arg setTranslatesAutoresizingMaskIntoConstraints:NO];
      }
    }
  }
  va_end( ap );
  
  return [result copy];
}

static inline void DBCreateMotionEffect ( UIView *view ) {
  UIInterpolatingMotionEffect *xMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                               type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
  xMotionEffect.minimumRelativeValue = @( -20.0 );
  xMotionEffect.maximumRelativeValue = @( 20.0 );
  
  UIInterpolatingMotionEffect *yMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                               type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
  yMotionEffect.minimumRelativeValue = @( -20.0 );
  yMotionEffect.maximumRelativeValue = @( 20.0 );
  
  UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
  group.motionEffects = @[ xMotionEffect, yMotionEffect ];
  [view addMotionEffect:group];
}

#define TM_NARGS( ... ) TM_NARGS1( __VA_ARGS__, 26, 25 ,24 ,23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 )
#define TM_NARGS1( x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, n, ... ) n

// Tohle makro vytvori slovnik __vB s views a translateAutoresizingMaskIntoConstraints necha na pokoji
#define TMALVariableBindings( ... ) NSDictionary *__vB = __TMDictionaryOfVariableBindings( NO, TM_NARGS( __VA_ARGS__ ), @"" # __VA_ARGS__, __VA_ARGS__ )

// Tohle makro vytvori slovnik __vB s views a translateAutoresizingMaskIntoConstraint nastavi na NO
#define TMALVariableBindingsAMNO( ... ) NSDictionary *__vB = __TMDictionaryOfVariableBindings( YES, TM_NARGS( __VA_ARGS__ ), @"" # __VA_ARGS__, __VA_ARGS__ )

#pragma mark - Visual

#define TMAL_VISUAL( __visual ) \
[NSLayoutConstraint constraintsWithVisualFormat:(__visual) options:0 metrics:nil views:__vB]

#define TMAL_VISUALM( __visual, __metrics ) \
[NSLayoutConstraint constraintsWithVisualFormat:(__visual) options:0 metrics:(__metrics) views:__vB]

#define TMAL_ADD_VISUAL( __view, __visual ) [(__view) addConstraints:TMAL_VISUAL( (__visual) )]
#define TMAL_ADD_VISUALM( __view, __visual, __metrics ) [(__view) addConstraints:TMAL_VISUALM( (__visual), (__metrics) )]

#define TMAL_ADDS_VISUAL( __visual ) TMAL_ADD_VISUAL( self, (__visual) )
#define TMAL_ADDS_VISUALM( __visual, __metrics ) TMAL_ADD_VISUALM( self, (__visual), (__metrics) )

#define TMAL_ADDA_VISUAL( __array, __visual ) [(__array) addObjectsFromArray:TMAL_VISUAL( (__visual) )]
#define TMAL_ADDA_VISUALM( __array, __visual, __metrics ) [(__array) addObjectsFromArray:TMAL_VISUALM( (__visual), (__metrics) )]

#pragma mark - Attributes

#define TMAL_ATTR( __item, __relativeTo, __attr, __relation ) \
[NSLayoutConstraint constraintWithItem:( __item )       \
attribute:( __attr )       \
relatedBy:( __relation )   \
toItem:( __relativeTo ) \
attribute:( __attr )       \
multiplier:1.0              \
constant:0.0]

#define TMAL_ATTRM( __item, __relativeTo, __attr, __relation, __mul ) \
[NSLayoutConstraint constraintWithItem:( __item )       \
attribute:( __attr )       \
relatedBy:( __relation )   \
toItem:( __relativeTo ) \
attribute:( __attr )       \
multiplier:(__mul)              \
constant:0.0]

#define TMAL_ADD_ATTR( __view, __item, __relativeTo, __attr, __relation ) [(__view) addConstraint:TMAL_ATTR( (__item), (__relativeTo), (__attr), (__relation ) )]
#define TMAL_ADDS_ATTR( __item, __relativeTo, __attr, __relation ) TMAL_ADD_ATTR( self, (__item), (__relativeTo), (__attr), (__relation ) )
#define TMAL_ADDA_ATTR( __array, __item, __relativeTo, __attr, __relation ) [(__array) addObject:TMAL_ATTR( (__item), (__relativeTo), (__attr), (__relation ) )]

#define TMAL_ADD_ATTRM( __view, __item, __relativeTo, __attr, __relation, __mul ) \
[(__view) addConstraint:TMAL_ATTRM( (__item), (__relativeTo), (__attr), (__relation ), (__mul) )]

#define TMAL_ADDS_ATTRM( __item, __relativeTo, __attr, __relation, __mul )\
TMAL_ADD_ATTRM( self, (__item), (__relativeTo), (__attr), (__relation ), (__mul ) )

#define TMAL_ADDA_ATTRM( __array, __item, __relativeTo, __attr, __relation, __mul ) \
[(__array) addObject:TMAL_ATTRM( (__item), (__relativeTo), (__attr), (__relation ), (__mul) )]

#pragma mark - Centering

#define TMAL_CENTERX( __item, __relativeTo ) TMAL_ATTR( (__item), (__relativeTo), NSLayoutAttributeCenterX, NSLayoutRelationEqual )
#define TMAL_ADD_CENTERX( __view, __item, __relativeTo ) [(__view) addConstraint:TMAL_CENTERX( (__item), (__relativeTo) )]
#define TMAL_ADDS_CENTERX( __item, __relativeTo) TMAL_ADD_CENTERX( self, (__item), (__relativeTo) )
#define TMAL_ADDA_CENTERX( __array, __item, __relativeTo ) [(__array) addObject:TMAL_CENTERX( (__item), (__relativeTo) )]

#define TMAL_CENTERY( __item, __relativeTo ) TMAL_ATTR( (__item), (__relativeTo), NSLayoutAttributeCenterY, NSLayoutRelationEqual )
#define TMAL_ADD_CENTERY( __view, __item, __relativeTo ) [(__view) addConstraint:TMAL_CENTERY( (__item), (__relativeTo) )]
#define TMAL_ADDS_CENTERY( __item, __relativeTo) TMAL_ADD_CENTERY( self, (__item), (__relativeTo) )
#define TMAL_ADDA_CENTERY( __array, __item, __relativeTo ) [(__array) addObject:TMAL_CENTERY( (__item), (__relativeTo) )]

#define TMAL_ADD_CENTERX_WITH_WIDTH( __view, __item, __relativeTo, __width ) { \
[(__view) addConstraint:TMAL_CENTERX( (__item), (__relativeTo) )]; \
[(__view) addConstraint:[NSLayoutConstraint constraintWithItem:__item \
attribute:NSLayoutAttributeWidth \
relatedBy:NSLayoutRelationEqual \
toItem:nil \
attribute:NSLayoutAttributeNotAnAttribute \
multiplier:1.0 \
constant:__width]]; \
}

#define TMAL_ADDS_CENTERX_WITH_WIDTH( __item, __relativeTo, __width ) { \
[self addConstraint:TMAL_CENTERX( (__item), (__relativeTo) )]; \
[self addConstraint:[NSLayoutConstraint constraintWithItem:__item \
attribute:NSLayoutAttributeWidth \
relatedBy:NSLayoutRelationEqual \
toItem:nil \
attribute:NSLayoutAttributeNotAnAttribute \
multiplier:1.0 \
constant:__width]]; \
}

#define TMAL_ADD_CENTERY_WITH_HEIGHT( __view, __item, __relativeTo, __width ) { \
[(__view) addConstraint:TMAL_CENTERY( (__item), (__relativeTo) )]; \
[(__view) addConstraint:[NSLayoutConstraint constraintWithItem:__item \
attribute:NSLayoutAttributeHeight \
relatedBy:NSLayoutRelationEqual \
toItem:nil \
attribute:NSLayoutAttributeNotAnAttribute \
multiplier:1.0 \
constant:__width]]; \
}

#define TMAL_ADDS_CENTERY_WITH_HEIGHT( __item, __relativeTo, __width ) { \
[self addConstraint:TMAL_CENTERY( (__item), (__relativeTo) )]; \
[self addConstraint:[NSLayoutConstraint constraintWithItem:__item \
attribute:NSLayoutAttributeHeight\
relatedBy:NSLayoutRelationEqual \
toItem:nil \
attribute:NSLayoutAttributeNotAnAttribute \
multiplier:1.0 \
constant:__width]]; \
}

#endif
