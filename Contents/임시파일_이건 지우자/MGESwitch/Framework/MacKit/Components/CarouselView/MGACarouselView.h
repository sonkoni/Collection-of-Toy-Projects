//
//  MGACarouselView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//
#import <MacKit/MGACarouselDiffableDataSource.h>
#import <MacKit/MGACarouselCellLayoutAttributes.h>
#import <MacKit/MGACarouselTransformerUmbrella.h>
#import <MacKit/MGACarouselItem.h>
#import <MacKit/MGACarouselSupplementaryView.h>
@class MGACarouselView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 프로토콜 선언 <MGACarouselViewDelegate>
@protocol MGACarouselViewDelegate <NSObject>
@required
@optional
/// tracking하는 동안 아이템을 강조 표시(하이라이팅)해야하는지 delegate 객체에 묻는다.
/// iOS에서는 BOOL을 반환하지만, mac은 다르다. index로 커팅해서 주면 반환 값을 받는 원본 NSCollectionViewDelegate 가 난감해진다.
- (NSSet <NSIndexPath *>*)carouselView:(MGACarouselView *)carouselView
         shouldChangeItemsAtIndexPaths:(NSSet <NSIndexPath *>*)indexPaths
                      toHighlightState:(NSCollectionViewItemHighlightState)highlightState;

/// delegate 객체에 지정된 인덱스의 아이템이 강조 강조 표시(하이라이팅)되었음을 알린다.
- (void)carouselView:(MGACarouselView *)carouselView
didChangeItemsAtIndexSet:(NSIndexSet *)indexSet
    toHighlightState:(NSCollectionViewItemHighlightState)highlightState;

/// 지정된 아이템을 선택해야하는지 delegate 객체에 묻는다.
/// iOS에서는 BOOL을 반환하지만, mac은 다르다. index로 커팅해서 주면 반환 값을 받는 원본 NSCollectionViewDelegate 가 난감해진다.
- (NSSet <NSIndexPath *>*)carouselView:(MGACarouselView *)carouselView
         shouldSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;

/// delegate 객체에게 지정된 인덱스의 아이템이 선택되었음을 알려준다.
- (void)carouselView:(MGACarouselView *)carouselView
didSelectItemsAtIndexSet:(NSIndexSet *)indexSet;

/// 지정된 셀이 MGACarouselView에 표시될 것임을 delegate 객체에게 알려준다.
- (void)carouselView:(MGACarouselView *)carouselView
     willDisplayItem:(NSCollectionViewItem *)item
forRepresentedObjectAtIndex:(NSInteger)index;

- (void)carouselView:(MGACarouselView *)carouselView
willDisplaySupplementaryView:(NSView *)view
        forElementKind:(NSCollectionViewSupplementaryElementKind)elementKind
             atIndex:(NSInteger)index;

/// 지정된 셀이 MGACarouselView에서 제거되었음을 delegate 객체에게 알려준다. ?? 그게 맞나?
- (void)carouselView:(MGACarouselView *)carouselView
  didEndDisplayingItem:(NSCollectionViewItem *)item
forRepresentedObjectAtIndex:(NSInteger)index;

- (void)carouselView:(MGACarouselView *)carouselView
didEndDisplayingSupplementaryView:(NSView *)view
      forElementOfKind:(NSCollectionViewSupplementaryElementKind)elementKind
             atIndex:(NSInteger)index;

/// 사용자가 리시버 내에서 컨텐츠 뷰를 스크롤할 때 delegate 객체에게 알려준다.
- (void)carouselViewDidScroll:(MGACarouselView *)carouselView;

/// MGACarouselView가 컨텐츠 스크롤을 시작하려고할 때 delegate 객체에게 알려준다.
- (void)carouselViewWillBeginScrolling:(MGACarouselView *)carouselView;

/// 사용자가 컨텐츠 스크롤을 마치면 delegate 객체에게 알려준다. carouselView을 사용하는 객체가 자신의 페이지 번호를 갱신하는데 사용할 수 있다.
- (void)carouselViewWillBeginDecelerating:(MGACarouselView *)carouselView;
//- (void)carouselViewWillEndDragging:(MGACarouselView *)carouselView targetIndex:(NSInteger)targetIndex;

- (void)carouselViewDidEndScrolling:(MGACarouselView *)carouselView rollingStop:(BOOL)rollingStop;

/// MGACarouselView의 스크롤 애니메이션이 종료되면 delegate 객체에게 알려준다.
- (void)carouselViewDidEndScrollingAnimation:(MGACarouselView *)carouselView;
@end


#pragma mark - NS_ENUM ScrollDirection
typedef NS_ENUM(NSInteger, MGACarouselScrollDirection) {
    MGACarouselScrollDirectionHorizontal = 1, // MGACarouselView가 컨텐츠를 수평으로 스크롤한다.
    MGACarouselScrollDirectionVertical        // MGACarouselView가 컨텐츠를 수직으로 스크롤한다.
};

IB_DESIGNABLE @interface MGACarouselView : NSView <NSCollectionViewDelegate>

// MARK: - 클래스 readonly 프라퍼티
// decelerationDistance 프라퍼티에 넣을 인자로 넣을 수 있게 만들어 놓은 거리. -> 속도에 맞게 스크롤링이 이동. 디폴트가 아님!!!!
@property (nonatomic, assign, class, readonly) NSUInteger automaticDistance;
// itemSize 프라퍼티에 넣을 인자로 넣을 수 있게 만들어 놓은 사이즈. -> 하나의 아이템이 꽉찬다. 디폴트 값이다.
@property (nonatomic, assign, class, readonly) CGSize automaticSize;

@property (nonatomic, assign, readonly) BOOL rubberEffect; // cover flow 2 에서 사용한다. rubber Effect를 작동할 수 있는지

// MARK: - 델리게이트
@property (weak, nonatomic, nullable) IBOutlet id <MGACarouselViewDelegate>delegate;

@property (nonatomic, readonly) NSCollectionView *collectionView;
@property (nonatomic, nullable) NSView *backgroundView; // 원하면 넣어라. 무조건 전체 크기.
@property (nonatomic, strong, nullable) MGACarouselTransformer *transformer; // MGUCarouselView의 transformer.
@property (nonatomic, assign) MGACarouselScrollDirection scrollDirection; // 스크롤 방향. 디폴트 수평방향
@property (nonatomic) IBInspectable CGSize itemSize; // 디폴트가 [MGUCarouselView automaticSize].
@property (nonatomic) IBInspectable CGFloat interitemSpacing; // MGUCarouselView에서 item 사이에 사용할 간격. 디폴트 0.0.
/// 감속 거리를 결정하는 unsigned integer로, 감속 중 패싱할 아이템 수를 나타냄.
/// [MGACarouselView automaticDistance](디폴트 아님!)인 경우 스크롤 속도에 따라 자동으로 계산됨. 디폴트 1.
@property (nonatomic) IBInspectable NSUInteger decelerationDistance;

// MARK: - readonly 프라퍼티
@property (nonatomic, assign, readonly) CGFloat scrollOffset; // 컨텐츠 뷰의 원점이 MGACarouselView의 원점에서 오프셋되는 x 위치의 백분율.
@property (nonatomic, assign, readonly) NSInteger currentIndex; // KVO 가능. - willChangeValueForKey: - didChangeValueForKey:

// MARK: - 스페셜 프라퍼티
//@property (nonatomic) IBInspectable BOOL isInfinite; // 무한 아이템으로 표시할지 여부. 디폴트 NO.
//@property (nonatomic) BOOL isWrap; // 유한일 때, wrap를 할지에 대한 여부. 디폴트 NO. IBInspectable를 사용하지 말자.
@property (nonatomic, assign, readonly) MGACarouselVolumeType volumeType; // 디폴트 MGUCarouselVolumeTypeFinite.

@property (nonatomic) IBInspectable BOOL removesInfiniteLoopForSingleItem; // 하나의 item만 있는 경우 무한 루프를 제거할지 여부. 디폴트 NO
@property (nonatomic) IBInspectable CGFloat automaticSlidingInterval; // 자동 슬라이딩 시간 간격(초). 0.0은 비활성화를 의미. 디폴트 0.0

// MARK: - NSCollectionView의 원래 프라퍼티와 연결만 해주는 프라퍼티
@property (nonatomic) IBInspectable BOOL isScrollEnabled; // 스크롤 가능 여부를 결정하는 BOOL 값. 디폴트 YES
@property (nonatomic) IBInspectable NSScrollElasticity horizontalScrollElasticity;
@property (nonatomic) IBInspectable NSScrollElasticity verticalScrollElasticity;

@property (nonatomic, assign, readonly) BOOL isTracking;

// macOS에서는 최초에 표기 시에 스크롤 전까지 로드를 안하거나(ex: Supplementary View)
// CollectionView item(view controller)의 뷰의 content view(내가 만든)의 transform을 제대로 갱신하지 못하는 버그가 존재한다.
// 이를 위해 - initialRefreshWithCompletion:async:를 이용하자
- (void)initialRefreshWithCompletion:(void(^_Nullable)(void))completionBlock async:(BOOL)async;
- (void)updateCurrentIndex; // 외부에서 delete, insert, moving을 할때, current Index가 핀트가 어긋날 수 있으므로, 외부에서도 사용할 수 있게 공개함.

// MARK: - NSCollectionView의 원래 메서드와 연결만 해주는 메서드
- (void)registerClass:(Class)itemClass forItemWithIdentifier:(NSUserInterfaceItemIdentifier)identifier;
- (void)registerNib:(NSNib *)nib forItemWithIdentifier:(NSUserInterfaceItemIdentifier)identifier;

// MARK: - (유한 && Wrap ON && 이 메서드로 등록 할때 사용) 또는 (유한 && 이 메서드로 등록 할때 사용)
- (void)registerClass:(Class)viewClass
forSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)kind
       withIdentifier:(NSUserInterfaceItemIdentifier)identifier;
- (void)registerNib:(NSNib *)nib
forSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)kind
     withIdentifier:(NSUserInterfaceItemIdentifier)identifier;

// MARK: - NSCollectionViewLayout의 원래 메서드와 연결만 해주는 메서드
- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSCollectionViewDecorationElementKind)elementKind;
- (void)registerNib:(NSNib *)nib forDecorationViewOfKind:(NSCollectionViewDecorationElementKind)elementKind;


// MARK: - NSCollectionView의 원래 메서드와 가공하여 연결해주는 메서드
- (__kindof NSCollectionViewItem *)makeItemWithIdentifier:(NSUserInterfaceItemIdentifier)identifier
                                                 forIndex:(NSInteger)index;
- (__kindof NSView *)makeSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)elementKind
                                  withIdentifier:(NSUserInterfaceItemIdentifier)identifier
                                        forIndex:(NSInteger)index;

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;   // - selectItemAtIndexPath:animated:scrollPosition: 호출
- (void)deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated; // - deselectItemAtIndexPath:animated: 호출
//! completion 블락이 nil 아니면, display link를 이용하며 이때 duration을 사용한다.

//! completion 블락이 nil 아니면, display link를 이용하며 이때 duration을 사용한다.
- (void)scrollToItemAtIndex:(NSInteger)index  // - setContentOffset:animated: 연결
                   animated:(BOOL)animated
                   duration:(CFTimeInterval)duration
                 completion:(void(^_Nullable)(void))completionBlock;

- (NSInteger)indexForCell:(NSCollectionViewItem *)item; // - indexPathForCell: 연결
- (NSCollectionViewItem * _Nullable)cellForItemAtIndex:(NSInteger)index; // - cellForItemAtIndexPath: 연결
- (NSArray <__kindof NSCollectionViewItem *>*)visibleItems;
- (NSArray <NSNumber *>*)indexesForVisibleItems; // NSInteger로 해석 - indexPathsForVisibleItems: 연결
- (nullable NSView <NSCollectionViewElement>*)supplementaryViewForElementKind:(NSCollectionViewSupplementaryElementKind)elementKind
                                                                      atIndex:(NSInteger)index;
- (NSArray <NSView <NSCollectionViewElement>*> *)visibleSupplementaryViewsOfKind:(NSCollectionViewSupplementaryElementKind)elementKind;
- (NSArray <NSNumber *>*)indexesForVisibleSupplementaryElementsOfKind:(NSCollectionViewSupplementaryElementKind)elementKind;

- (__kindof MGACarouselCellLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index;
- (__kindof MGACarouselCellLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind
                                                                                    atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
