//
//  ConfigChartTypeViewModel.m
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/08/31.
//

#import "LineSettingViewModel.h"

@interface LineSettingViewModel ()
@property (nonatomic, strong) NSMutableArray <DTOLineSetting *>*basicSettings;
@property (nonatomic, strong) NSMutableArray <DTOLineSetting *>*detailSettings;
@property (nonatomic, strong, readonly) NSArray <NSNumber *>*requiredIndexesInBasicSettings; // @dynamic
@end

@implementation LineSettingViewModel
@dynamic requiredIndexesInBasicSettings;
@dynamic mainTitle;

#pragma mark - 생성 & 소멸

- (instancetype)initWithLineType:(ToolSettingLineType)lineType {
    self = [super init];
    if (self) {
        _lineType = lineType;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _sectionTitles = @[@"기본설정", @"세부설정"];
    _basicSettings = @[].mutableCopy;
    _detailSettings = @[].mutableCopy;
    [self setupBasicSettings];
    [self setupDetailSettings];
}

- (void)setupBasicSettings {
    DTOLineSetting *set0 = [[DTOLineSetting alloc] initWithTitle:@"선 색상/굵기" identifier:LineSettingCellIDColorDrop];
    
    DTOLineSetting *set1 = [[DTOLineSetting alloc] initWithTitle:@"가격표시" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set2 = [[DTOLineSetting alloc] initWithTitle:@"각도(숫자로 표시)" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set3 = [[DTOLineSetting alloc] initWithTitle:@"값" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set4 = [[DTOLineSetting alloc] initWithTitle:@"거래량정보" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set5 = [[DTOLineSetting alloc] initWithTitle:@"대등수치" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set6 = [[DTOLineSetting alloc] initWithTitle:@"목표치" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set7 = [[DTOLineSetting alloc] initWithTitle:@"수치표시" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set8 = [[DTOLineSetting alloc] initWithTitle:@"우측가격" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set9 = [[DTOLineSetting alloc] initWithTitle:@"우측연장" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set10 = [[DTOLineSetting alloc] initWithTitle:@"일시" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set11 = [[DTOLineSetting alloc] initWithTitle:@"일자표시" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set12 = [[DTOLineSetting alloc] initWithTitle:@"일시표시" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set13 = [[DTOLineSetting alloc] initWithTitle:@"전체영역" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set14 = [[DTOLineSetting alloc] initWithTitle:@"전환가격" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set15 = [[DTOLineSetting alloc] initWithTitle:@"좌측가격" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set16 = [[DTOLineSetting alloc] initWithTitle:@"좌측비율" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set17 = [[DTOLineSetting alloc] initWithTitle:@"좌측연장" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set18 = [[DTOLineSetting alloc] initWithTitle:@"특정일 라인 표시" identifier:LineSettingCellIDToggle];
    DTOLineSetting *set19 = [[DTOLineSetting alloc] initWithTitle:@"H/L비율" identifier:LineSettingCellIDToggle];
    
    DTOLineSetting *set20 = [[DTOLineSetting alloc] initWithTitle:@"비율" identifier:LineSettingCellIDTextInput];
    
    DTOLineSetting *set21 = [[DTOLineSetting alloc] initWithTitle:@"각도" identifier:LineSettingCellIDDrop];
    DTOLineSetting *set22 = [[DTOLineSetting alloc] initWithTitle:@"스타일" identifier:LineSettingCellIDDrop];
    DTOLineSetting *set23 = [[DTOLineSetting alloc] initWithTitle:@"크기" identifier:LineSettingCellIDDrop];
    
    DTOLineSetting *set24 = [[DTOLineSetting alloc] initWithTitle:@"채우기" identifier:LineSettingCellIDColorFill];
    DTOLineSetting *set25 = [[DTOLineSetting alloc] initWithTitle:@"테두리" identifier:LineSettingCellIDColorFill];
    DTOLineSetting *set26 = [[DTOLineSetting alloc] initWithTitle:@"배경색" identifier:LineSettingCellIDColorFill];
    
    DTOLineSetting *set27 = [[DTOLineSetting alloc] initWithTitle:@"글자색" identifier:LineSettingCellIDColor];
    DTOLineSetting *set28 = [[DTOLineSetting alloc] initWithTitle:@"색상" identifier:LineSettingCellIDColor];
    
    DTOLineSetting *set29 = [[DTOLineSetting alloc] initWithTitle:@"폰트 설정" identifier:LineSettingCellIDFont];
    
    DTOLineSetting *set30 = [[DTOLineSetting alloc] initWithTitle:@"도형 선택" identifier:LineSettingCellIDGeometricShapes];

    set0.color = [UIColor systemTealColor];
    set24.color = [UIColor cyanColor];
    set25.color = [UIColor systemRedColor];
    set26.color = [UIColor whiteColor];
    set27.color = [UIColor blackColor];
    set28.color = [UIColor systemYellowColor];
    
    if (self.lineType == ToolSettingLineTypeHorizontalLine) {
        set16.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeVerticalLine) {
        set10.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeCrossLine) {
        set10.toggleOn = YES;
        set3.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeDiagonalLine) {
        set2.toggleOn = YES;
        set21.dropBtnTitles = @[@"30º", @"45º", @"60º", @"330º", @"315º", @"300º"];
    } else if (self.lineType == ToolSettingLineTypeAngleLine) {
        set16.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypePriceDifference) {
        set7.toggleOn = YES;
        set5.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypePriceChangeLine) {
        set11.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeFibonacciArc) {
        set16.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeFibonacciFan) {
        set16.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeFibonacciRetracement) {
        set16.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeFibonacciTarget) {
        set6.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeGannLine) {
        set2.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeGannFan) {
        set16.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeGannRetracement) {
        set16.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeAccelerationResistanceLine) {
        set16.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeAccelerationResistanceFan) {
        set16.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeText) {
        set26.selected = YES;
    } else if (self.lineType == ToolSettingLineTypeSymbol) {
        set24.selected = YES;
        set22.dropBtnTitles = @[@"보통", @"굵게"];
        set22.dropBtnSelectedIndex = 0;
        NSMutableArray <NSString *>*dropdownData = @[].mutableCopy;
        for (int i = 10; i <= 50; i++) {
            NSString *title = [NSString stringWithFormat:@"%d", i];
            [dropdownData addObject:title];
        }
        set23.dropBtnTitles = dropdownData;
        set23.dropBtnSelectedIndex = 7;
    } else if (self.lineType == ToolSettingLineTypeElliottWave) {
        set15.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeStatisticalRegressionLine) {
        set15.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeStatisticalRegressionChannel ||
               self.lineType == ToolSettingLineTypeBisectorLine ||
               self.lineType == ToolSettingLineTypeTrisectorLine) {
        set16.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeCandleLine) {
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeAutomaticTrendline) {
        set9.toggleOn = YES;
        set12.toggleOn = YES;
        set20.textInputBtnTitle = @"0.05";
    } else if (self.lineType == ToolSettingLineTypeConversionLine) {
        set20.textInputBtnTitle = @"0.05";
    } else if (self.lineType == ToolSettingLineTypeTargetENV ||
               self.lineType == ToolSettingLineTypeTargetNT) {
        set16.toggleOn = YES;
        set8.toggleOn = YES;
    } else if (self.lineType == ToolSettingLineTypeShapeRectangle ||
               self.lineType == ToolSettingLineTypeShapeEllipse ||
               self.lineType == ToolSettingLineTypeShapeTriangle) {
        if (self.lineType == ToolSettingLineTypeShapeRectangle) {
            set30.geometricShapesType = GeometricShapesViewTypeRectangle;
        } else if (self.lineType == ToolSettingLineTypeShapeEllipse) {
            set30.geometricShapesType = GeometricShapesViewTypeEllipse;
        } else if (self.lineType == ToolSettingLineTypeShapeTriangle) {
            set30.geometricShapesType = GeometricShapesViewTypeTriangle;
        } else {
            NSCAssert(FALSE, @"잘못된 타입이 들어왔다.");
        }
        set24.selected = YES;
        
        set0.color = [UIColor systemRedColor];
        set24.color = [UIColor systemYellowColor];
        set0.dropBtnSelectedIndex = 9;
        
        set30.geometricShapesBackColor = (set24.selected == YES) ? set24.color : [UIColor clearColor];
        set30.geometricShapesBorderColor = set0.color;
        set30.geometricShapesBorderWidth = set0.dropBtnSelectedIndex + 1.0;
    }
        
    _basicSettings = @[set0, set1, set2, set3, set4, set5, set6, set7, set8, set9, set10, set11, set12, set13, set14, set15, set16, set17, set18, set19, set20, set21, set22, set23, set24, set25, set26, set27, set28, set29, set30].mutableCopy;
    NSMutableArray <DTOLineSetting *>*basicSettings = @[].mutableCopy;
    NSArray <NSNumber *>*requiredIndexesInBasicSettings = self.requiredIndexesInBasicSettings.copy;
    [requiredIndexesInBasicSettings enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [number integerValue];
        [basicSettings addObject:self.basicSettings[index]];
    }];
    self.basicSettings = basicSettings;
}

- (void)setupDetailSettings {
}

#pragma mark - 세터 & 게터

- (NSString *)mainTitle {
    return self.lineType;
}

#pragma mark - Actions

- (NSInteger)numberOfSections {
    if (self.detailSettings.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.basicSettings.count;
    } else {
        return self.detailSettings.count;
    }
}

- (DTOLineSetting *)cellModelForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        return self.basicSettings[row];
    } else if (section == 1) {
        return self.detailSettings[row];
    } else {
        NSCAssert(FALSE, @"잘못된 인덱스가 들어왔다.");
    }
    return nil;
}

- (void)synchronize:(void (^)(void))completionHandler {
    ToolSettingLineType lineType = self.lineType;
    if ([lineType isEqualToString:ToolSettingLineTypeShapeRectangle] ||
        [lineType isEqualToString:ToolSettingLineTypeShapeEllipse] ||
        [lineType isEqualToString:ToolSettingLineTypeShapeTriangle]) {
        DTOLineSetting *targetDTO = [self cellModelForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        DTOLineSetting *borderDTO = [self cellModelForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]; // 선굵기, 칼라
        DTOLineSetting *backColorDTO = [self cellModelForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]; // 채우기, 칼라
        targetDTO.geometricShapesBackColor = (backColorDTO.selected == YES) ? backColorDTO.color : [UIColor clearColor];
        targetDTO.geometricShapesBorderColor = borderDTO.color;
        targetDTO.geometricShapesBorderWidth = borderDTO.dropBtnSelectedIndex + 1.0;
    }
    
    if (completionHandler!= nil) {
        completionHandler();
    }
}

#pragma mark - Helper

- (NSArray <NSNumber *>*)requiredIndexesInBasicSettings {
    ToolSettingLineType lineType = self.lineType;
    if (lineType == ToolSettingLineTypeBaseline) {                    // 기준선
        return @[]; /// 따로 작업
    } else if (lineType == ToolSettingLineTypeStraightTrendline) {    // 직선추세선
        return @[@(0), @(16), @(17), @(8), @(9)];
    } else if (lineType == ToolSettingLineTypeHorizontalLine) {       // 수평선
        return @[@(0), @(16), @(8)]; // 선 색상/굵기, 좌측비율, 우측가격
    } else if (lineType == ToolSettingLineTypeVerticalLine) {         // 수직선
        return @[@(0), @(10)]; // 선 색상/굵기, 일시
    } else if (lineType == ToolSettingLineTypeCrossLine) {            // 십자선
        return @[@(0), @(10), @(3)]; // 선 색상/굵기, 일시, 값
    } else if (lineType == ToolSettingLineTypeDiagonalLine) {         // 대각선
        return @[@(0), @(2), @(21)];
    } else if (lineType == ToolSettingLineTypeAngleLine) {            // 각도선
        return @[@(0), @(16), @(13)];  // 선 색상/굵기, 좌측비율, 전체영역
    } else if (lineType == ToolSettingLineTypePriceDifference) {      // 가격-차이
        return @[@(0), @(7), @(5)];  // 선 색상/굵기, 수치표시, 대등수치
    } else if (lineType == ToolSettingLineTypePriceChangeLine) {      // 가격-변화선
        return @[@(0), @(11), @(1), @(4), @(5), @(19)];  // 선 색상/굵기, 일자표시, 가격표시, 거래량정보, 대등수치, H/L비율
    } else if (lineType == ToolSettingLineTypeFibonacciArc) {         // 피보나치-아크
        return @[@(0), @(16), @(13)];  // 선 색상/굵기, 좌측비율, 전체영역
    } else if (lineType == ToolSettingLineTypeFibonacciFan) {         // 피보나치-팬
        return @[@(0), @(16)]; // 선 색상/굵기, 좌측비율
    } else if (lineType == ToolSettingLineTypeFibonacciRetracement) { // 피보나치-수평조정대
        return @[@(0), @(16), @(17), @(8), @(9)];
    } else if (lineType == ToolSettingLineTypeFibonacciTimezone) {    // 피보나치-시간간격
        return @[@(0), @(16)]; // 선 색상/굵기, 좌측비율
    } else if (lineType == ToolSettingLineTypeFibonacciTarget) {      // 피보나치-목표치
        return @[@(0), @(14), @(6), @(9)]; // 선 색상/굵기, 전환가격, 목표치, 우측연장
    } else if (lineType == ToolSettingLineTypeAndrewsPitchfork) {     // 앤드류피치포크
        return @[@(0)];
    } else if (lineType == ToolSettingLineTypeCycleRange) {           // 사이클구간
        return @[@(0)];
    } else if (lineType == ToolSettingLineTypeGannLine) {             // 갠-라인
        return @[@(0), @(2)]; // 선 색상/굵기, 각도
    } else if (lineType == ToolSettingLineTypeGannFan) {              // 갠-팬
        return @[@(0), @(16)]; // 선 색상/굵기, 좌측비율
    } else if (lineType == ToolSettingLineTypeGannRetracement) {      // 갠-조정대
        return @[@(0), @(16), @(17), @(8), @(9)];
    } else if (lineType == ToolSettingLineTypeAccelerationResistanceLine) { // 가속저항-호
        return @[@(0), @(16), @(8), @(13)]; // 선 색상/굵기, 좌측비율, 우측가격, 전체영역
    } else if (lineType == ToolSettingLineTypeAccelerationResistanceFan) {  // 가속저항-팬
        return @[@(0), @(16), @(8)]; // 선 색상/굵기, 좌측비율, 우측가격
    } else if (lineType == ToolSettingLineTypeShapeRectangle) {             // 도형-사각형
        return @[@(30), @(0), @(24)]; // 선 색상/굵기, 채우기
    } else if (lineType == ToolSettingLineTypeShapeEllipse) {               // 도형-타원
        return @[@(30), @(0), @(24)]; // 선 색상/굵기, 채우기
    } else if (lineType == ToolSettingLineTypeShapeTriangle) {              // 도형-삼각형
        return @[@(30), @(0), @(24)]; // 선 색상/굵기, 채우기
    } else if (lineType == ToolSettingLineTypeText) {                       // 텍스트
        return @[@(27), @(25), @(26), @(18), @(29)]; // 글자색, 테두리, 배경색, 특정일 라인 표시, 폰트 설정
    } else if (lineType == ToolSettingLineTypeSymbol) {                     // 심볼
        return @[@(24), @(28), @(22), @(23)]; // 채우기, 색상, 스타일, 크기
    } else if (lineType == ToolSettingLineTypeElliottWave) {                // 엘리엇파동
        return @[@(0), @(15)]; // 선 색상/굵기, 좌측가격
    } else if (lineType == ToolSettingLineTypeStatisticalRegressionLine) {    // 통계-직선회귀선
        return @[@(0), @(15), @(17), @(8), @(9)];
    } else if (lineType == ToolSettingLineTypeStatisticalRegressionChannel) { // 통계-직선회귀채널
        return @[@(0), @(16), @(17), @(8), @(9)];
    } else if (lineType == ToolSettingLineTypeBisectorLine) {       // 사등분선
        return @[@(0), @(16), @(17), @(8), @(9)];
    } else if (lineType == ToolSettingLineTypeTrisectorLine) {      // 삼등분선
        return @[@(0), @(16), @(17), @(8), @(9)];
    } else if (lineType == ToolSettingLineTypeCandleLine) {         // 캔들라인
        return @[@(0), @(8)];
    } else if (lineType == ToolSettingLineTypeAutomaticTrendline) { // 자동추세선
        return @[@(0), @(20), @(12), @(8), @(9), @(13)];
    } else if (lineType == ToolSettingLineTypeConversionLine) {     // 전환선
        return @[@(0), @(20), @(12), @(8)];
    } else if (lineType == ToolSettingLineTypeTargetENV) {          // 목표치-ENV
        return @[@(0), @(16), @(8)]; // 선 색상/굵기, 좌측비율, 우측가격
    } else if (lineType == ToolSettingLineTypeTargetNT) {           // 목표치-NT
        return @[@(0), @(16), @(8)]; // 선 색상/굵기, 좌측비율, 우측가격
    }
    
    NSCAssert(FALSE, @"적절한 타입이 들어오지 않았다.");
    return @[];
}

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end


//! MARK: - DTOLineSetting 클래스

@interface DTOLineSetting ()
@end
@implementation DTOLineSetting

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _title = title;
        _identifier = identifier;
    }
    return self;
}

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
