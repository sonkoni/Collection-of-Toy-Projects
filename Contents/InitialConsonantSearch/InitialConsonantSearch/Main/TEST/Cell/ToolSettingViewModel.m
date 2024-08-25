//
//  ConfigChartTypeViewModel.m
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/08/31.
//

#import "ToolSettingViewModel.h"
#import "LineSettingViewModel.h"

@interface ToolSettingViewModel ()
@property (nonatomic, strong) NSMutableArray <LineSettingViewModel *>*testArr; // lazy 저장 메커니즘 확인..
@end

@implementation ToolSettingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

#pragma mark - 생성 & 소멸

static void CommonInit(ToolSettingViewModel *self) {
    [self setupChartTypeSceneData];
}

- (void)setupChartTypeSceneData {
    self.lineTypes = defaultAllToolSettingLineType();
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.lineTypes.count;
}

- (ToolSettingLineType)chartLineTypeForIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    return self.lineTypes[row];
}


// TODO: - 저장 메커니즘 확인을 위해. 잠시 잠군다.
/*
- (LineSettingViewModel *)lineSettingViewModelForIndexPath:(NSIndexPath *)indexPath {
    ToolSettingLineType selectedLineType = self.lineTypes[indexPath.row];
    return [[LineSettingViewModel alloc] initWithLineType:selectedLineType];
}
*/

#pragma mark - DEBUG

// TODO: - 저장 메커니즘 확인을 위해 임시로 사용한다.
- (LineSettingViewModel *)lineSettingViewModelForIndexPath:(NSIndexPath *)indexPath {
    return self.testArr[indexPath.row];
}

- (NSMutableArray <LineSettingViewModel *>*)testArr {
    if (_testArr == nil) {
        NSMutableArray <LineSettingViewModel *>*arr = @[].mutableCopy;
        for (NSInteger i = 0; i < self.lineTypes.count; i++) {
            ToolSettingLineType selectedLineType = self.lineTypes[i];
            if (i < 3) {
                [arr addObject:@(0)];
            } else {
                LineSettingViewModel *model = [[LineSettingViewModel alloc] initWithLineType:selectedLineType];
                [arr addObject:model];
            }
            
        }
        _testArr = arr;
    }
    return _testArr;
}

@end

NSMutableArray <ToolSettingLineType>*defaultAllToolSettingLineType(void) {
    return @[ToolSettingLineTypeBaseline,
             ToolSettingLineTypeDeleteAllTrendlines,
             ToolSettingLineTypeDeleteTrendline,
             ToolSettingLineTypeStraightTrendline,
             ToolSettingLineTypeHorizontalLine,
             ToolSettingLineTypeVerticalLine,
             ToolSettingLineTypeCrossLine,
             ToolSettingLineTypeDiagonalLine,
             ToolSettingLineTypeAngleLine,
             ToolSettingLineTypePriceDifference,
             ToolSettingLineTypePriceChangeLine,
             ToolSettingLineTypeFibonacciArc,
             ToolSettingLineTypeFibonacciFan,
             ToolSettingLineTypeFibonacciRetracement,
             ToolSettingLineTypeFibonacciTimezone,
             ToolSettingLineTypeFibonacciTarget,
             ToolSettingLineTypeAndrewsPitchfork,
             ToolSettingLineTypeCycleRange,
             ToolSettingLineTypeGannLine,
             ToolSettingLineTypeGannFan,
             ToolSettingLineTypeGannRetracement,
             ToolSettingLineTypeAccelerationResistanceLine,
             ToolSettingLineTypeAccelerationResistanceFan,
             ToolSettingLineTypeShapeRectangle,
             ToolSettingLineTypeShapeEllipse,
             ToolSettingLineTypeShapeTriangle,
             ToolSettingLineTypeText,
             ToolSettingLineTypeSymbol,
             ToolSettingLineTypeElliottWave,
             ToolSettingLineTypeStatisticalRegressionLine,
             ToolSettingLineTypeStatisticalRegressionChannel,
             ToolSettingLineTypeBisectorLine,
             ToolSettingLineTypeTrisectorLine,
             ToolSettingLineTypeCandleLine,
             ToolSettingLineTypeAutomaticTrendline,
             ToolSettingLineTypeConversionLine,
             ToolSettingLineTypeTargetENV,
             ToolSettingLineTypeTargetNT].mutableCopy;
}
