//
//  MGUHexagonalWallpaperView.h
//  MGRRegularPolygon
//
//  Created by Kwan Hyun Son on 16/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IosKit/MGUHexagonalInfo.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface MGUHexagonalWallpaperView : UIView

@property (nonatomic, strong) IBInspectable UIColor *mainColor;
@property (nonatomic, strong) IBInspectable UIColor *subColor;
@property (nonatomic, strong) IBInspectable UIColor *lineColor; // backgroundColor의 @dynamic
@property (nonatomic, assign) IBInspectable CGFloat radius;          // 구조를 그리는데 필요한 반경
@property (nonatomic, assign) IBInspectable CGFloat showRadiusRatio; // 배치된 상태에서 작게 만들기 위해. 디폴트 1.0, 0.0 ~ 1.0

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger direction;
#else
@property (nonatomic, assign) MGUHexagonalOrderDirection direction;
#endif

@property (nonatomic, assign) IBInspectable BOOL useFocusRandomColor; // 디폴트 YES

@property (nonatomic, assign) IBInspectable BOOL useHsbMode; // 디폴트 NO
@property (nonatomic, strong) NSArray <NSNumber *>*hsbRange; // 디폴트 {0.1, 0.1, 0.1} 알파는 조절안함. 반경을 의미한다.
//! {0.0, 0.0, 0.1} 추천한다.

@property (nonatomic, assign) CGFloat progress;
- (CABasicAnimation *)hexagonalProgressAnimation;


- (instancetype)initWithMainColor:(UIColor *)mainColor
                           radius:(CGFloat)radius
                        direction:(MGUHexagonalOrderDirection)direction;
@end

NS_ASSUME_NONNULL_END
