//
//  IndicatorSettingDetailViewModel.h
//  StockLineTEST
//
//  Created by Kwan Hyun Son on 10/24/23.
//

#import <UIKit/UIKit.h>
@class DTOIndicatorDetailSetting;
@class DTOIndicatorSetting;


NS_ASSUME_NONNULL_BEGIN

typedef NSString *IndicatorSettingDetailID NS_TYPED_ENUM;
static IndicatorSettingDetailID const IndicatorSettingDetailIDNormal = @"Normal";
static IndicatorSettingDetailID const IndicatorSettingDetailIDDescription = @"Description";
static IndicatorSettingDetailID const IndicatorSettingDetailIDToggle = @"Toggle";
static IndicatorSettingDetailID const IndicatorSettingDetailIDColor = @"Color";
static IndicatorSettingDetailID const IndicatorSettingDetailIDDrop = @"Drop";
static IndicatorSettingDetailID const IndicatorSettingDetailIDDropLineStyle = @"DropLineStyle";
static IndicatorSettingDetailID const IndicatorSettingDetailIDDropLineWidth = @"DropLineWidth";
static IndicatorSettingDetailID const IndicatorSettingDetailIDDropFillExpression = @"DropFillExpression";
static IndicatorSettingDetailID const IndicatorSettingDetailIDDropFillType = @"DropFillType";
static IndicatorSettingDetailID const IndicatorSettingDetailIDStepper = @"Stepper";
static IndicatorSettingDetailID const IndicatorSettingDetailIDToggleDrop = @"ToggleDrop";
static IndicatorSettingDetailID const IndicatorSettingDetailIDDetailSetting = @"DetailSetting";

typedef NS_ENUM(NSInteger, IndicatorSettingDetailCategory) {
    IndicatorSettingDetailCategoryLine = 0,
    IndicatorSettingDetailCategoryConditions,
    IndicatorSettingDetailCategoryDescription
};

@interface IndicatorSettingDetailViewModel : NSObject

@property (nonatomic, assign) IndicatorSettingDetailCategory detailCategory; // 디폴트 .Line

@property (nonatomic, strong, readonly) NSArray <NSString *>*sectionTitles; // bottom table view 전용 1개 또는 2개 @dynamic

@property (nonatomic, assign, readonly) BOOL isShowGraph; // @dynamic
@property (nonatomic, strong, readonly) NSString *mainTitle; // @dynamic

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (DTOIndicatorDetailSetting *)cellModelForIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithIndicatorSetting:(DTOIndicatorSetting *)indicatorSetting;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end


@interface DTOIndicatorDetailSetting : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, strong, nullable) UIColor *color;
@property (nonatomic, assign) NSInteger dropBtnSelectedIndex;
@property (nonatomic, assign, getter=isToggleOn) BOOL toggleOn; // 스위치 토글을 의미한다.

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
