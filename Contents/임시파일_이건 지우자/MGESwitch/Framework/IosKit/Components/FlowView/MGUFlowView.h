//
//  MGUFlowView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUFlowDiffableDataSource.h>
#import <IosKit/MGUFlowFoldCell.h> // MGUFlowCell 상속
#import <IosKit/MGUFlowIndicatorSupplementaryView.h>
#import <IosKit/MGUFlowVegaTransformer.h> // MGUFlowTransformer  상속
#import <IosKit/MGUFlowFoldTransformer.h> // MGUFlowTransformer  상속
@class MGUFlowView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 프로토콜 선언 <MGUFlowViewDelegate>
@protocol MGUFlowViewDelegate <NSObject>
@required
@optional
- (BOOL)flowView:(MGUFlowView *)flowView shouldHighlightItemAtIndex:(NSInteger)index; // tracking하는 동안 아이템을 강조 표시(하이라이팅)해야하는지 묻는다.

- (void)flowView:(MGUFlowView *)flowView didHighlightItemAtIndex:(NSInteger)index; // 해당 인덱스의 아이템이 강조 표시(하이라이팅)되었음을 알림.

- (BOOL)flowView:(MGUFlowView *)flowView shouldSelectItemAtIndex:(NSInteger)index; // 지정된 아이템을 선택해야하는지 묻는다.

- (void)flowView:(MGUFlowView *)flowView didSelectItemAtIndex:(NSInteger)index; // 지정된 인덱스의 아이템이 선택되었음을 알림.

- (void)flowView:(MGUFlowView *)flowView // 지정된 셀이 flowView에 표시될 것임을 알림.
     willDisplayCell:(__kindof UICollectionViewCell *)cell
      forItemAtIndex:(NSInteger)index;

- (void)flowView:(MGUFlowView *)flowView
willDisplaySupplementaryView:(UICollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndex:(NSInteger)index;

- (void)flowView:(MGUFlowView *)flowView // 지정된 셀이 flowView에서 제거되었음을 알림.
didEndDisplayingCell:(__kindof UICollectionViewCell *)cell
      forItemAtIndex:(NSInteger)index;

- (void)flowView:(MGUFlowView *)flowView
didEndDisplayingSupplementaryView:(UICollectionReusableView *)view
      forElementOfKind:(NSString *)elementKind
             atIndex:(NSInteger)index;

- (void)flowViewWillBeginDragging:(MGUFlowView *)flowView; // flowView가 컨텐츠 스크롤을 시작하려고할 때 알림.

// 사용자가 컨텐츠 스크롤을 마치면 알림. flowView을 사용하는 객체가 자신의 페이지 번호를 갱신하는데 사용할 수 있음.
- (void)flowViewWillEndDragging:(MGUFlowView *)flowView targetIndex:(NSInteger)targetIndex;

- (void)flowViewDidScroll:(MGUFlowView *)flowView; // 사용자가 리시버 내에서 컨텐츠 뷰를 스크롤할 때 알림.

- (void)flowViewDidEndScrollAnimation:(MGUFlowView *)flowView; // flowView의 스크롤 애니메이션이 종료되면 알림.

- (void)flowViewDidEndDragging:(MGUFlowView *)flowView willDecelerate:(BOOL)decelerate;

- (void)flowViewWillBeginDecelerating:(MGUFlowView *)flowView;

- (void)flowViewDidEndDecelerating:(MGUFlowView *)flowView; // flowView가 스크롤 이동 감속이 끝냈다고 알림.
@end


#pragma mark - 인터페이스
IB_DESIGNABLE @interface MGUFlowView : UIView <UICollectionViewDelegate>

@property (nonatomic, strong, readonly) __kindof UICollectionView *collectionView;
@property (nonatomic, strong, readonly) __kindof UICollectionViewLayout *collectionViewLayout;

// MARK: - 클래스 readonly 프라퍼티
// decelerationDistance 프라퍼티에 넣을 인자로 넣을 수 있게 만들어 놓은 거리. -> 속도에 맞게 스크롤링이 이동. 디폴트가 아님!!!!
@property (nonatomic, assign, class, readonly) NSUInteger automaticDistance;
// itemSize 프라퍼티에 넣을 인자로 넣을 수 있게 만들어 놓은 사이즈. -> 하나의 아이템이 꽉찬다. 디폴트 값이다.
@property (nonatomic, assign, class, readonly) CGSize automaticSize;

@property (nonatomic, assign, readonly) BOOL rubberEffect; // cover flow 2 에서 사용한다. rubber Effect를 작동할 수 있는지 알려준다.

// MARK: - 델리게이트
@property (weak, nonatomic, nullable) IBOutlet id <MGUFlowViewDelegate>delegate;


// MARK: - Basic
@property (nonatomic, nullable) UIView *backgroundView; // 백그라운드로 뷰를 사용하고 싶다면, 니가 넣으면 됨. 무조건 전체 크기.
@property (nonatomic, strong, nullable) MGUFlowTransformer *transformer; // MGUFlowView의 transformer.
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection; // 스크롤 방향. 디폴트 수평방향
@property (nonatomic) IBInspectable CGSize itemSize; // 디폴트가 [MGUFlowView automaticSize].
@property (nonatomic) IBInspectable CGFloat interitemSpacing; // MGUFlowView에서 item 사이에 사용할 간격. 디폴트 0.0.
@property (nonatomic) IBInspectable CGFloat leadingSpacing;
@property (nonatomic) IBInspectable BOOL reversed;


// 감속 거리를 결정하는 unsigned integer로, 감속 중 패싱할 아이템 수를 나타냄.
// [MGUFlowView automaticDistance](디폴트 아님!)인 경우 스크롤 속도에 따라 자동으로 계산됨. 디폴트 1.
@property (nonatomic) IBInspectable NSUInteger decelerationDistance;


// MARK: - readonly 프라퍼티
@property (nonatomic, assign, readonly) CGFloat scrollOffset; // 컨텐츠 뷰의 원점이 MGUFlowView의 원점에서 오프셋되는 x 위치의 백분율.
@property (nonatomic, assign, readonly) NSInteger currentIndex; // KVO 가능. - willChangeValueForKey: - didChangeValueForKey:
@property (nonatomic, assign, readonly) NSInteger maxSelectableIndex;

// MARK: - 스페셜 프라퍼티
//@property (nonatomic) IBInspectable BOOL isInfinite; // 무한 아이템으로 표시할지 여부. 디폴트 NO.
//@property (nonatomic) BOOL isWrap; // 유한일 때, wrap를 할지에 대한 여부. 디폴트 NO. IBInspectable를 사용하지 말자.

@property (nonatomic, assign) MGUFlowVolumeType volumeType; // 디폴트 MGUFlowVolumeTypeFinite.

@property (nonatomic) IBInspectable BOOL removesInfiniteLoopForSingleItem; // 하나의 item만 있는 경우 무한 루프를 제거할지 여부. 디폴트 NO
@property (nonatomic) IBInspectable CGFloat automaticSlidingInterval; // 자동 슬라이딩 시간 간격(초). 0.0은 비활성화를 의미. 디폴트 0.0


// MARK: - UICollectionView의 원래 프라퍼티와 연결만 해주는 프라퍼티
@property (nonatomic) IBInspectable BOOL isScrollEnabled; // 스크롤 가능 여부를 결정하는 BOOL 값. 디폴트 YES
@property (nonatomic) IBInspectable BOOL bounces; //컨텐츠의 가장자리를 지나 튀어 나오는지(바운스) 여부를 제어하는 BOOL 값. 디폴트 YES.
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
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier // data source에서 호출.
                                                                  atIndex:(NSInteger)index;
- (__kindof UICollectionViewCell *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                      withReuseIdentifier:(NSString *)identifier
                                                                 forIndex:(NSInteger)index;

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;   // - selectItemAtIndexPath:animated:scrollPosition: 호출
- (void)deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated; // - deselectItemAtIndexPath:animated: 호출
//! completion 블락이 nil 아니면, display link를 이용하며 이때 duration을 사용한다.
- (void)scrollToItemAtIndex:(NSInteger)index  // - setContentOffset:animated: 연결
                   animated:(BOOL)animated
                   duration:(CFTimeInterval)duration
                 completion:(void(^_Nullable)(void))completionBlock;

- (NSInteger)indexForCell:(__kindof UICollectionViewCell *)cell; // - indexPathForCell: 연결
- (__kindof UICollectionViewCell * _Nullable)cellForItemAtIndex:(NSInteger)index; // - cellForItemAtIndexPath: 연결
- (NSArray<__kindof UICollectionViewCell *> *)visibleCells;
- (NSArray<NSNumber *> *)indexesForVisibleItems; // NSInteger로 해석 - indexPathsForVisibleItems: 연결

//! MGUFlowCell의 모든 supplementaryView의 index는 0로 설계되었다. IndexPath는 0-0
- (__kindof UICollectionReusableView * _Nullable)supplementaryViewForElementKind:(NSString *)elementKind
                                                                         atIndex:(NSInteger)index; // - supplementaryViewForElementKind:atIndexPath: 연결

- (NSArray<__kindof UICollectionReusableView *> *)visibleSupplementaryViewsOfKind:(NSString *)elementKind;
// NSInteger를 감싸는 NSNumber
- (NSArray<NSNumber *> *)indexesForVisibleSupplementaryElementsOfKind:(NSString *)elementKind; // - indexPathsForVisibleSupplementaryElementsOfKind: 연결

// - layoutAttributesForItemAtIndexPath: 연결
- (__kindof MGUFlowCellLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index;

//- layoutAttributesForSupplementaryElementOfKind:atIndexPath: 연결. 이 프로젝트에서는 MGUFlowSupplementaryViewLayoutAttributes를 사용하지 않는다.
- (__kindof MGUFlowCellLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind
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
