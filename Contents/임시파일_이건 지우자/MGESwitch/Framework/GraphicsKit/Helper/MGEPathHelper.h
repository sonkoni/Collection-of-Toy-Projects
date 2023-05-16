//
//  MGRXXX.h
//  MGRGradientProject
//
//  Created by Kwan Hyun Son on 2022/11/16.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//


#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

CGPathRef _Nullable MGECGPathGetPath(MGEBezierPath *path);
// CFAutorelease된 결과 값을 반환한다. 저장하려면. CGPathRetain(...)

CGPathRef _Nullable MGECGPathCreateWithRect(CGRect rect, CACornerMask corners, CGFloat cornerRadius);
NS_ASSUME_NONNULL_END
