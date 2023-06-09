//
//  ViewControllerC.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/11/26.
//

@import BaseKit;
@import IosKit;
#import "ViewControllerC.h"
#import "MiniTimerCell.h"
#import "MiniTimerCellModel.h"

@interface ViewControllerC () <MGUFlowViewDelegate, MGUSwipeCollectionViewCellDelegate>
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) MGUFlowView *flowView;
@property (nonatomic, strong) NSMutableArray <MiniTimerCellModel *>*models;
@property (nonatomic, strong) MGUFlowDiffableDataSource <NSNumber *, MiniTimerCellModel *>*diffableDataSource;
@end

@implementation ViewControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonInit(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _itemSize = CGSizeMake(self.view.bounds.size.width - 135.0, 80.0);
    if (CGSizeEqualToSize(_itemSize, self.flowView.itemSize) == NO) {
        self.flowView.itemSize = _itemSize;
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(ViewControllerC *self) {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupModel];
    self->_itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 135.0, 80.0);
    
    self.flowView  = [MGUFlowView new];
    [self.flowView registerClass:[MiniTimerCell class]
          forCellWithReuseIdentifier:NSStringFromClass([MiniTimerCell class])];
    
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
    
    self.navigationItem.title = NSLocalizedString(@"MiniTimer 앱", @"");
 
    self->_diffableDataSource =
    [[MGUFlowDiffableDataSource alloc] initWithFlowView:self.flowView
                                           cellProvider:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath * indexPath, MiniTimerCellModel *cellModel) {
        
        MiniTimerCell *cell =
        (MiniTimerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MiniTimerCell class])
                                                                 forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [MiniTimerCell new];
        }
        
        [cell setData:cellModel];
        cell.delegate = self;
        cell.deleteDirectionReverse = YES;
        cell.swipeDecoRightColor = [UIColor systemRedColor];
        cell.swipeDecoLeftColor = [UIColor clearColor];
        return cell;
    }];
    NSDiffableDataSourceSnapshot <NSNumber *, MiniTimerCellModel *>*snapshot = self.diffableDataSource.snapshot;
    [snapshot appendSectionsWithIdentifiers:@[@(0)]];
    [snapshot appendItemsWithIdentifiers:self.models intoSectionWithIdentifier:@(0)];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:NO completion:^{}];
}

- (void)setupModel {
    NSMutableArray <MiniTimerCellModel *>*(^modelsBlock)(void) = ^NSMutableArray <MiniTimerCellModel *>*{
        NSMutableArray <MiniTimerCellModel *>*models = [NSMutableArray array];
        MiniTimerCellModel *model0 = [MiniTimerCellModel favCellModelWithMainDescription:@"재민게임"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MiniTimerCellModel *model1 = [MiniTimerCellModel favCellModelWithMainDescription:@"아침리뷰"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MiniTimerCellModel *model2 = [MiniTimerCellModel favCellModelWithMainDescription:@"조깅"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MiniTimerCellModel *model3 = [MiniTimerCellModel favCellModelWithMainDescription:@"영어공부"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MiniTimerCellModel *model4 = [MiniTimerCellModel favCellModelWithMainDescription:@"스파게티 면"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MiniTimerCellModel *model5 = [MiniTimerCellModel favCellModelWithMainDescription:@"역사공부"
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
    
    NSMutableArray <MiniTimerCellModel *>*models = modelsBlock();
    [models addObjectsFromArray:modelsBlock()];
    [models addObjectsFromArray:modelsBlock()];
    self.models = models.mutableCopy;
}


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
        NSDiffableDataSourceSnapshot <NSNumber *, MiniTimerCellModel *>*snapshot = self.diffableDataSource.snapshot;
        [snapshot deleteItemsWithIdentifiers:@[weakSelf.models[indexPath.row]]];
        [weakSelf.models removeObjectAtIndex:indexPath.row];
        [weakSelf.diffableDataSource mgrSwipeApplySnapshot:snapshot
                                            collectionView:weakSelf.flowView.collectionView
                                                completion:nil];
    }];
            
    deleteAction.title = @"삭제";
    UIImage *image = [UIImage systemImageNamed:@"trash"];
    deleteAction.image = [image mgrImageWithColor:[UIColor whiteColor]];
    deleteAction.textColor = [UIColor whiteColor];
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    configuration.transitionStyle = MGUSwipeTransitionStyleReveal;
    configuration.backgroundColor = [UIColor systemRedColor];
    return configuration;
}

#pragma mark - @optional
- (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView  {
    return CGRectNull;
}
// - (void)collectionView:(UICollectionView *)collectionView
// willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)collectionView:(UICollectionView *)collectionView
// willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)collectionView:(UICollectionView *)collectionView
// didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)collectionView:(UICollectionView *)collectionView
// didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}


#pragma mark - <MGUFlowViewDelegate>
// 모두 옵셔널. 샘플이므로 생략.
@end
