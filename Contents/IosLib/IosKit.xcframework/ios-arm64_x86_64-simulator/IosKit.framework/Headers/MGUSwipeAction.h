//
//  MGUSwipeAction.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@protocol MGUSwipeActionTransitioning;
@class MGUSwipeAction;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGUSwipeActionStyle) {
    MGUSwipeActionStyleDefault = 0,
    MGUSwipeActionStyleDestructive
};

// sourceView <--- SwipeActionButton, completionHandler(YES) 액션 실행시 닫는다.
typedef void (^MGUSwipeActionHandler)(MGUSwipeAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL actionPerformed));

@interface MGUSwipeAction : NSObject

@property (nonatomic, assign) MGUSwipeActionStyle style;
@property (nonatomic, strong, nullable) id <MGUSwipeActionTransitioning>transitionDelegate;
@property (nonatomic, copy, nullable) MGUSwipeActionHandler handler;
@property (nonatomic, strong, nullable) NSString *identifier;
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) UIFont *font;
@property (nonatomic, strong, nullable) UIColor *textColor;
@property (nonatomic, strong, nullable) UIColor *highlightedTextColor;

//! TODO: 나중에 넣어야겠다.
//! image 애니메이션화할 수 있는 이미지 뷰를 넣어주자.
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong, nullable) UIImage *highlightedImage;

@property (nonatomic, strong, nullable) UIColor *backgroundColor;
@property (nonatomic, strong, nullable) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong, nullable) UIVisualEffect *backgroundEffect;
//@property (nonatomic, assign) BOOL hidesWhenSelected; // 디폴트 NO;
@property (nonatomic, assign, readonly) BOOL hasBackgroundColor; // @dynamic

+ (instancetype)swipeActionWithStyle:(MGUSwipeActionStyle)style
                               title:(NSString * _Nullable)title
                             handler:(MGUSwipeActionHandler)handler;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new __attribute__((unavailable("Use +swipeActionWithStyle:title:handler: instead.")));
- (instancetype)init __attribute__((unavailable("Use +swipeActionWithStyle:title:handler: instead.")));
@end

NS_ASSUME_NONNULL_END

