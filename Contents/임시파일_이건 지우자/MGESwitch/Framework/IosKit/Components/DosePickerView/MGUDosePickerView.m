//
//  MGUDosePickerView.m
//  PickerView
//
//  Created by Kwan Hyun Son on 11/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUDosePickerView.h"
#import "MGUDosePickerCollectionViewCell.h"
#import "MGUDosePickerCollectionViewLayout.h"

/// 재사용 셀의 Identifier
static NSString * const reuseIdentifier = @"Cell";

@interface MGUDosePickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL notify;
@property (nonatomic, assign) NSUInteger centerFocusItemIndex; // 소리를 대응시키기 위해 필요하다.
@end

@implementation MGUDosePickerView
@dynamic contentOffset;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.collectionView.userInteractionEnabled == NO) { // 다음과 같은 상황일 때
        return self.window; // 터치를 수퍼로 보내지 않고, 직빵으로 위도우로 보내서 끝내버린다.
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)dealloc {
    self.collectionView.delegate = nil;
}

//! 반드시 frame을 먼저 맞추고, collectionViewLayout을 꽂아줘야한다.
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout]; //! 반드시 순서를 지켜야 한다.
    self.collectionView.frame = self.bounds;
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
//    self.collectionView.collectionViewLayout = [self collectionViewLayout]; // 회전 시, 새롭게 꽂아주지 않으면 제대로 작동하지 않는다.
//    if ([self.dataSource numberOfItemsInPickerView:self] > 0) {
//        [self selectItemIndex:self.selectedItemIndex animated:NO notify:NO];
//    }
    //
    // 회전 또는 최초 로딩 시, 애니메이션 없이 동작하도록하자.
    //! 레이아웃을 갱신 할때에는 반드시 순서를 지켜야한다.
    //! 1. collectionViewLayout 객체의 invalidateLayout 메서드 호출
    //! 2. collectionView 객체의 frame 맞추기
    //! 3. collectionViewLayout 객체에 새로운 collectionViewLayout객체 꽂기.
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUDosePickerView *self) {
    self->_mode = MGUDosePickerViewModeTitle;
    self->_font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self->_highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self->_textColor = [UIColor darkGrayColor];
    self->_highlightedTextColor = [UIColor blackColor];
    self->_pickerViewStyle = MGUDosePickerViewStyleCylinder;
    self->_interitemSpacing = 40.f; // 사실 collection view의 interitemSpacing과는 무관하다. cell 자체의 크기를 확보하기 위해 사용했다.
    self->_selectedItemIndex = 0; // 첫 번째 아이템이 선택된 상태로 나오게 될 것이다.
    self->_soundOn = NO;      // 일반적으로 이 객체를 생성하는 객체가 YES로 바꿔줄 것이다.
    self->_notify  = YES;     // offset이 변경되면 델리게이트에게 알림을 준다.
    self.maskDisabled = NO;
    
    [self.collectionView removeFromSuperview];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:[self collectionViewLayout]];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // system inset에 영향을 받지 않으려면.
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self; // <UICollectionViewDelegateFlowLayout>, <UICollectionViewDelegate> 둘다!
    self.collectionView.allowsMultipleSelection = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[MGUDosePickerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //
    // UICollectionViewFlowLayout 클래스는 collectionView의 delegate가 <UICollectionViewDelegateFlowLayout>를 따를 것이라고
    // 간주한다.
    // - layoutSubviews를 이용하기로 했다.
    // self.collectionView.translatesAutoresizingMaskIntoConstraints = YES;
    // self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


#pragma mark - 세터 & 게터
- (CGPoint)contentOffset {
    return self.collectionView.contentOffset;
}

- (void)setEyePosition:(CGFloat)eyePosition {
    _eyePosition = eyePosition;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / eyePosition;
    self.collectionView.layer.sublayerTransform = transform;
    //
    // m34는 객체의 원근감을 준다.
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW13
}

//! 양끝을 희미하게 만든다. 양끝을 휘게 하는 것은 아니다.
- (void)setMaskDisabled:(BOOL)maskDisabled {
    _maskDisabled = maskDisabled;
    
    if (maskDisabled == YES) {
        self.collectionView.layer.mask = nil;
    } else {
        self.collectionView.layer.mask = ({
            CAGradientLayer *maskLayer = [CAGradientLayer layer];
            maskLayer.frame = self.collectionView.bounds;
            maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor blackColor] CGColor],
                                 (id)[[UIColor blackColor] CGColor],
                                 (id)[[UIColor clearColor] CGColor]];
            maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
            maskLayer.startPoint = CGPointMake(0.5, 0.0);
            maskLayer.endPoint = CGPointMake(0.5, 1.0);
            maskLayer;
        });
    }
}

- (void)setPickerViewStyle:(MGUDosePickerViewStyle)pickerViewStyle {
    _pickerViewStyle = pickerViewStyle;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - 컨트롤
- (void)reloadData {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    if ([self.dataSource numberOfItemsInPickerView:self] > 0) {
        _centerFocusItemIndex = self.selectedItemIndex;
        [self selectItemIndex:self.selectedItemIndex animated:NO notify:NO];
    }
}

//! 핵심.
- (void)selectItemIndex:(NSUInteger)itemIndex animated:(BOOL)animated notify:(BOOL)notify {
    self.notify = notify;               // 위치를 옮겨서는 안된다.
    self.selectedItemIndex = itemIndex; // 위치를 옮겨서는 안된다.
    
    CGPoint targetOffset = CGPointMake(self.contentOffset.x, [self offsetForItem:itemIndex]);
    if (CGPointEqualToPoint(targetOffset, self.contentOffset) == NO) {
        if (animated == YES) {
            self.collectionView.userInteractionEnabled = NO;
        }
        [self.collectionView setContentOffset:targetOffset animated:animated];
    }
    
    if (notify == YES && [self.delegate respondsToSelector:@selector(pickerView:didSelectItemIndex:)]) {
        [self.delegate pickerView:self didSelectItemIndex:itemIndex];
    }
    //
    // 1. 셀렉티드 아이템을 기억한다.
    // 2. - selectItemAtIndexPath:animated:scrollPosition: 아이템을 선택하게 한다. 굵은 글씨로 표시되게 한다.
    // 3. 스크롤로 이동한다.
    // 4. animated == YES 이면, 델리게이트에게 바뀌었다고 알린다.
    // 이리저리 움직이다. 최종적으로 최초의 위치보다 이동했다고 하더라도, 마지막 터치 위치에서 변함이 조정이 없을 때에는 추가 무빙없이 셀렉 정보만 갱신할 수 있다.
}

//! 멈췄을 때, 실행된다.
- (void)mgrScrollStop {
    switch (self.pickerViewStyle) {
        case MGUDosePickerViewStyleFlat :
        case MGUDosePickerViewStyleFlatCenterPop: {
            CGPoint center = [self convertPoint:self.collectionView.center toView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
            [self selectItemIndex:indexPath.item animated:YES notify:YES];
            break;
        }
        case MGUDosePickerViewStyleCylinder: {
            for (NSUInteger i = 0; i < [self collectionView:self.collectionView numberOfItemsInSection:0]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                if ([self offsetForItem:i] + cell.bounds.size.height / 2 > self.contentOffset.y) {
                    [self selectItemIndex:i animated:YES notify:YES];
                    break;
                }
            }
            break;
        }
        default: break;
    }
    
    self.notify = NO;
    //
    // MGRHRPickerViewStyle3D 일 경우 한 바퀴 돌아버릴 경우, MGRHRPickerViewStyleFlat과 같은 식으로 찾을 수 없다. 겹쳐버림.
}


#pragma mark - <MGUDosePickerViewInterface> 프로토콜 메서드
//! MGUDosePickerCollectionViewLayout에게 공개된다.
- (MGUDosePickerViewStyle)pickerViewStyleForCollectionViewLayout:(MGUDosePickerCollectionViewLayout *)layout {
    return self.pickerViewStyle;
}


#pragma mark - <UICollectionViewDataSource> 프로토콜 메서드
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInPickerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGUDosePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                    forIndexPath:indexPath];
    
    if (self.mode == MGUDosePickerViewModeTitle && [self.dataSource respondsToSelector:@selector(pickerView:titleForItemIndex:)]) {
        NSString *title = [self.dataSource pickerView:self titleForItemIndex:indexPath.item];
        cell.label.text = title;
        cell.label.textColor = self.textColor;
        cell.label.highlightedTextColor = self.highlightedTextColor;
        cell.label.font = self.font;
        cell.font = self.font;
        cell.highlightedFont = self.highlightedFont;
        cell.label.bounds = (CGRect){CGPointZero, [self sizeForString:title]};
        
    }
    if (self.mode == MGUDosePickerViewModeImage && [self.dataSource respondsToSelector:@selector(pickerView:imageForItemIndex:)]) {
        cell.imageView.image = [self.dataSource pickerView:self imageForItemIndex:indexPath.item];
    }
    
    if (indexPath.item == self.selectedItemIndex) {
        cell.selected = YES;
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    } else {
        cell.selected = NO;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}


#pragma mark - <UICollectionViewDelegateFlowLayout> 프로토콜 메서드
//! UICollectionViewFlowLayout의 itemSize 프라퍼티를 이용하여 모두 동일하게 설정할 수도 있다.
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(collectionView.bounds.size.width, self.interitemSpacing);

    if (self.mode == MGUDosePickerViewModeTitle && [self.dataSource respondsToSelector:@selector(pickerView:titleForItemIndex:)]) { // 타이틀로 콜렉션 뷰를 만들꺼냐
        NSString *title = [self.dataSource pickerView:self titleForItemIndex:indexPath.item];
        size.height = size.height + [self sizeForString:title].height;
    }

    if (self.mode == MGUDosePickerViewModeImage && [self.dataSource respondsToSelector:@selector(pickerView:imageForItemIndex:)]) { // 이미지로 콜렉션 뷰를 만들꺼냐
        UIImage *image = [self.dataSource pickerView:self imageForItemIndex:indexPath.item];
        size.height = size.height + image.size.height;
    }
    return size; // return CGSizeMake(100.f, collectionView.bounds.size.height); 단일 크기를 원한다면 이렇게 하라.
    //
    // 본 메서드를 사용하므로써 itemSize가 모두 같지 않게 설정할 수도 있다.
    // 그러나 모두 같게 설정하는 경우에도 여러가지 고려사항을 통해 델리게이트에서 설정할 수도 있다.
}

//! UICollectionViewFlowLayout의 sectionInset 프라퍼티를 이용하여 모두 동일하게 설정할 수도 있다.
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake((collectionView.bounds.size.height - firstSize.height) / 2, 0.0,
                            (collectionView.bounds.size.height - lastSize.height) / 2, 0.0);
    //
    // 본 메서드를 사용하므로써 sectionInset가 모두 같지 않게 설정할 수도 있다.
    // 그러나 모두 같게 설정하는 경우에도 여러가지 고려사항을 통해 델리게이트에서 설정할 수도 있다.
}


// <UICollectionViewDelegateFlowLayout> -> <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedItemIndex != indexPath.item) {
        [self selectItemIndex:indexPath.item animated:YES notify:YES];
    }
    //
    // 손가락으로 탭했을 때, 실행된다. 탭을 연속으로 쳤을 때 문제가 생기므로 탭을 치면 인터렉션을 잠그고 애니메이션이 끝나면 풀어버린다.
}

// <UICollectionViewDelegateFlowLayout> -> <UICollectionViewDelegate> -> <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.notify = YES; // 손가락으로 움직일때, notify가 잠겼다면 풀어준다. sound 자체를 막고 싶다면 soundOn 프라퍼티 이용.
}

//! 스크롤이 되면 반응한다. 움직이는 순간 순간마다 호출될 것이다.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    [CATransaction begin];
    [CATransaction setDisableActions:YES]; // mask layer
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
    [CATransaction commit];
    
    [self selectMiddleCellWhileScrolling];
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) { // 이 자체가 알림이 아니다.
        [self.delegate scrollViewDidScroll:scrollView]; // 아마 사용하지 않을 것이다.
    }
}

//! 터치로 스크롤이 멈출때(decelerate == NO), 스와이프로 밀어서 손가락이 떨어지고 스스로 굴러 갈때(decelerate == YES)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self mgrScrollStop];
    }
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate]; // 아마 사용하지 않을 것이다.
    }
    //
    // 스와이프로 밀어서 알아서 굴러갈 때에도, 그냥 터치하고 바로 때도 이 메서드가 호출된다. 이것을 구분하는 것은 decelerate 매개변수이다.
}

//! 스와이프로 스크롤이 돌다가 멈출때
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.isTracking == NO) { // 사용자가 content view를 터치했지만 아직 드래그하지 않은 경우 isTracking 프라퍼티의 값은 YES이다.
        [self mgrScrollStop];
    }
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView]; // 아마 사용하지 않을 것이다.
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.collectionView.userInteractionEnabled = YES;
    self.notify = NO;
    //
    // 탭을 빠르게 쳤을 때, 문제가 생기므로 잠그고 여기서 풀어버린다.
    // - collectionView:didSelectItemAtIndexPath: 여기서 잠궜다.
}


#pragma mark - 지원
- (MGUDosePickerCollectionViewLayout *)collectionViewLayout {
    return [MGUDosePickerCollectionViewLayout new];
}

- (CGSize)sizeForString:(NSString *)string {
    CGSize size;
    CGSize highlightedSize;
    size = [string sizeWithAttributes:@{NSFontAttributeName: self.font}];
    highlightedSize = [string sizeWithAttributes:@{NSFontAttributeName: self.highlightedFont}];
    return CGSizeMake(ceilf(MAX(size.width, highlightedSize.width)), ceilf(MAX(size.height, highlightedSize.height))); // 올림
}

//! item(cell)에 대하여 정 가운데 오게 했을 때의 offsetY
- (CGFloat)offsetForItem:(NSUInteger)item {
    CGFloat offset = 0.0;
    
    for (NSInteger i = 0; i < item; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize cellSize = [self collectionView:self.collectionView
                                        layout:self.collectionView.collectionViewLayout
                        sizeForItemAtIndexPath:indexPath];
        offset = offset + cellSize.height;
    }
    
    CGSize firstSize = [self collectionView:self.collectionView
                                     layout:self.collectionView.collectionViewLayout
                     sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    CGSize selectedSize = [self collectionView:self.collectionView
                                        layout:self.collectionView.collectionViewLayout
                        sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
    
    offset = offset - ((firstSize.height - selectedSize.height) / 2);
    return offset;
    //
    // 임의의 item에 대하여 그 item이 가운데 왔을 때, 갖게될 offsetX를 계산해준다.
}

//! - scrollViewDidScroll: 내부에서만 호출되며, 스크롤이 작동하고 있는 도중에 가장 가운데 있는 셀을 선택이 되게하며, 소리를 발생한다.
- (void)selectMiddleCellWhileScrolling {
    NSMutableArray<NSIndexPath *> *indexPathsForVisibleItems = [self.collectionView indexPathsForVisibleItems].mutableCopy;
    [indexPathsForVisibleItems sortUsingComparator:^NSComparisonResult(NSIndexPath *indexPath1, NSIndexPath *indexPath2) {
        CGFloat offset1 = [self offsetForItem:indexPath1.item];
        CGFloat offset2 = [self offsetForItem:indexPath2.item];
        
        if (ABS(offset1 - self.contentOffset.y) < ABS(offset2 - self.contentOffset.y)) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];

    //! 논리적 확정적 선택이 아닌 가시적 선택에 해당하며, 소리에 대응한다.
    NSIndexPath *indexPathsForSelectedItem = [self.collectionView indexPathsForSelectedItems].firstObject;
    [self.collectionView deselectItemAtIndexPath:indexPathsForSelectedItem animated:NO];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPathsForSelectedItem];
    cell.selected = NO;
    
    [self.collectionView selectItemAtIndexPath:indexPathsForVisibleItems.firstObject
                                      animated:NO
                                scrollPosition:UICollectionViewScrollPositionNone];
    cell = [self.collectionView cellForItemAtIndexPath:indexPathsForVisibleItems.firstObject];
    cell.selected = YES;
    [self setCenterFocusItemIndex:indexPathsForVisibleItems.firstObject.item];
    return;
    
    /**
    NSMutableArray<UICollectionViewCell *> *visibleCells = [self.collectionView.visibleCells mutableCopy];
    if (visibleCells == nil || visibleCells.count == 0) {
        return;
    }
    
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    CGFloat midY  = CGRectGetMidY(visibleRect);
    [visibleCells sortUsingComparator:^NSComparisonResult(UICollectionViewCell *obj1, UICollectionViewCell *obj2) {
        if (ABS(CGRectGetMidY(obj1.frame) - midY) < ABS(CGRectGetMidY(obj2.frame) - midY)) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    //! 논리적 확정적 선택이 아닌 가시적 선택에 해당하며, 소리에 대응한다.
    NSIndexPath *indexPathsForSelectedItem = [self.collectionView indexPathsForSelectedItems].firstObject;
    [self.collectionView deselectItemAtIndexPath:indexPathsForSelectedItem animated:NO];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPathsForSelectedItem];
    cell.selected = NO;
    
    NSIndexPath *indexPathCloseToCenter = [self.collectionView indexPathForCell:visibleCells.firstObject];
    [self.collectionView selectItemAtIndexPath:indexPathCloseToCenter animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    cell = [self.collectionView cellForItemAtIndexPath:indexPathCloseToCenter];
    cell.selected = YES;
    
    [self setCenterFocusItemIndex:indexPathCloseToCenter.item];
    */
}

- (void)setCenterFocusItemIndex:(NSUInteger)centerFocusItemIndex {
    if (_centerFocusItemIndex != centerFocusItemIndex) {
        _centerFocusItemIndex = centerFocusItemIndex;
        if(self.soundOn && self.notify && self.normalSoundPlayBlock) {
            self.normalSoundPlayBlock();
        }
    }
}

@end
