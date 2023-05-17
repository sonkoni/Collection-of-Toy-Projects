//
//  UIBezierPath+Etc.h
//
//  Created by Kwan Hyun Son on 2021/08/26.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (Etc)

/**
 * @brief CGPathCreateCopyByStrokingPath(...) 함수의 UIBezierPath 버전
 * @param transform NULL을 넣을 수도 있다. 보통 NULL 인듯.
 * @discussion 선을 면으로 바꾸어서 선으로 반환한다.
 * @remark self의 lineWidth, lineCapStyle, lineJoinStyle, miterLimit를 이용하므로 설정을 미리해둬야한다.
 * @code
    UIBezierPath *shadowPath = path.copy;
    shadowPath.lineWidth = self.lineWidth;
    shadowPath.lineCapStyle = kCGLineCapRound;
    shadowPath.lineJoinStyle = kCGLineJoinRound;
    shadowPath.miterLimit = 0.0; // 보통 0.0인듯.
 
    shadowPath = [shadowPath mgrCreateCopyByStrokingPath:NULL];
    shadowPath = [shadowPath mgrCreateCopyByStrokingPath:&CGAffineTransformIdentity]; <- 이런식도 가능.
 
 * @endcode
 * @return 선을 면으로 바꾸어서 그 면을 둘러싼 선을 반화한다.
*/
- (UIBezierPath *)mgrCreateCopyByStrokingPath:(const CGAffineTransform * _Nullable)transform;

/**
 * @brief + bezierPathWithRoundedRect:cornerRadius: + bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:의 장점을 모아서 만들었다.
 * @param rect 그려야할 rect
 * @param corners 어느 코너를 그릴 것인가에 대한 '옵션'
 * @param cornerRadius 코너 라디어스
 * @discussion 기본 메서드가 지랄 같은 버그가 존재해서 내가 만들었다. 가로 세로 중 작은 길이의 1/2가 되지 않았는되도 그냥 반으로 라디어스를 때리는 버그가 존재함.
 * @remark 애플 기본메서드가 버그가 존재하여 만들었다.
 * @code
    UIBezierPath *path = [UIBezierPath mgrBezierPathWithRoundedRect:rect
                                                  byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                       cornerRadius:15.0];
 
 * @endcode
 * @return 원하는 방향에 주어진 라디어스를 적용한 Rounded Rect Path를 반환한다.
*/
+ (instancetype)mgrBezierPathWithRoundedRect:(CGRect)rect
                           byRoundingCorners:(UIRectCorner)corners
                                cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
