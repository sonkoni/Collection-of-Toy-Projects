//
//  IndicatorSettingDetailViewModel.m
//  StockLineTEST
//
//  Created by Kwan Hyun Son on 10/24/23.
//

#import <BaseKit/BaseKit.h>
#import "IndicatorSettingDetailViewModel.h"
#import "IndicatorSettingViewModel.h"

@interface IndicatorSettingDetailViewModel ()
@property (nonatomic, weak) DTOIndicatorSetting *indicatorSetting;

@property (nonatomic, strong) NSMutableArray <DTOIndicatorDetailSetting *>*dtoNormalLineSettings;
@property (nonatomic, strong) NSMutableArray <DTOIndicatorDetailSetting *>*dtoStandardLineSettings;
@property (nonatomic, strong) NSMutableArray <DTOIndicatorDetailSetting *>*dtoConditionSettings;
@property (nonatomic, strong) NSMutableArray <DTOIndicatorDetailSetting *>*dtoDescriptionSettings;

@end

@implementation IndicatorSettingDetailViewModel
@dynamic sectionTitles;
@dynamic isShowGraph;
@dynamic mainTitle;

- (instancetype)initWithIndicatorSetting:(DTOIndicatorSetting *)indicatorSetting {
    self = [super init];
    if (self) {
        _indicatorSetting = indicatorSetting;
        CommonInit(self);
    }
    return self;
}

#pragma mark - 생성 & 소멸

static void CommonInit(IndicatorSettingDetailViewModel *self) {
    self->_detailCategory = IndicatorSettingDetailCategoryLine;
    self->_dtoNormalLineSettings = @[].mutableCopy;
    self->_dtoStandardLineSettings = @[].mutableCopy;
    self->_dtoConditionSettings = @[].mutableCopy;
    self->_dtoDescriptionSettings = @[].mutableCopy;
    [self setupMockupSettings];
    [self setupRealDataSettings];
    
}

#pragma mark - 생성 & 소멸 목업

- (void)setupMockupSettings {
    [self setupLineMockupSettings];
    // [self setupDescriptionMockupSettings];
}

- (void)setupLineMockupSettings {
    if ([self.indicatorSetting.mainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        DTOIndicatorDetailSetting *item0 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"제목 표시" identifier:IndicatorSettingDetailIDToggle];
        DTOIndicatorDetailSetting *item1 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"신호명 표시" identifier:IndicatorSettingDetailIDToggle];
        DTOIndicatorDetailSetting *item2 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"색상" identifier:IndicatorSettingDetailIDColor];
        DTOIndicatorDetailSetting *item3 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"유형" identifier:IndicatorSettingDetailIDDropLineStyle];
        DTOIndicatorDetailSetting *item4 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"굵기" identifier:IndicatorSettingDetailIDDropLineWidth];
        DTOIndicatorDetailSetting *item5 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"표현" identifier:IndicatorSettingDetailIDDropFillExpression];
        DTOIndicatorDetailSetting *item6 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"타입" identifier:IndicatorSettingDetailIDDropFillType];
        item0.toggleOn = YES;
        item2.color = [UIColor systemRedColor];
        self.dtoNormalLineSettings = @[item0, item1, item2, item3, item4, item5, item6].mutableCopy;
    } else if ([self.indicatorSetting.mainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        DTOIndicatorDetailSetting *item0 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"제목 표시" identifier:IndicatorSettingDetailIDToggleDrop];
        DTOIndicatorDetailSetting *item1 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"기본소수점" identifier:IndicatorSettingDetailIDStepper];
        DTOIndicatorDetailSetting *item2 =
            [[DTOIndicatorDetailSetting alloc] initWithTitle:@"상한선" identifier:IndicatorSettingDetailIDDetailSetting];
        item0.toggleOn = YES;
        self.dtoNormalLineSettings = @[item0, item1, item2].mutableCopy;
    }
}

- (void)setupDescriptionMockupSettings {
    DTOIndicatorDetailSetting *dto1 = [DTOIndicatorDetailSetting new];
    DTOIndicatorDetailSetting *dto2 = [DTOIndicatorDetailSetting new];
    dto1.sectionTitle = @"[개요]";
    dto2.sectionTitle = @"[해석]";
    dto1.title = @"- 시장은 추세적시장(Trend market)과 비추세적 시장(Non-trend market)으로 구분할 수 있다.\n\n- 추세적시장이란 시장이 강세 또는 약세라는 추세를 가지고 있는 시장으로 포지션을 다음날로 이월시키는 Position Trading에 의해 수익을 얻을 수 있으며,\n\n- 비추세적 시장이란 장중에 일정한 박스권내에서 매매하는 Day Trading에 적합한 상황을 말한다.\n\n- 따라서 현재의 시장이 추세적 시장인지 비추세적 시장인지 판단하는 것은 매우 중요하다.\n\n- DMI차트는 현재의 시장추세와 함께 그 추세의 강도까지 알려 주는 지표로 단기보다는 중장기 추세 판별에 적합한다.\n\n+DI는 실질적으로 상승하는 폭의 비율을 나타내며,\n\n-DI는 실질적으로 하락하는 폭의 비율을 의미한다.";
    
    dto2.title = @"- + DI와 -DI의 교차\n\n>+DI가 -DI보다 큰 국면은 상승추세, 작은 국면은 하락추세로 규정할 수 있다.\n\n>+DI가 -DI를 상향돌파 하는 시점에서 매수,  하향돌파 하는 시점에서 매도 포지션을 취한다.\n\n> +DI와 -DI의 교차를 매매신호로 이용할 때는 ADX를 같이 사용해야한다.\n\n즉 +DI와 -DI가 교차하는 시점에서 ADX가 20선 아래에서 진행되다가 다시 그 값이 커지거나 20선을 상향돌파 하는 시점에서 +DI와 -DI중 값이 큰 지표방향으로 매매하는 것이 정석입니다.\n\n즉 ADX값이 상승하는 것은 현재 +DI와 -DI중 위에 있는 지표의 방향대로 추세가 진행되며, 그 강도가 강화된다는 것을 의미한다.";
    
    self.dtoDescriptionSettings = @[dto1, dto2].mutableCopy;
}

#pragma mark - 생성 & 소멸 Real

- (void)setupRealDataSettings {
    [self setupRealDescriptionSettings];
}

- (void)setupRealDescriptionSettings {
    
    /// 구간 - MesaSineWave약세 까지 했음.
    // ▶ ÷ × + − = ≤ ≥ ≦ ≧
    NSString *jsonFileName = @"HelpIndica";
    
    if ([self.indicatorSetting.mainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        jsonFileName = @"HelpRanges";
    } else if ([self.indicatorSetting.mainCategory isEqualToString:IndiSetMainCategoryFill]) {
        jsonFileName = @"HelpFill";
    } else if ([self.indicatorSetting.mainCategory isEqualToString:IndiSetMainCategorySignals]) {
        jsonFileName = @"HelpSignals";
    } else if ([self.indicatorSetting.mainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
        jsonFileName = @"HelpPatterns";
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:jsonFileName withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    __autoreleasing NSError* error = nil;
    NSArray <NSDictionary *>*originalObject = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:&error];
    if (error != nil) {
        NSCAssert(FALSE, @"Error %@", error);
    }
    NSString *targetTitle = self.indicatorSetting.title;
    if ([self.indicatorSetting.mainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        targetTitle = [targetTitle mgrRemoveLastNumberWithSpaceRemove:YES]; // child 걸릴 수 있으므로. "ADX 1"
    }
    for (NSDictionary *dic in originalObject) {
        NSString *title = dic[@"title"];
        NSArray <NSDictionary <NSString *, NSString *>*>*contents = dic[@"contents"];
        if ([title isEqualToString:targetTitle] == YES) {
            for (NSDictionary *contentDic in contents) {
                NSString *uniqueKey = contentDic.allKeys.firstObject;
                NSString *uniqueValue = contentDic.allValues.firstObject;
                DTOIndicatorDetailSetting *dto = [DTOIndicatorDetailSetting new];
                dto.identifier = IndicatorSettingDetailIDDescription;
                dto.title = uniqueValue;
                dto.sectionTitle = uniqueKey;
                [self.dtoDescriptionSettings addObject:dto];
            }
            return;
        }
    }
}

- (NSInteger)numberOfSections {
    if (self.detailCategory == IndicatorSettingDetailCategoryLine) {
        NSInteger result = 0;
        if (self.dtoNormalLineSettings.count > 0) {
            result++;
        }
        if (self.dtoStandardLineSettings.count > 0) {
            result++;
        }
        return result;
    } else if (self.detailCategory == IndicatorSettingDetailCategoryConditions) {
        return 0;
    } else if (self.detailCategory == IndicatorSettingDetailCategoryDescription) {
        return self.dtoDescriptionSettings.count;
    }
    NSCAssert(FALSE, @"예상치 못한 값이 들어옴.");
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if (self.detailCategory == IndicatorSettingDetailCategoryLine) {
        if (section == 0) {
            return self.dtoNormalLineSettings.count;
        } else if (section == 1) {
            return self.dtoStandardLineSettings.count;
        } else {
            NSCAssert(FALSE, @"예상치 못한 값이 들어옴");
            return 0;
        }
    } else if (self.detailCategory == IndicatorSettingDetailCategoryConditions) {
        return 0;
    } else if (self.detailCategory == IndicatorSettingDetailCategoryDescription) {
        return 1;
    }
    NSCAssert(FALSE, @"예상치 못한 값이 들어옴.");
    return 0;
}

- (DTOIndicatorDetailSetting *)cellModelForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    if (self.detailCategory == IndicatorSettingDetailCategoryLine) {
        if (section == 0) {
            return self.dtoNormalLineSettings[index];
        } else if (section == 1) {
            return self.dtoStandardLineSettings[index];
        } else {
            NSCAssert(FALSE, @"예상치 못한 값이 들어옴");
            return nil;
        }
    } else if (self.detailCategory == IndicatorSettingDetailCategoryConditions) {
        if (section == 0) {
//            return self.pivotSettings[index];
        } else if (section == 1) {
//            return self.demarkSettings[index];
        }
        NSCAssert(FALSE, @"잘못된 값이 들어옴.");
    } else if (self.detailCategory == IndicatorSettingDetailCategoryDescription) {
        return self.dtoDescriptionSettings[section];
    }
    NSCAssert(FALSE, @"예상치 못한갓이 들어왔다.");
    return nil;
}

- (NSArray <NSString *>*)sectionTitles {
    if (self.detailCategory == IndicatorSettingDetailCategoryLine) {
        return @[@"일반선", @"기준선"];
    } else if (self.detailCategory == IndicatorSettingDetailCategoryConditions) {
        return @[@"뭐넣지?", @"뭐넣을까?"];
    } else if (self.detailCategory == IndicatorSettingDetailCategoryDescription) {
        return [self.dtoDescriptionSettings mgrMap:^NSString *(DTOIndicatorDetailSetting *obj) {
            return obj.sectionTitle;
        }];
    } else {
        NSCAssert(FALSE, @"예상치 못한 값 대입됨");
        return nil;
    }
}


#pragma mark - 세터 & 게터

- (BOOL)isShowGraph {
    if (self.indicatorSetting.mainCategory == IndiSetMainCategoryIndicators) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)mainTitle {
    NSString *title = self.indicatorSetting.title;
    if (title != nil && [title isEqualToString:@""] == NO) {
        return [DTOIndicatorSetting prettyName:title];
    }
    return title;
}

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end


@interface DTOIndicatorDetailSetting ()

@end

@implementation DTOIndicatorDetailSetting

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _title = title;
        _identifier = identifier;
    }
    return self;
}
@end
