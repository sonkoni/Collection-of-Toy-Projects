//
//  IndicatorSettingViewModel.h
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/10/23.
//

#import <Foundation/Foundation.h>
#import <BaseKit/BaseKit.h>
#import "IndicatorSettingViewModel+Enum.h"
@class IndicatorSettingDetailViewModel;

NS_ASSUME_NONNULL_BEGIN

typedef NSString *IndicatorSettingCellID NS_TYPED_ENUM;
static IndicatorSettingCellID const IndicatorSettingCellIDSection = @"Section";
static IndicatorSettingCellID const IndicatorSettingCellIDSubPlus = @"IndicatorSubPlus";
static IndicatorSettingCellID const IndicatorSettingCellIDSubMinus = @"IndicatorSubMinus";

static IndicatorSettingCellID const IndicatorSettingCellIDSubNormal = @"IndicatorSubNormal";
static IndicatorSettingCellID const IndicatorSettingCellIDRegion = @"IndicatorRegion";
static IndicatorSettingCellID const IndicatorSettingCellIDFavorite = @"IndicatorFavorite";
static IndicatorSettingCellID const IndicatorSettingCellIDFavoriteSub = @"IndicatorFavoriteSub";
static IndicatorSettingCellID const IndicatorSettingCellIDSearch = @"IndicatorSearch";

//! MARK: - DTOIndicatorSetting 클래스
//! 주의사항: MGROutlineItemContent 프로토콜은 아카이빙하지 않는다. 순환문제 생길 수 있다.
@interface DTOIndicatorSetting : NSObject <NSSecureCoding, NSCopying, MGROutlineItemContent>
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected; // 디폴트 NO
@property (nonatomic, assign) BOOL favorite; // 디폴트 NO
@property (nonatomic, strong) IndiSetMainCategory mainCategory; // 디폴트 indicators
@property (nonatomic, weak) MGROutlineItem <DTOIndicatorSetting *>*outlineItem; // <MGROutlineItemContent>

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier;

- (NSComparisonResult)compareWithIndicatorSetting:(DTOIndicatorSetting *)element;
+ (NSString *)prettyName:(NSString *)name;

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

////var currentMainCategory: IndiSetMainCategory = .indicators
@interface IndicatorSettingViewModel : NSObject
@property (nonatomic, strong) IndiSetMainCategory currentMainCategory; // 디폴트 indicator
@property (nonatomic, strong, readonly) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*currentItems; // @dynamic

- (NSDiffableDataSourceSnapshot <NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*)snapshotForCurrentState;

- (NSDiffableDataSourceSnapshot <NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*)snapshotForCurrentText:(NSString *)searchText;

/// 주어진 아이템의 차일드로 새로운 서브 아이템을 추가한다
- (void)addChildItemForItem:(MGROutlineItem <DTOIndicatorSetting *>*)item;

/// 해당 아이템을 지운다
 - (void)deleteItem:(MGROutlineItem <DTOIndicatorSetting *>*)item;

- (void)updateFavoriteItem:(MGROutlineItem <DTOIndicatorSetting *>*)item
                completion:(void(^)(void))completion;


- (IndicatorSettingDetailViewModel *)detailViewModelForIndicatorSetting:(DTOIndicatorSetting *)indicatorSetting;

@end

NS_ASSUME_NONNULL_END


//@interface DTOStandardLineSetting : NSObject
//
//
//@property (nonatomic, strong) NSString *title;
//@property (nonatomic, assign) BOOL selected; // 디폴트 NO
//
//@property (nonatomic, assign, getter=isRatio) BOOL ratio;
//
//@property (nonatomic, strong, nullable) UIColor *color;
//
//@property (nonatomic, strong, nullable) NSArray <NSString *>*dropBtnTitles;
//@property (nonatomic, assign) NSInteger dropBtnSelectedIndex;
//@property (nonatomic, assign, readonly) BOOL dropBtnHidden;
//
//@property (nonatomic, assign, getter=isToggleOn) BOOL toggleOn; // 스위치 토글을 의미한다.
//
//@property (nonatomic, strong) NSString *textFieldTitle;
//@property (nonatomic, strong) NSString *textFieldPlaceHolderTitle;
//
//@property (nonatomic, strong) NSString *textInputBtnTitle;
//
//- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier;
//
//#pragma mark - NS_UNAVAILABLE
//
//+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;
//@end
