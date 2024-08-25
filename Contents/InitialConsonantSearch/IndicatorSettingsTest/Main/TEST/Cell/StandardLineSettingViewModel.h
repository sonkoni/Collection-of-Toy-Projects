//
//  StandardLineSettingViewModel.h
//  ToolSettingTest
//
//  Created by Kwan Hyun Son on 2023/09/18.
//

#import "ToolSettingViewModel.h"
@class DTOStandardLineSetting;

NS_ASSUME_NONNULL_BEGIN

typedef NSString *StandardLineSettingCellID NS_TYPED_ENUM;
//! MARK: - 상단 테이블뷰 셀 타입
static StandardLineSettingCellID const StandardLineCellIDToggleDrop = @"ToggleDrop";
static StandardLineSettingCellID const StandardLineCellIDToggle = @"Toggle";
//! MARK: - 하단 테이블뷰 셀 타입
static StandardLineSettingCellID const StandardLineCellIDNormal = @"Normal";
static StandardLineSettingCellID const StandardLineCellIDUser = @"User";

typedef NSString *StandardLineSettingTableID NS_TYPED_ENUM;
//! MARK: - 상단 테이블뷰 타입
static StandardLineSettingTableID const StandardLineSettingTableIDTop = @"Top";
//! MARK: - 하단 테이블뷰 타입
static StandardLineSettingTableID const StandardLineSettingTableIDYesterdayToday = @"YesterdayToday";
static StandardLineSettingTableID const StandardLineSettingTableIDPivotDemark = @"PivotDemark";
static StandardLineSettingTableID const StandardLineSettingTableIDCustom = @"Custom";


@interface StandardLineSettingViewModel : NSObject

@property (nonatomic, strong) StandardLineSettingTableID optionalTableType; // top을 제외한 나머지 셋 중 하나

@property (nonatomic, strong, readonly) NSArray <NSString *>*sectionTitles; // bottom table view 전용 1개 또는 2개 @dynamic

- (NSInteger)numberOfTopSections;
- (NSInteger)numberOfBottomSections;
- (NSInteger)numberOfRowsInTopSection:(NSInteger)section;
- (NSInteger)numberOfRowsInBottomSection:(NSInteger)section;
- (DTOStandardLineSetting *)topCellModelForIndexPath:(NSIndexPath *)indexPath;
- (DTOStandardLineSetting *)bottomcellModelForIndexPath:(NSIndexPath *)indexPath;

@end

//! MARK: - StandardLineSetting 클래스

@interface DTOStandardLineSetting : NSObject
@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected; // 디폴트 NO

@property (nonatomic, assign, getter=isRatio) BOOL ratio;

@property (nonatomic, strong, nullable) UIColor *color;

@property (nonatomic, strong, nullable) NSArray <NSString *>*dropBtnTitles;
@property (nonatomic, assign) NSInteger dropBtnSelectedIndex;
@property (nonatomic, assign, readonly) BOOL dropBtnHidden;

@property (nonatomic, assign, getter=isToggleOn) BOOL toggleOn; // 스위치 토글을 의미한다.

@property (nonatomic, strong) NSString *textFieldTitle;
@property (nonatomic, strong) NSString *textFieldPlaceHolderTitle;

@property (nonatomic, strong) NSString *textInputBtnTitle;

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier;

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
