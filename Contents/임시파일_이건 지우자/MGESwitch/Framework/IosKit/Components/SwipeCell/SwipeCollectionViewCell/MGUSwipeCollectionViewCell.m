//
//  MGUSwipeCollectionViewCell.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "UIView+Extension.h"
#import "MGUFlowView.h"
#import "MGUSwipeCollectionViewCell.h"
#import "MGUSwipeColCellController.h"
#import "MGUSwipeActionsView.h"
#import "MGUSwipeDecoEdgeView.h"
#import "MGUSwipeAccessibilityCustomAction.h"


static const MGUSwipeActionsOrientation SwipeActionsOrientationUnknown = 10000.0;

@interface MGUSwipeableContentView : UIView
@end

@implementation MGUSwipeableContentView
//! swipeableContentView 옆에있는 'SwipeActionsView'에서 터치를 감지하는 데 필요하다.
//! cell의 minY / maxY 내의 어느 곳에서나 터치를 받아 들일 수 있다.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event { //! UIView에 존재하는 메서드.
    if (self.superview == nil) {
        return NO;
    }

    point = [self convertPoint:point toCoordinateSpace:self.superview];
//    if (UIAccessibilityIsVoiceOverRunning() == NO) {
//        for (MGRSwipeCollectionViewCell *cell in [self.collectionView swipeCells]) {
//            if ((cell.state == SwipeStateLeft || cell.state == SwipeStateRight) && ![cell containsPoint:point]) { // cell은 self가 아니다.
//                [self.collectionView hideSwipeCell]; // 다른 곳을 터치하면 사라지게 만든다.
//                break;
//            }
//        }
//    }
    return [self containsPoint:point];
}
- (BOOL)containsPoint:(CGPoint)point {
    return (point.y > CGRectGetMinY(self.frame) && point.y < CGRectGetMaxY(self.frame));
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maskView = [UIView new];
        self.maskView.backgroundColor = [UIColor redColor];
        self.maskView.frame = self.bounds;
    }
    return self;
}

- (void)setCenter:(CGPoint)center {
    [super setCenter:center];
    CGRect frame = self.frame;
    CGFloat originX = frame.origin.x;
    CGRect newMaskFrame = self.bounds;
    newMaskFrame.size.width = frame.size.width + ABS(originX);
    if (originX > 0.0) {
        newMaskFrame.origin.x = -1.0 * originX;
    }
    
    self.maskView.frame = newMaskFrame;
}

@end


@interface MGUSwipeCollectionViewCellLayer : CALayer
@end

@implementation MGUSwipeCollectionViewCellLayer
- (void)setMasksToBounds:(BOOL)masksToBounds { //! - deleteRowsAtIndexPaths:withRowAnimation: 는 메서드가 강제로 YES를 때리므로.
    if (masksToBounds == NO) {
        [super setMasksToBounds:NO];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (self.mask != nil) {
        [super setCornerRadius:0.0];
        self.mask.cornerRadius = cornerRadius;
    } else {
        [super setCornerRadius:cornerRadius];
    }

}

- (void)setMaskedCorners:(CACornerMask)maskedCorners {
    if (self.mask != nil) {
        [super setMaskedCorners:0];
        self.mask.maskedCorners = maskedCorners;
    } else {
        [super setMaskedCorners:maskedCorners];
    }
}

@end

@interface MGUSwipeCollectionViewCell () <MGUSwipeColCellControllerDelegate>
@property (nonatomic, assign) BOOL isPreviouslySelected; // 디폴트 NO
@property (nonatomic, assign) CGFloat swipeOffset; // @dynamic
@property (nonatomic, strong) MGUSwipeColCellController *swipeController;
@property (nonatomic, assign) CGSize previousSize;
@property (nonatomic, assign) MGUSwipeActionsOrientation orientation; // 디폴트 NO 액션뷰가 왼쪽에 붙어서 나오는가의 여부. 일반적인 트레일링은 NO이다.
//@property (nonatomic, strong) CALayer *contentViewMaskLayer;
//@property (nonatomic, strong) UIView *insetGroupedStyleMaskView;
@property (nonatomic, weak) UIView *swipeableContentViewUsingMaskView;
@property (nonatomic, strong) MGUSwipeDecoEdgeView *decoEdgeView;
@end

@implementation MGUSwipeCollectionViewCell
@dynamic indexPath;
@dynamic swipeOffset;
@dynamic scrollView;
@dynamic contentView;

+ (Class)layerClass {
    return [MGUSwipeCollectionViewCellLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

//!  - dequeueReusableCellWithIdentifier: 이 메서드에서 반환 전에 호출된다.
//! FIXME: 불필요한 것으로 예상된다.
- (void)prepareForReuse { // 이거 안써도 상관 없을 것 같다.
    [super prepareForReuse]; // super를 반드시 호출해야한다.
    [self reset];
    [self resetSelectedState];
}

- (void)dealloc {
    [self.collectionView.panGestureRecognizer removeTarget:self action:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self updateContentViewMaskLayerFrame];
    
    if (CGSizeEqualToSize(_previousSize, self.bounds.size) == NO) { // 사이즈가 변할때.
        _previousSize = self.bounds.size;
        [self.swipeController traitCollectionDidChangeFromPreviousTraitCollrection:self.traitCollection
                                                         toCurrentTraitCollrection:self.traitCollection];
    }
}

//! 회전시에 cell 이 열렸을 때에, 열림을 유지해준다. 열렸을 때, safeArea에 따른 길이의 섬세한 조절은 - traitCollectionDidChange:
//- (void)setFrame:(CGRect)frame {
//    CGRect bounds = self.bounds;
//    if (self.state != SwipeStateCenter) {
//         CGFloat originX = CGRectGetMinX(self.frame);
//         frame = CGRectMake(originX, CGRectGetMinY(frame), frame.size.width, frame.size.height);
//         bounds.origin.x = - originX;
//    }
//    [super setFrame:frame];
//    self.maskView.frame = bounds;
//}


// SwipeController.m 파일의 - showActionsViewFor: 메서드에서 self.originalLayoutMargins = self.swipeableCell.layoutMargins;
// 이렇게 저장을 해서 썼는데, 좋은 방법이 아니다. 회전에서 문제가 생긴다. 따라서 아래와 같이 수정한다.
- (UIEdgeInsets)layoutMargins {
    UIEdgeInsets defaultEdgeInsets = [super layoutMargins];
    
    //! 가로로 꽉 찬 셀이 이동을 했다면.
    CGFloat cellWidth = self.frame.size.width;
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    if ((ABS(cellWidth - collectionViewWidth) < FLT_EPSILON) &&
        (self.frame.origin.x != 0.0)) {
        UIEdgeInsets collectionViewEdgeInsets = self.collectionView.layoutMargins;
        defaultEdgeInsets.left = MAX(defaultEdgeInsets.left, collectionViewEdgeInsets.left);
        defaultEdgeInsets.right = MAX(defaultEdgeInsets.right, collectionViewEdgeInsets.right);
    }
    
    //! 가로로 꽉 찬 셀이 이동을 했다면.
//    if (self.frame.origin.x != 0.0 && self.tableView.style != UITableViewStyleInsetGrouped) {
//        UIEdgeInsets tableEdgeInsets = self.tableView.layoutMargins;
//        defaultEdgeInsets.left = MAX(defaultEdgeInsets.left, tableEdgeInsets.left);
//        defaultEdgeInsets.right = MAX(defaultEdgeInsets.right, tableEdgeInsets.right);
//    }
    
    return defaultEdgeInsets;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    UIView *view = self;
    while (view.superview != nil) {
        view = view.superview;
        if ([view isKindOfClass:[UICollectionView class]] == YES) {
            self.collectionView = (UICollectionView *)view;
            self.swipeController.collectionView = self.collectionView;
            [self.collectionView.panGestureRecognizer removeTarget:self action:nil];
            [self.collectionView.panGestureRecognizer addTarget:self action:@selector(handleTablePan:)];
            if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)] == NO) {
                NSCAssert(FALSE, @"- collectionView:willDisplayCell:forItemAtIndexPath: 구현하고 내부에서 maskView의 frame을 조정해야한다.");
                /**
                - (void)tableView:(UITableView *)tableView
                  willDisplayCell:(UITableViewCell *)cell
                forRowAtIndexPath:(NSIndexPath *)indexPath {
                    if (cell.maskView != nil) {
                        cell.maskView.frame = cell.bounds;
                    }
                }*/
            }
            return;
        }
    }
}

//! SwipeTableCell 옆에있는 'SwipeActionsView'에서 터치를 감지하는 데 필요하다.
//! cell의 minY / maxY 내의 어느 곳에서나 터치를 받아 들일 수 있다.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event { //! UIView에 존재하는 메서드.
    if (self.superview == nil) {
        return NO;
    }

    point = [self convertPoint:point toCoordinateSpace:self.superview];
    
    if (UIAccessibilityIsVoiceOverRunning() == NO) {
        for (MGUSwipeCollectionViewCell *cell in [self.collectionView swipeCells]) {
            if ((cell.state ==     MGUSwipeStateLeft || cell.state ==     MGUSwipeStateRight) && ![cell containsPoint:point]) { // cell은 self가 아니다.
                [self.collectionView hideSwipeCell]; // 다른 곳을 터치하면 사라지게 만든다.
                break;
            }
        }
    }
    return [self containsPoint:point];
}

/** 콜렉션뷰에는 해당 메서드가 존재하지 않는다.
 - (void)setEditing:(BOOL)editing animated:(BOOL)animated {
     [super setEditing:editing animated:animated];
     if (editing == YES) {
         [self hideSwipeAnimated:NO completion:nil];
     }
 }
 
 - (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (self.state == SwipeStateCenter || self.state == SwipeStateAnimatingToCenter) {
        [super setEditing:editing animated:animated];
    } else if (self.state != SwipeStateDragging) {
        self.userInteractionEnabled = NO;
        [self hideSwipeAnimated:YES completion:^(BOOL completion) {
            self.userInteractionEnabled = YES;
            [super setEditing:editing animated:animated];
        }];
    } else {
        self.userInteractionEnabled = NO;
        [self hideSwipeAnimated:YES completion:^(BOOL completion) {
            self.userInteractionEnabled = YES;
            [super setEditing:editing animated:animated];
        }];
    }
}*/

- (void)setHighlighted:(BOOL)highlighted {
    if (self.state == MGUSwipeStateCenter) {
        [super setHighlighted:highlighted];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.swipeController traitCollectionDidChangeFromPreviousTraitCollrection:previousTraitCollection
                                                     toCurrentTraitCollrection:self.traitCollection]; // action view를 제대로 고쳐주고 있다.
}

//! <UIGestureRecognizerDelegate> UITableViewCell은 디폴트로 이 프로토콜을 따른다.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self.swipeController gestureRecognizerShouldBegin:gestureRecognizer];
}


#pragma mark - UIKit NSObject (UIAccessibilityContainer) - VoiceOver ON 에서 작동이 되는 것이 확인되었음.
- (NSInteger)accessibilityElementCount {
    if (self.state == MGUSwipeStateCenter) {
        return [super accessibilityElementCount];
    }

    return 1;
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    if (self.state == MGUSwipeStateCenter) {
        return [super accessibilityElementAtIndex:index];
    }

    return self.actionsView;
    
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    if (self.state == MGUSwipeStateCenter) {
        return [super indexOfAccessibilityElement:element];
    }
    
    if ([element isKindOfClass:[MGUSwipeActionsView class]] == YES) {
        return 0;
    } else {
        return NSNotFound;
    }
}


#pragma mark - UIKit NSObject (UIAccessibilityAction) - VoiceOver ON 에서 작동이 되는 것이 확인되었음.
- (NSArray<UIAccessibilityCustomAction *> *)accessibilityCustomActions {
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:self];
    if (indexPath == nil) {
        return [super accessibilityCustomActions];
    }
    
    NSMutableArray <MGUSwipeAction *>*leftActions = [self.delegate collectionView:self.collectionView
                           leading_SwipeActionsConfigurationForItemAtIndexPath:indexPath].actions.mutableCopy;
    NSMutableArray <MGUSwipeAction *>*rightActions = [self.delegate collectionView:self.collectionView
                           trailing_SwipeActionsConfigurationForItemAtIndexPath:indexPath].actions.mutableCopy;

    if (leftActions == nil) {
        leftActions = @[].mutableCopy;
    }
    if (rightActions == nil) {
        rightActions = @[].mutableCopy;
    }
        
    NSMutableArray <MGUSwipeAction *>*actions = @[rightActions.firstObject, leftActions.firstObject].mutableCopy;
    [rightActions removeObjectAtIndex:0];
    [leftActions removeObjectAtIndex:0];
    [actions addObjectsFromArray:rightActions];
    [actions addObjectsFromArray:leftActions];
    
    if (actions.count > 0) {
        return [actions mgrMap:^id _Nonnull(MGUSwipeAction *action) {
            return [[MGUSwipeAccessibilityCustomAction alloc] initWithAction:action
                                                                indexPath:indexPath
                                                                   target:self
                                                                 selector:@selector(performAccessibilityCustomAction:)];
        }];

    } else {
        return [super accessibilityCustomActions];
    }
    
}


#pragma mark - 생성 & 소멸
- (void)_commonInit {
    _maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    _deleteDirectionReverse = NO;
    _orientation = SwipeActionsOrientationUnknown;
    _clip = YES;
    _previousSize = self.frame.size;
    _swipeableContentView = [MGUSwipeableContentView new];
//    _contentViewMaskLayer = [CALayer layer];
//    self.contentViewMaskLayer.backgroundColor = [UIColor redColor].CGColor;
    UIView *contentView = [super contentView];
    contentView.clipsToBounds = YES;
    contentView.layer.masksToBounds = YES;
//    contentView.layer.mask = self.contentViewMaskLayer;
    [contentView addSubview:self.swipeableContentView];
    [self.swipeableContentView mgrPinSizeToSuperviewSize];
    [self.swipeableContentView.centerYAnchor constraintEqualToAnchor:contentView.centerYAnchor].active = YES;
    _swipeableContentViewCenterXConstraint = [self.swipeableContentView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor];
    self.swipeableContentViewCenterXConstraint.active = YES;
//    self.contentViewMaskLayer.frame = contentView.layer.bounds;
    _isPreviouslySelected = NO;
    _state = MGUSwipeStateCenter;

    self.clipsToBounds = NO; // swipe 했을 때, 옆에 붙어있는 actionview가 보여야 하므로.
    self.layer.masksToBounds = NO;
    
    self.swipeController = [[MGUSwipeColCellController alloc] initWithSwipeableCell:self actionsContainerView:self.swipeableContentView];
    self.swipeController.delegate = self;
    
    //! 마스크 - 더미뷰를 이용한 오토레이아웃은 OS에 따라서 버그를 발생시킨다.
//    self.swipeableContentView.maskView = [UIView new];
//    UIView *autoMaskView = [UIView new];
//    self.swipeableContentView.maskView.userInteractionEnabled = NO;
//    autoMaskView.userInteractionEnabled = NO;
//    [self.swipeableContentView.maskView addSubview:autoMaskView];
//    autoMaskView.backgroundColor = [UIColor redColor];
//    autoMaskView.translatesAutoresizingMaskIntoConstraints = NO;
//    [autoMaskView.topAnchor constraintEqualToAnchor:self.swipeableContentView.topAnchor].active = YES;
//    [autoMaskView.bottomAnchor constraintEqualToAnchor:self.swipeableContentView.bottomAnchor].active = YES;
//    [autoMaskView.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.swipeableContentView.trailingAnchor].active = YES;
//    [autoMaskView.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.swipeableContentView.superview.trailingAnchor].active = YES;
//    [autoMaskView.leadingAnchor constraintLessThanOrEqualToAnchor:self.swipeableContentView.leadingAnchor].active = YES;
//    [autoMaskView.leadingAnchor constraintLessThanOrEqualToAnchor:self.swipeableContentView.superview.leadingAnchor].active = YES;
//    _swipeableContentViewUsingMaskView = autoMaskView;
    if (self.swipeableContentView.maskView != nil) {
        _swipeableContentViewUsingMaskView = self.swipeableContentView.maskView;
    } else {
        NSCAssert(FALSE, @"잘못만들었다.");
    }
    
    _decoEdgeView = [MGUSwipeDecoEdgeView new];
    [self.swipeableContentView addSubview:self.decoEdgeView];
    [self.decoEdgeView mgrPinEdgesToSuperviewEdges];
}

- (void)reset {
    [self.swipeController reset];
    self.clipsToBounds = NO;
}

- (void)resetSelectedState {
    if (self.isPreviouslySelected == YES) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
        if (indexPath != nil) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    self.isPreviouslySelected = NO;
}


#pragma mark - 세터 & 게터
- (NSIndexPath *)indexPath {
    return [self.collectionView indexPathForCell:self];
}

- (CGFloat)swipeOffset {
    return CGRectGetMidX(self.frame) - CGRectGetMidX(self.bounds);
}

- (void)setSwipeOffset:(CGFloat)swipeOffset {
    [self setSwipeOffset:swipeOffset animated:NO completion:nil];
}

- (UIScrollView *)scrollView { // 호환성을 위해.
    return (UIScrollView *)(self.collectionView);
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    UIView *contentView = [super contentView];
    self.layer.cornerRadius = cornerRadius;
    contentView.layer.cornerRadius = cornerRadius;
//    self.contentViewMaskLayer.cornerRadius = cornerRadius;
//    self.actionsUsingMaskView.layer.cornerRadius = cornerRadius;
    
    self.swipeableContentViewUsingMaskView.layer.cornerRadius = cornerRadius;
    self.decoEdgeView.cornerRadius = cornerRadius;
}

- (void)setMaskedCorners:(CACornerMask)maskedCorners {
    _maskedCorners = maskedCorners;
    UIView *contentView = [super contentView];
    self.layer.maskedCorners = maskedCorners;
    contentView.layer.maskedCorners = maskedCorners;
//    self.contentViewMaskLayer.maskedCorners = maskedCorners;
//    self.actionsUsingMaskView.layer.maskedCorners = maskedCorners;
    self.swipeableContentViewUsingMaskView.layer.maskedCorners = maskedCorners;
//    self.decoEdgeView.
}

- (void)setClip:(BOOL)clip {
    if (_clip != clip) {
        _clip = clip;
        UIView *contentView = [super contentView];
        if (clip == YES) {
            contentView.layer.masksToBounds = YES;
            contentView.clipsToBounds = YES;
        } else {
            contentView.layer.masksToBounds = NO;
            contentView.clipsToBounds = NO;
        }
    }
}


#pragma mark - <MGUSwipeColCellControllerDelegate>
- (BOOL)swipeController:(MGUSwipeColCellController *)controller
canBeginEditingSwipeableForOrientation:(MGUSwipeActionsOrientation)orientation {
    return YES;
    //! FIXME: 이거 해야할듯.
    //return (self.editing == NO);
}

- (MGUSwipeActionsConfiguration *)leftSwipeActionsConfigurationForSwipeController:(MGUSwipeColCellController *)controller {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
    if (indexPath == nil) {
        return nil;
    }
    return [self.delegate collectionView:self.collectionView leading_SwipeActionsConfigurationForItemAtIndexPath:indexPath];
}

- (MGUSwipeActionsConfiguration *)rightSwipeActionsConfigurationForSwipeController:(MGUSwipeColCellController *)controller {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
    if (indexPath == nil) {
        return nil;
    }
    return [self.delegate collectionView:self.collectionView trailing_SwipeActionsConfigurationForItemAtIndexPath:indexPath];
}

- (void)swipeController:(MGUSwipeColCellController *)controller willBeginSwipeForOrientation:(MGUSwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
    if (indexPath == nil) {
        return;
    }
    _orientation = orientation;
//    [self updateContentViewMaskLayerFrame];
    [super setHighlighted:NO];
    self.isPreviouslySelected = self.isSelected;
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    // delegate 메소드 구현 여부 확인
    if ((orientation == MGUSwipeActionsOrientationLeft && [self.collectionView mgrIsRTLLocale] == NO) ||
            (orientation == MGUSwipeActionsOrientationRight && [self.collectionView mgrIsRTLLocale] == YES)) { // leading
        if([self.delegate respondsToSelector:@selector(collectionView:willBeginLeadingSwipeAtIndexPath:)]) {
            [self.delegate collectionView:self.collectionView willBeginLeadingSwipeAtIndexPath:indexPath];
        }
    } else {  // trailing
        if([self.delegate respondsToSelector:@selector(collectionView:willBeginTrailingSwipeAtIndexPath:)]) {
            [self.delegate collectionView:self.collectionView willBeginTrailingSwipeAtIndexPath:indexPath];
        }
    }
    
    if (orientation == MGUSwipeActionsOrientationLeft) {
        self.decoEdgeView.swipeDecoLeftColor = self.swipeDecoLeftColor;
        self.decoEdgeView.swipeDecoRightColor = [UIColor clearColor];
    } else {
        self.decoEdgeView.swipeDecoRightColor = self.swipeDecoRightColor;
        self.decoEdgeView.swipeDecoLeftColor = [UIColor clearColor];
    }
}

- (void)swipeController:(MGUSwipeColCellController *)controller didEndSwipeForOrientation:(MGUSwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
    _orientation = SwipeActionsOrientationUnknown;
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0.7];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    [self updateContentViewMaskLayerFrame];
//    [CATransaction commit];
    
    //! 경우에 따라선 이렇게 줄 수도 있을 듯하다.
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    [self updateContentViewMaskLayerFrame];
//    [CATransaction commit];
    
    if (indexPath != nil) {
        MGUSwipeActionsView *actionsView = self.actionsView;
        if (actionsView != nil) {
            [self resetSelectedState];
            // delegate 메소드 구현 여부 확인
            if ((orientation == MGUSwipeActionsOrientationLeft && [self.collectionView mgrIsRTLLocale] == NO) ||
                    (orientation == MGUSwipeActionsOrientationRight && [self.collectionView mgrIsRTLLocale] == YES)) { // leading
                if([self.delegate respondsToSelector:@selector(collectionView:didEndLeadingSwipeAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView didEndLeadingSwipeAtIndexPath:indexPath];
                }
            } else {  // trailing
                if([self.delegate respondsToSelector:@selector(collectionView:didEndTrailingSwipeAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView didEndTrailingSwipeAtIndexPath:indexPath];
                }
            }
        }
    }
}

- (CGRect)swipeController:(MGUSwipeColCellController *)controller
visibleRectForCollectionView:(UICollectionView *)collectionView {
    if (self.collectionView == nil) {
        return CGRectNull;
    }
    
    // delegate 메소드 구현 여부 확인
    if([self.delegate respondsToSelector:@selector(visibleRectForCollectionView:)]) {
        return [self.delegate visibleRectForCollectionView:self.collectionView];
    } else {
        return CGRectNull;
    }
    
}


#pragma mark - Display
//! Public
- (void)hideSwipeAnimated:(BOOL)animated completion:(void(^ _Nullable)(BOOL))completion {
    [self.swipeController hideSwipeAnimated:animated completion:completion];
}

- (void)didAddActionsView:(UIView *)actionsView {}
- (void)didRemoveActionsView:(UIView *)actionsView {
    self.decoEdgeView.swipeDecoLeftColor = [UIColor clearColor];
    self.decoEdgeView.swipeDecoRightColor = [UIColor clearColor];
}

//! 좌측을 다보여줄지, 우측을 다 보여줄지
- (void)showSwipeOrientation:(MGUSwipeActionsOrientation)orientation
                    animated:(BOOL)animated
                  completion:(void(^ _Nullable)(BOOL))completion {
    [self setSwipeOffset:CGFLOAT_MAX * orientation * -1.0
                animated:animated
              completion:completion];
}

//! 얼만큼 보여줄지
- (void)setSwipeOffset:(CGFloat)offset
              animated:(BOOL)animated
            completion:(void(^ _Nullable)(BOOL))completion {
    [self.swipeController setSwipeOffset:offset animated:animated completion:completion];
}


#pragma mark - Action
//! 테이블 뷰 자체의 스크롤 제스처가 작동할 때, 만약 스와이프로 인해 열려있는 셀이 있다면 닫는다.
- (void)handleTablePan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state ==  UIGestureRecognizerStateBegan) {
        [self hideSwipeAnimated:YES completion:nil];
    }
}


#pragma mark - Helper
- (BOOL)containsPoint:(CGPoint)point {
    return (point.y > CGRectGetMinY(self.frame) && point.y < CGRectGetMaxY(self.frame));
}

//- (void)updateContentViewMaskLayerFrame {
//    UIView *contentView = [super contentView];
//    CGRect frame = contentView.layer.bounds;
//    if (_orientation == SwipeActionsOrientationUnknown) {
//    } else if (_orientation == SwipeActionsOrientationRight) {
//        frame.origin.x = frame.origin.x - frame.size.width;
//        frame.size.width = frame.size.width * 2.0;
//    } else if (_orientation == SwipeActionsOrientationLeft) {
//        frame.size.width = frame.size.width * 2.0;
//    } else {
//        NSCAssert(FALSE, @"불가능한 값이다.");
//    }
//    self.contentViewMaskLayer.frame = frame;
//}


#pragma mark - Accessibility Target - Action : VoiceOver ON 에서 작동이 되는 것이 확인되었음.
- (BOOL)performAccessibilityCustomAction:(MGUSwipeAccessibilityCustomAction *)accessibilityCustomAction {
    if (self.collectionView == nil) {
        return NO;
    }
    
    MGUSwipeAction *swipeAction = accessibilityCustomAction.action;
    
    NSArray <MGUSwipeAction *>*swipeActions = self.actionsView.actions;
    NSArray <MGUSwipeActionButton *>*buttons = self.actionsView.buttons;
    NSInteger index = [swipeActions indexOfObject:swipeAction];
    MGUSwipeActionButton *button = buttons[index];
    if (button == nil) {
        NSCAssert(FALSE, @"action에 해당하는 SwipeActionButton이 없다.");
    }
    
    if (swipeAction.handler != nil) {
        swipeAction.handler(swipeAction, (UIView *)button, ^(BOOL actionPerformed) {});
    }
    
//    if (swipeAction.handler != nil) {
//        swipeAction.handler(swipeAction, accessibilityCustomAction.indexPath);
//    }
    
    
    if (swipeAction.style == MGUSwipeActionStyleDestructive) {
        [self.collectionView deleteItemsAtIndexPaths:@[accessibilityCustomAction.indexPath]];
    }
    
    return YES;
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    NSCAssert(FALSE, @"- initWithCoder: 사용금지. 스와이프시에 문제가 발생하므로 코드로 만든다.");
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    NSCAssert(FALSE, @"xib로 초기화 금지이다. 스와이프시에 문제가 발생하므로 코드로 만든다.");
}
@end


@implementation UICollectionView (MGUSwipeCellKit)

- (NSArray <MGUSwipeCollectionViewCell *>*)swipeCells {
    NSMutableArray <MGUSwipeCollectionViewCell *>*visibleCells = self.visibleCells.mutableCopy;
    for (MGUSwipeCollectionViewCell * cell in visibleCells.reverseObjectEnumerator) {
        if ([cell isKindOfClass:[MGUSwipeCollectionViewCell class]] == NO) {
            [visibleCells removeObject:cell];
        }
    }
    
    return visibleCells;
}

- (void)hideSwipeCell {
    for (MGUSwipeCollectionViewCell *cell in [self swipeCells]) {
        [cell hideSwipeAnimated:YES completion:nil];
    }
}

//! FIXME: 이거 추가해야하나??
//func setGestureEnabled(_ enabled: Bool) {
//    gestureRecognizers?.forEach {
//        guard $0 != panGestureRecognizer else { return }
//
//        $0.isEnabled = enabled
//    }
//}
@end


@implementation UICollectionViewDiffableDataSource (MGUSwipeCellKit)
//- (void)mgrSwipeApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
//         animatingDifferences:(BOOL)animatingDifferences // 항상 YES 일듯.
//                   completion:(void (^)(void))completion {
//    
//}

- (void)mgrSwipeApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
               collectionView:(UICollectionView *)collectionView
                   completion:(void (^)(void))completion {
    NSArray *oldItemIdentifiers = self.snapshot.itemIdentifiers;
    NSArray *newItemIdentifiers = snapshot.itemIdentifiers;
    
    // 위키 : Project:Mac-ObjC/필터링
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", newItemIdentifiers];
    NSArray *deleteItems = [oldItemIdentifiers filteredArrayUsingPredicate:predicate];
    if (deleteItems == nil || deleteItems.count != 1) {
        NSCAssert(FALSE, @"제거된 아이템이 오직 한개가 존재해야한다.");
    }
    id deleteItem = deleteItems.firstObject;
    NSIndexPath *deleteIndexPath = [self indexPathForItemIdentifier:deleteItem];
    MGUSwipeCollectionViewCell *cell = (MGUSwipeCollectionViewCell *)[collectionView cellForItemAtIndexPath:deleteIndexPath];
    BOOL isReverse = cell.deleteDirectionReverse;
    BOOL tempMask = NO;
    if (cell.maskView != nil) {
        cell.maskView.frame = CGRectIntegral(cell.maskView.frame);
    } else {
        CGSize size = cell.bounds.size;
        UIView *maskView = [UIView new];
        maskView.backgroundColor = [UIColor redColor];
        CGFloat originX = 0.0;
        if ([collectionView mgrIsRTLLocale] == NO) {
            originX = -size.width;
        }
        maskView.frame = CGRectIntegral(CGRectMake(originX, 0.0, size.width * 2.0, size.height));
        // maskView.frame = CGRectIntegral(CGRectMake(-size.width, 0.0, size.width * 3.0, size.height));
        maskView.layer.cornerRadius = cell.layer.cornerRadius;
        maskView.layer.masksToBounds = YES;
        cell.maskView = maskView;
        tempMask = YES;
    }
    
    BOOL fitToSize = (ABS(collectionView.contentSize.height - collectionView.bounds.size.height) < FLT_EPSILON) ? YES : NO;
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:UICollectionViewDeleteItemDuration
                                                                            dampingRatio:1.0
                                                                             animations:^{
        [self applySnapshot:snapshot animatingDifferences:YES completion:completion];
//        MGRFlowLayout *layout = (MGRFlowLayout *)collectionView.collectionViewLayout;
//        if ([layout isKindOfClass:[MGRFlowLayout class]] == YES) {
//            [layout forceInvalidate];
//        } else {
//            [collectionView.collectionViewLayout invalidateLayout];
//        }
        
        CGRect frame = cell.maskView.frame;
        if (isReverse == YES && fitToSize == YES) {
            frame.origin.y = frame.origin.y + frame.size.height;
        }
        frame.size.height = 0.0;
        cell.maskView.frame = frame;
        
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        cell.swipeableContentViewCenterXConstraint.constant = 0.0;
        [cell reset];

        if (tempMask == NO) {
            cell.maskView.frame = cell.bounds;
        } else {
            [cell.maskView removeFromSuperview];
        }
        //! 반드시 맞춰줘야한다.
        cell.swipeableContentView.frame = cell.swipeableContentView.superview.bounds;
        cell.swipeableContentView.maskView.frame = cell.swipeableContentView.bounds;
    }];
    [animator startAnimationAfterDelay:0.0];
}
@end
