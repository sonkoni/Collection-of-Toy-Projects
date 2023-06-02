//
//  IVDropQuickDisplay.m
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2020/12/22.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "IVDropQuickDisplay.h"
#import "IVDropQuickView.h"

@interface IVDropQuickDisplay ()
@property (nonatomic, strong) IVDropQuickModel *quickModel;
@property (nonatomic, assign) IVDropQuickDisplayType displayType;
@property (nonatomic, assign) CGFloat maxValue;
@end

@implementation IVDropQuickDisplay

#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame quickModel:(IVDropQuickModel *)quickModel {
    self = [super initWithFrame:frame];
    if (self) {
        _quickModel = quickModel;
        CommonInit(self);
    }
    
    return self;
}

static void CommonInit(IVDropQuickDisplay *self) {
    if (self.quickModel.quickType == IVDropQuickTypeDose ||
        self.quickModel.quickType == IVDropQuickTypeMedication ||
        self.quickModel.quickType == IVDropQuickTypeBagVol) {
        self.displayType = IVDropQuickDisplayTypeKeyboard; // 오른쪽에 치우친 밸류라벨 (키보드가 나올는 것들이다.)
    } else if (self.quickModel.quickType == IVDropQuickTypeWeight ||
               self.quickModel.quickType == IVDropQuickTypeChamber) {
        self.displayType = IVDropQuickDisplayTypeDefault; // 중앙에 밸류라벨
    } else if (self.quickModel.quickType == IVDropQuickTypeTime) {
        self.displayType = IVDropQuickDisplayTypeTime; // 중앙에 시간 분 밸류라밸
    }
     
    self->_symbolImageView  = [self setupSymbolImageView];
    self->_titleLabel       = [self setupTitleANDUintLabel];
    
    self->_firstValueLabel  = [self setupValueLabel];
    self->_firstUnitLabel   = [self setupTitleANDUintLabel];
    
    if (self.displayType == IVDropQuickDisplayTypeTime) { // time 일 경우, 시간과 분을 나타태야하므로.
        self->_secondValueLabel = [self setupValueLabel];
        self->_secondUnitLabel  = [self setupTitleANDUintLabel];
    } else if (self.displayType == IVDropQuickDisplayTypeKeyboard) {
        // 글자가 많아 질 경우 조금 크기를 좀 줄여야한다.
        self.firstValueLabel.adjustsFontSizeToFitWidth = YES;
        self.firstValueLabel.minimumScaleFactor = 0.5;
        self.firstValueLabel.textAlignment = NSTextAlignmentRight;
        [self.firstValueLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel
                                                forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    if (self.quickModel.quickType == IVDropQuickTypeDose) {
        self.symbolImageView.image = [UIImage imageNamed:@"36_dose_fill"];
    } else if (self.quickModel.quickType == IVDropQuickTypeMedication) {
        self.symbolImageView.image = [UIImage imageNamed:@"36_medication_fill"];
    } else if (self.quickModel.quickType == IVDropQuickTypeBagVol) {
        self.symbolImageView.image = [UIImage imageNamed:@"36_bag_fill"];
    } else if (self.quickModel.quickType == IVDropQuickTypeWeight) {
        self.symbolImageView.image = [UIImage imageNamed:@"36_weight_fill"];
    } else if (self.quickModel.quickType == IVDropQuickTypeChamber) {
        self.symbolImageView.image = [UIImage imageNamed:@"36_chamber_fill"];
    } else if (self.quickModel.quickType == IVDropQuickTypeTime) {
        self.symbolImageView.image = [UIImage imageNamed:@"36_duration_fill"];
    }
    
    self.titleLabel.text = self.quickModel.title;
    self.firstUnitLabel.text = self.quickModel.unitName;
    [self setupConstraints];
    [self setSourceValue:self.quickModel.value];
}

//! 자신의 라벨을 갱신한다!!
- (void)setSourceValue:(CGFloat)value {
    if (self.quickModel.quickType == IVDropQuickTypeDose) {
        self.firstValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    } else if (self.quickModel.quickType == IVDropQuickTypeMedication) {
        self.firstValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    } else if (self.quickModel.quickType == IVDropQuickTypeBagVol) {
        self.firstValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    } else if (self.quickModel.quickType == IVDropQuickTypeWeight) {
        self.firstValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    } else if (self.quickModel.quickType == IVDropQuickTypeChamber) {
        self.firstValueLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    } else if (self.quickModel.quickType == IVDropQuickTypeTime) {
        NSInteger minuteValue = (NSInteger)value;
        minuteValue = MIN(MAX(minuteValue, 0), self.quickModel.maxValue); // 0 분  24시간까지.
        NSInteger hour = minuteValue / 60;
        NSInteger min = minuteValue % 60;
        if (minuteValue >= 60) { // 시분 둘 다 나오는 경우.
            self.secondValueLabel.hidden = NO;
            self.secondUnitLabel.hidden = NO;
            self.firstUnitLabel.text = @"hr";
            self.secondUnitLabel.text = @"min";
            self.firstValueLabel.text = [NSString stringWithFormat:@"%d", (int)hour];
            self.secondValueLabel.text = [NSString stringWithFormat:@"%d", (int)min];
        } else { // 분만 나올경우.
            self.secondValueLabel.hidden = YES;
            self.secondUnitLabel.hidden = YES;
            self.firstValueLabel.text = [NSString stringWithFormat:@"%d", (int)min];
            self.firstUnitLabel.text = @"min";
        }
    }
}

//! self.quickModel의 value를 먼저 고쳐줘야한다.
- (void)setFirstValueString:(NSString *)str1 secondValueString:(NSString *)str2 {
    self.firstValueLabel.text = str1;
    self.secondValueLabel.text = str2;
    if (self.quickModel.quickType == IVDropQuickTypeTime) {
        NSInteger minuteValue = self.quickModel.value;
        minuteValue = MIN(MAX(minuteValue, 0), self.quickModel.maxValue); // 0 분  24시간까지.
        if (minuteValue >= 60) { // 시분 둘 다 나오는 경우.
            self.secondValueLabel.hidden = NO;
            self.secondUnitLabel.hidden = NO;
            self.firstUnitLabel.text = @"hr";
            self.secondUnitLabel.text = @"min";
        } else { // 분만 나올경우.
            self.secondValueLabel.hidden = YES;
            self.secondUnitLabel.hidden = YES;
            self.firstUnitLabel.text = @"min";
        }
    }
}

- (UIImageView *)setupSymbolImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.tintColor = [UIColor secondaryLabelColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (UILabel *)setupTitleANDUintLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    label.textColor = [UIColor secondaryLabelColor];
    [self addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UILabel *)setupValueLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont monospacedDigitSystemFontOfSize:28.0f weight:UIFontWeightRegular];
    label.textColor = [UIColor labelColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)setupConstraints {
    [self.symbolImageView mgrPinFixSize:CGSizeMake(34.0, 34.0)];
    [self.symbolImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:24.0].active = YES;
    [self.symbolImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.symbolImageView.trailingAnchor
                                                  constant:15.0].active = YES;
    [self.titleLabel.firstBaselineAnchor constraintEqualToAnchor:self.firstValueLabel.firstBaselineAnchor].active = YES;
    [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.firstUnitLabel.centerYAnchor].active = YES;
    
    if (self.displayType == IVDropQuickDisplayTypeDefault) {
        [self.firstValueLabel mgrPinCenterToSuperviewCenter];
        [self.firstValueLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.2].active = YES;
        [self.firstUnitLabel.leadingAnchor constraintEqualToAnchor:self.firstValueLabel.trailingAnchor
                                                          constant:10.0].active = YES;
    } else if (self.displayType == IVDropQuickDisplayTypeKeyboard) {
        [self.firstValueLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [self.firstValueLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor
                                                           constant:15.0].active = YES;
        [self.firstUnitLabel.leadingAnchor constraintEqualToAnchor:self.firstValueLabel.trailingAnchor
                                                          constant:10.0].active = YES;
        [self.trailingAnchor constraintEqualToAnchor:self.firstUnitLabel.trailingAnchor
                                                          constant:24.0].active = YES;
        
    } else { // 타임.
        [self.firstValueLabel mgrPinCenterToSuperviewCenter];
        [self.firstValueLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.1].active = YES;
        [self.firstUnitLabel.leadingAnchor constraintEqualToAnchor:self.firstValueLabel.trailingAnchor
                                                          constant:10.0].active = YES;
        [self.secondValueLabel.leadingAnchor constraintEqualToAnchor:self.firstUnitLabel.trailingAnchor
                                                            constant:15.0].active = YES;
        [self.secondValueLabel.centerYAnchor constraintEqualToAnchor:self.firstValueLabel.centerYAnchor].active = YES;
        [self.secondValueLabel.widthAnchor constraintEqualToAnchor:self.firstValueLabel.widthAnchor].active = YES;
        [self.secondUnitLabel.leadingAnchor constraintEqualToAnchor:self.secondValueLabel.trailingAnchor
                                                           constant:10.0].active = YES;
        [self.secondUnitLabel.centerYAnchor constraintEqualToAnchor:self.firstUnitLabel.centerYAnchor].active = YES;
    }
    
}

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
    NSCAssert(FALSE, @"- initWithCoder: 사용금지.");
    return nil;
}

@end
