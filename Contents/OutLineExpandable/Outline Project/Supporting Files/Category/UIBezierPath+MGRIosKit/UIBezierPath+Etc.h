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
@end

NS_ASSUME_NONNULL_END
