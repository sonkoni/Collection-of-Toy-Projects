//
//  ViewControllerF.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/26.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import IosKit;
#import "ViewControllerF.h"
#import "SwipeCell.h"
#import "SwipeCellModel.h"

@interface ViewControllerF () <MGUFlowViewDelegate, MGUSwipeCollectionViewCellDelegate>
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) MGUFlowView *flowView;
@property (nonatomic, strong) NSMutableArray <SwipeCellModel *>*models;
@property (nonatomic, strong) MGUFlowDiffableDataSource <NSNumber *, SwipeCellModel *>*diffableDataSource;
@end

@implementation ViewControllerF

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
}


#pragma mark - 생성 & 소멸
static void CommonInit(ViewControllerF *self) {
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"Swipe Sample";
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
    [self.view addSubview:self.flowView];
    [self.flowView mgrPinEdgesToSuperviewSafeAreaLayoutGuide];
    
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
    NSMutableArray <SwipeCellModel *>*(^modelsBlock)(void) = ^NSMutableArray <SwipeCellModel *>*{
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
    
    NSMutableArray <SwipeCellModel *>*models = modelsBlock();
    [models addObjectsFromArray:modelsBlock()];
    [models addObjectsFromArray:modelsBlock()];
    self.models = models.mutableCopy;
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
    // SwipeCell *cell = (SwipeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // Completed 일 때 삭제 처리
    __weak __typeof(self) weakSelf = self;
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
    // action.font = [UIFont systemFontOfSize:13.0];
    // action.backgroundColor = ActionDescriptorColorForStyle(descriptor, self.buttonStyle);
    // deleteAction.transitionDelegate = [SwipeTransitionAnimation transitionAnimationWithType:SwipeTransitionAnimationTypeNone];
    // deleteAction.transitionDelegate = [SwipeTransitionAnimation transitionAnimationWithType:SwipeTransitionAnimationTypeFavorite];
    // SwipeTransitionAnimationTypeFavorite SwipeTransitionAnimationTypeNone
        
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    configuration.transitionStyle = MGUSwipeTransitionStyleReveal;
    configuration.backgroundColor = [UIColor systemRedColor];
    // configuration.buttonSpacing = 4.0;
    return configuration;
}

#pragma mark - @optional
- (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView  {
    return CGRectNull;
}
// - (void)collectionView:(UICollectionView *)collectionView willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)collectionView:(UICollectionView *)collectionView willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)collectionView:(UICollectionView *)collectionView didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)collectionView:(UICollectionView *)collectionView didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
@end
