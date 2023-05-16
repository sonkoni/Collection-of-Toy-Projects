//
//  MGAStepperConfiguration.m
//  MGUStepperExample
//
//  Created by Kwan Hyun Son on 2022/11/02.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAStepperConfiguration.h"

@interface MGAStepperConfiguration ()
@end

@implementation MGAStepperConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
    /** ❊ 중요 : super의 - isEqual: 메서드가 pointer 값의 동일성 비교결과라면 호출금지다.
     super의 - isEqual:이 pointer 값의 동일성 비교결과가 아니라면 주석 부분을 풀어준다.
    if ([super isEqual:object] == NO) {
        return NO;
    }
    */
    
    return [self isEqualToStepperConfiguration:(__typeof(self))object];
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    /** ❊ 중요 : super의 - hash 메서드가 pointer 값이라면 호출금지다.
     super의 - hash가 pointer 값이 아니라면 아니라면 주석 부분을 풀어준다.
     NSUInteger result = [super hash];
    */

    //! 스칼라.
    NSUInteger result = [[NSNumber numberWithDouble:_value] hash];
    result = prime * result + [[NSNumber numberWithDouble:_minimumValue] hash];
    result = prime * result + [[NSNumber numberWithDouble:_maximumValue] hash];
    result = prime * result + [[NSNumber numberWithDouble:_stepValue] hash];
    result = prime * result + [[NSNumber numberWithBool:_showIntegerIfDoubleIsInteger] hash];
    result = prime * result + [[NSNumber numberWithBool:_autorepeat] hash];
    result = prime * result + [[NSNumber numberWithDouble:_cornerRadius] hash];
    result = prime * result + [[NSNumber numberWithDouble:_borderWidth] hash];
    result = prime * result + [[NSNumber numberWithDouble:_separatorWidth] hash];
    result = prime * result + [[NSNumber numberWithDouble:_separatorHeightRatio] hash];
    result = prime * result + [[NSNumber numberWithUnsignedInteger:_stepperLabelType] hash];
    result = prime * result + [[NSNumber numberWithBool:_isStaticLabelTitle] hash];
    result = prime * result + [[NSNumber numberWithDouble:_labelCornerRadius] hash];
    result = prime * result + [[NSNumber numberWithDouble:_labelWidthRatio] hash];
    result = prime * result + [[NSValue valueWithSize:_intrinsicContentSize] hash];
    
    //! 객체
    result = prime * result + [_borderColor hash];
    result = prime * result + [_fullColor hash];
    result = prime * result + [_separatorColor hash];
    result = prime * result + [_buttonsBackgroundColor hash];
    result = prime * result + [_limitHitAnimationColor hash];
    result = prime * result + [_leftNormalImage hash];
    result = prime * result + [_leftDisabledImage hash];
    result = prime * result + [_rightNormalImage hash];
    result = prime * result + [_rightDisabledImage hash];
    result = prime * result + [_buttonsContensColor hash];
    result = prime * result + [_buttonsFont hash];
    result = prime * result + [_impactColor hash];
    result = prime * result + [_labelTextColor hash];
    result = prime * result + [_labelBackgroundColor hash];
    result = prime * result + [_labelFont hash];
    result = prime * result + [_items hash];
    
    return result;
}


#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    //! super(NSObject)가 <NSCopying> 프로토콜을 따르지 않으므로 [[[self class] allocWithZone:zone] init];을 호출함
    //! 그렇지 않은 경우. [super copyWithZone:zone];
    MGAStepperConfiguration *configuration = [[[self class] allocWithZone:zone] init];
    
    if (configuration) {
        /** 스칼라 : 언제나 딥카피이다. **/
        configuration->_value = _value;
        configuration->_minimumValue = _minimumValue;
        configuration->_maximumValue = _maximumValue;
        configuration->_stepValue = _stepValue;
        configuration->_showIntegerIfDoubleIsInteger = _showIntegerIfDoubleIsInteger;
        configuration->_autorepeat = _autorepeat;
        configuration->_cornerRadius = _cornerRadius;
        configuration->_borderWidth = _borderWidth;
        configuration->_separatorWidth = _separatorWidth;
        configuration->_separatorHeightRatio = _separatorHeightRatio;
        configuration->_stepperLabelType = _stepperLabelType;
        configuration->_isStaticLabelTitle = _isStaticLabelTitle;
        configuration->_labelCornerRadius = _labelCornerRadius;
        configuration->_labelWidthRatio = _labelWidthRatio;
        configuration->_intrinsicContentSize = _intrinsicContentSize;
            
        /** 객체 : 딥카피 또는 쉘로우 카피. 객체에서 스칼라의 형식은 쉘로우 카피가 된다. **/
        configuration->_borderColor = [_borderColor copyWithZone:zone]; // 객체에서의 딥 카피이다.
        // configuration->_borderColor = _borderColor; // 객체에서의 쉘로우 카피이다.
        configuration->_fullColor = [_fullColor copyWithZone:zone];
        configuration->_separatorColor = [_separatorColor copyWithZone:zone];
        configuration->_buttonsBackgroundColor = [_buttonsBackgroundColor copyWithZone:zone];
        configuration->_limitHitAnimationColor = [_limitHitAnimationColor copyWithZone:zone];
        configuration->_leftNormalImage = _leftNormalImage; // - copyWithZone를 구현 안함. <NOCopying> 따르지 않는다.
        configuration->_leftDisabledImage = _leftDisabledImage;
        configuration->_rightNormalImage = _rightNormalImage;
        configuration->_rightDisabledImage = _rightDisabledImage;
        configuration->_buttonsContensColor = [_buttonsContensColor copyWithZone:zone];
        configuration->_buttonsFont = [_buttonsFont copyWithZone:zone];
        configuration->_impactColor = [_impactColor copyWithZone:zone];
            
        configuration->_labelTextColor = [_labelTextColor copyWithZone:zone];
        configuration->_labelBackgroundColor = [_labelBackgroundColor copyWithZone:zone];
        configuration->_labelFont = [_labelFont copyWithZone:zone];
        configuration->_items = [_items mutableCopyWithZone:zone]; // mutable array이므로
        
    }

    return configuration;
}


#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToStepperConfiguration:(MGAStepperConfiguration *)stepperConfiguration {
    if (self == stepperConfiguration) {
        return YES;
    }

    if (stepperConfiguration == nil) {
        return NO;
    }

    //! 스칼라일 경우는 단순히 둘만 비교해도 된다.
    BOOL haveEqualValue = (self.value == stepperConfiguration.value);
    BOOL haveEqualMinimumValue = (self.minimumValue == stepperConfiguration.minimumValue);
    BOOL haveEqualMaximumValue = (self.maximumValue == stepperConfiguration.maximumValue);
    BOOL haveEqualStepValue = (self.stepValue == stepperConfiguration.stepValue);
    BOOL haveEqualShowIntegerIfDoubleIsInteger =
    (self.showIntegerIfDoubleIsInteger == stepperConfiguration.showIntegerIfDoubleIsInteger);
    BOOL haveEqualAutorepeat = (self.autorepeat == stepperConfiguration.autorepeat);
    BOOL haveEqualCornerRadius = (self.cornerRadius == stepperConfiguration.cornerRadius);
    BOOL haveEqualBorderWidth = (self.borderWidth == stepperConfiguration.borderWidth);
    BOOL haveEqualSeparatorWidth = (self.separatorWidth == stepperConfiguration.separatorWidth);
    BOOL haveEqualSeparatorHeightRatio = (self.separatorHeightRatio == stepperConfiguration.separatorHeightRatio);
    BOOL haveEqualStepperLabelType = (self.stepperLabelType == stepperConfiguration.stepperLabelType);
    BOOL haveEqualIsStaticLabelTitle = (self.isStaticLabelTitle == stepperConfiguration.isStaticLabelTitle);
    BOOL haveEqualLabelCornerRadius = (self.labelCornerRadius == stepperConfiguration.labelCornerRadius);
    BOOL haveEqualLabelWidthRatio = (self.labelWidthRatio == stepperConfiguration.labelWidthRatio);
    BOOL haveEqualIntrinsicContentSize =
    CGSizeEqualToSize(self.intrinsicContentSize, stepperConfiguration.intrinsicContentSize);
    
    //! 객체 경우는 객체가 둘다 nil이면 같은 것으로 보는 것이 옳다.
    BOOL haveEqualBorderColor = (!self.borderColor && !stepperConfiguration.borderColor) || [self.borderColor isEqual:stepperConfiguration.borderColor];
    BOOL haveEqualFullColor = (!self.fullColor && !stepperConfiguration.fullColor) || [self.fullColor isEqual:stepperConfiguration.fullColor];
    BOOL haveEqualSeparatorColor = (!self.separatorColor && !stepperConfiguration.separatorColor) || [self.separatorColor isEqual:stepperConfiguration.separatorColor];
    BOOL haveEqualButtonsBackgroundColor = (!self.buttonsBackgroundColor && !stepperConfiguration.buttonsBackgroundColor) || [self.buttonsBackgroundColor isEqual:stepperConfiguration.buttonsBackgroundColor];
    BOOL haveEqualLimitHitAnimationColor = (!self.limitHitAnimationColor && !stepperConfiguration.limitHitAnimationColor) || [self.limitHitAnimationColor isEqual:stepperConfiguration.limitHitAnimationColor];
    
    //! 이미지는 - copyWithZone:에서 그냥 주소를 때려박으므로. 스칼라식으로 비교하자.
    BOOL haveEqualLeftNormalImage = (self.leftNormalImage == stepperConfiguration.leftNormalImage);
    BOOL haveEqualLeftDisabledImage = (self.leftDisabledImage == stepperConfiguration.leftDisabledImage);
    BOOL haveEqualRightNormalImage = (self.rightNormalImage == stepperConfiguration.rightNormalImage);
    BOOL haveEqualRightDisabledImage = (self.rightDisabledImage == stepperConfiguration.rightDisabledImage);
    
    BOOL haveEqualButtonsContensColor = (!self.buttonsContensColor && !stepperConfiguration.buttonsContensColor) || [self.buttonsContensColor isEqual:stepperConfiguration.buttonsContensColor];
    BOOL haveEqualButtonsFont = (!self.buttonsFont && !stepperConfiguration.buttonsFont) || [self.buttonsFont isEqual:stepperConfiguration.buttonsFont];
    BOOL haveEqualImpactColor = (!self.impactColor && !stepperConfiguration.impactColor) || [self.impactColor isEqual:stepperConfiguration.impactColor];
    
    BOOL haveEqualLabelTextColor = (!self.labelTextColor && !stepperConfiguration.labelTextColor) || [self.labelTextColor isEqual:stepperConfiguration.labelTextColor];
    BOOL haveEqualLabelBackgroundColor = (!self.labelBackgroundColor && !stepperConfiguration.labelBackgroundColor) || [self.labelBackgroundColor isEqual:stepperConfiguration.labelBackgroundColor];
    BOOL haveEqualLabelFont = (!self.labelFont && !stepperConfiguration.labelFont) || [self.labelFont isEqual:stepperConfiguration.labelFont];
    BOOL haveEqualItems = (!self.items && !stepperConfiguration.items) || [self.items isEqual:stepperConfiguration.items];
    
    return haveEqualValue && haveEqualMinimumValue && haveEqualMaximumValue && haveEqualStepValue && haveEqualShowIntegerIfDoubleIsInteger && haveEqualAutorepeat && haveEqualCornerRadius && haveEqualBorderWidth && haveEqualSeparatorWidth && haveEqualSeparatorHeightRatio && haveEqualStepperLabelType && haveEqualIsStaticLabelTitle && haveEqualLabelCornerRadius && haveEqualLabelWidthRatio&& haveEqualIntrinsicContentSize && haveEqualBorderColor && haveEqualFullColor && haveEqualSeparatorColor && haveEqualButtonsBackgroundColor && haveEqualLimitHitAnimationColor && haveEqualLeftNormalImage && haveEqualLeftDisabledImage && haveEqualRightNormalImage && haveEqualRightDisabledImage&& haveEqualButtonsContensColor && haveEqualButtonsFont&& haveEqualImpactColor && haveEqualLabelTextColor && haveEqualLabelBackgroundColor && haveEqualLabelFont && haveEqualItems;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGAStepperConfiguration *self) {
    self->_value = 0.0f;
    self->_minimumValue = 0.0f;
    self->_maximumValue = 100.0f;
    self->_stepValue = 1.0f;
    self->_showIntegerIfDoubleIsInteger = YES;
    
    self->_autorepeat = YES;
    self->_cornerRadius = 7.0;
    self->_borderWidth = 0.0f;
    self->_borderColor = NSColor.clearColor;
    self->_fullColor = [NSColor colorWithRed:0.21 green:0.5 blue:0.74 alpha:1.0];
    
    self->_separatorColor = NSColor.clearColor;
    self->_separatorWidth = 1.0f;
    self->_separatorHeightRatio = 0.55;
    
    self->_buttonsBackgroundColor = [NSColor colorWithRed:0.21 green:0.5 blue:0.74 alpha:1.0];
    self->_limitHitAnimationColor = [NSColor colorWithRed:0.26 green:0.6 blue:0.87 alpha:1.0];
    
    NSImageSymbolConfiguration *normalConfiguration =
    [NSImageSymbolConfiguration configurationWithPointSize:17.0
                                                    weight:NSFontWeightRegular
                                                     scale:NSImageSymbolScaleMedium];
    
//    NSImageSymbolConfiguration *disabledConfiguration =
//    [NSImageSymbolConfiguration configurationWithPointSize:17.0
//                                                    weight:NSImageSymbolWeightThin // NSImageSymbolWeightLight 중간쯤.
//                                                     scale:NSImageSymbolScaleMedium];
    NSImage *leftNormalImage = [NSImage imageWithSystemSymbolName:@"minus" accessibilityDescription:@""];
    self->_leftNormalImage = [leftNormalImage imageWithSymbolConfiguration:normalConfiguration];
//    _leftDisabledImage = [NSImage systemImageNamed:@"minus" withConfiguration:disabledConfiguration];
    
    NSImage *rightNormalImage = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:@""];
    self->_rightNormalImage = [rightNormalImage imageWithSymbolConfiguration:normalConfiguration];
//    _rightDisabledImage = [NSImage systemImageNamed:@"plus" withConfiguration:disabledConfiguration];
    
    self->_buttonsContensColor = NSColor.whiteColor;
    self->_buttonsFont = [NSFont fontWithName:@"AvenirNext-Bold" size:20.0];
    self->_impactColor = [NSColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    
    self->_stepperLabelType = MGAStepperLabelTypeShowDraggable;
    
    self->_labelTextColor = NSColor.whiteColor;
    self->_labelBackgroundColor = [NSColor colorWithRed:0.26 green:0.6 blue:0.87 alpha:1.0];
    self->_labelFont = [NSFont fontWithName:@"AvenirNext-Bold" size:25.0];
    self->_labelWidthRatio = 0.5;
    self->_labelCornerRadius = 0.0;
    
    self->_isStaticLabelTitle = NO; // 즉, 스텝퍼의 value에 따라 라벨도 갱신하라는 뜻이다
    self->_items = [NSMutableArray array];
    
    self->_intrinsicContentSize = CGSizeZero;
}


#pragma mark - convenience
+ (instancetype)defaultConfiguration {
    return [[MGAStepperConfiguration alloc] init];
}

+ (instancetype)iOS13Configuration {
    MGAStepperConfiguration *configuration = [[MGAStepperConfiguration alloc] init];
    configuration.cornerRadius = 7.0;
    configuration.borderWidth = 0.0f;
    configuration.borderColor = [NSColor clearColor];
    configuration.fullColor =
    [NSColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:239.0/255.0 alpha:1.0];
    
    configuration.separatorColor =
    [NSColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:217.0/255.0 alpha:1.0];
    configuration.separatorWidth = 1.0f;
    configuration.separatorHeightRatio = 0.55;
    
    configuration.buttonsBackgroundColor = [NSColor clearColor];
    configuration.limitHitAnimationColor = [NSColor clearColor];
    configuration.buttonsContensColor = [NSColor blackColor];
    configuration.buttonsFont = [NSFont fontWithName:@"AvenirNext-Bold" size:20.0];
    configuration.impactColor = [NSColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    
    configuration.stepperLabelType = MGAStepperLabelTypeHidden;
    configuration.intrinsicContentSize = CGSizeMake(94.0, 32.0);
    configuration.leftDisabledImage = nil;
    configuration.rightDisabledImage = nil;
    //! 하이라이트 애니메이션 크기변화 (0.85 X 0.75) => (1.0 X 1.0)
    return configuration;
}

+ (instancetype)iOS7Configuration {
    MGAStepperConfiguration *configuration = [[MGAStepperConfiguration alloc] init];
    configuration.cornerRadius = 3.0;
    configuration.borderWidth = 1.0f;
    configuration.borderColor = [NSColor systemBlueColor];
    configuration.fullColor =
    [NSColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    configuration.separatorColor = [NSColor systemBlueColor];
    configuration.separatorWidth = 1.0f;
    configuration.separatorHeightRatio = 1.0;
    
    configuration.buttonsBackgroundColor = [NSColor clearColor];
    configuration.limitHitAnimationColor = [NSColor clearColor];
    configuration.buttonsContensColor = [NSColor systemBlueColor];
    configuration.buttonsFont = [NSFont fontWithName:@"AvenirNext-Bold" size:20.0];
    configuration.impactColor = [NSColor colorWithRed:217.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    configuration.stepperLabelType = MGAStepperLabelTypeHidden;
    configuration.intrinsicContentSize = CGSizeMake(94.0, 29.0);
    configuration.leftDisabledImage = nil;
    configuration.rightDisabledImage = nil;
    //! 하이라이트 애니메이션 크기변화 (0.85 X 0.75) => (1.0 X 1.0)
    return configuration;
}

+ (instancetype)forgeDropConfiguration {
    MGAStepperConfiguration *configuration = [[MGAStepperConfiguration alloc] init];
    configuration.cornerRadius = 7.0;
    configuration.borderWidth = 0.0f;
    configuration.borderColor = [NSColor clearColor];
    configuration.fullColor =
        [NSColor colorWithRed:118/255.0 green:118/255.0 blue:128/255.0 alpha:0.12];
    
    configuration.separatorColor = [NSColor quaternaryLabelColor];
    configuration.separatorWidth = 1.0f;
    configuration.separatorHeightRatio = 0.55;
    
    configuration.buttonsBackgroundColor = [NSColor clearColor];
    configuration.limitHitAnimationColor = [NSColor clearColor];
    configuration.buttonsContensColor = [NSColor labelColor];
    configuration.buttonsFont = [NSFont fontWithName:@"AvenirNext-Bold" size:20.0];
    configuration.impactColor = [NSColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    
    configuration.stepperLabelType = MGAStepperLabelTypeShowFixed;
    
    configuration.labelTextColor = [NSColor labelColor];
    configuration.labelBackgroundColor = [NSColor clearColor];
    configuration.labelFont =
        [NSFont preferredFontForTextStyle:NSFontTextStyleTitle1
                                  options:[NSDictionary dictionary]];
    configuration.labelWidthRatio = (1.0 / 3.0);
    configuration.labelCornerRadius = 0.0;
    
    //configuration.intrinsicContentSize = CGSizeMake(141.0, 32.0);
    configuration.intrinsicContentSize = CGSizeMake(128.0, 44.0);
    configuration.leftDisabledImage = nil;
    configuration.rightDisabledImage = nil;
    return configuration;
}

+ (instancetype)forgeDropConfiguration2 {
    MGAStepperConfiguration *configuration = [[MGAStepperConfiguration alloc] init];
    configuration.cornerRadius = 10.0;
    configuration.borderWidth = 0.0f;
    configuration.borderColor = [NSColor clearColor];
    configuration.fullColor = [NSColor colorWithRed:118/255.0 green:118/255.0 blue:128/255.0 alpha:0.12];
    configuration.separatorColor = [NSColor quaternaryLabelColor];
    configuration.separatorWidth = 1.0f;
    configuration.separatorHeightRatio = 0.55;
    
    configuration.buttonsBackgroundColor = [NSColor clearColor];
    configuration.limitHitAnimationColor = [NSColor clearColor];
    configuration.buttonsContensColor = [NSColor labelColor];
    configuration.buttonsFont = [NSFont fontWithName:@"AvenirNext-Bold" size:20.0];
    configuration.impactColor = [NSColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    
    configuration.stepperLabelType = MGAStepperLabelTypeShowFixed;
    
    configuration.labelTextColor = [NSColor tertiaryLabelColor];
    configuration.labelBackgroundColor = [NSColor clearColor];
    configuration.labelFont = [NSFont systemFontOfSize:28.0 weight:NSFontWeightRegular];
    configuration.labelWidthRatio = (1.0 / 3.0);
    configuration.labelCornerRadius = 0.0;
    
    configuration.isStaticLabelTitle = YES;
    configuration.intrinsicContentSize = CGSizeMake(128.0, 44.0);

    configuration.leftDisabledImage = nil;
    configuration.rightDisabledImage = nil;
    
    return configuration;
}

@end
