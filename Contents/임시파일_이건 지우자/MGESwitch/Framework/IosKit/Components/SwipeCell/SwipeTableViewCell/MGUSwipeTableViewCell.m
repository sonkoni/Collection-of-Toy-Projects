//
//  MGUSwipeTableViewCell.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "UIView+Extension.h"
#import "UITableView+Extension.h"
#import "MGUSwipeTableViewCell.h"
#import "MGUSwipeTableCellController.h"
#import "MGUSwipeActionsView.h"
#import "MGUSwipeAccessibilityCustomAction.h"

@interface SwipeTableViewCellLayer : CALayer
@end
@implementation SwipeTableViewCellLayer
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

@interface MGUSwipeTableViewCell () <MGUSwipeTableCellControllerDelegate>
@property (nonatomic, assign) BOOL isPreviouslySelected; // 디폴트 NO
@property (nonatomic, assign) CGFloat swipeOffset; // @dynamic
@property (nonatomic, strong) MGUSwipeTableCellController *swipeController;
@property (nonatomic, strong) UIView *insetGroupedStyleMaskView;
@end

@implementation MGUSwipeTableViewCell
@dynamic indexPath;
@dynamic swipeOffset;
@dynamic scrollView;

+ (Class)layerClass {
    return [SwipeTableViewCellLayer class];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
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
    [self.tableView.panGestureRecognizer removeTarget:self action:nil];
}

//! 회전시에 cell 이 열렸을 때에, 열림을 유지해준다. 열렸을 때, safeArea에 따른 길이의 섬세한 조절은 - traitCollectionDidChange:
- (void)setFrame:(CGRect)frame {
    CGRect bounds = self.bounds;
     if (self.state != MGUSwipeStateCenter) {
         CGFloat originX = CGRectGetMinX(self.frame);
         frame = CGRectMake(originX, CGRectGetMinY(frame), frame.size.width, frame.size.height);
         bounds.origin.x = - originX;
    }
    [super setFrame:frame];
    self.maskView.frame = bounds;
}

- (void)setCenter:(CGPoint)center {
    [super setCenter:center];
    
    CGFloat radius = self.frame.size.width / 2.0;
    CGFloat length = radius - center.x;
    CGRect frame = self.bounds;
    frame.origin.x = length;
    self.maskView.frame = frame;
}

// SwipeController.m 파일의 - showActionsViewFor: 메서드에서 self.originalLayoutMargins = self.swipeableCell.layoutMargins;
// 이렇게 저장을 해서 썼는데, 좋은 방법이 아니다. 회전에서 문제가 생긴다. 따라서 아래와 같이 수정한다.
- (UIEdgeInsets)layoutMargins {
    UIEdgeInsets defaultEdgeInsets = [super layoutMargins];
    
    if (self.frame.origin.x != 0.0 && self.tableView.style != UITableViewStyleInsetGrouped) {
        UIEdgeInsets tableEdgeInsets = self.tableView.layoutMargins;
        defaultEdgeInsets.left = MAX(defaultEdgeInsets.left, tableEdgeInsets.left);
        defaultEdgeInsets.right = MAX(defaultEdgeInsets.right, tableEdgeInsets.right);
    }
    
    return defaultEdgeInsets;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    UIView *view = self;
    while (view.superview != nil) {
        view = view.superview;
        if ([view isKindOfClass:[UITableView class]] == YES) {
            self.tableView = (UITableView *)view;
            self.swipeController.tableView = self.tableView;
            [self.tableView.panGestureRecognizer removeTarget:self action:nil];
            [self.tableView.panGestureRecognizer addTarget:self action:@selector(handleTablePan:)];
            
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)] == NO) {
                NSCAssert(FALSE, @"- tableView:willDisplayCell:forRowAtIndexPath: 구현하고 내부에서 maskView의 frame을 조정해야한다.");
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
        for (MGUSwipeTableViewCell *cell in [self.tableView swipeCells]) {
            if ((cell.state ==     MGUSwipeStateLeft || cell.state ==     MGUSwipeStateRight) && ![cell containsPoint:point]) { // cell은 self가 아니다.
                [self.tableView hideSwipeCell]; // 다른 곳을 터치하면 사라지게 만든다.
                break;
            }
        }
    }
    
    return [self containsPoint:point];
}


//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    if (editing == YES) {
//        [self hideSwipeAnimated:NO completion:nil];
//    }
//}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (self.state == MGUSwipeStateCenter || self.state ==     MGUSwipeStateAnimatingToCenter) {
        [super setEditing:editing animated:animated];
    } else if (self.state !=     MGUSwipeStateDragging) {
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
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.state == MGUSwipeStateCenter) {
        [super setHighlighted:highlighted animated:animated];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.superview.window.rootViewController.view layoutIfNeeded]; // Diffable로 오면서 이렇게 안하면 업데이트가 느림.
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
    NSIndexPath * indexPath = [self.tableView indexPathForCell:self];
    if (indexPath == nil) {
        return [super accessibilityCustomActions];
    }
        
//    NSMutableArray <SwipeAction *>*leftActions = [self.delegate tableView:self.tableView
//                                             editActionsForRowAtIndexPath:indexPath
//                                                           forOrientation:SwipeActionsOrientationLeft].mutableCopy;
//
//    NSMutableArray <SwipeAction *>*rightActions = [self.delegate tableView:self.tableView
//                                              editActionsForRowAtIndexPath:indexPath
//                                                            forOrientation:SwipeActionsOrientationRight].mutableCopy;
    
    NSMutableArray <MGUSwipeAction *>*leftActions = [self.delegate tableView:self.tableView
                           leading_SwipeActionsConfigurationForRowAtIndexPath:indexPath].actions.mutableCopy;
    
    NSMutableArray <MGUSwipeAction *>*rightActions = [self.delegate tableView:self.tableView
                           trailing_SwipeActionsConfigurationForRowAtIndexPath:indexPath].actions.mutableCopy;

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
    _isPreviouslySelected = NO;
    _state = MGUSwipeStateCenter;
    _insetGroupedStyleMaskView = [UIView new];
    self.insetGroupedStyleMaskView.backgroundColor = [UIColor redColor];
    self.maskView = self.insetGroupedStyleMaskView;

    self.clipsToBounds = NO; // swipe 했을 때, 옆에 붙어있는 actionview가 보여야 하므로.
    self.layer.masksToBounds = NO;
    self.swipeController = [[MGUSwipeTableCellController alloc] initWithSwipeableCell:self actionsContainerView:self];
    self.swipeController.delegate = self;
}

- (void)reset {
    [self.swipeController reset];
    self.clipsToBounds = NO;
}

- (void)resetSelectedState {
    if (self.isPreviouslySelected == YES) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
        if (indexPath != nil) {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    self.isPreviouslySelected = NO;
}


#pragma mark - 세터 & 게터
- (NSIndexPath *)indexPath {
    return [self.tableView indexPathForCell:self];
}

- (CGFloat)swipeOffset {
    return CGRectGetMidX(self.frame) - CGRectGetMidX(self.bounds);
}

- (void)setSwipeOffset:(CGFloat)swipeOffset {
    [self setSwipeOffset:swipeOffset animated:NO completion:nil];
}

- (UIScrollView *)scrollView { // 호환성을 위해.
    return (UIScrollView *)(self.tableView);
}


#pragma mark - <SwipeControllerDelegate>
- (BOOL)swipeController:(MGUSwipeTableCellController *)controller canBeginEditingSwipeableForOrientation:(MGUSwipeActionsOrientation)orientation {
    return (self.editing == NO);
}

- (MGUSwipeActionsConfiguration *)leftSwipeActionsConfigurationForSwipeController:(MGUSwipeTableCellController *)controller {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (indexPath == nil) {
        return nil;
    }
    return [self.delegate tableView:self.tableView leading_SwipeActionsConfigurationForRowAtIndexPath:indexPath];
}

- (MGUSwipeActionsConfiguration *)rightSwipeActionsConfigurationForSwipeController:(MGUSwipeTableCellController *)controller {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (indexPath == nil) {
        return nil;
    }
    return [self.delegate tableView:self.tableView trailing_SwipeActionsConfigurationForRowAtIndexPath:indexPath];
}


- (void)swipeController:(MGUSwipeTableCellController *)controller willBeginSwipeForOrientation:(MGUSwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (indexPath == nil) {
        return;
    }
    
    [super setHighlighted:NO animated:NO];
    self.isPreviouslySelected = self.isSelected;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // delegate 메소드 구현 여부 확인
    if ((orientation == MGUSwipeActionsOrientationLeft && [self.tableView mgrIsRTLLocale] == NO) ||
            (orientation == MGUSwipeActionsOrientationRight && [self.tableView mgrIsRTLLocale] == YES)) { // leading
        if([self.delegate respondsToSelector:@selector(tableView:willBeginLeadingSwipeAtIndexPath:)]) {
            [self.delegate tableView:self.tableView willBeginLeadingSwipeAtIndexPath:indexPath];
        }
    } else {  // trailing
        if([self.delegate respondsToSelector:@selector(tableView:willBeginTrailingSwipeAtIndexPath:)]) {
            [self.delegate tableView:self.tableView willBeginTrailingSwipeAtIndexPath:indexPath];
        }
    }
}

- (void)swipeController:(MGUSwipeTableCellController *)controller didEndSwipeForOrientation:(MGUSwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (indexPath != nil) {
        MGUSwipeActionsView *actionsView = self.actionsView;
        if (actionsView != nil) {
            [self resetSelectedState];
            // delegate 메소드 구현 여부 확인
            if ((orientation == MGUSwipeActionsOrientationLeft && [self.tableView mgrIsRTLLocale] == NO) ||
                    (orientation == MGUSwipeActionsOrientationRight && [self.tableView mgrIsRTLLocale] == YES)) { // leading
                if([self.delegate respondsToSelector:@selector(tableView:didEndLeadingSwipeAtIndexPath:)]) {
                    [self.delegate tableView:self.tableView didEndLeadingSwipeAtIndexPath:indexPath];
                }
            } else {  // trailing
                if([self.delegate respondsToSelector:@selector(tableView:didEndTrailingSwipeAtIndexPath:)]) {
                    [self.delegate tableView:self.tableView didEndTrailingSwipeAtIndexPath:indexPath];
                }
            }
        }
    }
}

- (CGRect)swipeController:(MGUSwipeTableCellController *)controller visibleRectForTableView:(UITableView *)tableView {
    if (self.tableView == nil) {
        return CGRectNull;
    }
    
    // delegate 메소드 구현 여부 확인
    if([self.delegate respondsToSelector:@selector(visibleRectForTableView:)]) {
        return [self.delegate visibleRectForTableView:self.tableView];
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
- (void)didRemoveActionsView:(UIView *)actionsView {}

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


#pragma mark - Accessibility Target - Action : VoiceOver ON 에서 작동이 되는 것이 확인되었음.
- (BOOL)performAccessibilityCustomAction:(MGUSwipeAccessibilityCustomAction *)accessibilityCustomAction {
    if (self.tableView == nil) {
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
        [self.tableView deleteRowsAtIndexPaths:@[accessibilityCustomAction.indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    return YES;
}

@end

@implementation UITableView (MGUSwipeCellKit)

- (NSArray <MGUSwipeTableViewCell *>*)swipeCells {
    NSMutableArray <MGUSwipeTableViewCell *>*visibleCells = self.visibleCells.mutableCopy;
    for (MGUSwipeTableViewCell * cell in visibleCells.reverseObjectEnumerator) {
        if ([cell isKindOfClass:[MGUSwipeTableViewCell class]] == NO) {
            [visibleCells removeObject:cell];
        }
    }
    
    return visibleCells;
}

- (void)hideSwipeCell {
    for (MGUSwipeTableViewCell *cell in [self swipeCells]) {
        [cell hideSwipeAnimated:YES completion:nil];
    }
}

@end

@implementation UITableViewDiffableDataSource (MGUSwipeCellKit)

- (void)mgrSwipeApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
                    tableView:(UITableView *)tableView
                   completion:(void(^)(void))completion  {
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
    MGUSwipeTableViewCell *cell = (MGUSwipeTableViewCell *)[tableView cellForRowAtIndexPath:deleteIndexPath];
    BOOL tempMask = NO;
    if (cell.maskView != nil) {
        cell.maskView.frame = CGRectIntegral(cell.maskView.frame);
    } else {
        CGSize size = cell.bounds.size;
        UIView *maskView = [UIView new];
        maskView.backgroundColor = [UIColor redColor];
        maskView.frame = CGRectIntegral(CGRectMake(-size.width, 0.0, size.width * 3.0, size.height));
        cell.maskView = maskView;
        tempMask = YES;
    }
    
    UITableViewRowAnimation previousAnimation = self.defaultRowAnimation;
    self.defaultRowAnimation = UITableViewRowAnimationNone;
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:UITableViewDeleteRowDuration
                                                                            dampingRatio:1.0
                                                                             animations:^{
        [self applySnapshot:snapshot animatingDifferences:YES completion:completion];
        CGRect frame = cell.maskView.frame;
        frame.size.height = 0.0;
        cell.maskView.frame = frame;
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        cell.center = CGPointMake(CGRectGetMidX(cell.bounds), cell.center.y);
        [cell reset];
        if (tempMask == NO) {
            cell.maskView.frame = cell.bounds;
        } else {
            [cell.maskView removeFromSuperview];
        }
        self.defaultRowAnimation = previousAnimation;
    }];
    [animator startAnimationAfterDelay:0.0];
}
@end
