//
//  MGASevenSwitchConfiguration.h
//
//  Created by Kwan Hyun Son on 2022/04/20.
//

#import <Cocoa/Cocoa.h>
@class MGASevenSwitch;

NS_ASSUME_NONNULL_BEGIN

@interface MGASevenSwitchConfiguration : NSObject

@property (nonatomic, strong) NSColor *offTintColor;
@property (nonatomic, strong) NSColor *onTintColor;
@property (nonatomic, strong) NSColor *onThumbTintColor;  // 디폴트 whiteColor
@property (nonatomic, strong) NSColor *offThumbTintColor; // 디폴트 whiteColor
@property (nonatomic, strong) NSColor *onBorderColor;
@property (nonatomic, strong) NSColor *offBorderColor;    // 디폴트 [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0] 회색빛
@property (nonatomic, strong) NSColor *decoLayerColor;    // off(정지 상태)에서의 데코뷰의 칼라.
@property (nonatomic, assign, getter = isHandCursorType) BOOL handCursorType; // 👆 디폴트는 YES

//@property (nonatomic) UIColor *shadowColor;       // grayColor
//@property (nonatomic, strong, nullable) UIImage *knobImage;
//@property (nonatomic, strong, nullable) UIImage *onImage;
//@property (nonatomic, strong, nullable) UIImage *offImage;
//@property (nonatomic) NSString *onLabelTitle;
//@property (nonatomic) NSString *offLabelTitle;
//@property (nonatomic) NSTextAlignment onLabelTextAlignment;
//@property (nonatomic) NSTextAlignment offLabelTextAlignment;
//@property (nonatomic) UIColor *onLabelTextColor;
//@property (nonatomic) UIColor *offLabelTextColor;
//@property (nonatomic) UIFont *onLabelTextFont;
//@property (nonatomic) UIFont *offLabelTextFont;

+ (MGASevenSwitchConfiguration *)defaultConfiguration;

//! 코드로 초기화 할때 사용한다.
- (void)apply:(MGASevenSwitch *)sevenSwitch;

//! XIB로 초기화 할때 사용한다.
- (void)applyWithNIB:(MGASevenSwitch *)sevenSwitch;
@end

NS_ASSUME_NONNULL_END
