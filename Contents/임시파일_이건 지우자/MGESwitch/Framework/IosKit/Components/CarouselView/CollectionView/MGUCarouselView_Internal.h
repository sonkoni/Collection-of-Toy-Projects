//
//  MGUCarouselView_Internal.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

@import GraphicsKit;
#import "MGUCarouselLayout.h"
#import "MGUCarouselCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGUCarouselView ()

@property (nonatomic, strong) MGUCarouselLayout *collectionViewLayout;
@property (nonatomic, strong, readwrite) MGUCarouselCollectionView *collectionView;
@property (nonatomic, assign, readwrite) MGUCarouselVolumeType volumeType;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak, nullable) NSTimer *timer; /// NSTimer는 등록시 target을 strong으로 잡으므로 weak로 써주자.
@property (nonatomic, assign, readonly) NSInteger numberOfItems; // @dynamic
@property (nonatomic, assign, readonly) NSInteger numberOfSections; // @dynamic
@property (nonatomic, assign) NSInteger dequeingSection; // MGUCarouselView는 오직 하나의 섹션만 갖는다. data source에 index만 전달한다.
@property (nonatomic, strong, readonly) NSIndexPath *centermostIndexPath;
@property (nonatomic, assign, readonly) BOOL isPossiblyRotating;    // 불필요할듯.
@property (nonatomic, strong, nullable) NSIndexPath *possibleTargetingIndexPath; // - collectionView:didSelectItemAtIndexPath: 설정됨.
@property (nonatomic, assign) BOOL panScene; // rubber effect를 위해 존재함.
@property (nonatomic, strong) MGEDisplayLink *displayLink; // 기존 - scrollToItemAtIndex:animated:의 컴플리션의 필요성 때문에 만들었다.
@end

NS_ASSUME_NONNULL_END
