//
//  MGUCarouselView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUCarouselDiffableDataSource.h>
#import <IosKit/MGUCarouselCellLayoutAttributes.h>
#import <IosKit/MGUCarouselTransformerUmbrella.h>
#import <IosKit/MGUCarouselCell.h>
@class MGUCarouselView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 프로토콜 선언 <MGUCarouselViewDelegate>
@protocol MGUCarouselViewDelegate <NSObject>
@required
@optional
/// tracking하는 동안 아이템을 강조 표시(하이라이팅)해야하는지 delegate 객체에 묻는다.
- (BOOL)carouselView:(MGUCarouselView *)carouselView shouldHighlightItemAtIndex:(NSInteger)index;

/// delegate 객체에 지정된 인덱스의 아이템이 강조 강조 표시(하이라이팅)되었음을 알린다.
- (void)carouselView:(MGUCarouselView *)carouselView didHighlightItemAtIndex:(NSInteger)index;

/// 지정된 아이템을 선택해야하는지 delegate 객체에 묻는다.
- (BOOL)carouselView:(MGUCarouselView *)carouselView shouldSelectItemAtIndex:(NSInteger)index;

/// delegate 객체에게 지정된 인덱스의 아이템이 선택되었음을 알려준다.
- (void)carouselView:(MGUCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index;

/// 지정된 셀이 MGUCarouselView에 표시될 것임을 delegate 객체에게 알려준다.
- (void)carouselView:(MGUCarouselView *)carouselView
     willDisplayCell:(MGUCarouselCell *)cell
      forItemAtIndex:(NSInteger)index;

- (void)carouselView:(MGUCarouselView *)carouselView
willDisplaySupplementaryView:(UICollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndex:(NSInteger)index;

/// 지정된 셀이 MGUCarouselView에서 제거되었음을 delegate 객체에게 알려준다. ?? 그게 맞나?
- (void)carouselView:(MGUCarouselView *)carouselView
didEndDisplayingCell:(MGUCarouselCell *)cell
      forItemAtIndex:(NSInteger)index;

- (void)carouselView:(MGUCarouselView *)carouselView
didEndDisplayingSupplementaryView:(UICollectionReusableView *)view
      forElementOfKind:(NSString *)elementKind
             atIndex:(NSInteger)index;

/// MGUCarouselView가 컨텐츠 스크롤을 시작하려고할 때 delegate 객체에게 알려준다.
- (void)carouselViewWillBeginDragging:(MGUCarouselView *)carouselView;

/// 사용자가 컨텐츠 스크롤을 마치면 delegate 객체에게 알려준다. carouselView을 사용하는 객체가 자신의 페이지 번호를 갱신하는데 사용할 수 있다.
- (void)carouselViewWillEndDragging:(MGUCarouselView *)carouselView targetIndex:(NSInteger)targetIndex;

/// 사용자가 리시버 내에서 컨텐츠 뷰를 스크롤할 때 delegate 객체에게 알려준다.
- (void)carouselViewDidScroll:(MGUCarouselView *)carouselView;

/// MGUCarouselView의 스크롤 애니메이션이 종료되면 delegate 객체에게 알려준다.
- (void)carouselViewDidEndScrollAnimation:(MGUCarouselView *)carouselView;

- (void)carouselViewDidEndDragging:(MGUCarouselView *)carouselView willDecelerate:(BOOL)decelerate;

- (void)carouselViewWillBeginDecelerating:(MGUCarouselView *)carouselView;

/// MGUCarouselView가 스크롤 이동의 감속을 끝냈다고 delegate 객체에게 알려준다.
- (void)carouselViewDidEndDecelerating:(MGUCarouselView *)carouselView;
@end


#pragma mark - NS_ENUM ScrollDirection
typedef NS_ENUM(NSInteger, MGUCarouselScrollDirection) {
    MGUCarouselScrollDirectionHorizontal = 1, // MGUCarouselView가 컨텐츠를 수평으로 스크롤한다.
    MGUCarouselScrollDirectionVertical        // MGUCarouselView가 컨텐츠를 수직으로 스크롤한다.
};


#pragma mark - 인터페이스
IB_DESIGNABLE @interface MGUCarouselView : UIView <UICollectionViewDelegate>

// MARK: - 클래스 readonly 프라퍼티
// decelerationDistance 프라퍼티에 넣을 인자로 넣을 수 있게 만들어 놓은 거리. -> 속도에 맞게 스크롤링이 이동. 디폴트가 아님!!!!
@property (nonatomic, assign, class, readonly) NSUInteger automaticDistance;
// itemSize 프라퍼티에 넣을 인자로 넣을 수 있게 만들어 놓은 사이즈. -> 하나의 아이템이 꽉찬다. 디폴트 값이다.
@property (nonatomic, assign, class, readonly) CGSize automaticSize;

@property (nonatomic, assign, readonly) BOOL rubberEffect; // cover flow 2 에서 사용한다. rubber Effect를 작동할 수 있는지 알려준다.

// MARK: - 델리게이트
//@property (weak, nonatomic, nullable) IBOutlet id <MGUCarouselViewDataSource>dataSource;
@property (weak, nonatomic, nullable) IBOutlet id <MGUCarouselViewDelegate>delegate;


// MARK: - Basic
@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, nullable) UIView *backgroundView; // 백그라운드로 뷰를 사용하고 싶다면, 니가 넣으면 됨. 무조건 전체 크기.
@property (nonatomic, strong, nullable) MGUCarouselTransformer *transformer; // MGUCarouselView의 transformer.
@property (nonatomic, assign) MGUCarouselScrollDirection scrollDirection; // 스크롤 방향. 디폴트 수평방향
@property (nonatomic) IBInspectable CGSize itemSize; // 디폴트가 [MGUCarouselView automaticSize].
@property (nonatomic) IBInspectable CGFloat interitemSpacing; // MGUCarouselView에서 item 사이에 사용할 간격. 디폴트 0.0.
/// 감속 거리를 결정하는 unsigned integer로, 감속 중 패싱할 아이템 수를 나타냄.
/// [MGUCarouselView automaticDistance](디폴트 아님!)인 경우 스크롤 속도에 따라 자동으로 계산됨. 디폴트 1.
@property (nonatomic) IBInspectable NSUInteger decelerationDistance;


// MARK: - readonly 프라퍼티
@property (nonatomic, assign, readonly) CGFloat scrollOffset; // 컨텐츠 뷰의 원점이 MGUCarouselView의 원점에서 오프셋되는 x 위치의 백분율.
@property (nonatomic, assign, readonly) NSInteger currentIndex; // KVO 가능. - willChangeValueForKey: - didChangeValueForKey:


// MARK: - 스페셜 프라퍼티
//@property (nonatomic) IBInspectable BOOL isInfinite; // 무한 아이템으로 표시할지 여부. 디폴트 NO.
//@property (nonatomic) BOOL isWrap; // 유한일 때, wrap를 할지에 대한 여부. 디폴트 NO. IBInspectable를 사용하지 말자.
@property (nonatomic, assign, readonly) MGUCarouselVolumeType volumeType; // 디폴트 MGUCarouselVolumeTypeFinite.

@property (nonatomic) IBInspectable BOOL removesInfiniteLoopForSingleItem; // 하나의 item만 있는 경우 무한 루프를 제거할지 여부. 디폴트 NO
@property (nonatomic) IBInspectable CGFloat automaticSlidingInterval; // 자동 슬라이딩 시간 간격(초). 0.0은 비활성화를 의미. 디폴트 0.0


// MARK: - UICollectionView의 원래 프라퍼티와 연결만 해주는 프라퍼티
@property (nonatomic) IBInspectable BOOL isScrollEnabled; // 스크롤 가능 여부를 결정하는 BOOL 값. 디폴트 YES
@property (nonatomic) IBInspectable BOOL bounces; // 컨텐츠의 가장자리를 지나 튀어 나오는지(바운스) 여부를 제어하는 BOOL 값. 디폴트 YES.
@property (nonatomic) IBInspectable BOOL alwaysBounceHorizontal; // 수평 끝에 도달 할 때 항상 bouncing 발생하는지 여부. 디폴트 NO.
@property (nonatomic) IBInspectable BOOL alwaysBounceVertical; // 디폴트 NO.
@property (nonatomic, assign, readonly) BOOL isTracking;

- (void)updateCurrentIndex; // 외부에서 delete, insert, moving을 할때, current Index가 핀트가 어긋날 수 있으므로, 외부에서도 사용할 수 있게 공개함.

// MARK: - UICollectionView의 원래 메서드와 연결만 해주는 메서드
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

//! (유한 && Wrap ON && 이 메서드로 등록 할때 사용) 또는 (유한 && 이 메서드로 등록 할때 사용)
- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;


// MARK: - UICollectionViewLayout의 원래 메서드와 연결만 해주는 메서드
- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)elementKind;
- (void)registerNib:(UINib *)nib forDecorationViewOfKind:(NSString *)elementKind;


// MARK: - UICollectionView의 원래 메서드와 가공하여 연결해주는 메서드
- (__kindof MGUCarouselCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier // data source에서 호출.
                                                             atIndex:(NSInteger)index;
- (__kindof MGUCarouselCell *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                 withReuseIdentifier:(NSString *)identifier
                                                            forIndex:(NSInteger)index;

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;   // - selectItemAtIndexPath:animated:scrollPosition: 호출
- (void)deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated; // - deselectItemAtIndexPath:animated: 호출
//! completion 블락이 nil 아니면, display link를 이용하며 이때 duration을 사용한다.
- (void)scrollToItemAtIndex:(NSInteger)index  // - setContentOffset:animated: 연결
                   animated:(BOOL)animated
                   duration:(CFTimeInterval)duration
                 completion:(void(^_Nullable)(void))completionBlock;

- (NSInteger)indexForCell:(MGUCarouselCell *)cell; // - indexPathForCell: 연결
- (MGUCarouselCell * _Nullable)cellForItemAtIndex:(NSInteger)index; // - cellForItemAtIndexPath: 연결
- (NSArray<__kindof MGUCarouselCell *> *)visibleCells;
- (NSArray<NSNumber *> *)indexesForVisibleItems; // NSInteger로 해석 - indexPathsForVisibleItems: 연결

//! MGUCarouselCell의 모든 supplementaryView의 index는 0로 설계되었다. IndexPath는 0-0
- (MGUCarouselCell * _Nullable)supplementaryViewForElementKind:(NSString *)elementKind
                                                       atIndex:(NSInteger)index; // - supplementaryViewForElementKind:atIndexPath: 연결

- (NSArray<__kindof MGUCarouselCell *> *)visibleSupplementaryViewsOfKind:(NSString *)elementKind;
// NSInteger를 감싸는 NSNumber
- (NSArray<NSNumber *> *)indexesForVisibleSupplementaryElementsOfKind:(NSString *)elementKind; // - indexPathsForVisibleSupplementaryElementsOfKind: 연결

// - layoutAttributesForItemAtIndexPath: 연결
- (__kindof MGUCarouselCellLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index;

//- layoutAttributesForSupplementaryElementOfKind:atIndexPath: 연결. 이 프로젝트에서는 MGUCarouselSupplementaryViewLayoutAttributes를 사용하지 않는다.
- (__kindof MGUCarouselCellLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind
                                                                                    atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
//
//! * scrollOffset : 만약 최초 상태이면 0.0, 두 번째 아이템에 멈춰있는 상태(두 번째 아이템이 중간)라면 1.0,
//! 세 번째 아이템에 멈춰있는 상태(세 번째 아이템이 중간)라면 2.0
//! 만약, 2.5 라면 세 번째 아이템과 네 번째 아이템의 중간지점이 화면 중간에 있다라고 보면된다.
//! 즉, 스크롤링 중(손가락을 대고 왔다갔다하는 중)에 현재 시점의 인덱스를 CGFloat(실수)로 나타낸다고 보면된다. 스크롤링에서만 의미를 갖는다.
//! 이름을 scrollingFloatingCurrentIndex 로 바꾸든지 해야겠다.

//! - selectItemAtIndex:animated: 억지로 특정 부위를 선택하게 할때에는 사용할 수도 있다.
//! 구현에 문제가 있다. 내부에서 스크롤 포지션을 None으로 하는 것이 옳은듯하다.




//
//- (void)reloadData; // 내부에 layout을 준비하는 코드 하나 더 추가했다.
//- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths // - insertItemsAtIndexPaths: 호출
//                       animated:(BOOL)animated
//                     dataUpdate:(void(^_Nonnull)(void))dataUpdateBlock
//                     completion:(void(^_Nullable)(void))completionBlock;
//- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths // - deleteItemsAtIndexPaths: 호출
//                       animated:(BOOL)animated
//                     dataUpdate:(void(^_Nonnull)(void))dataUpdateBlock
//                     completion:(void(^_Nullable)(void))completionBlock;
//- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath                // - moveItemAtIndexPath:toIndexPath: 호출
//                toIndexPath:(NSIndexPath *)newIndexPath
//                   animated:(BOOL)animated
//                 dataUpdate:(void(^_Nonnull)(void))dataUpdateBlock
//                 completion:(void(^_Nullable)(void))completionBlock;


/*
#pragma mark - 프로토콜 선언 <MGUCarouselViewDataSource>
@protocol MGUCarouselViewDataSource <NSObject>
@optional
@required
// MGUCarouselView의 아이템의 갯수를 data source 객체에 묻는다.
- (NSInteger)numberOfItemsInCarouselView:(MGUCarouselView *)carouselView;

// MGUCarouselView에서 지정된 아이템에 해당하는 cell을 data source 객체에 요청한다.
- (MGUCarouselCell *)carouselView:(MGUCarouselView *)carouselView cellForItemAtIndex:(NSInteger)index;

@optional
// 유한에서만 Wrap ON 일 때 사용 index path 는 0 - 0 만 있다. 실제로 atIndex에 해당하는 정보는 필요없지만 그냥 넣자.
// 유한에서 MGUCarouselDiceTransformer 일때도 사용.
- (MGUCarouselCell *)carouselView:(MGUCarouselView *)carouselView viewForSupplementaryElementOfKind:(NSString *)kind atIndex:(__unused NSInteger)index;

// 유한에서 MGUCarouselDiceTransformer 일때 사용.
- (NSArray <NSString *>*)elementOfKindsInCarouselView:(MGUCarouselView *)carouselView;
@end
*/
