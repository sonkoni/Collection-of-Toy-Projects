//
//  ConfigChartTypeViewModel.h
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/08/31.
//

#import "ToolSettingViewModel.h"
#import "GeometricShapesView.h"

@class DTOLineSetting;

NS_ASSUME_NONNULL_BEGIN

typedef NSString *LineSettingCellID NS_TYPED_ENUM;

//! MARK: - 기본설정
static LineSettingCellID const LineSettingCellIDColorDrop = @"ColorDrop"; // 칼라버튼 + 드롭다운
static LineSettingCellID const LineSettingCellIDColorFill = @"ColorFill"; // 좌측 채우기 체크 + 칼라버튼
static LineSettingCellID const LineSettingCellIDToggle = @"Toggle"; // toggle 스위치 하나 toggle
static LineSettingCellID const LineSettingCellIDDrop = @"Drop"; // 드롭다운 메뉴 하나만 있는 것
static LineSettingCellID const LineSettingCellIDColor = @"Color";
static LineSettingCellID const LineSettingCellIDTextInput = @"TextInput"; // 텍스트 필드 기능을 하는 버튼이 있는 셀
static LineSettingCellID const LineSettingCellIDFont = @"Font"; // 드랍다운 + 볼드버튼

// MARK: - 기본설정. 특수한 셀: 높이가 좀 있다.
static LineSettingCellID const LineSettingCellIDGeometricShapes = @"GeometricShapes";

@interface LineSettingViewModel : NSObject

@property (nonatomic, strong) ToolSettingLineType lineType;

@property (nonatomic, strong, readonly) NSString *mainTitle;
@property (nonatomic, strong) NSArray <NSString *>*sectionTitles; // 1개 또는 2개

- (instancetype)initWithLineType:(ToolSettingLineType)lineType;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (DTOLineSetting *)cellModelForIndexPath:(NSIndexPath *)indexPath;

- (void)synchronize:(void(^_Nullable)(void))completionHandler;

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

//! MARK: - DTOLineSetting 클래스

@interface DTOLineSetting : NSObject
@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected; // 디폴트 NO

@property (nonatomic, assign) GeometricShapesViewType geometricShapesType;
@property (nonatomic, strong, nullable) UIColor *geometricShapesBorderColor;
@property (nonatomic, assign) CGFloat geometricShapesBorderWidth;
@property (nonatomic, strong, nullable) UIColor *geometricShapesBackColor;

@property (nonatomic, assign, getter=isBold) BOOL bold;

@property (nonatomic, strong, nullable) UIColor *color;

@property (nonatomic, strong, nullable) NSArray <NSString *>*dropBtnTitles;
@property (nonatomic, assign) NSInteger dropBtnSelectedIndex;

@property (nonatomic, assign, getter=isToggleOn) BOOL toggleOn; // 스위치 토글을 의미한다.

@property (nonatomic, strong) NSString *textInputBtnTitle;

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier;

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
