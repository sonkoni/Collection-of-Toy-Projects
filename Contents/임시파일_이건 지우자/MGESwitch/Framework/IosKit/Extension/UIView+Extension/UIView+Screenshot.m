//
//  UIView+Screenshot.m
//  NavigationStackDemo_koni
//
//  Created by Kwan Hyun Son on 28/11/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *)mgrScreenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale); // 스케일을 맞추지 않으면, 흐리게 나온다.
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//! 스크린샷이 찍혀지는 self(뷰)에서 일정부분을 잘라서 사용할 때 이용한다.
- (UIImage *)mgrScreenshotWithInsideFrame:(CGRect)insideFrame {
    CGFloat scale = UIScreen.mainScreen.scale;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 여기까지는 풀사이즈.
    CGRect rect = insideFrame;
    rect = CGRectMake(rect.origin.x *scale, rect.origin.y *scale, rect.size.width *scale, rect.size.height *scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

- (UIImageView *)mgrRenderSnapshot {
    CGFloat shadowOpacity = self.layer.shadowOpacity;
    self.layer.shadowOpacity = 0.0; // bounds에서 shadow 비트를 캡처하지 마라.

    UIGraphicsImageRenderer *graphicsImageRenderer = [[UIGraphicsImageRenderer alloc] initWithBounds:self.bounds];
    UIImage *image = [graphicsImageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [self.layer renderInContext:rendererContext.CGContext];
    }];

    UIImageView *snapshot = [[UIImageView alloc] initWithImage:image];
    self.layer.shadowOpacity =  shadowOpacity;
    
    CGPathRef shadowPath = self.layer.shadowPath;
//    if (shadowPath != NULL) {
//        snapshot.layer.shadowPath = shadowPath;
//        snapshot.layer.shadowColor = self.layer.shadowColor;
//        snapshot.layer.shadowOffset = self.layer.shadowOffset;
//        snapshot.layer.shadowRadius = self.layer.shadowRadius;
//        snapshot.layer.shadowOpacity = self.layer.shadowOpacity;
//    }
    snapshot.layer.shadowPath = shadowPath;
    snapshot.layer.shadowColor = self.layer.shadowColor;
    snapshot.layer.shadowOffset = self.layer.shadowOffset;
    snapshot.layer.shadowRadius = self.layer.shadowRadius;
    snapshot.layer.shadowOpacity = self.layer.shadowOpacity;
    
    return snapshot;
}

- (CALayer *)mgrRenderSnapshotLayer {
    CGFloat shadowOpacity = self.layer.shadowOpacity;
    self.layer.shadowOpacity = 0.0; // bounds에서 shadow 비트를 캡처하지 마라.

    UIGraphicsImageRenderer *graphicsImageRenderer = [[UIGraphicsImageRenderer alloc] initWithBounds:self.bounds];
    UIImage *image = [graphicsImageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [self.layer renderInContext:rendererContext.CGContext];
    }];
    
    CALayer *snapshotLayer = [CALayer layer];
    snapshotLayer.contents = (__bridge id)(image.CGImage);
    self.layer.shadowOpacity =  shadowOpacity;
    
    snapshotLayer.shadowPath = self.layer.shadowPath;
    snapshotLayer.shadowColor = self.layer.shadowColor;
    snapshotLayer.shadowOffset = self.layer.shadowOffset;
    snapshotLayer.shadowRadius = self.layer.shadowRadius;
    snapshotLayer.shadowOpacity = self.layer.shadowOpacity;
    return snapshotLayer;
}

+ (UIImageView *)mgrDefaultSliderKnob:(CGFloat)size {
    CGFloat length = 28.0;
    if (size > 0.0) {
        length = size;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, length, length)];
    view.layer.backgroundColor = UIColor.whiteColor.CGColor;
    view.layer.cornerRadius = length / 2.0;
    view.layer.shadowColor = UIColor.blackColor.CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0, 2.5f);
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowOpacity = 0.25;
    view.layer.borderColor = [UIColor.blackColor colorWithAlphaComponent:0.25].CGColor;
    view.layer.borderWidth = 0.5f;
    return [view mgrRenderSnapshot];
}

@end
