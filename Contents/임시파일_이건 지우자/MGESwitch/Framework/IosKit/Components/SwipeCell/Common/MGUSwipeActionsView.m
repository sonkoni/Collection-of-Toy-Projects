//
//  MGUSwipeActionsView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "MGUSwipeActionsView.h"
#import "MGUSwipeActionsConfiguration.h"
#import "MGUSwipeTransitionLayout.h"
#import "MGUSwipeActionTransitioning.h"
#import "MGUSwipeAction.h"
#import "MGUSwipeActionButton.h"
#import "MGUSwipeExpanding.h"
#import "MGUSwipeExpansionStyle.h"

#pragma mark - Private Class
@interface SwipeActionButtonWrapperView : UIView // 각 버튼의 super view에 해당하며, 버튼을 길게 감싸고 있다.
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, strong, nullable) UIColor *actionBackgroundColor;
- (instancetype)initWithFrame:(CGRect)frame
                       action:(MGUSwipeAction *)action
                  orientation:(MGUSwipeActionsOrientation)orientation
                 contentWidth:(CGFloat)contentWidth;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

@implementation SwipeActionButtonWrapperView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIColor *actionBackgroundColor = self.actionBackgroundColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (actionBackgroundColor != nil && context != NULL) {
        [actionBackgroundColor setFill];
        CGContextFillRect(context, rect);
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                       action:(MGUSwipeAction *)action
                  orientation:(MGUSwipeActionsOrientation)orientation
                 contentWidth:(CGFloat)contentWidth {
    self = [super initWithFrame:frame];
    if (self) {
        if (orientation == MGUSwipeActionsOrientationLeft) {
            self.contentRect = CGRectMake(frame.size.width - contentWidth, 0.0, contentWidth, frame.size.height);
        } else if (orientation == MGUSwipeActionsOrientationRight) {
            self.contentRect = CGRectMake(0.0, 0.0, contentWidth, frame.size.height);
        }
        [self configureBackgroundColorWithAction:action];
        
    }
    return self;
}

- (void)configureBackgroundColorWithAction:(MGUSwipeAction *)action {
    if (action.hasBackgroundColor == NO) {
        self.opaque = NO;
        return;
    }

    UIColor *backgroundColor = action.backgroundColor;
    if (backgroundColor != nil) {
        self.actionBackgroundColor = backgroundColor;
    } else {
        if (action.style == MGUSwipeActionStyleDestructive) {
            self.actionBackgroundColor = [UIColor systemRedColor];
        } else {
            self.actionBackgroundColor = [UIColor systemGray3Color];
        }
    }
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end

@interface MGUSwipeActionsView ()
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedbackGenerator;
@property (nonatomic, strong) NSArray <NSNumber *>*preLayoutVisibleWidths;
@end


#pragma mark - SwipeActionsView Class
@implementation MGUSwipeActionsView
@dynamic preferredWidth;
@dynamic expansionDelegate;
@dynamic maximumImageHeight;
@dynamic safeAreaMargin;
@dynamic contentSize;
@dynamic expandableAction;

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [self.transitionLayout layoutButtonWrapperView:subview atIndex:idx];
    }];

    if (self.expanded == YES) {
        UIView *view = self.subviews.lastObject;
        CGRect frame = view.frame;
        frame.origin.x = self.bounds.origin.x;
        view.frame = frame;
    }
}

// hover, visual effect view 등이 혼합되어있는 상황에서 backgroundColor 가 제대로 작동하지 않는 상황이
// 발생했다. - drawRect:를 추가하여 해결한다.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.configuration.backgroundColor != nil && context != NULL) {
        [self.configuration.backgroundColor setFill];
        CGContextFillRect(context, rect);
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                                  maxSize:(CGSize)maxSize
                        safeAreaInsetView:(UIView *)safeAreaInsetView
                            configuration:(MGUSwipeActionsConfiguration *)configuration
                              orientation:(MGUSwipeActionsOrientation)orientation {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _safeAreaInsetView = safeAreaInsetView;
        _configuration = configuration;
        _orientation = orientation;
        _actions = [[configuration.actions reverseObjectEnumerator] allObjects]; // action에 해당하는 배열은 subview로 붇는 순서가 반대이다.
        
        _transitionLayout = [MGUSwipeTransitionLayout transitionLayoutForActionsView:self];

        NSInteger count = configuration.actions.count;
        NSMutableArray <NSNumber *>*preLayoutVisibleWidths = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i++) {
            [preLayoutVisibleWidths addObject:@(0.0)];
        }
        _preLayoutVisibleWidths = preLayoutVisibleWidths.copy;
        
        _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [self.feedbackGenerator prepare];
        
        UIColor *backgroundColor = configuration.backgroundColor;
        if (backgroundColor != nil) {
            self.backgroundColor = backgroundColor;
        } else {
            self.backgroundColor = [UIColor systemGray5Color];
        }

        _buttons = [self addButtonsFor:self.actions withMaximum:maxSize contentEdgeInsets:contentEdgeInsets].mutableCopy;
    }

return self;

}


#pragma mark - 세터 & 게터
- (void)setVisibleWidth:(CGFloat)visibleWidth {
    _visibleWidth = MAX(0.0, visibleWidth);

    //! border에서는 empty 메서드이다.
    [self.transitionLayout swipeActionsViewBounds];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    NSArray <NSNumber *>*preLayoutVisibleWidths = self.preLayoutVisibleWidths;
    NSArray <NSNumber *>*currentLayoutVisibleWidths = [self.transitionLayout visibleWidthsForButtonWrapperViews];
    self.preLayoutVisibleWidths = currentLayoutVisibleWidths;
    //! 현재 프로젝트에서는 circular 에서 잡아 당길때, 커지는 애니메이션에 해당한다.
    [self notifyVisibleWidthChangedOldWidths:preLayoutVisibleWidths
                                   newWidths:currentLayoutVisibleWidths];
}

- (CGFloat)preferredWidth {
    return self.minimumButtonWidth * (CGFloat)(self.actions.count) + self.safeAreaMargin;
}

- (id <MGUSwipeExpanding>)expansionDelegate {
    if (self.configuration.expansionDelegate != nil) {
        return self.configuration.expansionDelegate;
    } else {
        return (self.expandableAction.hasBackgroundColor == NO) ? [MGUSwipeScaleAndAlphaExpansion new] : nil;
    }
}

- (CGFloat)maximumImageHeight {
    NSNumber *returnValue =
    [self.actions mgrReduce:@(0.0) block:^NSNumber *(NSNumber *object, MGUSwipeAction *action) {
        CGFloat height = (action.image.size.height != CGFLOAT_MAX) ? action.image.size.height : 0.0;
        CGFloat result = MAX(object.doubleValue, height);
        return @(result);
    }];
    
    return returnValue.doubleValue;
    
}

- (CGFloat)safeAreaMargin {
    if ([self.safeAreaInsetView isKindOfClass:[UITableView class]] == YES) {
        UITableView *tableView = (UITableView *)self.safeAreaInsetView;
        if (tableView == nil || tableView.style == UITableViewStyleInsetGrouped) {
            return 0.0;
        }
        
        return (self.orientation == MGUSwipeActionsOrientationLeft) ? tableView.safeAreaInsets.left : tableView.safeAreaInsets.right;
    } else if ([self.safeAreaInsetView isKindOfClass:[UICollectionView class]] == YES) {
        //! FIXME: 여기가 맞는지 확인해봐야한다. 맞는 것 같다.
        UICollectionView *collectionView = (UICollectionView *)self.safeAreaInsetView;
        CGFloat cellWidth = self.cell.frame.size.width; // collectionView.visibleCells 로 찾으면 오류가 발생한다.
        CGFloat collectionViewWidth = collectionView.bounds.size.width;
        if (ABS(cellWidth - collectionViewWidth) < FLT_EPSILON) { // 꽉 차있다면 가로에서 세이프 에어리어에 걸릴 수 있다.
            return (self.orientation == MGUSwipeActionsOrientationLeft) ? collectionView.safeAreaInsets.left : collectionView.safeAreaInsets.right;
        } else {
            if ((collectionViewWidth - collectionView.safeAreaInsets.left - collectionView.safeAreaInsets.right) >= cellWidth) {
                return 0.0;
            } else {
                CGFloat safeAreaMargin =  (self.orientation == MGUSwipeActionsOrientationLeft) ? collectionView.safeAreaInsets.left : collectionView.safeAreaInsets.right;
                CGFloat cellPadding = (collectionViewWidth - cellWidth) / 2.0;
                return safeAreaMargin - cellPadding;
            }
        }
    } else {
        NSCAssert(FALSE, @"테이블뷰도 아니고 콜렉션 뷰도 아닌 것이 들어왔다. 완벽한 오류이다.");
        return 0.0;
    }
}

//! SwipeActionsView의 visibleWidth 중에서 컨텐츠가 보여지는 영역의 넓이
- (CGSize)contentSize {
    //! 여기를 추가했다.
    if (self.configuration.expansionStyle.elasticOverscroll != YES) {
        if (self.visibleWidth >= self.preferredWidth && self.actions.count == 1) {
            return CGSizeMake(self.preferredWidth, self.bounds.size.height);
        } else {
            return CGSizeMake(self.visibleWidth, self.bounds.size.height);
        }
    } else {
        if (self.visibleWidth < self.preferredWidth) {
            return CGSizeMake(self.visibleWidth, self.bounds.size.height);
        } else {
            CGFloat scrollRatio = MAX(0.0, self.visibleWidth - self.preferredWidth);
            return CGSizeMake(self.preferredWidth + (scrollRatio * 0.25), self.bounds.size.height);
        }
    }
/**
    //! 이전 코드이다.
    if (self.options.expansionStyle.elasticOverscroll != YES || // elasticOverscroll 이 아니라면 그냥 나와.
        self.visibleWidth < self.preferredWidth) { // 다 보여지고 가려진 영역이 있다면 그냥 따라나와
        return CGSizeMake(self.visibleWidth, self.bounds.size.height);
    } else { // 컨텐츠가 뒤쳐지게 따라오게 된다. 초과된 길이의 (1/4)만큼만 더 나온다.
        CGFloat scrollRatio = MAX(0.0, self.visibleWidth - self.preferredWidth);
        return CGSizeMake(self.preferredWidth + (scrollRatio * 0.25), self.bounds.size.height);
    }
 */
}

- (MGUSwipeAction *)expandableAction {
    return (self.configuration.expansionStyle != nil) ? self.actions.lastObject : nil;
}


#pragma mark - Action
//! Transition Animation.
- (void)notifyVisibleWidthChangedOldWidths:(NSArray <NSNumber *>*)oldWidths
                                 newWidths:(NSArray <NSNumber *>*)newWidths {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [oldWidths enumerateObjectsUsingBlock:^(NSNumber *oldWidth, NSUInteger index, BOOL *stop) {
            NSNumber *newWidth = newWidths[index];
            CGFloat newPercentVisible = newWidth.doubleValue / self.minimumButtonWidth;
            CGFloat oldPercentVisible = oldWidth.doubleValue / self.minimumButtonWidth;
            MGUSwipeActionTransitioningContext *context =
            [MGUSwipeActionTransitioningContext transitioningContextWithActionIdentifier:self.actions[index].identifier
                                                                                button:self.buttons[index]
                                                                    newPercentVisible:newPercentVisible
                                                                    oldPercentVisible:oldPercentVisible
                                                                            wrapperView:self.subviews[index]];
            [self.actions[index].transitionDelegate didTransitionWithContext:context];
        }];
    });
}

- (NSArray <MGUSwipeActionButton *>*)addButtonsFor:(NSArray <MGUSwipeAction *>*)actions
                                    withMaximum:(CGSize)size
                              contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    
    NSArray <MGUSwipeActionButton *>*buttons = [actions mgrMap:^MGUSwipeActionButton * (MGUSwipeAction *action) {
        MGUSwipeActionButton *actionButton = [[MGUSwipeActionButton alloc] initWithAction:action];
        [actionButton addTarget:self
                         action:@selector(actionTappedButton:)
               forControlEvents:UIControlEventTouchUpInside];
        
        actionButton.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | ((self.orientation == MGUSwipeActionsOrientationRight)? UIViewAutoresizingFlexibleRightMargin : UIViewAutoresizingFlexibleLeftMargin);
        
        actionButton.spacing = (self.configuration.buttonSpacing != CGFLOAT_MAX) ? self.configuration.buttonSpacing : 8.0;
        actionButton.contentEdgeInsets = [self buttonEdgeInsetsFromOptions:self.configuration];
        return actionButton;
    }];
    
    
    CGFloat maximum =
    (self.configuration.maximumButtonWidth != CGFLOAT_MAX) ? self.configuration.maximumButtonWidth : (size.width - 30.0) / (CGFloat)(actions.count);
    CGFloat minimum =
    (self.configuration.minimumButtonWidth != CGFLOAT_MAX) ? self.configuration.minimumButtonWidth : MIN(maximum, 74.0);
    
    NSNumber *minimumButtonWidthValue =
    [buttons mgrReduce:@(minimum) block:^NSNumber *(NSNumber *object, MGUSwipeActionButton *button) {
        CGFloat result = MAX(object.doubleValue, [button preferredWidth:maximum]);
        return @(result);
    }];
    
    self.minimumButtonWidth = minimumButtonWidthValue.doubleValue;
    
    [buttons enumerateObjectsUsingBlock:^(MGUSwipeActionButton *button, NSUInteger index, BOOL *stop) {
        MGUSwipeAction *action = actions[index];
        CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
        SwipeActionButtonWrapperView *wrapperView =
        [[SwipeActionButtonWrapperView alloc] initWithFrame:frame
                                                     action:action
                                                orientation:self.orientation
                                               contentWidth:self.minimumButtonWidth];
        
        wrapperView.translatesAutoresizingMaskIntoConstraints = NO;
        [wrapperView addSubview:button];
           
        UIVisualEffect *effect = action.backgroundEffect;
        if (effect != nil) {
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
            effectView.frame = wrapperView.frame;
            effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [effectView.contentView addSubview:wrapperView];
            [self addSubview:effectView];
        } else {
            [self addSubview:wrapperView];
        }
           
        button.frame = wrapperView.contentRect; //! 버튼의 프레임을 정해준다.
        button.maximumImageHeight = self.maximumImageHeight;
        button.verticalAlignment = self.configuration.buttonVerticalAlignment;
        button.shouldHighlight = action.hasBackgroundColor;
        
        [wrapperView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [wrapperView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
           
        NSLayoutConstraint *topConstraint = [wrapperView.topAnchor constraintEqualToAnchor:self.topAnchor
                                                                                  constant:contentEdgeInsets.top];
        
        topConstraint.priority = (contentEdgeInsets.top == 0.0) ? UILayoutPriorityRequired : UILayoutPriorityDefaultHigh;
        topConstraint.active = YES;
        
        NSLayoutConstraint *bottomConstraint =
        [wrapperView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor
                                                 constant:-1.0 * contentEdgeInsets.bottom];
        
        bottomConstraint.priority = (contentEdgeInsets.bottom == 0.0) ? UILayoutPriorityRequired : UILayoutPriorityDefaultHigh;
        bottomConstraint.active = YES;
         
        if (UIEdgeInsetsEqualToEdgeInsets(contentEdgeInsets, UIEdgeInsetsZero) == NO) {
            NSLayoutConstraint *heightConstraint =
            [wrapperView.heightAnchor constraintGreaterThanOrEqualToConstant:button.intrinsicContentSize.height];
            heightConstraint.priority = UILayoutPriorityRequired;
            heightConstraint.active = YES;
        }
    }];
    
    return buttons;
}

- (void)actionTappedButton:(MGUSwipeActionButton *)button {
    NSUInteger index = [self.buttons indexOfObject:button];
    if (NSNotFound != index) {
        [self.delegate swipeActionsView:self didSelect:self.actions[index]];
    }
}

- (UIEdgeInsets)buttonEdgeInsetsFromOptions:(MGUSwipeActionsConfiguration *)configuration {
    CGFloat padding = (configuration.buttonPadding != CGFLOAT_MAX) ? configuration.buttonPadding : 8.0;
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

- (void)setExpanded:(BOOL)expanded feedback:(BOOL)feedback {
    if (self.expanded == expanded) {
        return;
    }
    
    self.expanded = expanded;

    if (feedback == YES) {
        [self.feedbackGenerator impactOccurred];
        [self.feedbackGenerator prepare];
    }

    MGUSwipeExpansionAnimationTimingParameters timingParameters =
    [self.expansionDelegate animationTimingParameters:[self.buttons.reverseObjectEnumerator allObjects]
                                            expanding:expanded];

    if (self.expansionAnimator.isRunning == YES) {
        [self.expansionAnimator stopAnimation:YES];
    }

    NSTimeInterval duration = timingParameters.duration;
    if (duration == 0.0) {
        duration = 0.6;
    }
    
    self.expansionAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
                                                                 dampingRatio:1.0
                                                                   animations:nil];
    
    __weak __typeof(self) weakSelf = self;
    [self.expansionAnimator addAnimations:^{
        [weakSelf setNeedsLayout];
        [weakSelf layoutIfNeeded];
    }];

    [self.expansionAnimator startAnimationAfterDelay:timingParameters.delay];
    [self notifyExpansionExpanded:expanded];
}

//! 추가적인 expansion 애니메이션이 존재할때.
- (void)notifyExpansionExpanded:(BOOL)expanded {
    MGUSwipeActionButton *expandedButton = self.buttons.lastObject;
    if (expandedButton == nil) {
        return;
    }
    
    NSMutableArray <MGUSwipeActionButton *>*buttons = self.buttons.mutableCopy;
    [buttons removeLastObject];
    
    [self.expansionDelegate actionButton:expandedButton
                               didChange:expanded
                      otherActionButtons:[[buttons reverseObjectEnumerator] allObjects]];
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
