//
//  MGULivelyButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//
// FRDLivelyButton - objective - C 를 베이스로 만들었다.
// https://github.com/sebastienwindal/FRDLivelyButton
// https://github.com/yannickl/DynamicButton
// https://github.com/victorBaro/VBFPopFlatButton

#import <IosKit/MGULivelyButtonConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGULivelyButtonStyle) {
    MGULivelyButtonStyleNone,        /// No style
    MGULivelyButtonStyleHamburger,   /// Hamburger button style: ≡
    MGULivelyButtonStyleClose,       /// Close symbol style: X
    MGULivelyButtonStylePlus,        /// Plus symbol: +
    MGULivelyButtonStyleCirclePlus,  /// Plus symbol surrounded by a circle: ⨁
    MGULivelyButtonStyleCircleClose, /// Close symbol surrounded by a circle: ⨂
    MGULivelyButtonStyleCaretUp,     /// Up caret: ⌃
    MGULivelyButtonStyleCaretDown,   /// Down caret: ⋁
    MGULivelyButtonStyleCaretLeft,   /// Left caret: <
    MGULivelyButtonStyleCaretRight,  /// Right caret: >
    MGULivelyButtonStyleCheckMark,   /// Check mark: ✓
    MGULivelyButtonStyleArrowLeft,   /// Leftwards arrow: ←
    MGULivelyButtonStyleArrowRight,  /// Rightwards arrow: →
    MGULivelyButtonStyleArrowUp,     /// Upwards arrow: ↑
    MGULivelyButtonStyleArrowDown,   /// Downwards arrow: ↓
    MGULivelyButtonStyleDownLoad,    /// Downwards triangle-headed arrow to bar: ⤓
    MGULivelyButtonStylePause,       /// Pause symbol: ‖
    MGULivelyButtonStylePlay,        /// Play symbol: ► \{U+25B6}
    MGULivelyButtonStyleStop,        /// Stop symbol: ◼ \{U+2588}
    MGULivelyButtonStyleRewind,      /// Rewind symbol: ≪
    MGULivelyButtonStyleFastForward, /// Fast forward: ≫
    MGULivelyButtonStyleDot,                   /// Dot symbol: .
    MGULivelyButtonStyleHorizontalMoreOptions, /// Horizontal more options: …
    MGULivelyButtonStyleVerticalMoreOptions,   /// Vertical more options: ⋮
    MGULivelyButtonStyleHorizontalLine,        /// Horizontal line: ―
    MGULivelyButtonStyleVerticalLine,          /// Vertical line: |
    MGULivelyButtonStyleReload,                /// Reload symbol: ↻
    MGULivelyButtonStyleLocation               /// Location: ⌖
};

IB_DESIGNABLE @interface MGULivelyButton : UIButton

@property (nonatomic, strong, nullable) MGULivelyButtonConfiguration *config; // 설정에 해당하는 객체이다.

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger buttonStyle;
#else
@property (nonatomic, assign) MGULivelyButtonStyle buttonStyle; // set은 setStyle:animated: animated = NO와 같다.
#endif

- (void)setStyle:(MGULivelyButtonStyle)style animated:(BOOL)animated;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(MGULivelyButtonStyle)style
                configuration:(MGULivelyButtonConfiguration * _Nullable)configuration;
@end

NS_ASSUME_NONNULL_END
