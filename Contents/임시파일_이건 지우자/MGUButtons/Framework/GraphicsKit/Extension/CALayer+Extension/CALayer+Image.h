//
//  CALayer+Image.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-13
//  ----------------------------------------------------------------------
//
// https://developer.apple.com/documentation/appkit/nsimage?language=objc
// https://stackoverflow.com/questions/23002653/nsimageview-image-aspect-fill
// http://wiki.mulgrim.net/page/Api:Core_Animation/CALayer/contents
// http://wiki.mulgrim.net/page/Api:Core_Animation/CALayerContentsGravity
// http://wiki.mulgrim.net/page/Api:UIKit/UIView/UIViewContentMode

#import <QuartzCore/QuartzCore.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Image)

#if TARGET_OS_OSX
- (void)mgrUpdateLayerWithImage:(NSImage *)image
                contentsGravity:(CALayerContentsGravity)contentsGravity // contentmode
                       inWindow:(NSWindow *)window;
#elif TARGET_OS_IPHONE
- (void)mgrUpdateLayerWithImage:(UIImage *)image contentsGravity:(CALayerContentsGravity)contentsGravity;
#endif

@end

NS_ASSUME_NONNULL_END

/* ----------------------------------------------------------------------
 * 2022-10-13 : 라이브러리 정리됨
 */
