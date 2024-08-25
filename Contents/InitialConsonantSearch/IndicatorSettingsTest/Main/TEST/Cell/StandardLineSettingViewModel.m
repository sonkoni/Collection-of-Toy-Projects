//
//  StandardLineSettingViewModel.m
//  ToolSettingTest
//
//  Created by Kwan Hyun Son on 2023/09/18.
//

#import "StandardLineSettingViewModel.h"


@interface StandardLineSettingViewModel ()
/// top
@property (nonatomic, strong) NSMutableArray <DTOStandardLineSetting *>*topSettings;

/// bottoms
@property (nonatomic, strong) NSMutableArray <DTOStandardLineSetting *>*yesterdaySettings;
@property (nonatomic, strong) NSMutableArray <DTOStandardLineSetting *>*todaySettings;
@property (nonatomic, strong) NSMutableArray <DTOStandardLineSetting *>*pivotSettings;
@property (nonatomic, strong) NSMutableArray <DTOStandardLineSetting *>*demarkSettings;
@property (nonatomic, strong) NSMutableArray <DTOStandardLineSetting *>*customSettings;

@end

@implementation StandardLineSettingViewModel
@dynamic sectionTitles;

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

#pragma mark - 생성 & 소멸

static void CommonInit(StandardLineSettingViewModel *self) {
    self->_optionalTableType = StandardLineSettingTableIDYesterdayToday;
    self->_topSettings = @[].mutableCopy;
    [self setupTopMockupSettings];
    [self setupBottomMockupSettings];
    [self setupTopRealSettings];
    [self setupBottomRealSettings];
}

- (void)setupTopMockupSettings {
    DTOStandardLineSetting *s0 = [[DTOStandardLineSetting alloc] initWithTitle:@"수치 표시" identifier:StandardLineCellIDToggleDrop];
    s0.toggleOn = YES;
    DTOStandardLineSetting *s1 = [[DTOStandardLineSetting alloc] initWithTitle:@"알람 / 메시지" identifier:StandardLineCellIDToggle];
    _topSettings = @[s0, s1].mutableCopy;
}
- (void)setupBottomMockupSettings {
    
    DTOStandardLineSetting *y0 = [[DTOStandardLineSetting alloc] initWithTitle:@"전일 시가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *y1 = [[DTOStandardLineSetting alloc] initWithTitle:@"전일 고가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *y2 = [[DTOStandardLineSetting alloc] initWithTitle:@"전일 저가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *y3 = [[DTOStandardLineSetting alloc] initWithTitle:@"전일 종가" identifier:StandardLineCellIDNormal];
    y0.color = [UIColor blackColor];
    y1.color = [UIColor systemRedColor];
    y2.color = [UIColor systemGreenColor];
    y3.color = [UIColor systemPinkColor];
    _yesterdaySettings = @[y0, y1, y2, y3].mutableCopy;
    
    DTOStandardLineSetting *t0 = [[DTOStandardLineSetting alloc] initWithTitle:@"당일 시가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *t1 = [[DTOStandardLineSetting alloc] initWithTitle:@"당일 고가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *t2 = [[DTOStandardLineSetting alloc] initWithTitle:@"당일 저가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *t3 = [[DTOStandardLineSetting alloc] initWithTitle:@"당일 종가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *t4 = [[DTOStandardLineSetting alloc] initWithTitle:@"(시 + 고 + 저)/3" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *t5 = [[DTOStandardLineSetting alloc] initWithTitle:@"상한가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *t6 = [[DTOStandardLineSetting alloc] initWithTitle:@"하한가" identifier:StandardLineCellIDNormal];
    t0.color = [UIColor systemBlueColor];
    t1.color = [UIColor systemTealColor];
    t2.color = [UIColor systemCyanColor];
    t3.color = [UIColor systemPinkColor];
    t4.color = [UIColor systemIndigoColor];
    t5.color = [UIColor systemGrayColor];
    t6.color = [UIColor systemBrownColor];
    _todaySettings = @[t0, t1, t2, t3, t4, t5, t6].mutableCopy;
    
    DTOStandardLineSetting *p0 = [[DTOStandardLineSetting alloc] initWithTitle:@"기준선" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *p1 = [[DTOStandardLineSetting alloc] initWithTitle:@"1차 저항" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *p2 = [[DTOStandardLineSetting alloc] initWithTitle:@"2차 저항" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *p3 = [[DTOStandardLineSetting alloc] initWithTitle:@"1차 지지" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *p4 = [[DTOStandardLineSetting alloc] initWithTitle:@"2차 지지" identifier:StandardLineCellIDNormal];
    p0.color = [UIColor systemGreenColor];
    p1.color = [UIColor blackColor];
    p2.color = [UIColor systemRedColor];
    p3.color = [UIColor systemGreenColor];
    p4.color = [UIColor systemPinkColor];
    _pivotSettings = @[p0, p1, p2, p3, p4].mutableCopy;
    
    DTOStandardLineSetting *d0 = [[DTOStandardLineSetting alloc] initWithTitle:@"기준선" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *d1 = [[DTOStandardLineSetting alloc] initWithTitle:@"목표 고가" identifier:StandardLineCellIDNormal];
    DTOStandardLineSetting *d2 = [[DTOStandardLineSetting alloc] initWithTitle:@"목표 저가" identifier:StandardLineCellIDNormal];
    d0.color = [UIColor blackColor];
    d1.color = [UIColor systemRedColor];
    d2.color = [UIColor systemBlueColor];
    _demarkSettings = @[d0, d1, d2].mutableCopy;
    
    DTOStandardLineSetting *u0 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    DTOStandardLineSetting *u1 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    DTOStandardLineSetting *u2 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    DTOStandardLineSetting *u3 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    DTOStandardLineSetting *u4 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    DTOStandardLineSetting *u5 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    DTOStandardLineSetting *u6 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    DTOStandardLineSetting *u7 = [[DTOStandardLineSetting alloc] initWithTitle:@"" identifier:StandardLineCellIDUser];
    
    u0.color = [UIColor systemGreenColor];
    u1.color = [UIColor blackColor];
    u2.color = [UIColor systemRedColor];
    u3.color = [UIColor systemGreenColor];
    u4.color = [UIColor systemYellowColor];
    u5.color = [UIColor systemGrayColor];
    u6.color = [UIColor systemBrownColor];
    u7.color = [UIColor systemTealColor];
    u0.textInputBtnTitle = @"0";
    u1.textInputBtnTitle = @"0";
    u2.textInputBtnTitle = @"0";
    u3.textInputBtnTitle = @"0";
    u4.textInputBtnTitle = @"0";
    u5.textInputBtnTitle = @"0";
    u6.textInputBtnTitle = @"0";
    u7.textInputBtnTitle = @"0";
    _customSettings = @[u0, u1, u2, u3, u4, u5, u6, u7].mutableCopy;
    for (NSInteger i = 0; i < _customSettings.count; i++) {
        NSString *title = [NSString stringWithFormat:@"사용자 %ld", i + 1];
        _customSettings[i].textFieldPlaceHolderTitle = title;
    
    }
}
- (void)setupTopRealSettings {}
- (void)setupBottomRealSettings {}


#pragma mark - 세터 & 게터

- (void)setOptionalTableType:(StandardLineSettingTableID)optionalTableType {
    if ([optionalTableType isEqualToString:StandardLineSettingTableIDYesterdayToday] ||
        [optionalTableType isEqualToString:StandardLineSettingTableIDPivotDemark] ||
        [optionalTableType isEqualToString:StandardLineSettingTableIDCustom]) {
        _optionalTableType = optionalTableType;
    } else {
        NSCAssert(FALSE, @"적절한 optionalTableType이 아니다.");
    }
}

- (NSArray <NSString *>*)sectionTitles {
    if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDYesterdayToday] ) {
        return @[@"전일", @"당일"];
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDPivotDemark] ) {
        return @[@"Pivot", @"Demark"];
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDCustom] ) {
        return @[@"사용자 정의 기준선"];
    } else {
        NSCAssert(FALSE, @"예상치 못한 값 대입됨");
        return nil;
    }
}

#pragma mark - Actions

- (NSInteger)numberOfTopSections {
    return 1;
}

- (NSInteger)numberOfBottomSections {
    if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDYesterdayToday] == YES) {
        return 2;
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDPivotDemark] == YES) {
        return 2;
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDCustom] == YES) {
        return 1;
    }
    NSCAssert(FALSE, @"예상치 못한갓이 들어왔다.");
    return 0;
}

- (NSInteger)numberOfRowsInTopSection:(NSInteger)section {
    return self.topSettings.count;
}

- (NSInteger)numberOfRowsInBottomSection:(NSInteger)section {
    if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDYesterdayToday] == YES) {
        if (section == 0) {
            return self.yesterdaySettings.count;
        } else if (section == 1) {
            return self.todaySettings.count;
        }
        NSCAssert(FALSE, @"잘못된 값이 들어옴.");
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDPivotDemark] == YES) {
        if (section == 0) {
            return self.pivotSettings.count;
        } else if (section == 1) {
            return self.demarkSettings.count;
        }
        NSCAssert(FALSE, @"잘못된 값이 들어옴.");
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDCustom] == YES) {
        if (section == 0) {
            return self.customSettings.count;
        }
        NSCAssert(FALSE, @"잘못된 값이 들어옴.");
    }
    NSCAssert(FALSE, @"예상치 못한갓이 들어왔다.");
    return 0;
}

- (DTOStandardLineSetting *)topCellModelForIndexPath:(NSIndexPath *)indexPath {
    return self.topSettings[indexPath.row];
}

- (DTOStandardLineSetting *)bottomcellModelForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDYesterdayToday] == YES) {
        if (section == 0) {
            return self.yesterdaySettings[index];
        } else if (section == 1) {
            return self.todaySettings[index];
        }
        NSCAssert(FALSE, @"잘못된 값이 들어옴.");
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDPivotDemark] == YES) {
        if (section == 0) {
            return self.pivotSettings[index];
        } else if (section == 1) {
            return self.demarkSettings[index];
        }
        NSCAssert(FALSE, @"잘못된 값이 들어옴.");
    } else if ([self.optionalTableType isEqualToString:StandardLineSettingTableIDCustom] == YES) {
        if (section == 0) {
            return self.customSettings[index];
        }
        NSCAssert(FALSE, @"잘못된 값이 들어옴.");
    }
    NSCAssert(FALSE, @"예상치 못한갓이 들어왔다.");
    return nil;
}

@end


//! MARK: - DTOStandardLineSetting 클래스

@interface DTOStandardLineSetting ()
@end

@implementation DTOStandardLineSetting
@dynamic dropBtnHidden;

#pragma mark - 생성 & 소멸

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _title = title;
        _identifier = identifier;
    }
    return self;
}

#pragma mark - 세터 & 게터

- (BOOL)dropBtnHidden {
    if ([self.identifier isEqualToString:StandardLineCellIDToggleDrop] == YES &&
        self.isToggleOn == NO) {
        return YES;
    }
    return NO;
}


#pragma mark - NS_UNAVAILABLE

+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
