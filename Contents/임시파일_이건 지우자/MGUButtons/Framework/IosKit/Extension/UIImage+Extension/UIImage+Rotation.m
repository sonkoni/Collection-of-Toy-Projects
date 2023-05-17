//
//  UIImage+Rotation.m
//
//  Created by Kwan Hyun Son on 2021/09/06.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UIImage+Rotation.h"
#import "UIImage+ResizeColor.h"

@implementation UIImage (Rotation)

- (UIImage *)mgrImageRotatedByRadians:(CGFloat)radians {
    UIImage *cropAlphaImage = [self mgrCropAlpha]; // 이렇게 해줘야 정확한 크기(여분의 알파)가 포함되지 않는다.
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0, cropAlphaImage.size.width, cropAlphaImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    
    CGSize rotatedSize = rotatedViewBox.frame.size;
//    CGSize rotatedSize = CGRectIntegral(rotatedViewBox.frame).size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);

    CGContextRotateCTM(bitmap, radians);

    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGRect drawRect =
    CGRectMake(-cropAlphaImage.size.width / 2.0, -cropAlphaImage.size.height / 2.0 , cropAlphaImage.size.width, cropAlphaImage.size.height);
    CGContextDrawImage(bitmap, drawRect, cropAlphaImage.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    newImage = [newImage mgrCropAlpha];
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)mgrImageWithOrientation:(UIImageOrientation)imageOrientation {
    UIImage *image = [[UIImage alloc] initWithCGImage:self.CGImage scale:self.scale orientation:imageOrientation];
    return image;
}

@end
