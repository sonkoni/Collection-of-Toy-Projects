//
//  MGUButtonConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUButtonConfiguration.h"
#import "MGUButton.h"

#pragma mark - MGUButton 클래스 private
@interface MGUButton ()
@property (nonatomic, strong) CALayer *rippleLayer;
@property (nonatomic, strong, nullable) UIImage *mainImage;
@property (nonatomic, strong, nullable) UIImage *alternativeImage;
@end


#pragma mark - MGUButtonConfiguration 클래스
@interface MGUButtonConfiguration ()
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL continuousPressIsPossible; // 디폴트 NO, long press 시, 일정한 간격으로 반복적 호출
@property (nonatomic, assign) NSTimeInterval continuousPressRepeatTimeInterval;
@property (nonatomic, assign) NSTimeInterval continuousPressDelay;
@property (nonatomic, assign) BOOL breadEffect;    // 디폴트 NO
@property (nonatomic, assign) BOOL shrinkEffect;   // 디폴트 NO
@property (nonatomic, assign) BOOL isRippleCircle; // 디폴트 YES
@property (nonatomic, strong) UIColor *rippleColor; //breadEffect, shrinkEffect에 디폴트 gray alpha 0.2

@property (nonatomic, strong) UIFont *buttonTitleLabelFont;

/* 색깔 설정관련 **/
@property (nonatomic, strong) UIColor *buttonBackgroundColor;            // Enable - Normal
@property (nonatomic, strong) UIColor *buttonContentsColor;              // Enable - Normal
@property (nonatomic, strong) UIColor *highlightedButtonBackgroundColor; // Enable - Highlighted
@property (nonatomic, strong) UIColor *highlightedButtonContentsColor;   // Enable - Highlighted
@property (nonatomic, strong) UIColor *selectedButtonBackgroundColor; // Enable - Selected
@property (nonatomic, strong) UIColor *selectedButtonContentsColor;   // Enable - Selected
@property (nonatomic, strong) UIColor *disabledButtonBackgroundColor;    // Disabled
@property (nonatomic, strong) UIColor *disabledButtonContentsColor;      // Disabled
@property (nonatomic, strong) UIColor *buttonShadowColor;                // 디폴트 clear
@property (nonatomic, strong) UIColor *borderColor;                      // 디폴트 clear

@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong, nullable) UIImage *mainImage;
@property (nonatomic, strong, nullable) UIImage *alternativeImage;

@end
@implementation MGUButtonConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUButtonConfiguration *self) {
    self->_cornerRadius = 1.0;
    self->_continuousPressIsPossible = NO;
    self->_continuousPressRepeatTimeInterval = 0.15;
    self->_continuousPressDelay = 0.3;
    self->_breadEffect = NO;
    self->_shrinkEffect = NO;
    self->_isRippleCircle = YES;
    self->_rippleColor = [UIColor.grayColor colorWithAlphaComponent:0.2];
    self->_buttonTitleLabelFont = [UIFont systemFontOfSize:18.0];
    self->_buttonBackgroundColor = UIColor.whiteColor;
    self->_buttonContentsColor   = UIColor.blackColor;
    self->_highlightedButtonBackgroundColor = UIColor.grayColor;
    self->_highlightedButtonContentsColor   = UIColor.lightGrayColor;
    self->_selectedButtonBackgroundColor    = UIColor.clearColor;
    self->_selectedButtonContentsColor      = UIColor.blackColor;
    self->_disabledButtonBackgroundColor    = UIColor.darkGrayColor;
    self->_disabledButtonContentsColor      = UIColor.blackColor;
    self->_buttonShadowColor = UIColor.clearColor;
    self->_borderColor       = UIColor.clearColor;
    
    self->_shadowOffset  = CGSizeMake(0, 1.0);
    self->_shadowRadius  = 0.0;
    self->_shadowOpacity = 1.0;
    self->_borderWidth   = 0.5;
}


#pragma mark - 생성 & 소멸 메서드
+ (MGUButtonConfiguration *)defaultConfiguration {
    return [[MGUButtonConfiguration alloc] init];
}

+ (MGUButtonConfiguration *)standardPlayPauseConfiguration {
    MGUButtonConfiguration *configuration = [[MGUButtonConfiguration alloc] init];
    configuration.shrinkEffect = YES;
    configuration.buttonBackgroundColor = UIColor.clearColor;
    configuration.highlightedButtonBackgroundColor = UIColor.clearColor;
    configuration.highlightedButtonContentsColor   = UIColor.blackColor;
    
    if (@available(iOS 13, *)) {
        configuration.mainImage = [MGUButtonConfiguration standardPlayImage];
        configuration.alternativeImage = [MGUButtonConfiguration standardPauseImage];
    } else {
        configuration.mainImage = [UIImage new];
        configuration.alternativeImage = [UIImage new];
    }
    
    return configuration;
}

+ (MGUButtonConfiguration *)standardBackwardConfiguration {
    MGUButtonConfiguration *configuration = [MGUButtonConfiguration standardPlayPauseConfiguration];
    
    if (@available(iOS 13, *)) {
        configuration.mainImage = [MGUButtonConfiguration standardBackwardImage];
        configuration.alternativeImage = nil;
    } else {
        configuration.mainImage = [UIImage new];
        configuration.alternativeImage = nil;
    }
    
    return configuration;
}

+ (MGUButtonConfiguration *)standardForwardConfiguration {
    MGUButtonConfiguration *configuration = [MGUButtonConfiguration standardPlayPauseConfiguration];
    
    if (@available(iOS 13, *)) {
        configuration.mainImage = [MGUButtonConfiguration standardForwardImage];
        configuration.alternativeImage = nil;
    } else {
        configuration.mainImage = [UIImage new];
        configuration.alternativeImage = nil;
    }
    
    return configuration;
}

- (void)applyConfigurationOnMGUButton:(MGUButton *)button {
    button.cornerRadius = self.cornerRadius;
    button.continuousPressIsPossible = self.continuousPressIsPossible;
    button.continuousPressRepeatTimeInterval = self.continuousPressRepeatTimeInterval;
    button.continuousPressDelay = self.continuousPressDelay;
    button.breadEffect = self.breadEffect;
    button.shrinkEffect = self.shrinkEffect;
    button.isRippleCircle = self.isRippleCircle;
    button.rippleColor = self.rippleColor;
    button.buttonTitleLabelFont = self.buttonTitleLabelFont;
    button.buttonBackgroundColor = self.buttonBackgroundColor;
    button.buttonContentsColor   = self.buttonContentsColor;
    button.highlightedButtonBackgroundColor = self.highlightedButtonBackgroundColor;
    button.highlightedButtonContentsColor   = self.highlightedButtonContentsColor;
    button.selectedButtonBackgroundColor    = self.selectedButtonBackgroundColor;
    button.selectedButtonContentsColor      = self.selectedButtonContentsColor;
    button.disabledButtonBackgroundColor    = self.disabledButtonBackgroundColor;
    button.disabledButtonContentsColor      = self.disabledButtonContentsColor;
    button.buttonShadowColor = self.buttonShadowColor;
    button.borderColor       = self.borderColor;
    
    button.rippleLayer.backgroundColor = self.rippleColor.CGColor;
    button.layer.shadowOffset  = self.shadowOffset;
    button.layer.shadowRadius  = self.shadowRadius;
    button.layer.shadowOpacity = self.shadowOpacity;
    button.layer.shadowColor   = self.buttonShadowColor.CGColor;
    button.layer.cornerRadius  = self.cornerRadius;
    button.layer.borderWidth   = self.borderWidth   = 0.5f;
    button.layer.borderColor   = self.borderColor.CGColor;
    
    button.mainImage          = self.mainImage;
    button.alternativeImage   = self.alternativeImage;
    
    [button updateButtonAppearance];
    
    if (self.mainImage != nil) {
        [button setImage:button.mainImage forState:UIControlStateNormal];
    }
}



#pragma mark - 버튼에 들어갈 편의 이미지들.
+ (UIImage *)standardPlayImage API_AVAILABLE(ios(13.0)) {
    UIImageSymbolConfiguration *playPause =
    [UIImageSymbolConfiguration configurationWithPointSize:26.5
                                                    weight:UIImageSymbolWeightBold
                                                     scale:UIImageSymbolScaleLarge];
    
    return [UIImage systemImageNamed:@"play.fill" withConfiguration:playPause];
}

+ (UIImage *)standardPauseImage API_AVAILABLE(ios(13.0)) {
    UIImageSymbolConfiguration *playPause =
    [UIImageSymbolConfiguration configurationWithPointSize:26.5
                                                    weight:UIImageSymbolWeightBold
                                                     scale:UIImageSymbolScaleLarge];
    
    return [UIImage systemImageNamed:@"pause.fill" withConfiguration:playPause];
}

+ (UIImage *)standardBackwardImage API_AVAILABLE(ios(13.0)) {
    UIImageSymbolConfiguration *backwardForward =
    [UIImageSymbolConfiguration configurationWithPointSize:17.0
                                                    weight:UIImageSymbolWeightBold
                                                     scale:UIImageSymbolScaleLarge];
    
    return [UIImage systemImageNamed:@"backward.fill" withConfiguration:backwardForward];
}

+ (UIImage *)standardForwardImage API_AVAILABLE(ios(13.0)) {
    UIImageSymbolConfiguration *backwardForward =
    [UIImageSymbolConfiguration configurationWithPointSize:17.0
                                                    weight:UIImageSymbolWeightBold
                                                     scale:UIImageSymbolScaleLarge];
    
    return [UIImage systemImageNamed:@"forward.fill" withConfiguration:backwardForward];
}



@end
