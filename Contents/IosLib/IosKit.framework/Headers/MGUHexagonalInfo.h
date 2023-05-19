//
//  MGUHexagonalInfo.h
//  MGRRegularPolygon
//
//  Created by Kwan Hyun Son on 16/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUHexagonal;

typedef NS_ENUM(NSInteger, MGUHexagonalOrderDirection) {
    MGUHexagonalOrderDirectionCenter = 1, // 0은 피하는 것이 좋다.
    
    MGUHexagonalOrderDirectionNorth,
    MGUHexagonalOrderDirectionEast,
    MGUHexagonalOrderDirectionSouth,
    MGUHexagonalOrderDirectionWest,
    
    MGUHexagonalOrderDirectionNorthWest,
    MGUHexagonalOrderDirectionNorthEast,
    MGUHexagonalOrderDirectionSouthWest,
    MGUHexagonalOrderDirectionSouthEast
};

NS_ASSUME_NONNULL_BEGIN

@interface MGUHexagonalInfo : NSObject

@property (nonatomic, assign) MGUHexagonalOrderDirection direction;
@property (nonatomic, strong) NSArray <MGUHexagonal *>*orderItems;
@property (nonatomic, assign) BOOL useFocusRandomColor;

- (instancetype)initWithSize:(CGSize)size
                      radius:(CGFloat)radius
                   mainColor:(UIColor *)mainColor
                    subColor:(UIColor *)subColor NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end


//! 내부 클래스. 각 Hexagonal에 대한 정보.
@interface MGUHexagonal : NSObject
@property (nonatomic, assign) CGFloat delay; // 디폴트 0.0
@property (nonatomic, assign) CGFloat progress; // 디폴트 0.0 / 0.0 ~ 1.0
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong, readonly) UIColor *color; // 작은 육각형 하나의 색
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign, readonly) CGPoint currentCenter;

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
