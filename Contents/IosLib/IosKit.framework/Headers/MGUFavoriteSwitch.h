//
//  MGUFavoriteSwitch.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-03
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUFavoriteSwitchConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGUFavoriteSwitchContentsSize) {
    MGUFavoriteSwitchContentsSizeDefault, // 이미지가 버튼 크기의 반
    MGUFavoriteSwitchContentsSize34th,    // 이미지가 버튼 크기의 3/4
    MGUFavoriteSwitchContentsSizeFull     // 이미지가 버튼 크기와 같음.
};

typedef NS_ENUM(NSInteger, MGUFavoriteSwitchSparkMode) {
    MGUFavoriteSwitchSparkModeline, // 디폴트
    MGUFavoriteSwitchSparkModeShine //
};


IB_DESIGNABLE @interface MGUFavoriteSwitch : UIControl

@property (nonatomic) IBInspectable UIImage *mainImage;
@property (nonatomic, nullable) IBInspectable UIImage *secondaryOnImage;

@property (nonatomic) IBInspectable UIColor *imageColorOn;  // 디폴트 값이 존재한다.
@property (nonatomic) IBInspectable UIColor *imageColorOff; // 디폴트 값이 존재한다.
@property (nonatomic) IBInspectable UIColor *rippleColor;   // 디폴트 값이 존재한다.
@property (nonatomic) IBInspectable UIColor *sparkColor;    // 디폴트 값이 존재한다. line Color 또는 Big Shine Color
@property (nonatomic) IBInspectable UIColor *sparkColor2;   // 디폴트 값이 존재한다. small Shine Color. Shine Mode 일때만 작동함.
@property (nonatomic) IBInspectable BOOL useRandomColorOnShineMode; // 디폴트 값 YES
@property (nonatomic) IBInspectable BOOL useFlashOnShineMode;       // 디폴트 값 YES

@property (nonatomic) IBInspectable CGFloat duration;       // 디폴트 값 1.0

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger contentsSize;
#else
@property (nonatomic, assign) MGUFavoriteSwitchContentsSize contentsSize;
#endif

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger sparkMode;
#else
@property (nonatomic, assign) MGUFavoriteSwitchSparkMode sparkMode;
#endif



- (instancetype)initWithFrame:(CGRect)frame
                    imageType:(MGUFavoriteSwitchImageType)imageType
                  colorConfig:(MGUFavoriteSwitchColorConfiguration * _Nullable)colorConfig NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated notify:(BOOL)notify;

@end

NS_ASSUME_NONNULL_END
