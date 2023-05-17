//
//  CALayer+Image.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "CALayer+Image.h"

@implementation CALayer (Image)

#if TARGET_OS_OSX
- (void)mgrUpdateLayerWithImage:(NSImage *)image
                contentsGravity:(CALayerContentsGravity)contentsGravity
                       inWindow:(NSWindow *)window {
    CGFloat desiredScaleFactor = window.backingScaleFactor;
    CGFloat actualScaleFactor = [image recommendedLayerContentsScale:desiredScaleFactor];
    id layerContents = [image layerContentsForContentsScale:actualScaleFactor];
    self.contentsGravity = contentsGravity;
    self.contents = layerContents;
    self.contentsScale = actualScaleFactor;
}

#elif TARGET_OS_IPHONE
- (void)mgrUpdateLayerWithImage:(UIImage *)image contentsGravity:(CALayerContentsGravity)contentsGravity {
    self.contentsScale = [UIScreen mainScreen].scale;
    self.contentsGravity = contentsGravity;
    self.contents = (__bridge id)(image.CGImage);
}
#endif

@end

