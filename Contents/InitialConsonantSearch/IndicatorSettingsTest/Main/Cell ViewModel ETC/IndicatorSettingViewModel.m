//
//  IndicatorSettingViewModel.m
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/10/23.
//

#import <BaseKit/BaseKit.h>
#import "IndicatorSettingViewModel.h"
#import "IndicatorSettingDetailViewModel.h"

@interface IndicatorSettingViewModel ()
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*indicatorItems;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*signalItems;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*patternItems;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*regionItems; // 강세/약세 구간
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*fillItems;

@property (nonatomic, strong, readonly) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*favoriteItems; // @dynamic
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*favoriteIndicatorItems;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*favoriteSignalItems;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*favoritePatternItems;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*favoriteRegionItems;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*favoriteFillItems;

@property (nonatomic, strong) NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*searchPoolItems;
@end

@implementation IndicatorSettingViewModel
@dynamic favoriteItems;
@dynamic currentItems;

- (NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*)currentItems {
    if ([self.currentMainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        return self.indicatorItems;
    } else if ([self.currentMainCategory isEqualToString:IndiSetMainCategorySignals]) {
        return self.signalItems;
    } else if ([self.currentMainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
        return self.patternItems;
    } else if ([self.currentMainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        return self.regionItems;
    } else if ([self.currentMainCategory isEqualToString:IndiSetMainCategoryFill]) {
        return self.fillItems;
    } else if ([self.currentMainCategory isEqualToString:IndiSetMainCategoryFavorites]) {
        return self.favoriteItems;
    } else {
        NSCAssert(FALSE, @"잘못된 아이템");
        return self.indicatorItems;
    }
}

- (NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*)favoriteItems {
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*result = @[].mutableCopy;
    [result addObjectsFromArray:self.favoriteIndicatorItems];
    [result addObjectsFromArray:self.favoriteSignalItems];
    [result addObjectsFromArray:self.favoritePatternItems];
    [result addObjectsFromArray:self.favoriteRegionItems];
    [result addObjectsFromArray:self.favoriteFillItems];
    return result;
}

#pragma mark - 생성 & 소멸

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(IndicatorSettingViewModel *self) {
    self->_currentMainCategory = IndiSetMainCategoryIndicators;
    self->_indicatorItems = @[].mutableCopy;
    self->_signalItems = @[].mutableCopy;
    self->_patternItems = @[].mutableCopy;
    self->_regionItems = @[].mutableCopy;
    self->_fillItems = @[].mutableCopy;
    self->_favoriteIndicatorItems = @[].mutableCopy;
    self->_favoriteSignalItems = @[].mutableCopy;
    self->_favoritePatternItems = @[].mutableCopy;
    self->_favoriteRegionItems = @[].mutableCopy;
    self->_favoriteFillItems = @[].mutableCopy;
    self->_searchPoolItems = @[].mutableCopy;
    
    ///[self setupMockupSettings];
    [self loadData];
}

- (void)setupMockupSettings {
    /// Section - DTO
    NSMutableArray <DTOIndicatorSetting *>*sectionDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*sectionTitles = @[@"추세지표", @"변동성지표", @"모멘텀지표", @"시장강도지표", @"가격지표", @"거래량지표", @"모바일전용", @"기타지표"].mutableCopy;
    for (NSString *title in sectionTitles) {
        [sectionDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSection]];
    }
    
    /// Section - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*mainItems = @[].mutableCopy;
    for (DTOIndicatorSetting *sectionDTO in sectionDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:sectionDTO isFolder:YES subitems:nil];
        [mainItems addObject:item];
    }
    
    // 추세지표
    /// 추세지표 - DTO
    NSMutableArray <DTOIndicatorSetting *>*trendDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*trendTitles = @[@"ADX", @"CCI", @"DMI"].mutableCopy;
    
    for (NSString *title in trendTitles) {
        DTOIndicatorSetting *dto = [[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus];
        dto.selected = YES;
        [trendDTOs addObject:dto];
    }
    
    /// 추세지표 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*trendItems = @[].mutableCopy;
    for (DTOIndicatorSetting *trendDTO in trendDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:trendDTO isFolder:YES subitems:nil];
        item.expanded = YES; // 무조건 열린 상태
        [trendItems addObject:item];
    }
    
    [mainItems[0] appendSubitems:trendItems];
    mainItems[0].expanded = YES;
    
    //++ 테스트 코드
    DTOIndicatorSetting *dto = [[DTOIndicatorSetting alloc] initWithTitle:@"ADX 1" identifier:IndicatorSettingCellIDSubMinus];
    MGROutlineItem *item = [[MGROutlineItem alloc] initWithContentItem:dto isFolder:NO subitems:nil];
    [trendItems[0] appendSubitems:@[item]];
    
    
    // 변동성지표
    /// 변동성지표 - DTO
    NSMutableArray <DTOIndicatorSetting *>*volatilityDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*volatilityTitles = @[@"Average True Range", @"BWI", @"RVI(Relative Volatility Index)", @"Sigma"].mutableCopy;
    
    for (NSString *title in volatilityTitles) {
        [volatilityDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus]];
    }
    
    /// 변동성지표 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*volatilityItems = @[].mutableCopy;
    for (DTOIndicatorSetting *volatilityDTO in volatilityDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:volatilityDTO isFolder:YES subitems:nil];
        item.expanded = YES;
        [volatilityItems addObject:item];
    }
    [mainItems[1] appendSubitems:volatilityItems];
    mainItems[1].expanded = NO;
    
    // 모멘텀지표
    /// 모멘텀지표 - DTO
    NSMutableArray <DTOIndicatorSetting *>*momentumDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*momentumTitles = @[@"Breath Trust", @"ABI", @"ADL", @"ADR(코스닥)", @"ADR(코스피)"].mutableCopy;
    
    for (NSString *title in momentumTitles) {
        [momentumDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus]];
    }
    
    /// 모멘텀지표 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*momentumItems = @[].mutableCopy;
    for (DTOIndicatorSetting *momentumDTO in momentumDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:momentumDTO isFolder:YES subitems:nil];
        item.expanded = YES;
        [momentumItems addObject:item];
    }
    [mainItems[2] appendSubitems:momentumItems];
    mainItems[2].expanded = NO;
    
    // 시장강도지표
    /// 시장강도지표 - DTO
    NSMutableArray <DTOIndicatorSetting *>*marketStrengthDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*marketStrengthTitles = @[@"투자심리선", @"신심리도", @"Accumulation_Distribution", @"Binary Wave", @"BPDL Short trend", @"BPDL Stochastic"].mutableCopy;
    
    for (NSString *title in marketStrengthTitles) {
        [marketStrengthDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus]];
    }
    
    /// 시장강도지표 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*marketStrengthItems = @[].mutableCopy;
    for (DTOIndicatorSetting *marketStrengthDTO in marketStrengthDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:marketStrengthDTO isFolder:YES subitems:nil];
        item.expanded = YES;
        [marketStrengthItems addObject:item];
    }
    [mainItems[3] appendSubitems:marketStrengthItems];
    mainItems[3].expanded = NO;
    
    // 가격지표
    /// 가격지표 - DTO
    NSMutableArray <DTOIndicatorSetting *>*priceDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*priceTitles = @[@"가격 이동평균", @"시고저라인", @"Bollinger Bands", @"매물대차트", @"가격박스"].mutableCopy;
    
    for (NSString *title in priceTitles) {
        [priceDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus]];
    }
    
    /// 가격지표 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*priceItems = @[].mutableCopy;
    for (DTOIndicatorSetting *priceDTO in priceDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:priceDTO isFolder:YES subitems:nil];
        item.expanded = YES;
        [priceItems addObject:item];
    }
    [mainItems[4] appendSubitems:priceItems];
    mainItems[4].expanded = NO;
    
    // 거래량지표
    /// 거래량지표 - DTO
    NSMutableArray <DTOIndicatorSetting *>*volumeDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*volumeTitles = @[@"거래량", @"거래량(매수/매도)", @"거래량가격대비", @"거래량전일비교"].mutableCopy;
    
    for (NSString *title in volumeTitles) {
        [volumeDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus]];
    }
    
    /// 거래량지표 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*volumeItems = @[].mutableCopy;
    for (DTOIndicatorSetting *volumeDTO in volumeDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:volumeDTO isFolder:YES subitems:nil];
        item.expanded = YES;
        [volumeItems addObject:item];
    }
    [mainItems[5] appendSubitems:volumeItems];
    mainItems[5].expanded = NO;
    
    // 모바일전용
    /// 모바일전용 - DTO
    NSMutableArray <DTOIndicatorSetting *>*mobileDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*mobileTitles = @[@"CMO", @"RCI", @"Qstick"].mutableCopy;
    
    for (NSString *title in mobileTitles) {
        [mobileDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus]];
    }
    
    /// 모바일전용 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*mobileItems = @[].mutableCopy;
    for (DTOIndicatorSetting *mobileDTO in mobileDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:mobileDTO isFolder:YES subitems:nil];
        item.expanded = YES;
        [mobileItems addObject:item];
    }
    [mainItems[6] appendSubitems:mobileItems];
    mainItems[6].expanded = NO;
    
    // 기타지표
    /// 기타지표 - DTO
    NSMutableArray <DTOIndicatorSetting *>*otherDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*otherTitles = @[@"거래대금", @"뉴스", @"공시", @"외국인보유비중"].mutableCopy;
    
    for (NSString *title in otherTitles) {
        [otherDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubPlus]];
    }
    
    /// 기타지표 - OutlineItem
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*otherItems = @[].mutableCopy;
    for (DTOIndicatorSetting *otherDTO in otherDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:otherDTO isFolder:YES subitems:nil];
        item.expanded = YES;
        [otherItems addObject:item];
    }
    [mainItems[7] appendSubitems:otherItems];
    mainItems[7].expanded = NO;
    
    //    추세지표 (Trend): Trend
    //    변동성지표 (Volatility): Volatility
    //    모멘텀지표 (Momentum): Momentum
    //    시장강도지표 (Market Strength): Market Strength
    //    가격지표 (Price): Price
    //    거래량지표 (Volume): Volume
    //    모바일전용 (Mobile): Mobile
    //    기타지표 (Other): Other
    self.indicatorItems = mainItems;
}

- (void)loadData {
    [self loadIndicatorData];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self loadIndicatorSubData];
        [self loadSignalData];
        [self loadPatternData];
        [self loadRegionData];
        [self loadFillData];
    });
}

- (void)loadIndicatorData {
    /// Section - DTO
    NSMutableArray <DTOIndicatorSetting *>*sectionDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*sectionTitles = @[@"가격지표", @"모멘텀지표", @"변동성지표", @"채널지표", @"추세지표", @"시장강도지표", @"거래량지표", @"기타지표", @"투자자지표"].mutableCopy;
    for (NSString *title in sectionTitles) {
        [sectionDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSection]];
    }
    
    /// Section - OutlineItem
    for (DTOIndicatorSetting *sectionDTO in sectionDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:sectionDTO isFolder:YES subitems:nil];
        [self.indicatorItems addObject:item];
    }
}

- (void)loadIndicatorSubData {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"indica" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    __autoreleasing NSError* error = nil;
    NSArray <NSArray <NSString *>*>*titlesArr =
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    // 자료가 빵구다.
    for (NSInteger i = 0; i < self.indicatorItems.count - 1; i++) {
        MGROutlineItem <DTOIndicatorSetting *>*item = self.indicatorItems[i];
        NSArray <NSString *>*titles = titlesArr[i];
        NSMutableArray *subitems = @[].mutableCopy;
        for (NSInteger index = 0; index < titles.count; index++) {
            NSString *title = titles[index];
            DTOIndicatorSetting *dto = [[DTOIndicatorSetting alloc] initWithTitle:title
                                                                       identifier:IndicatorSettingCellIDSubPlus];
            dto.mainCategory = IndiSetMainCategoryIndicators;
            MGROutlineItem *subitem = [[MGROutlineItem alloc] initWithContentItem:dto isFolder:YES subitems:nil];
            subitem.expanded = YES; // 무조건 열린 상태
            [self.searchPoolItems addObject:subitem]; // SubPlus만 담는다
            
            // TODO: - 제대로 된 데이터로 설정이 되어야한다.
            // 데이터에서 favorite 정보를 가져와라.
            /// <- 설정이 먼저 이루어져야한다.
            if (dto.favorite == YES) {
                [self.favoriteIndicatorItems addObject:subitem];
            }
            [subitems addObject:subitem];
        }
        
        [item appendSubitems:subitems];
    }
}

- (void)loadSignalData {
    /// Section - DTO
    NSMutableArray <DTOIndicatorSetting *>*sectionDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*sectionTitles = @[@"분석신호", @"매매신호"].mutableCopy;
    for (NSString *title in sectionTitles) {
        [sectionDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSection]];
    }
    
    /// Section - OutlineItem
    for (DTOIndicatorSetting *sectionDTO in sectionDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:sectionDTO isFolder:YES subitems:nil];
        [self.signalItems addObject:item];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"signal" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    __autoreleasing NSError* error = nil;
    NSArray <NSArray <NSString *>*>*titlesArr =
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    for (NSInteger i = 0; i < self.signalItems.count; i++) {
        MGROutlineItem <DTOIndicatorSetting *>*item = self.signalItems[i];
        NSArray <NSString *>*titles = titlesArr[i];
        
        NSMutableArray *subitems = @[].mutableCopy;
        for (NSInteger index = 0; index < titles.count; index++) {
            NSString *title = titles[index];
            DTOIndicatorSetting *dto = [[DTOIndicatorSetting alloc] initWithTitle:title
                                                                       identifier:IndicatorSettingCellIDSubNormal];
            dto.mainCategory = IndiSetMainCategorySignals;
            MGROutlineItem *subitem = [[MGROutlineItem alloc] initWithContentItem:dto isFolder:NO subitems:nil];
            [self.searchPoolItems addObject:subitem]; // SubNormal만 담는다
            
            // TODO: - 제대로 된 데이터로 설정이 되어야한다.
            // 데이터에서 favorite 정보를 가져와라.
            /// <- 설정이 먼저 이루어져야한다.
            if (dto.favorite == YES) {
                [self.favoriteSignalItems addObject:subitem];
            }
            [subitems addObject:subitem];
        }
        
        [item appendSubitems:subitems];
    }

}

- (void)loadPatternData {
    /// Section - DTO
    NSMutableArray <DTOIndicatorSetting *>*sectionDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*sectionTitles = @[@"상승반전패턴", @"상승지속패턴", @"하락반전패턴", @"하락지속패턴", @"횡보구간패턴", @"박스장세패턴", @"추세패턴"].mutableCopy;
    for (NSString *title in sectionTitles) {
        [sectionDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSection]];
    }
    
    /// Section - OutlineItem
    for (DTOIndicatorSetting *sectionDTO in sectionDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:sectionDTO isFolder:YES subitems:nil];
        [self.patternItems addObject:item];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"pattern" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    __autoreleasing NSError* error = nil;
    NSArray <NSArray <NSString *>*>*titlesArr =
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    for (NSInteger i = 0; i < self.patternItems.count - 2; i++) {
        MGROutlineItem <DTOIndicatorSetting *>*item = self.patternItems[i];
        // 자료가 빵구다.
        if (i == (self.patternItems.count - 3)) {
            item = self.patternItems[(self.patternItems.count-1)];
        }
        NSArray <NSString *>*titles = titlesArr[i];
        
        NSMutableArray *subitems = @[].mutableCopy;
        for (NSInteger index = 0; index < titles.count; index++) {
            NSString *title = titles[index];
            DTOIndicatorSetting *dto = [[DTOIndicatorSetting alloc] initWithTitle:title
                                                                       identifier:IndicatorSettingCellIDSubNormal];
            dto.mainCategory = IndiSetMainCategoryPatterns;
            MGROutlineItem *subitem = [[MGROutlineItem alloc] initWithContentItem:dto isFolder:NO subitems:nil];
            [self.searchPoolItems addObject:subitem]; // SubNormal만 담는다
            
            // TODO: - 제대로 된 데이터로 설정이 되어야한다.
            // 데이터에서 favorite 정보를 가져와라.
            /// <- 설정이 먼저 이루어져야한다.
            if (dto.favorite == YES) {
                [self.favoritePatternItems addObject:subitem];
            }
            [subitems addObject:subitem];
        }
        
        [item appendSubitems:subitems];
    }
}

- (void)loadRegionData {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"region" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    __autoreleasing NSError* error = nil;
    NSArray <NSString *>*titles = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&error];
    
    for (NSString *title in titles) {
        DTOIndicatorSetting *dto = [[DTOIndicatorSetting alloc] initWithTitle:title
                                                                   identifier:IndicatorSettingCellIDRegion];
        dto.mainCategory = IndiSetMainCategoryRanges;
        MGROutlineItem *item = [[MGROutlineItem alloc] initWithContentItem:dto isFolder:NO subitems:nil];
        [self.searchPoolItems addObject:item]; // Region만 담는다
        
        // TODO: - 제대로 된 데이터로 설정이 되어야한다.
        // 데이터에서 favorite 정보를 가져와라.
        /// <- 설정이 먼저 이루어져야한다.
        if (dto.favorite == YES) {
            [self.favoriteRegionItems addObject:item];
        }
        
        [self.regionItems addObject:item];
    }
}

- (void)loadFillData {
    /// Section - DTO
    NSMutableArray <DTOIndicatorSetting *>*sectionDTOs = @[].mutableCopy;
    NSMutableArray <NSString *>*sectionTitles = @[@"가격영역채움", @"거래량영역채움", @"분석영역채움"].mutableCopy;
    for (NSString *title in sectionTitles) {
        [sectionDTOs addObject:[[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSection]];
    }
    
    /// Section - OutlineItem
    for (DTOIndicatorSetting *sectionDTO in sectionDTOs) {
        MGROutlineItem *item =
        [[MGROutlineItem alloc] initWithContentItem:sectionDTO isFolder:YES subitems:nil];
        [self.fillItems addObject:item];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"fill" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    __autoreleasing NSError* error = nil;
    NSArray <NSArray <NSString *>*>*titlesArr =
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    for (NSInteger i = 0; i < self.fillItems.count; i++) {
        MGROutlineItem <DTOIndicatorSetting *>*item = self.fillItems[i];
        NSArray <NSString *>*titles = titlesArr[i];
        
        NSMutableArray *subitems = @[].mutableCopy;
        for (NSInteger index = 0; index < titles.count; index++) {
            NSString *title = titles[index];
            DTOIndicatorSetting *dto = [[DTOIndicatorSetting alloc] initWithTitle:title
                                                                       identifier:IndicatorSettingCellIDSubNormal];
            
            dto.mainCategory = IndiSetMainCategoryFill;
            MGROutlineItem *subitem = [[MGROutlineItem alloc] initWithContentItem:dto isFolder:NO subitems:nil];
            [self.searchPoolItems addObject:subitem]; // SubNormal만 담는다
            
            // TODO: - 제대로 된 데이터로 설정이 되어야한다.
            // 데이터에서 favorite 정보를 가져와라.
            /// <- 설정이 먼저 이루어져야한다.
            if (dto.favorite == YES) {
                [self.favoriteFillItems addObject:subitem];
            }
            [subitems addObject:subitem];
        }
        
        [item appendSubitems:subitems];
    }
}


#pragma mark - Actions

- (NSDiffableDataSourceSnapshot<NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*)snapshotForCurrentState {
    NSDiffableDataSourceSnapshot <NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*snapshot =
    [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@"mainSection"]];
    void (^__block addItemsBlock)(MGROutlineItem * _Nullable);
    
    __weak __block __typeof(addItemsBlock) weakAddItemsBlock = addItemsBlock = ^(MGROutlineItem *menuItem){
        [snapshot appendItemsWithIdentifiers:@[menuItem]];
        if (menuItem.isExpanded == YES) {
            for (MGROutlineItem *item in menuItem.subitems) {
                weakAddItemsBlock(item);
            }
        }
    };

    for (MGROutlineItem *item in self.currentItems) {
        addItemsBlock(item);
    }

    return snapshot;
}

- (NSDiffableDataSourceSnapshot<NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*)snapshotForCurrentText:(NSString *)searchText {
    NSDiffableDataSourceSnapshot <NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*snapshot =
    [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@"mainSection"]];
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*resultArray = @[].mutableCopy;
    
    /// Filtering
    for (MGROutlineItem <DTOIndicatorSetting *>*outlineItem in self.searchPoolItems) {
        NSString *poolTitle = outlineItem.contentItem.title;
        NSRange subRange = [poolTitle mgrRangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(subRange.location != NSNotFound) {
            [resultArray addObject:outlineItem];
        }
    }
    
    /// Sorting
    if (resultArray.count > 0) {
        [resultArray sortUsingComparator:^NSComparisonResult(MGROutlineItem <DTOIndicatorSetting *>*obj1,
                                                             MGROutlineItem <DTOIndicatorSetting *>*obj2) {
            NSComparisonResult resut = [obj1.contentItem compareWithIndicatorSetting:obj2.contentItem];
            if (resut != NSOrderedSame) {
                return resut;
            }
            return [obj1.contentItem.title compare:obj2.contentItem.title options:NSCaseInsensitiveSearch];
        }];
        [snapshot appendItemsWithIdentifiers:resultArray];
    }
    return snapshot;
}

- (void)addChildItemForItem:(MGROutlineItem <DTOIndicatorSetting *>*)item {
    if (item.subitems.count > 9) { // 10개로 제한하자.
        return;
        //
        // 제한 알림을 띄워주면 좋을 듯하다
    }
    DTOIndicatorSetting *contentItem = item.contentItem;
    NSInteger i = 1;
    NSString *title = [NSString stringWithFormat:@"%@ %ld", contentItem.title, i];
    NSArray <NSString *>*titles = [item.subitems mgrUnionOfObjectsForProperty:@"contentItem.title"];
    while ([titles containsObject:title] == YES) {
        i++;
        title = [NSString stringWithFormat:@"%@ %ld", contentItem.title, i];
    }
    DTOIndicatorSetting *indicatorSetContentItem =
        [[DTOIndicatorSetting alloc] initWithTitle:title identifier:IndicatorSettingCellIDSubMinus];
    MGROutlineItem *resultOutlineItem =
        [[MGROutlineItem alloc] initWithContentItem:indicatorSetContentItem isFolder:NO subitems:nil];
    [item appendSubitems:@[resultOutlineItem]];
    
}

- (void)deleteItem:(MGROutlineItem <DTOIndicatorSetting *>*)item {
    [item removeFromSuperitem];
}

// item 의 favorite이 업데이트 되었다.
- (void)updateFavoriteItem:(MGROutlineItem <DTOIndicatorSetting *>*)item
                completion:(void(^)(void))completion {
    
    DTOIndicatorSetting *contentItem = item.contentItem;
    if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryFavorites]) {
        NSCAssert(FALSE, @"있을 수 없다. 나는 이것을 의도적으로 비웠다.");
    }
    
    NSMutableArray <MGROutlineItem <DTOIndicatorSetting *>*>*targetItems = self.favoriteIndicatorItems;
    if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        targetItems = self.favoriteIndicatorItems;
    } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategorySignals]) {
        targetItems = self.favoriteSignalItems;
    } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
        targetItems = self.favoritePatternItems;
    } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        targetItems = self.favoriteRegionItems;
    } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryFill]) {
        targetItems = self.favoriteFillItems;
    }
    
    // 현재 Scene이 .favorites이면 else만 작동한다. 그 외에는 if 와 else 모두 갈 수 있다.
    if (contentItem.favorite == YES) { // true, 추가한다, 현재 Scene이 favorite이 아닐 때에만 작동할 수 있다
        [targetItems removeAllObjects];
        
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
            void (^__block addItemsBlock)(MGROutlineItem * _Nullable);
            __weak __block __typeof(addItemsBlock) weakAddItemsBlock = addItemsBlock = ^(MGROutlineItem <DTOIndicatorSetting *>*menuItem){
                if (menuItem.contentItem.favorite == YES) {
                    [targetItems addObject:menuItem];
                }
                for (MGROutlineItem *item in menuItem.subitems) {
                    weakAddItemsBlock(item);
                }
            };
            for (MGROutlineItem *item in weakSelf.currentItems) {
                addItemsBlock(item);
            }
        });
    } else {
        // false, 현재 Scene이 favorite일 때도 작동할 수 있고 아닐 때도 작동할 수 있다
        [targetItems removeObject:item];
    }
    
    if (completion != nil) {
        completion();  // 현재 Scene이 favorite일 때만 작동한다.
    }
}

- (IndicatorSettingDetailViewModel *)detailViewModelForIndicatorSetting:(DTOIndicatorSetting *)indicatorSetting {
    return [[IndicatorSettingDetailViewModel alloc] initWithIndicatorSetting:indicatorSetting];
}

@end

//! MARK: - DTOIndicatorSetting 클래스

@interface DTOIndicatorSetting ()

@end

@implementation DTOIndicatorSetting

+ (NSString *)prettyName:(NSString *)name {
    
    __block NSString *result = [name mgrSeparateCamelToString];
    
    // regularExpressionXXX 함수들의 호출 순서도 중요함
    /// Volume&PriceInSync => Volume & PriceInSync
    for (NSString *str in @[@"기준값", @"&"]) {
        result = [result mgrInsertSpacePreExpression:MGRRegularExpStrNonWhitespace
                                      postExpression:MGRRegularExpStrNonWhitespace
                                             replace:str
                                             changed:str];
    }
        
    /// 상승횡보후재상승 => 상승횡보 후 재상승
    NSArray *arr1 = @[@"횡보후", @"조정후", @"하락후", @"상승후", @"밀집후", @"기준선", @"일목균형지표", @"전환선", @"심리도", @"비대칭"];
    NSArray *arr2 = @[@"횡보 후", @"조정 후", @"하락 후", @"상승 후", @"밀집 후", @"기준선", @"일목균형지표", @"전환선", @"심리도", @"비대칭"];

    for (NSInteger i = 0; i < arr1.count; i++) {
        result = [result mgrInsertSpacePreExpression:nil
                                      postExpression:MGRRegularExpStrNonWhitespace
                                             replace:arr1[i]
                                             changed:arr2[i]];
    }
    
    /// AVG골든크로스 => AVG 골든크로스, 영어+한글
    arr1 = @[@"골", @"데", @"크", @"매", @"과매", @"상승", @"하락", @"과열", @"침체", @"기준", @"1차", @"2차", @"가격", @"Oscillator", @"Midpoint"];
    for (NSString *str in arr1) {
        result = [result mgrInsertSpacePreExpression:MGRRegularExpStrAlphabet
                                      postExpression:nil
                                             replace:str
                                             changed:str];
    }
    
    arr1 = @[@"강세", @"약세", @"채움", @"상향", @"하향", @"정배열", @"역배열"];
    for (NSString *str in arr1) {
        result = [result mgrInsertSpacePreExpression:MGRRegularExpStrNonWhitespace
                                      postExpression:nil
                                             replace:str
                                             changed:str];
    }
    
    arr1 = @[@"ABRatio", @"OBVwith", @"ADXGapper", @"MESAsinewave", @"Zigzag", @"7%", @"10%", @"Band%", @"RVIoriginal", @"_"];
    arr2 = @[@"AB-Ratio", @"OBV with", @"ADX Gapper", @"Mesa Sine Wave", @"Zig Zag", @"7% ", @"10% ", @"Band %", @"RVI Original", @" "];
        
    for (NSInteger i = 0; i < arr1.count; i++) {
        result = [result stringByReplacingOccurrencesOfString:arr1[i] withString:arr2[i]];
    }
    
    return result;
}

- (id)copyWithZone:(NSZone *)zone {
    DTOIndicatorSetting *item = [[[self class] allocWithZone:zone] init];
    if (item) {
        /** 스칼라 : 언제나 딥카피이다. **/
        item->_selected = _selected;
        item->_favorite = _favorite;
        
        /** 객체 : 딥카피 또는 쉘로우 카피. 객체에서 스칼라의 형식은 쉘로우 카피가 된다. **/
        item->_title = [_title copyWithZone:zone];
        item->_identifier = [_identifier copyWithZone:zone];
        item->_mainCategory = [_mainCategory copyWithZone:zone];
    }

    return item;
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    
    /// 스칼라
    NSUInteger result = [[NSNumber numberWithBool:_selected] hash];
    result = prime * result + [[NSNumber numberWithBool:_favorite] hash];
    
    /// 객체
    result = prime * result + [_title hash];
    result = prime * result + [_identifier hash];
    result = prime * result + [_mainCategory hash];
    return result;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
    
    return [self isEqualToIndicatorSetting:(__typeof(self))object];
}

#pragma mark - 생성 & 소멸

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _title = title;
        _identifier = identifier;
        _mainCategory = IndiSetMainCategoryIndicators;
    }
    return self;
}

#pragma mark - Actions

- (NSComparisonResult)compareWithIndicatorSetting:(DTOIndicatorSetting *)element {
    return [self compareSettingType:element];
}

- (NSComparisonResult)compareSettingType:(DTOIndicatorSetting *)element {
    if ([self.mainCategory isEqualToString:element.mainCategory]) {
        return NSOrderedSame;
    }
    if ([self.mainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        return NSOrderedAscending;
    }
    if ([self.mainCategory isEqualToString:IndiSetMainCategorySignals]) {
        if ([element.mainCategory isEqualToString:IndiSetMainCategoryIndicators] == NO) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }
    
    if ([self.mainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
        if ([element.mainCategory isEqualToString:IndiSetMainCategoryRanges] ||
            [element.mainCategory isEqualToString:IndiSetMainCategoryFill]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }
    if ([self.mainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        if ([element.mainCategory isEqualToString:IndiSetMainCategoryFill]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }
    return NSOrderedDescending;
}

#pragma mark - isEqualTo___ClassName__:

- (BOOL)isEqualToIndicatorSetting:(DTOIndicatorSetting *)item {
    if (self == item) {
        return YES;
    }

    if (item == nil) {
        return NO;
    }
    
    //! 스칼라일 경우는 단순히 둘만 비교해도 된다.
    BOOL haveEqualSelected = (self.selected == item.selected);
    BOOL haveEqualFavorite = (self.favorite == item.favorite);
    
    
    BOOL haveEqualMainCategory = (!self.mainCategory && !item.mainCategory) || [self.mainCategory isEqualToString:item.mainCategory];
    BOOL haveEqualTitle = (!self.title && !item.title) || [self.title isEqualToString:item.title];
    BOOL haveEqualIdentifier = (!self.identifier && !item.identifier ) || [self.identifier  isEqualToString:item.identifier ];
    return haveEqualSelected && haveEqualFavorite && haveEqualMainCategory && haveEqualTitle && haveEqualIdentifier;
}

#pragma mark - <NSSecureCoding>

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init]; // NSObject가 만약 initWithCoder:를 구현했었다라고 가정하면, self = [super initWithCoder:aDecoder];
    if(self) {
        _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
        _selected = [aDecoder decodeBoolForKey:@"selected"];
        _favorite = [aDecoder decodeBoolForKey:@"favorite"];
        _mainCategory = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"mainCategory"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // NSObject가 만약 encodeWithCoder:를 구현했었다라고 가정하면, [super encodeWithCoder:aCoder]; 추가해야된다.
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.mainCategory forKey:@"mainCategory"];
    [aCoder encodeBool:_selected forKey:@"selected"];
    [aCoder encodeBool:_favorite forKey:@"favorite"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSAssert(FALSE, @"- init 사용금지."); return nil; }

@end
