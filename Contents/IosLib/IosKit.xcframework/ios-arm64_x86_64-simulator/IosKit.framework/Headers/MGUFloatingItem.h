//
//  JJActionItem.h
//  MGUFloatingButton
//
//  Created by Kwan Hyun Son on 15/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//
// label 부터 circleView(내부에 imageView 포함)까지를 포함하는 아이템에 대한 하나의 컨테이너 뷰이다.

#import <UIKit/UIKit.h>
@class MGUFloatingItem;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGUFloatingItemTitlePosition) {
    MGUFloatingItemTitlePositionLeading,    // Place the title at the leading edge of the circle view.
    MGUFloatingItemTitlePositionTrailing,   // Place the title at the trailing edge of the circle view.
    MGUFloatingItemTitlePositionLeft,    // Place the title at the left edge of the circle view.
    MGUFloatingItemTitlePositionRight,   // Place the title at the right edge of the circle view.
    MGUFloatingItemTitlePositionTop,        // Place the title at the top edge of the circle view.
    MGUFloatingItemTitlePositionBottom,     // Place the title at the bottom edge of the circle view.
    MGUFloatingItemTitlePositionHidden      // Hide the title all together.
};


typedef void (^MGRFloatingActionBlock)(MGUFloatingItem *item);

@interface MGUFloatingItem : UIControl

@property (nonatomic, copy, nullable) MGRFloatingActionBlock actionBlock;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIColor *highlightedButtonColor;
@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UIColor *buttonImageColor;
@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic) MGUFloatingItemTitlePosition titlePosition;
@property (nonatomic) CGFloat titleSpacing;


//! MGUFloatingItemPreparation 클래스에서만 호출되는 컨트롤 메서드이다.
//! translationX, translationY의 디폴트 값은 0.0이다. 안넣으면 0.0으로 설정된다. factor는 디폴트 값이 없다.
- (void)scaleBy:(CGFloat)factor translationX:(CGFloat)translationX translationY:(CGFloat)translationY;

- (void)callAction;

- (void)showLogAlert;

//===== LayerProperties Dynamic =======
@property (nonatomic, nullable) UIColor *shadowColor;
@property (nonatomic) CGSize   shadowOffset;
@property (nonatomic) CGFloat  shadowOpacity;
@property (nonatomic) CGFloat  shadowRadius;

@end

UIColor * transHighlightedColor(UIColor *originalColor);
NS_ASSUME_NONNULL_END
