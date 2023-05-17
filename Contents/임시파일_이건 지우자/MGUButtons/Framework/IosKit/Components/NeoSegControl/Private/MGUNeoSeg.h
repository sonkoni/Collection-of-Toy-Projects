//
//  MGUNeoSeg.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//
// 인디케이터 스테이트, 쉬링크, 하이라이트.

#import <UIKit/UIKit.h>
@class MGUNeoSegConfiguration;
@class MGUNeoSegModel;

typedef NS_ENUM(NSUInteger, MGUNeoSegState) {
    MGUNeoSegStateNoIndicator = 1,      // 인디케이터가 위치하지 않은 곳의 segment 상태
    MGUNeoSegStateIndicator             // 인디케이터가 있는 곳의 segment 상태
};

@interface MGUNeoSeg : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic) BOOL selected;
@property (nonatomic) MGUNeoSegState segmentState;

@property (nonatomic) CGFloat stackViewSpacing;
@property (nonatomic) UILayoutConstraintAxis stackViewAxis;
@property (nonatomic, strong) NSLayoutConstraint *imageViewHeightLayoutConstraint;

@property (nonatomic, strong) UIFont  *font;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic) UIColor *imageTintColor;

@property (nonatomic, strong) UIFont  *selectedFont;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic) UIColor *selectedImageTintColor;

@property (nonatomic, assign) BOOL isSelectedTextGlowON;

@property (nonatomic) BOOL shrink; // MGUSegmentedControl의 Pan으로 작동한다.
@property (nonatomic) BOOL highlight; // MGUSegmentedControl의 Pan으로 작동한다.

- (instancetype)initWithSegmentModel:(MGUNeoSegModel *)model
                              config:(MGUNeoSegConfiguration *)config NS_DESIGNATED_INITIALIZER;
+ (instancetype)segmentWithSegmentModel:(MGUNeoSegModel *)model
                                 config:(MGUNeoSegConfiguration *)config; // convenience.

- (void)setImageRenderingMode:(UIImageRenderingMode)imageRenderingMode; // 메서드만 존재함.

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
