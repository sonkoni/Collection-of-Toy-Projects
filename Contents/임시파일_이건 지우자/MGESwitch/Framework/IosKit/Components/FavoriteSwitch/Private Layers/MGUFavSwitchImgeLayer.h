//
//  MGUFavSwitchImgeLayer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-03
//  ----------------------------------------------------------------------
//

#import <QuartzCore/QuartzCore.h>
#import "MGUFavoriteSwitch.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGUFavSwitchImgeLayer : CALayer

@property (nonatomic, assign) CGFloat timeDuration;
@property (nonatomic, assign) BOOL selected;              // 디폴트 NO 이미지가 바뀌는게 존재할 수 있으므로. 추가했다.
@property (nonatomic, strong) NSArray <UIImage *>*images; // 이미지가 두 개 있으면, 칼라를 이용하지 않고, 한개 있으면 칼라로 on off로 보여준다
@property (nonatomic, strong) UIColor *imageColorOff;
@property (nonatomic, strong) UIColor *imageColorOn;

- (void)setupImgeLayerAnimationWith:(UIImage *)mainImage image:(UIImage * _Nullable)secondaryOnImage;
- (void)startImgeAnimation;
- (void)stopImgeAnimation;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
//
// 이미지가 한 개만 존재하면, 이미지에 칼라를 입혀서 on off를 표현한다.
// 이미지가 두 개 있으면, 첫 번째 이미지는 off 두 번째 이미지는 on을 의미한다.
