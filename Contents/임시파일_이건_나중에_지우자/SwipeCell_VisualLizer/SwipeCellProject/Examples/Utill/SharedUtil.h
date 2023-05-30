//
//  SharedUtil.h
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/04/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ButtonDisplayMode) {
    titleAndImage = 1, // 0은 피하는 것이 좋다.
    titleOnly,
    imageOnly
};

typedef NS_ENUM(NSUInteger, ButtonStyle) {
    backgroundColor = 1, // 0은 피하는 것이 좋다.
    circular
};

typedef NS_ENUM(NSUInteger, ActionDescriptor) {
    ActionDescriptorRead = 1, // 0은 피하는 것이 좋다.
    ActionDescriptorUnread,
    ActionDescriptorMore,
    ActionDescriptorFlag,
    ActionDescriptorTrash
};

CG_EXTERN NSString * _Nullable ActionDescriptorTitleForDisplayMode(ActionDescriptor descriptor,
                                                                   ButtonDisplayMode displayMode);

CG_EXTERN UIImage * _Nullable ActionDescriptorImageForStyle(ActionDescriptor descriptor,
                                                            ButtonStyle style,
                                                            ButtonDisplayMode displayMode);

CG_EXTERN UIColor * ActionDescriptorColorForStyle(ActionDescriptor descriptor,
                                                            ButtonStyle style);


CG_EXTERN UIImage * _Nullable ActionDescriptorCircularIconWith(ActionDescriptor descriptor,
                                                               UIColor *color,
                                                               CGSize size,
                                                               UIImage * _Nullable icon);


@interface IndicatorView : UIView

@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
