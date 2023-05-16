//
//  MGUSwipeColCellController.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "UIView+Extension.h"
#import "UIPanGestureRecognizer+Extension.h"
#import "MGUSwipeColCellController.h"
#import "MGUSwipeCollectionViewCell.h"
#import "MGUSwipeExpansionStyle.h"

@interface MGUSwipeColCellController ()
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer; // lazy
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer; // lazy
@property (nonatomic, weak, nullable) MGUSwipeCollectionViewCell *swipeableCell;
@property (nonatomic, weak, nullable) UIView *actionsContainerView;

@property (nonatomic, assign) CGFloat elasticScrollRatio; // 디폴트 0.4 고정.
@property (nonatomic, assign) CGFloat originalCenter;     // 디폴트 0.0
@property (nonatomic, assign) CGFloat scrollRatio;        // 디폴트 1.0
@property (nonatomic, strong, nullable) UIViewPropertyAnimator *animator;

@property (nonatomic, assign) BOOL expandedFullState; // 완전히 열려 있는 상태를 감지하기 위해. 회전에서 offset을 맞추기 위해.
@property (nonatomic, assign) MGUSwipeActionsOrientation initialOrientation; // iOS 13이하에서 이런 일이 발생한다. 초기 Velocity가 0.0 이 되는 일이 발생하여 이를 해결하기 위해.
@end

@implementation MGUSwipeColCellController

#pragma mark - 생성 & 소멸
- (instancetype)initWithSwipeableCell:(MGUSwipeCollectionViewCell *)swipeableCell
                 actionsContainerView:(UIView *)actionsContainerView { // 콜렉션 뷰에서는 contentView 이다.
    self = [super init];
    if (self) {
        _swipeableCell = swipeableCell;
        _actionsContainerView = actionsContainerView;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUSwipeColCellController *self) {
    // _originalLayoutMargins = UIEdgeInsetsZero;
    self->_expandedFullState = NO;
    self->_elasticScrollRatio = 0.4;
    self->_originalCenter = 0.0;
    self->_scrollRatio = 1.0;
        
    self->_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self->_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.tapGestureRecognizer.delegate = self;
    self.panGestureRecognizer.delegate = self;
    [self.swipeableCell addGestureRecognizer:self.tapGestureRecognizer];
    [self.swipeableCell addGestureRecognizer:self.panGestureRecognizer];
}


#pragma mark - Action
//!------ Action Public
- (void)setSwipeOffset:(CGFloat)offset
              animated:(BOOL)animated
            completion:(void(^ _Nullable)(BOOL))completion {
    
    MGUSwipeCollectionViewCell *swipeableCell = self.swipeableCell;
    UIView *actionsContainerView = self.actionsContainerView;
    if (swipeableCell == nil || actionsContainerView == nil) {
        return;
    }
    
    if (offset == 0.0) {
        [self hideSwipeAnimated:animated completion:completion];
        return;
    }
    
    MGUSwipeActionsOrientation orientation = offset > 0.0 ? MGUSwipeActionsOrientationLeft : MGUSwipeActionsOrientationRight;
    
    MGUSwipeState targetState;
    if (orientation == MGUSwipeActionsOrientationLeft) {
        targetState =     MGUSwipeStateLeft;
    } else {
        targetState =     MGUSwipeStateRight;
    }
    
    if (swipeableCell.state != targetState) {
        if ( [self showActionsViewForOrientation:orientation] == NO ) {
            return;
        }
        
        [self.collectionView hideSwipeCell];
        swipeableCell.state = targetState;
    }
    
    CGFloat maxOffset = MIN(swipeableCell.bounds.size.width, ABS(offset)) * orientation * -1.0;
    CGFloat targetCenter = (ABS(offset) == CGFLOAT_MAX) ? [self targetCenterActive:YES] : CGRectGetMidX(swipeableCell.bounds) + maxOffset;
    
    
    if (animated) {
        [self animateWithDuration:0.7 toOffset:targetCenter withInitialVelocity:0.0 completion:^(BOOL complete) {
            if (completion != nil) {
                completion(complete);
            }
        }];
        
    } else {
        CGFloat constraintConstant = [self constraintConstantForCenterPosition:targetCenter];
        swipeableCell.swipeableContentViewCenterXConstraint.constant = constraintConstant;
        swipeableCell.actionsView.visibleWidth = ABS(constraintConstant);
//        CGPoint center = actionsContainerView.center;
//        center.x = targetCenter;
//        actionsContainerView.center = center;
//        swipeableCell.actionsView.visibleWidth = ABS(CGRectGetMinX(actionsContainerView.frame));
    }
}

- (void)hideSwipeAnimated:(BOOL)animated completion:(void(^ _Nullable)(BOOL))completion {
    MGUSwipeCollectionViewCell *swipeableCell = self.swipeableCell;
    UIView *actionsContainerView = self.actionsContainerView;
    if (swipeableCell == nil || actionsContainerView == nil) {
        return;
    }
    if (swipeableCell.state == MGUSwipeStateCenter ||
        swipeableCell.state ==     MGUSwipeStateAnimatingToCenter) {
        return;
    }
    
    if (swipeableCell.state ==     MGUSwipeStateDragging) {
        self.panGestureRecognizer.enabled = NO; // UIGestureRecognizerStateCancelled 발생.
        self.panGestureRecognizer.enabled = YES;
    }
    
//    if (swipeableCell.state != SwipeStateLeft && swipeableCell.state != SwipeStateRight) {
//        return;
//    }
    //! 즉, SwipeStateLeft 또는 SwipeStateRight만 여기서부터 실행될 수 있다.
    MGUSwipeActionsView *actionView = swipeableCell.actionsView;
    if (actionView == nil) {
        return;
    }

    CGFloat targetCenter = [self targetCenterActive:NO];

    if (animated == YES) {
        swipeableCell.state =     MGUSwipeStateAnimatingToCenter;
        [self animateWithDuration:0.7 toOffset:targetCenter withInitialVelocity:0.0 completion:^(BOOL complete) {
            [self reset];
            if (completion != nil) {
                completion(complete);
            }
        }];
    } else {
        CGFloat constraintConstant = [self constraintConstantForCenterPosition:targetCenter];
        swipeableCell.swipeableContentViewCenterXConstraint.constant = constraintConstant;
        swipeableCell.actionsView.visibleWidth = ABS(constraintConstant);
//        actionsContainerView.center = CGPointMake(targetCenter, actionsContainerView.center.y);
//        swipeableCell.actionsView.visibleWidth = ABS(CGRectGetMinX(actionsContainerView.frame));
        [self reset];
    }

    [self.delegate swipeController:self didEndSwipeForOrientation:actionView.orientation];
}
  
- (void)traitCollectionDidChangeFromPreviousTraitCollrection:(UITraitCollection * _Nullable)previousTraitCollrection
                                   toCurrentTraitCollrection:(UITraitCollection *)currentTraitCollrection {
    
    MGUSwipeCollectionViewCell *swipeableCell = self.swipeableCell;
    UIView *actionsContainerView = self.actionsContainerView;
    
    if (swipeableCell == nil || actionsContainerView == nil || previousTraitCollrection == nil) {
        return;
    }
    
    if (swipeableCell.state ==     MGUSwipeStateLeft || swipeableCell.state ==     MGUSwipeStateRight) {
        
        CGFloat targetOffset = [self targetCenterActive:YES]; // swipeableCell.state != SwipeStateCenter ? YES : NO
        if (self.expandedFullState == YES) {
            if (swipeableCell.state ==     MGUSwipeStateRight) {
                targetOffset = - swipeableCell.bounds.size.width / 2.0;
            } else {
                targetOffset = swipeableCell.bounds.size.width / 2.0;
            }
        }

        CGFloat constraintConstant = [self constraintConstantForCenterPosition:targetOffset];
        swipeableCell.swipeableContentViewCenterXConstraint.constant = constraintConstant;
        swipeableCell.actionsView.visibleWidth = ABS(constraintConstant);
//        [swipeableCell layoutIfNeeded];
//        [swipeableCell setNeedsLayout];
    }
}

- (void)reset {
    self.swipeableCell.state = MGUSwipeStateCenter;
    [self.swipeableCell.actionsView removeFromSuperview];
    [self.swipeableCell didRemoveActionsView:self.swipeableCell.actionsView];
    self.swipeableCell.actionsView = nil;
    self.expandedFullState = NO;
}


//!------ Action Private
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *target = self.actionsContainerView;
    MGUSwipeCollectionViewCell *swipeableCell = self.swipeableCell;
    if (target == nil || swipeableCell == nil) { // 기본 조건.
        return;
    }
    
    CGPoint velocity = [gesture velocityInView:target];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIView *swipeable = [self.collectionView.swipeCells mgrFilterFirst:^BOOL(MGUSwipeCollectionViewCell * cell) {
            if (cell.state ==     MGUSwipeStateDragging) { // 기존에 드래그하고 있던 다른 셀이 존재한다면 나가라는 뜻이다.
                return YES;
            } else {
                return NO;
            }
        }];
        
        if (swipeable != nil && swipeable != self.swipeableCell) { // 기존에 드래그 하던 것이 존재한다면 그냥 제스처를 끝내라.
            return;
        }
        //! 반드시 없애 줘야한다. 애니메이션으로 원상복구를 눌렀다면 competion 에서 뷰가 날라가버린다.
        [self stopAnimatorIfNeeded];

        
        self.originalCenter = [self centerPositionForConstraintConstant:swipeableCell.swipeableContentViewCenterXConstraint.constant];
//        self.originalCenter = target.center.x; // UIGestureRecognizerStateChanged에서 이것과 비교할 것이다.
        
        //! 평범한 상태에서 만들어질때 들어온다.
        //! 이미 있는 상태(actionsView가 이미 보여져 있는 상태)에서는 만들 필요가 없으므로 만들지 않는다.
        if (swipeableCell.state == MGUSwipeStateCenter || swipeableCell.state ==     MGUSwipeStateAnimatingToCenter) {
            MGUSwipeActionsOrientation orientation =
            velocity.x > 0.0 ? MGUSwipeActionsOrientationLeft : MGUSwipeActionsOrientationRight;
            if (velocity.x == 0.0) {
                orientation = _initialOrientation;
            }
            if ([self showActionsViewForOrientation:orientation] == NO) { // leading swipe를 막았을 때에는 - showActionsViewFor: NO. actionsView 도 없다.
            }
        }
        
        if (swipeableCell.actionsView != nil) {
            swipeableCell.state =     MGUSwipeStateDragging;
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        MGUSwipeActionsView *actionsView = swipeableCell.actionsView;
        UIView *actionsContainerView = self.actionsContainerView;
        if (actionsView == nil) {
            return;
        }

        CGFloat translation = [gesture translationInView:target].x;
        self.scrollRatio = 1.0;
        
        //! 시작했던 방향과 반대로 가는데 AND 선을 넘을경우(중심을 지나) elastic 발동한다.
        if ( (translation + self.originalCenter - CGRectGetMidX(swipeableCell.bounds)) * actionsView.orientation > 0.0) {
            CGPoint targetCenter = target.center;
            targetCenter.x = [gesture mgrElasticTranslationInView:target
                                                        withLimit:CGSizeZero
                                               fromOriginalCenter:CGPointMake(self.originalCenter, 0.0)
                                                    applyingRatio:0.2].x;
                        
            CGFloat constraintConstant = [self constraintConstantForCenterPosition:targetCenter.x];
            swipeableCell.swipeableContentViewCenterXConstraint.constant = constraintConstant;
            swipeableCell.actionsView.visibleWidth = ABS(constraintConstant);
            self.scrollRatio = self.elasticScrollRatio;
            return;
        }
        
        MGUSwipeExpansionStyle *expansionStyle = actionsView.configuration.expansionStyle;
        //! 일반적인 경우, 시작한 방향으로 계속가거나, 시작한 방향으로 가다가 뒤로가더라도 선을 넘지 않을 경우.
        //! 그런데, expansionStyle 존재할 경우
        if (expansionStyle != nil && self.collectionView != nil) {
            CGRect referenceFrame = actionsContainerView != swipeableCell ? actionsContainerView.frame : CGRectNull;
            BOOL expanded = [expansionStyle shouldExpandView:swipeableCell
                                                     gesture:gesture
                                                 inSuperview:self.collectionView
                                                 withinFrame:referenceFrame];
            
            CGFloat targetOffset = [expansionStyle targetOffsetFor:swipeableCell]; // expand 상태가 변화가 되는 기준점.
            CGFloat currentOffset = ABS(translation + self.originalCenter - CGRectGetMidX(swipeableCell.bounds));

            //! trailing expand에서 gesture위치를 바꾼다. additionalTriggers 가 존재할때 실행될 것이다.
            //! additionalTriggers 가 존재하면 targetOffset > currentOffset 상태에서 expanded가 발동할 수 있다.
            //! additionalTriggers 가 없다면, targetOffset < currentOffset 이때 expanded leading expand 가 그렇다.
            if (expanded && !actionsView.expanded && targetOffset > currentOffset) { //! unexpanded => expanded
                
                CGFloat centerForTranslationToEdge =
                CGRectGetMidX(swipeableCell.bounds) - targetOffset * actionsView.orientation;
                CGFloat delta = centerForTranslationToEdge - self.originalCenter;
                
                [self animateWithDuration:0.7
                                 toOffset:centerForTranslationToEdge
                      withInitialVelocity:0.0
                               completion:nil];
                
                [gesture setTranslation:CGPointMake(delta, 0.0) inView:swipeableCell.superview];
            } else {
                CGPoint targetCenter = target.center;
                targetCenter.x = [gesture mgrElasticTranslationInView:target
                                                            withLimit:CGSizeMake(targetOffset, 0.0)
                                                   fromOriginalCenter:CGPointMake(self.originalCenter, 0.0)
                                                        applyingRatio:expansionStyle.targetOverscrollElasticity].x;
                
                CGFloat constraintConstant = [self constraintConstantForCenterPosition:targetCenter.x];
                swipeableCell.swipeableContentViewCenterXConstraint.constant = constraintConstant;
                swipeableCell.actionsView.visibleWidth = ABS(constraintConstant);
//                target.center = targetCenter;
//                swipeableCell.actionsView.visibleWidth = ABS(CGRectGetMinX(actionsContainerView.frame));
            }
            
            //! unexpanded <=> expanded 기존의 expanded와 다를 때에만 발동한다.
            [actionsView setExpanded:expanded feedback:YES];
            
        } else {
            CGPoint targetCenter = target.center;
            targetCenter.x = [gesture mgrElasticTranslationInView:target
                                                        withLimit:CGSizeMake(actionsView.preferredWidth, 0.0)
                                               fromOriginalCenter:CGPointMake(self.originalCenter, 0.0)
                                                    applyingRatio:self.elasticScrollRatio].x;
            
            CGFloat constraintConstant = [self constraintConstantForCenterPosition:targetCenter.x];
            swipeableCell.swipeableContentViewCenterXConstraint.constant = constraintConstant;
            swipeableCell.actionsView.visibleWidth = ABS(constraintConstant);
//            target.center = targetCenter;
//            swipeableCell.actionsView.visibleWidth = ABS(CGRectGetMinX(actionsContainerView.frame));
                
            if ((target.center.x - self.originalCenter) / translation != 1.0) {
                self.scrollRatio = self.elasticScrollRatio;
            }
        }
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateCancelled ||
             gesture.state == UIGestureRecognizerStateFailed) {
        //! 추가 했다. gesture.enabled = NO 가 되면 UIGestureRecognizerStateCancelled가 실행되므로.
        if (gesture.state == UIGestureRecognizerStateCancelled) {return;}
        
        MGUSwipeActionsView *actionsView = swipeableCell.actionsView;
        UIView *actionsContainerView = self.actionsContainerView;
        if (actionsView == nil || actionsContainerView == nil) {
            return;
        }
        
        if (swipeableCell.state == MGUSwipeStateCenter &&
            CGRectGetMidX(swipeableCell.bounds) == target.center.x) {
            return;
        }
        
        CGFloat translation = [gesture translationInView:target].x;
        if ( (translation + self.originalCenter - CGRectGetMidX(swipeableCell.bounds)) * actionsView.orientation > 0.0) {
            swipeableCell.state = MGUSwipeStateCenter; // 반대방향으로 초과하여 가고 있을 때였다면, 그냥 제자리로.
        } else {
            swipeableCell.state = [self targetStateForVelocity:velocity];
        }
        
        MGUSwipeAction *expandedAction = actionsView.expandableAction;
        
        if (actionsView.expanded == YES && expandedAction != nil) {
            [self performAction:expandedAction];
        } else {
            CGFloat targetOffset = [self targetCenterActive:(swipeableCell.state != MGUSwipeStateCenter)? YES : NO];
            CGFloat distance = targetOffset - actionsContainerView.center.x;
            CGFloat normalizedVelocity = velocity.x * self.scrollRatio / distance;
            
            __weak __typeof(self) weakSelf = self;
            [self animateWithDuration:0.7
                             toOffset:targetOffset
                  withInitialVelocity:normalizedVelocity
                           completion:^(BOOL success) {
                if (weakSelf.swipeableCell.state == MGUSwipeStateCenter) {
                    [weakSelf reset];
                }
            }];
            
            if (weakSelf.swipeableCell.state == MGUSwipeStateCenter) {
                [self.delegate swipeController:self
                     didEndSwipeForOrientation:actionsView.orientation];
            }
        }
        
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self hideSwipeAnimated:YES completion:nil];
}

- (MGUSwipeState)targetStateForVelocity:(CGPoint)velocity {
    MGUSwipeActionsView *actionsView = self.swipeableCell.actionsView;
    if (actionsView == nil) {
        return MGUSwipeStateCenter;
    }
    
    if (actionsView.orientation == MGUSwipeActionsOrientationLeft) {
        return (velocity.x < 0.0 && !actionsView.expanded) ? MGUSwipeStateCenter :     MGUSwipeStateLeft;
    } else if (actionsView.orientation == MGUSwipeActionsOrientationRight) {
        return (velocity.x > 0.0 && !actionsView.expanded) ? MGUSwipeStateCenter :     MGUSwipeStateRight;
    } else {
        NSCAssert(FALSE, @"SwipeActionsOrientation 값 오류");
        return MGUSwipeStateCenter;
    }
}

- (BOOL)showActionsViewForOrientation:(MGUSwipeActionsOrientation)orientation {
//     self.originalLayoutMargins = self.swipeableCell.layoutMargins; // 드래그 시에 원본 layoutMargins 이 필요하다.
    MGUSwipeActionsConfiguration *configuration;
    if ((orientation == MGUSwipeActionsOrientationLeft && [self.collectionView mgrIsRTLLocale] == NO) ||
        (orientation == MGUSwipeActionsOrientationRight && [self.collectionView mgrIsRTLLocale] == YES)) {
        configuration = [self.delegate leftSwipeActionsConfigurationForSwipeController:self];
    } else {
        configuration = [self.delegate rightSwipeActionsConfigurationForSwipeController:self];
    }
    
    if (configuration.actions == nil || configuration.actions.count <= 0 ||
        self.swipeableCell == nil || self.actionsContainerView == nil || self.collectionView == nil) {
        return NO;
    }

    [self.swipeableCell.actionsView removeFromSuperview];
    [self.swipeableCell didRemoveActionsView:self.swipeableCell.actionsView];
    self.swipeableCell.actionsView = nil;
    
    // SwipeActionsView를 만든다.
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsZero;

    CGRect visibleTableViewRect = [self.delegate swipeController:self visibleRectForCollectionView:self.collectionView];
    //!  tall 상태일때 맨위 또는 맨 아래에서 칸이 잘릴때, 버튼의 컨텐츠가 작게 나오게 하기 위해서
    if (CGRectIsNull(visibleTableViewRect) == NO) { // tall 이 아닌 평범한 상태면 YES(CGRect Is Null)이다.
        // tableView.safeAreaLayoutGuide.layoutFrame 이 상태가 넘어온다.
        CGRect frame = self.swipeableCell.frame;
        CGRect visibleSwipeableRect = CGRectIntersection(frame, visibleTableViewRect);
        if (CGRectIsNull(visibleSwipeableRect) == NO) {
            CGFloat top =
            (CGRectGetMinY(visibleSwipeableRect) > CGRectGetMinY(frame))? MAX(0.0, CGRectGetMinY(visibleSwipeableRect) - CGRectGetMinY(frame)) : 0.0;
            CGFloat bottom = MAX(0, frame.size.height - visibleSwipeableRect.size.height - top);
            contentEdgeInsets = UIEdgeInsetsMake(top, 0.0, bottom, 0.0);
        }
    }


    MGUSwipeActionsView *actionsView =
    [[MGUSwipeActionsView alloc] initWithContentEdgeInsets:contentEdgeInsets
                                                maxSize:self.swipeableCell.bounds.size
                                      safeAreaInsetView:self.collectionView
                                          configuration:configuration
                                            orientation:orientation];
    actionsView.cell = self.swipeableCell; // 콜렉션뷰에서는 필요하다.
    actionsView.delegate = self;

    [self.actionsContainerView addSubview:actionsView];
    [self.swipeableCell didAddActionsView:actionsView]; // 방금 actionsView가 추가되었다는 것을 알려준다.
    
    actionsView.translatesAutoresizingMaskIntoConstraints = NO;
    [actionsView.heightAnchor constraintEqualToAnchor:self.actionsContainerView.heightAnchor].active = YES;
    [actionsView.widthAnchor constraintEqualToAnchor:self.actionsContainerView.widthAnchor multiplier:2.0].active = YES; // 길이 2배.
    [actionsView.topAnchor constraintEqualToAnchor:self.actionsContainerView.topAnchor].active = YES;
    if (orientation == MGUSwipeActionsOrientationLeft) {
        [actionsView.rightAnchor constraintEqualToAnchor:self.actionsContainerView.leftAnchor].active = YES;
    } else {
        [actionsView.leftAnchor constraintEqualToAnchor:self.actionsContainerView.rightAnchor].active = YES;
    }
    
    [actionsView setNeedsUpdateConstraints];
    self.swipeableCell.actionsView = actionsView;
    //! 나왔다가 다시 들어가는 도중에 pan으로 다시 잡았을때, layout을 정비해줘야한다. 그렇지 않으면 깜빡거림이 존재할 수 있다.
    self.swipeableCell.actionsView.visibleWidth = ABS([self constraintConstantForCenterPosition:self.actionsContainerView.center.x]);
//    self.swipeableCell.actionsView.visibleWidth = ABS(CGRectGetMinX(self.swipeableCell.frame));
    
    /// [self configureActionsViewWith:actions forOrientation:orientation]; // 만들면서, state = draging
    [self.delegate swipeController:self willBeginSwipeForOrientation:orientation];
    
    return YES;
}

//! active == YES 열린상태. active == NO 닫힌상태. 이때의 origin.x의 좌표.
- (CGFloat)targetCenterActive:(BOOL)active {
    MGUSwipeCollectionViewCell *swipeableCell = self.swipeableCell;
    if (swipeableCell == nil) {
        return 0.0;
    }
    
    MGUSwipeActionsView *actionsView = swipeableCell.actionsView;
    if (actionsView == nil || active == NO) {
        return CGRectGetMidX(swipeableCell.bounds);
    }
//    NSLog(@"말이되냐?? %f %f", swipeableCell.frame.size.width, swipeableCell.frame.size.height);
//    NSLog(@"---> %f %f", CGRectGetMidX(swipeableCell.bounds), actionsView.preferredWidth * actionsView.orientation);
    return CGRectGetMidX(swipeableCell.bounds) - actionsView.preferredWidth * actionsView.orientation;
}

//! 0.7 XX 0.0 null
- (void)animateWithDuration:(CGFloat)duration
                   toOffset:(CGFloat)offset
        withInitialVelocity:(CGFloat)velocity
                 completion:(void(^ _Nullable)(BOOL))completion {
    //! 지워야 제대로 작동! 손으로 댕겨서 애니메이션으로 자리 잡을 때. 그때 누르면 깜빡거리로. 제스처에서만 사용하자.
//!    [self stopAnimatorIfNeeded];
    [self.swipeableCell layoutIfNeeded];
    
    UIViewPropertyAnimator *animator;
    if (velocity != 0.0) {
        CGVector initalVelocity = CGVectorMake(velocity, velocity);
        UISpringTimingParameters *parameters =
        [[UISpringTimingParameters alloc] initWithMass:1.0
                                             stiffness:100.0
                                               damping:18.0
                                       initialVelocity:initalVelocity];
        animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.0
                                                   timingParameters:parameters];
    } else {
        animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
                                                       dampingRatio:1.0
                                                         animations:nil];
    }
    
    [animator addAnimations:^{
        MGUSwipeCollectionViewCell *swipeableCell = self.swipeableCell;
        UIView *actionsContainerView = self.actionsContainerView;
        if (swipeableCell == nil || actionsContainerView == nil) {
            return;
        }
        
        CGFloat constraintConstant = [self constraintConstantForCenterPosition:offset];
        swipeableCell.swipeableContentViewCenterXConstraint.constant = constraintConstant;
        swipeableCell.actionsView.visibleWidth = ABS(constraintConstant);
//        actionsContainerView.center = CGPointMake(offset, actionsContainerView.center.y);
//        swipeTableViewCell.actionsView.visibleWidth = ABS(CGRectGetMinX(actionsContainerView.frame));
        [swipeableCell layoutIfNeeded];
    }];
    
    
    if (completion != nil) {
        [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition == UIViewAnimatingPositionEnd);
        }];
    }
    
    self.animator = animator;
    [self.animator startAnimation];
}

- (void)stopAnimatorIfNeeded {
    if (self.animator.isRunning == YES) {
        [self.animator stopAnimation:YES];
    }
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"슈드 비깉");
    if (gestureRecognizer == self.tapGestureRecognizer) {
        if (UIAccessibilityIsVoiceOverRunning()) {
            [self.collectionView hideSwipeCell];
        }
        
        MGUSwipeCollectionViewCell *swipedCell = nil;
        for (MGUSwipeCollectionViewCell *cell in self.collectionView.swipeCells) {
            if (cell.state != MGUSwipeStateCenter ||
                self.panGestureRecognizer.state ==  UIGestureRecognizerStateBegan ||
                self.panGestureRecognizer.state ==  UIGestureRecognizerStateChanged ||
                self.panGestureRecognizer.state ==  UIGestureRecognizerStateEnded) {
                swipedCell = cell;
                break;
            }
        }
        
        return swipedCell == nil ? NO : YES;
    }
    
    if (gestureRecognizer == self.panGestureRecognizer && self.panGestureRecognizer.view != nil) {
        CGPoint velocity = [self.panGestureRecognizer velocityInView:self.actionsContainerView];
        //! 실제 메서드에서는 두 번째 인수를 고려하지 않고 table view에서는 editing만 아니면 YES, collection view에서는 무조건 YES이다.
        BOOL canBegin = [self.delegate swipeController:self
                canBeginEditingSwipeableForOrientation:velocity.x > 0.0 ? MGUSwipeActionsOrientationLeft : MGUSwipeActionsOrientationRight];
        if (canBegin == NO) {
            return NO;
        }
        
        CGPoint translation = [self.panGestureRecognizer translationInView:self.panGestureRecognizer.view];
        if (translation.x > 0.0) {
            _initialOrientation = MGUSwipeActionsOrientationLeft;
        } else {
            _initialOrientation = MGUSwipeActionsOrientationRight;
        }
        return ABS(translation.y) <= ABS(translation.x);
    }
    
    return YES;
}

//! UIControl의 system subclass는 priority가 UIGestureRecognizer보다 높아서 큰 문제는 없지만
//! 프로그래머가 만든 커스텀 클래스는 priority가 낮아서 씹히는 문제가 생긴다.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGestureRecognizer && [touch.view isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)touch.view;
        if (control.enabled == YES) {
            return NO;
        }
    }

//    if (gestureRecognizer == self.tapGestureRecognizer) {
//        return NO;
//        UICollectionViewCell *cell = touch.view.superview;
//        NSLog(@"AA %@ %@", touch.view, cell);
//        if ([cell isKindOfClass:[UICollectionViewCell class]]) {
//            NSLog(@"AA %@", cell.contentView);
//        }
//
//
//        if (gestureRecognizer == self.tapGestureRecognizer && [touch.view isKindOfClass:[UIControl class]]) {
//            UIControl *control = (UIControl *)touch.view;
//            NSLog(@"BB");
//            if (control.enabled == YES) {
//                NSLog(@"CC");
//                return NO;
//            }
//        }
//    }
    
    return YES;
}


#pragma mark - <SwipeActionsViewDelegate>
- (void)swipeActionsView:(MGUSwipeActionsView *)swipeActionsView didSelect:(MGUSwipeAction *)action {
    [self performAction:action];
}


#pragma mark - <SwipeActionsViewDelegate> - Helper
// 버튼을 눌렀을 때도 작동한다.
// NSLog(@"쭉 댕겼을 때.~~~~~");
- (void)performAction:(MGUSwipeAction *)action {
    MGUSwipeActionsView *actionsView = self.swipeableCell.actionsView;
    if (actionsView == nil) {
        return;
    }
    
    MGUSwipeExpansionStyle *expansionStyle = actionsView.configuration.expansionStyle;
    if (action == actionsView.expandableAction && expansionStyle != nil ) {
        // Trigger the expansion (may already be expanded from drag)
        [actionsView setExpanded:YES feedback:NO];

        if (expansionStyle.completionAnimationType ==     MGUSwipeCompletionAnimationTypeBounce) {
            [self performAction:action hide:YES];
        } else {
            [self performFillAction:action fillOption:expansionStyle.completionAnimationType];
        }

    } else {
        //[self performAction:action hide:action.hidesWhenSelected];
        [self performAction:action hide:NO]; // hide 무조건 NO가 아니라. action. handler의 3 번째 인자 block의 BOOL 값에 따라 결정된다.
    }
}

- (void)performAction:(MGUSwipeAction *)action hide:(BOOL)hide {
    NSIndexPath *indexPath = self.swipeableCell.indexPath;
    if (indexPath == nil) {
        return;
    }
    
    if (hide == YES) {
        [self hideSwipeAnimated:YES completion:nil];
    }
    
    //! TODO: 지워
//    if (action.handler != nil) {
//        action.handler(action, indexPath);
//    }
    
    if (action.handler != nil) {
        NSArray <MGUSwipeAction *>*swipeActions = self.swipeableCell.actionsView.actions;
        NSArray <MGUSwipeActionButton *>*buttons = self.swipeableCell.actionsView.buttons;
        NSInteger index = [swipeActions indexOfObject:action];
        MGUSwipeActionButton *button = buttons[index];
        if (button == nil) {
            NSCAssert(FALSE, @"action에 해당하는 SwipeActionButton이 없다.");
        }
        
        action.handler(action, (UIView *)button, ^(BOOL actionPerformed) {
            if (actionPerformed == YES && hide == NO) { //! YES이면 - hideSwipeAnimated:completion: 호출!
                [self hideSwipeAnimated:YES completion:nil];
            }
        });
    }
}

//! 죽 당겨서 발생하는 효과가 있을 때.
//! 죽 당겨서 끝으로 갈때, 튕기는거 말고
- (void)performFillAction:(MGUSwipeAction *)action
               fillOption:(MGUSwipeCompletionAnimationType)fillOption { // fill 스타일만 가능.
    if (fillOption ==     MGUSwipeCompletionAnimationTypeBounce) {
        NSCAssert(FALSE, @"fill 스타일만 가능.");
    }
    
    MGUSwipeCollectionViewCell *swipeableCell = self.swipeableCell;
    UIView *actionsContainerView = self.actionsContainerView;
    if (swipeableCell == nil || actionsContainerView == nil) {
        return;
    }
    
    MGUSwipeActionsView *actionsView = swipeableCell.actionsView;
    NSIndexPath *indexPath = swipeableCell.indexPath;
    if (actionsView == nil || indexPath == nil) {
        return;
    }

    CGFloat newCenter = CGRectGetMidX(swipeableCell.bounds) - (swipeableCell.bounds.size.width) * actionsView.orientation;
    
    if (fillOption ==     MGUSwipeCompletionAnimationTypeFillReverse) {
        [self performAction:action hide:YES]; // action 실행 및 - swipeController:didEndEditingSwipeableFor: 실행된다.
    } else  {
        [self animateWithDuration:UICollectionViewDeleteItemDuration
                         toOffset:newCenter
              withInitialVelocity:0.0
                       completion:^(BOOL completion) {}];
        
        self.expandedFullState = YES;
        //! TODO: 지워
    //    if (action.handler != nil) {
    //        action.handler(action, indexPath); // data를 지운다.
    //    }
        
        if (action.handler != nil) {
            NSArray <MGUSwipeAction *>*swipeActions = self.swipeableCell.actionsView.actions;
            NSArray <MGUSwipeActionButton *>*buttons = self.swipeableCell.actionsView.buttons;
            NSInteger index = [swipeActions indexOfObject:action];
            MGUSwipeActionButton *button = buttons[index];
            if (button == nil) {
                NSCAssert(FALSE, @"action에 해당하는 SwipeActionButton이 없다.");
            }
            action.handler(action, (UIView *)button, ^(BOOL actionPerformed) {});
        }
        
        [self.delegate swipeController:self didEndSwipeForOrientation:actionsView.orientation];
    }
}


#pragma mark - Helper
- (CGFloat)constraintConstantForCenterPosition:(CGFloat)centerPosition {
    return centerPosition - (self.swipeableCell.bounds.size.width / 2.0);
}

- (CGFloat)centerPositionForConstraintConstant:(CGFloat)constraintConstant {
    return constraintConstant + (self.swipeableCell.bounds.size.width / 2.0);
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
