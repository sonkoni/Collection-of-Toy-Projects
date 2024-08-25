//
//  ConfigChartTypeViewModel.h
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/08/31.
//

#import <UIKit/UIKit.h>
@class DTOLineSetting;
@class LineSettingViewModel;

NS_ASSUME_NONNULL_BEGIN

// 스위프트 버전은 아래에 존재함
typedef NSString * ToolSettingLineType NS_TYPED_ENUM;
static ToolSettingLineType const ToolSettingLineTypeBaseline                     = @"기준선";
static ToolSettingLineType const ToolSettingLineTypeDeleteAllTrendlines          = @"추세선 모두 삭제";
static ToolSettingLineType const ToolSettingLineTypeDeleteTrendline              = @"추세선 삭제";
static ToolSettingLineType const ToolSettingLineTypeStraightTrendline            = @"직선추세선"; //
static ToolSettingLineType const ToolSettingLineTypeHorizontalLine               = @"수평선"; //
static ToolSettingLineType const ToolSettingLineTypeVerticalLine                 = @"수직선"; //
static ToolSettingLineType const ToolSettingLineTypeCrossLine                    = @"십자선"; //
static ToolSettingLineType const ToolSettingLineTypeDiagonalLine                 = @"대각선"; //
static ToolSettingLineType const ToolSettingLineTypeAngleLine                    = @"각도선"; //
static ToolSettingLineType const ToolSettingLineTypePriceDifference              = @"가격-차이"; //
static ToolSettingLineType const ToolSettingLineTypePriceChangeLine              = @"가격-변화선"; //
static ToolSettingLineType const ToolSettingLineTypeFibonacciArc                 = @"피보나치-아크"; //
static ToolSettingLineType const ToolSettingLineTypeFibonacciFan                 = @"피보나치-팬"; //
static ToolSettingLineType const ToolSettingLineTypeFibonacciRetracement         = @"피보나치-수평조정대"; //
static ToolSettingLineType const ToolSettingLineTypeFibonacciTimezone            = @"피보나치-시간간격"; //
static ToolSettingLineType const ToolSettingLineTypeFibonacciTarget              = @"피보나치-목표치"; //
static ToolSettingLineType const ToolSettingLineTypeAndrewsPitchfork             = @"앤드류피치포크"; //
static ToolSettingLineType const ToolSettingLineTypeCycleRange                   = @"사이클구간"; //
static ToolSettingLineType const ToolSettingLineTypeGannLine                     = @"갠-라인"; //
static ToolSettingLineType const ToolSettingLineTypeGannFan                      = @"갠-팬"; //
static ToolSettingLineType const ToolSettingLineTypeGannRetracement              = @"갠-조정대"; //
static ToolSettingLineType const ToolSettingLineTypeAccelerationResistanceLine   = @"가속저항-호"; //
static ToolSettingLineType const ToolSettingLineTypeAccelerationResistanceFan    = @"가속저항-팬"; //
static ToolSettingLineType const ToolSettingLineTypeShapeRectangle               = @"도형-사각형"; //
static ToolSettingLineType const ToolSettingLineTypeShapeEllipse                 = @"도형-타원"; //
static ToolSettingLineType const ToolSettingLineTypeShapeTriangle                = @"도형-삼각형"; //
static ToolSettingLineType const ToolSettingLineTypeText                         = @"텍스트"; //
static ToolSettingLineType const ToolSettingLineTypeSymbol                       = @"심볼"; //
static ToolSettingLineType const ToolSettingLineTypeElliottWave                  = @"엘리엇파동"; //
static ToolSettingLineType const ToolSettingLineTypeStatisticalRegressionLine    = @"통계-직선회귀선"; //
static ToolSettingLineType const ToolSettingLineTypeStatisticalRegressionChannel = @"통계-직선회귀채널"; //
static ToolSettingLineType const ToolSettingLineTypeBisectorLine                 = @"사등분선"; //
static ToolSettingLineType const ToolSettingLineTypeTrisectorLine                = @"삼등분선"; //
static ToolSettingLineType const ToolSettingLineTypeCandleLine                   = @"캔들라인"; //
static ToolSettingLineType const ToolSettingLineTypeAutomaticTrendline           = @"자동추세선"; //
static ToolSettingLineType const ToolSettingLineTypeConversionLine               = @"전환선"; //
static ToolSettingLineType const ToolSettingLineTypeTargetENV                    = @"목표치-ENV"; //
static ToolSettingLineType const ToolSettingLineTypeTargetNT                     = @"목표치-NT"; //

NSMutableArray <ToolSettingLineType>*defaultAllToolSettingLineType(void);

@interface ToolSettingViewModel : NSObject

@property (nonatomic, strong) NSMutableArray <ToolSettingLineType>*lineTypes;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (ToolSettingLineType)chartLineTypeForIndexPath:(NSIndexPath *)indexPath;
- (LineSettingViewModel *)lineSettingViewModelForIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
