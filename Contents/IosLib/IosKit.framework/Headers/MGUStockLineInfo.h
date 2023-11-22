//
//  MGUStockLineInfo.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-10-22
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUStockLine;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGUStockLineFillMode) {
    MGUStockLineFillModeShape = 0,
    MGUStockLineFillModeBar
} NS_ENUM_AVAILABLE_IOS(10_0);

@interface MGUStockLineInfo : NSObject

@property (nonatomic, strong) NSArray <MGUStockLine *>*curveLines;
@property (nonatomic, strong) NSArray <MGUStockLine *>*straightLines;

@end

//! 내부 클래스. 각 MGUStockLine에 대한 정보.
@interface MGUStockLine : NSObject

@property (nonatomic, assign, getter=isHidden) BOOL hidden;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong, nullable) UIColor *peakLineColor;
@property (nonatomic, strong, nullable) UIColor *valleyLineColor;
@property (nonatomic, strong) UIColor *peakFillColor;
@property (nonatomic, strong) UIColor *valleyFillColor;
@property (nonatomic, assign) MGUStockLineFillMode fillMode; // 디폴트 MGUStockLineFillModeShape

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) NSArray <NSNumber *>*lineDashes;

@end

NS_ASSUME_NONNULL_END
