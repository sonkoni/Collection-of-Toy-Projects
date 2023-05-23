//
//  ViewControllerG.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/30.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import IosKit;
#import "ViewControllerG.h"
#import "SwipeCell.h"
#import "SwipeCellModel.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ViewControllerG () <MGUFlowViewDelegate, MGUSwipeCollectionViewCellDelegate,
                               UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate>

@property (weak, nonatomic) IBOutlet UIView *container1;
@property (weak, nonatomic) IBOutlet UIView *container2;
@property (weak, nonatomic) IBOutlet UIView *destinationView;
@property (nonatomic, strong) CAShapeLayer *dashLayer;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) MGUFlowView *flowView;
@property (nonatomic, strong) NSMutableArray <SwipeCellModel *>*models;
@property (nonatomic, strong) MGUFlowDiffableDataSource <NSNumber *, SwipeCellModel *>*diffableDataSource;
@end

@implementation ViewControllerG

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonInit(self);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _itemSize = CGSizeMake(self.view.bounds.size.width - 135.0, 80.0);
    if (CGSizeEqualToSize(self.flowView.itemSize, _itemSize) == NO) {
        self.flowView.itemSize = _itemSize;
    }
    
    [self.destinationView layoutIfNeeded];
    self.dashLayer.frame = self.destinationView.layer.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.dashLayer.bounds cornerRadius:10.0];
    self.dashLayer.path = path.CGPath;
}


#pragma mark - 생성 & 소멸
static void CommonInit(ViewControllerG *self) {
    self.navigationItem.title = @"Swipe + Drag & Drop";
    [self setupModel];
   
    self->_itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 135.0, 80.0);
    
    self.flowView  = [MGUFlowView new];
    [self.flowView registerClass:[SwipeCell class]
          forCellWithReuseIdentifier:NSStringFromClass([SwipeCell class])];
    
    [self.flowView registerClass:[MGUFlowIndicatorSupplementaryView class]
      forSupplementaryViewOfKind:MGUFlowElementKindVegaLeading
             withReuseIdentifier:MGUFlowElementKindVegaLeading];
    
    self.flowView.itemSize = self.itemSize;
    self.flowView.leadingSpacing = 20.0;
    self.flowView.interitemSpacing = 8.0;
    self.flowView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowView.decelerationDistance = [MGUFlowView automaticDistance];
    self.flowView.transformer = nil;
    self.flowView.delegate = self;
    self.flowView.bounces = YES;
    self.flowView.alwaysBounceVertical = YES;
    self.flowView.reversed = YES;
    
    self.flowView.clipsToBounds = YES;
    MGUFlowVegaTransformer *transformer = [MGUFlowVegaTransformer vegaTransformerWithBothSides:NO];
    self.flowView.transformer = transformer;
    
    self.flowView.collectionView.dragDelegate = self;
    self.flowView.collectionView.dropDelegate = self;
    self.flowView.collectionView.dragInteractionEnabled = YES;
    
    [self.container1 addSubview:self.flowView];
    [self.flowView mgrPinEdgesToSuperviewEdges];
    
    UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    [self.container2 addInteraction:dropInteraction];

    self.destinationView.layer.borderColor = [UIColor greenColor].CGColor;
    self.destinationView.layer.borderWidth = 0.0;
    self.destinationView.backgroundColor = [UIColor clearColor];
    self.container2.layer.borderColor = [UIColor redColor].CGColor;
    
    self->_dashLayer = [CAShapeLayer layer];
    self.dashLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.destinationView.layer addSublayer:self.dashLayer];
    self.dashLayer.frame = self.destinationView.layer.bounds;
    self.dashLayer.fillColor = [UIColor clearColor].CGColor;
    self.dashLayer.lineCap = kCALineCapButt; // kCALineCapButt kCALineCapRound kCALineCapSquare
    self.dashLayer.lineJoin = kCALineJoinMiter;
    self.dashLayer.lineWidth = 1.0;    // dased line의 굵기
    self.dashLayer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor; // dashed line의 색깔.
    self.dashLayer.lineDashPattern = @[@(5), @(5)];
    // self.dashLayer.lineDashPhase = 3.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.dashLayer.bounds cornerRadius:10.0]; // 10.0으로 고정이다.
    self.dashLayer.path = path.CGPath;
    self.dashLayer.opacity = 0.0;
    
    self->_diffableDataSource =
    [[MGUFlowDiffableDataSource alloc] initWithFlowView:self.flowView
                                           cellProvider:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath * indexPath, SwipeCellModel *cellModel) {
        SwipeCell *cell =
        (SwipeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SwipeCell class])
                                                                 forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [SwipeCell new];
        }
        
        [cell setData:cellModel];
        cell.delegate = self;
        cell.deleteDirectionReverse = YES;
        return cell;
    }];
    
    self.diffableDataSource.elementOfKinds = @[MGUFlowElementKindVegaLeading];
    
    self.diffableDataSource.supplementaryViewProvider =
    ^UICollectionReusableView *(UICollectionView *collectionView, NSString * elementKind, NSIndexPath *indexPath) {
        MGUFlowIndicatorSupplementaryView * cell =
        [collectionView dequeueReusableSupplementaryViewOfKind:elementKind
                                           withReuseIdentifier:elementKind
                                                  forIndexPath:indexPath];
        
        if ([elementKind isEqualToString:MGUFlowElementKindVegaLeading] == YES) {
            cell.indicatorColor = [UIColor whiteColor];
        } else {
            NSCAssert(FALSE, @"뭔가 잘못들어왔다.");
        }
    
        return cell;
    };
    self.diffableDataSource.volumeType = MGUFlowVolumeTypeFinite; // 디폴트
    
    NSDiffableDataSourceSnapshot <NSNumber *, SwipeCellModel *>*snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@(0)]];
    [snapshot appendItemsWithIdentifiers:self.models intoSectionWithIdentifier:@(0)];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:NO completion:^{}];
}

- (void)setupModel {
    //! 아이템의 유일성 문제로 인해서 블락으로 만들었다.
    NSMutableArray <SwipeCellModel *>*(^makeArrayBlock)(void) = ^NSMutableArray <SwipeCellModel *>* {
        NSMutableArray <SwipeCellModel *>*models = [NSMutableArray array];
        SwipeCellModel *model0 = [SwipeCellModel favCellModelWithMainDescription:@"재민게임"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        SwipeCellModel *model1 = [SwipeCellModel favCellModelWithMainDescription:@"아침리뷰"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        SwipeCellModel *model2 = [SwipeCellModel favCellModelWithMainDescription:@"조깅"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        SwipeCellModel *model3 = [SwipeCellModel favCellModelWithMainDescription:@"영어공부"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        SwipeCellModel *model4 = [SwipeCellModel favCellModelWithMainDescription:@"스파게티 면"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        SwipeCellModel *model5 = [SwipeCellModel favCellModelWithMainDescription:@"역사공부"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        [models addObject:model0];
        [models addObject:model1];
        [models addObject:model2];
        [models addObject:model3];
        [models addObject:model4];
        [models addObject:model5];
        return models;
    };
    self.models = [NSMutableArray array];
    [self.models addObjectsFromArray:makeArrayBlock()];
    [self.models addObjectsFromArray:makeArrayBlock()];
    [self.models addObjectsFromArray:makeArrayBlock()];
}


#pragma mark - <MGUFlowViewDelegate>
// 모두 옵셔널. 샘플이므로 생략.


#pragma mark - <MGUSwipeCollectionViewCellDelegate>
#pragma mark - @required
- (MGUSwipeActionsConfiguration *)collectionView:(UICollectionView *)collectionView
leading_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (MGUSwipeActionsConfiguration *)collectionView:(UICollectionView *)collectionView
trailing_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self) weakSelf = self;
    
    // Completed 일 때 삭제 처리
    MGUSwipeAction *deleteAction =
    [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDestructive
                                title:nil
                              handler:^(MGUSwipeAction * _Nonnull action,
                                        __kindof UIView * _Nonnull sourceView,
                                        void (^ _Nonnull completionHandler)(BOOL)) {
        NSDiffableDataSourceSnapshot <NSNumber *, SwipeCellModel *>*snapshot = self.diffableDataSource.snapshot;
        [snapshot deleteItemsWithIdentifiers:@[weakSelf.models[indexPath.row]]];
        [weakSelf.models removeObjectAtIndex:indexPath.row];
        [weakSelf.diffableDataSource mgrSwipeApplySnapshot:snapshot
                                            collectionView:self.flowView.collectionView
                                                completion:nil];
    }];
        
    deleteAction.title = nil;
    UIImage *image = [UIImage systemImageNamed:@"trash"];
    deleteAction.image = [image mgrImageWithColor:[UIColor whiteColor]];
    deleteAction.textColor = [UIColor whiteColor];
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    configuration.transitionStyle = MGUSwipeTransitionStyleReveal;
    configuration.backgroundColor = [UIColor systemRedColor];
    // configuration.buttonSpacing = 4.0;
    return configuration;
}

#pragma mark - @optional
- (void)collectionView:(UICollectionView *)collectionView
willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {
    // MailCellX *cell = (MailCellX *)[collectionView cellForItemAtIndexPath:indexPath];
    // cell.swipeableContentView.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner; //
}

- (void)collectionView:(UICollectionView *)collectionView
willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {
    // SwipeCell *cell = (SwipeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // cell.backgroundColor = [UIColor systemRedColor];
    // MailCellX *cell = (MailCellX *)[collectionView cellForItemAtIndexPath:indexPath];
    // cell.swipeableContentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner; // 좌측
}

- (void)collectionView:(UICollectionView *)collectionView
didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}

- (void)collectionView:(UICollectionView *)collectionView
didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {
    // SwipeCell *cell = (SwipeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // cell.backgroundColor = [UIColor clearColor];
}

- (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView  {
    return CGRectNull;
}


#pragma mark - <UICollectionViewDragDelegate>
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView
             itemsForBeginningDragSession:(id<UIDragSession>)session
                              atIndexPath:(NSIndexPath *)indexPath {
    [self mgrDragSceneActive:YES];
    [self dashAnimationActive:YES];
    SwipeCellModel *model = [self.models objectAtIndex:indexPath.item];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:model];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = model;
    return @[dragItem];
    //
    //! 옮겨지면서 보여질 커스텀한 뷰를 만들 수 있다. - collectionView:dragPreviewParametersForItemAtIndexPath: 간단한 것은 이걸로도 충분할 수 있다.
    //! 움직이는 순간 손가락 터치를 옮겨지는 Preview의 중심으로 만든다. 즉, 어떤 뷰가 만들어질 줄 모르는 상황이므로 가운데로 옮기는 것이다.
//    dragItem.previewProvider = ^UIDragPreview *{
//        UIDragPreviewParameters *parameters = [self collectionView:collectionView dragPreviewParametersForItemAtIndexPath:indexPath];
//        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//        parameters.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
//        return [[UIDragPreview alloc] initWithView:cell parameters:parameters];
//    };
    // CGPoint touchLocation = [session locationInView:collectionView]; // 터치가 되고 있는 위치를 알려준다.
}

//! 기존 drag 세션에 지정된 아이템을 추가한다. 2개 이상.
/*
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView
              itemsForAddingToDragSession:(id<UIDragSession>)session
                              atIndexPath:(NSIndexPath *)indexPath
                                    point:(CGPoint)point {
    NSString *item = (collectionView == self.collectionView1) ? self.items1[indexPath.row] : self.items2[indexPath.row];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:item];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = item;
    return @[dragItem];
}
*/

// 드래그하는 동안 지정된 위치에 아이템을 표시하는 방법에 대한 커스텀 정보를 반환한다. 드래그하면서 표시될 뷰를 꾸민다.
- (UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView
    dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.flowView.collectionView) {
        SwipeCell *cell = (SwipeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        CGRect cellContainerViewFrame = [cell convertRect:cell.bounds toView:cell];
        UIDragPreviewParameters *previewParameters = [UIDragPreviewParameters new];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cellContainerViewFrame cornerRadius:cell.layer.cornerRadius];
        return previewParameters;
    }
    return nil;
//
// CGRect cellContentViewFrame = cell.contentView.frame;
// previewParameters.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
}

//- (void)collectionView:(UICollectionView *)collectionView dragSessionWillBegin:(id<UIDragSession>)session {}
//- (void)collectionView:(UICollectionView *)collectionView dragSessionDidEnd:(id<UIDragSession>)session {}
//- (BOOL)collectionView:(UICollectionView *)collectionView dragSessionAllowsMoveOperation:(id<UIDragSession>)session {}
//- (BOOL)collectionView:(UICollectionView *)collectionView dragSessionIsRestrictedToDraggingApplication:(id<UIDragSession>)session {}
#pragma mark - <UICollectionViewDropDelegate>
//! 이 메서드를 구현하지 않으면 collectionView 는 YES를 반환한 것으로 간주한다.
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[SwipeCellModel class]];
}

- (void)collectionView:(UICollectionView *)collectionView
performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    NSCAssert(FALSE, @"- collectionView:dropSessionDidUpdate:withDestinationIndexPath: 메서드를 \
UIDropOperationForbidden 또는 UIDropOperationCancel로 했으므로 여기에 들어올 수가 없다.");
}

//! 팬이 시작되면 계속해서 반복적으로 치게된다.
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView
                            dropSessionDidUpdate:(id<UIDropSession>)session
                        withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UIDropOperation operation = UIDropOperationForbidden;
    if (destinationIndexPath != nil) {
        UIDragItem *sourceItem = session.items.firstObject;
        SwipeCellModel *sourceModel = sourceItem.localObject;
        SwipeCellModel *destinationModel = self.models[destinationIndexPath.item];
        if (sourceModel == destinationModel) { // 원래 위치면 뱃지를 없애고 다른 위치면 UIDropOperationForbidden 뱃지를 표기한다.
            operation = UIDropOperationCancel;
        }
    }
    UICollectionViewDropProposal *proposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:operation
                                                                                                  intent:UICollectionViewDropIntentUnspecified];
    return proposal;
}

//! Drop 할때, 어떻게 보여지는 애니메이션에서 최종적인 모양.
- (UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView
    dropPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 현재 프로젝트에서는 실행이 안되는 것 같다.
    if (collectionView == self.flowView.collectionView) {
        SwipeCell *cell = (SwipeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        CGRect cellContainerViewFrame = [cell convertRect:cell.bounds toView:cell];
        UIDragPreviewParameters *previewParameters = [UIDragPreviewParameters new];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cellContainerViewFrame cornerRadius:cell.layer.cornerRadius];
        // previewParameters.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        return previewParameters;
    }
    return nil;
}

//! 인터렉션이 적용된 뷰에 들어올때(또는 시작할때) 호출된다. 굳이 이 프로젝트에서는 이용할 필요가 없다.
//- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnter:(id<UIDropSession>)session {}
//! 인터렉션이 적용된 뷰에 나갈때 호출된다. 굳이 이 프로젝트에서는 이용할 필요가 없다.
//- (void)collectionView:(UICollectionView *)collectionView dropSessionDidExit:(id<UIDropSession>)session {}

//! 종료가 콜렉션 뷰에서 되든 아니면 destination 에서 되든 호출되므로 여기에서 reset에 해당하는 코드를 작성하면된다.
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnd:(id<UIDropSession>)session {
    [self mgrDragSceneActive:NO];
    [self dashAnimationActive:NO];
}


#pragma mark - <UIDropInteractionDelegate>
- (BOOL)dropInteraction:(UIDropInteraction *)interaction
       canHandleSession:(id<UIDropSession>)session {
    // NSLog(@"Drop - canHandleSession");
    return [session canLoadObjectsOfClass:[SwipeCellModel class]];
}

- (void)dropInteraction:(UIDropInteraction *)interaction
        sessionDidEnter:(id<UIDropSession>)session {
    // NSLog(@"Drop - sessionDidEnter");
    CGPoint dropLocation = [session locationInView:self.view];
    [self updateLayersForDropLocation:dropLocation];
}

/**
     Required delegate method: return a drop proposal, indicating how the
     view is to handle the dropped items.
*/
- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction
                   sessionDidUpdate:(id<UIDropSession>)session {
    // NSLog(@"Drop - sessionDidUpdate");
    CGPoint dropLocation = [session locationInView:self.container2];
    [self updateLayersForDropLocation:dropLocation];

    UIDropOperation operation;
    
    
    if (CGRectContainsPoint(self.container2.bounds, dropLocation) == YES) {
        /*
           If you add in-app drag-and-drop support for the .move operation,
           you must write code to coordinate between the drag interaction
           delegate and the drop interaction delegate.
        */
        ;
        if (session.localDragSession == nil) {
            // NSLog(@"^^ 안녕 닐이다");
        } else {
            // NSLog(@"^^ 안녕 닐이 아니다.");
        }
        // operation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationMove;
        operation = UIDropOperationCopy;
    } else {
        // Do not allow dropping outside of the image view.
        operation = UIDropOperationCancel;
    }
    return [[UIDropProposal alloc] initWithDropOperation:operation];
}

/**
     This delegate method is the only opportunity for accessing and loading
     the data representations offered in the drag item.
*/
- (void)dropInteraction:(UIDropInteraction *)interaction
            performDrop:(id<UIDropSession>)session {
    
    UIDragItem *sourceItem = session.items.firstObject;
    SwipeCellModel *sourceModel = sourceItem.localObject; // 이렇게 다이렉트로도 가능하다.
    NSInteger index = [self.models indexOfObject:sourceModel];
    // NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    NSDiffableDataSourceSnapshot <NSNumber *, SwipeCellModel *>*snapshot = self.diffableDataSource.snapshot;
    [self.models removeObjectAtIndex:index];
    [snapshot deleteItemsWithIdentifiers:@[sourceModel]];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:YES completion:^{}];
    // [self.flowView deleteItemsAtIndexPaths:@[indexPath] animated:YES dataUpdate:^{
    //     [weakSelf.models removeObjectAtIndex:index];
    // } completion:^{}];
    
    [session loadObjectsOfClass:[SwipeCellModel class]
                     completion:^(NSArray <SwipeCellModel *>*models) { // completion 은 메인 스레드이다. 위키 참고.
        NSLog(@"==> %@ %@ %@", models.firstObject.leftValue, models.firstObject.rightValue, models.firstObject.mainDescription);
    }];
    
    // Perform additional UI updates as needed.
    CGPoint dropLocation = [session locationInView:self.view];
    [self updateLayersForDropLocation:dropLocation];
}

- (void)dropInteraction:(UIDropInteraction *)interaction
                   item:(nonnull UIDragItem *)item
willAnimateDropWithAnimator:(nonnull id<UIDragAnimating>)animator {
    [animator addAnimations:^{
        // self.view.backgroundColor = UIColor.redColor;
        // interaction.view.backgroundColor = UIColor.orangeColor; 드랍이 부탁된 뷰이다.
    }];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (finalPosition == UIViewAnimatingPositionEnd) {
        } else if (finalPosition == UIViewAnimatingPositionStart) {
        } else { // UIViewAnimatingPositionCurrent
        }
    }];
}

- (UITargetedDragPreview *)dropInteraction:(UIDropInteraction *)interaction // 마지막에 위치를 찾아갈 수 있도록 해준다.
                    previewForDroppingItem:(UIDragItem *)item
                               withDefault:(UITargetedDragPreview *)defaultPreview {
    CGPoint center = self.destinationView.center;
    UIDragPreviewTarget *target = [[UIDragPreviewTarget alloc] initWithContainer:self.container2 center:center];
    return [defaultPreview retargetedPreviewWithTarget:target];
}

- (void)dropInteraction:(UIDropInteraction *)interaction
           concludeDrop:(id<UIDropSession>)session {}

// Update UI, as needed, when touch point of drag session leaves view.
- (void)dropInteraction:(UIDropInteraction *)interaction
         sessionDidExit:(id<UIDropSession>)session {
    // NSLog(@"Drop - sessionDidExit");
    CGPoint dropLocation = [session locationInView:self.view];
    [self updateLayersForDropLocation:dropLocation];
}

// Update UI and model, as needed, when drop session ends.
- (void)dropInteraction:(UIDropInteraction *)interaction
          sessionDidEnd:(id<UIDropSession>)session {
    // NSLog(@"Drop - sessionDidEnd");
    CGPoint dropLocation = [session locationInView:self.view];
    [self updateLayersForDropLocation:dropLocation];
}


// MARK: - Helpers
- (void)updateLayersForDropLocation:(CGPoint)dropLocation {
    if (CGRectContainsPoint(self.destinationView.frame, dropLocation) == YES) {
        self.container2.layer.borderWidth = 0.0;
        self.destinationView.layer.borderWidth = 2.0;
    } else if (CGRectContainsPoint(self.container2.bounds, dropLocation) == YES) {
        self.container2.layer.borderWidth = 5.0;
        self.destinationView.layer.borderWidth = 0.0;
    } else {
        self.container2.layer.borderWidth = 0.0;
        self.destinationView.layer.borderWidth = 0.0;
    }
}

- (void)mgrDragSceneActive:(BOOL)active {
    if (active == YES) { // 드래그가 활성화 되었다.
        self.flowView.collectionView.scrollEnabled = NO;
    } else { // 드래그가 종료되었다.
        self.flowView.collectionView.scrollEnabled = YES;
    }
}

- (void)dashAnimationActive:(BOOL)active {
    if (active == YES && [self.dashLayer animationForKey:@"InfiniteAnimationKey"] == nil) { // 애니메이션을 생성하기 위해.
        CABasicAnimation *infiniteAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        infiniteAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        infiniteAnimation.toValue = [NSNumber numberWithFloat:10.0];
        infiniteAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
        infiniteAnimation.duration = 0.5;
        infiniteAnimation.repeatCount = INFINITY; // #define INFINITY    HUGE_VALF
        infiniteAnimation.removedOnCompletion = NO;
        infiniteAnimation.fillMode = kCAFillModeForwards;
        
        [CATransaction setCompletionBlock:^{}];
        [self.dashLayer addAnimation:infiniteAnimation forKey:@"InfiniteAnimationKey"];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.dashLayer.transform = CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1.0);
        [CATransaction commit];
        
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionFade];
        [transition setDuration:0.15];
        [CATransaction setCompletionBlock:^{
            self.dashLayer.opacity = 1.0;
        }];
        [self.dashLayer addAnimation:transition forKey:nil];
        self.dashLayer.opacity = 1.0;
    } else if (active == NO && [self.dashLayer animationForKey:@"InfiniteAnimationKey"] != nil) { // 애니메이션을 없애기 위해.
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionFade];
        [transition setDuration:0.15];
        [CATransaction setCompletionBlock:^{
            [self.dashLayer removeAllAnimations];
        }];
        [self.dashLayer addAnimation:transition forKey:nil];
        self.dashLayer.opacity = 0.0;
    }
}

@end
