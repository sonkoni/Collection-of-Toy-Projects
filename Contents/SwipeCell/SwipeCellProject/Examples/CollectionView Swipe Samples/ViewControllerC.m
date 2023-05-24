//
//  ViewControllerC.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/11/26.
//

@import BaseKit;
@import IosKit;
#import "ViewControllerC.h"
#import "MMTFavCell.h"
#import "MMTFavCellModel.h"


//@interface ViewControllerC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
//                                            MGUSwipeCollectionViewCellDelegate>

@interface ViewControllerC () <MGUFlowViewDelegate, MGUSwipeCollectionViewCellDelegate>
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) MGUFlowView *flowView;

@property (nonatomic, strong) NSMutableArray <MMTFavCellModel *>*models;
@property (nonatomic, strong) MGUFlowDiffableDataSource <NSNumber *, MMTFavCellModel *>*diffableDataSource;
@end

@implementation ViewControllerC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
//    NSArray <NSIndexPath *>*indexPaths = [self.collectionView indexPathsForSelectedItems];
//    if (indexPaths != nil) {
//        for (NSIndexPath *indexPath in indexPaths) {
//            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
//        }
//    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.flowView.itemSize = CGSizeMake(self.flowView.bounds.size.width, self.flowView.bounds.size.width);
    _itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 80.0, 98.0);
    //return CGSizeMake(collectionView.frame.size.width - 80.0, 98.0);
    self.flowView.itemSize = _itemSize;
}

#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupModel];
    _itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 135.0, 80.0);
    
    self.flowView  = [MGUFlowView new];
    [self.flowView registerClass:[MMTFavCell class]
          forCellWithReuseIdentifier:NSStringFromClass([MMTFavCell class])];
    
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
//    self.flowView.dataSource = self;
    self.flowView.bounces = YES;
    self.flowView.alwaysBounceVertical = YES;
    self.flowView.reversed = YES;
    
    self.flowView.clipsToBounds = YES;
    MGUFlowVegaTransformer *transformer = [MGUFlowVegaTransformer vegaTransformerWithBothSides:NO];
    self.flowView.transformer = transformer;
    [self.view addSubview:self.flowView];
    [self.flowView mgrPinEdgesToSuperviewSafeAreaLayoutGuide];
    
    self.navigationItem.title = NSLocalizedString(@"MMTFav Scene", @"");
 
    _diffableDataSource =
    [[MGUFlowDiffableDataSource alloc] initWithFlowView:self.flowView
                                           cellProvider:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath * indexPath, MMTFavCellModel *cellModel) {
        
        MMTFavCell *cell =
        (MMTFavCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MMTFavCell class])
                                                                 forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [MMTFavCell new];
        }
        
        [cell setData:cellModel];
        cell.delegate = self;
        cell.deleteDirectionReverse = YES;
        cell.swipeDecoRightColor = [UIColor systemRedColor];
        cell.swipeDecoLeftColor = [UIColor clearColor];
        return cell;
    }];
    
    NSDiffableDataSourceSnapshot <NSNumber *, MMTFavCellModel *>*snapshot = self.diffableDataSource.snapshot;
    [snapshot appendSectionsWithIdentifiers:@[@(0)]];
    [snapshot appendItemsWithIdentifiers:self.models intoSectionWithIdentifier:@(0)];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:NO completion:^{}];
    
}

- (void)setupModel {
    NSMutableArray <MMTFavCellModel *>*(^modelsBlock)(void) = ^NSMutableArray <MMTFavCellModel *>*{
        NSMutableArray <MMTFavCellModel *>*models = [NSMutableArray array];
        MMTFavCellModel *model0 = [MMTFavCellModel favCellModelWithMainDescription:@"재민게임"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MMTFavCellModel *model1 = [MMTFavCellModel favCellModelWithMainDescription:@"아침리뷰"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MMTFavCellModel *model2 = [MMTFavCellModel favCellModelWithMainDescription:@"조깅"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MMTFavCellModel *model3 = [MMTFavCellModel favCellModelWithMainDescription:@"영어공부"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MMTFavCellModel *model4 = [MMTFavCellModel favCellModelWithMainDescription:@"스파게티 면"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        MMTFavCellModel *model5 = [MMTFavCellModel favCellModelWithMainDescription:@"역사공부"
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
    
    NSMutableArray <MMTFavCellModel *>*models = modelsBlock();
    [models addObjectsFromArray:modelsBlock()];
    [models addObjectsFromArray:modelsBlock()];
    self.models = models.mutableCopy;
}


#pragma mark - <MGUSwipeCollectionViewCellDelegate>
//!------------------------------------------------- @required
- (MGUSwipeActionsConfiguration *)collectionView:(UICollectionView *)collectionView
leading_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (MGUSwipeActionsConfiguration *)collectionView:(UICollectionView *)collectionView
trailing_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    MMTFavCell *cell = (MMTFavCell *)[collectionView cellForItemAtIndexPath:indexPath];
    __weak __typeof(self) weakSelf = self;
        
    // Completed 일 때 삭제 처리
    MGUSwipeAction *deleteAction =
    [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDestructive
                                title:nil
                              handler:^(MGUSwipeAction * _Nonnull action,
                                        __kindof UIView * _Nonnull sourceView,
                                        void (^ _Nonnull completionHandler)(BOOL)) {
        NSDiffableDataSourceSnapshot <NSNumber *, MMTFavCellModel *>*snapshot = self.diffableDataSource.snapshot;
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
    //    action.font = [UIFont systemFontOfSize:13.0];
    //    action.backgroundColor = ActionDescriptorColorForStyle(descriptor, self.buttonStyle);
    //    deleteAction.transitionDelegate = [SwipeTransitionAnimation transitionAnimationWithType:SwipeTransitionAnimationTypeNone];
    //    deleteAction.transitionDelegate = [SwipeTransitionAnimation transitionAnimationWithType:SwipeTransitionAnimationTypeFavorite];
        // SwipeTransitionAnimationTypeFavorite SwipeTransitionAnimationTypeNone
            
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    
    configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
//    configuration.expansionStyle = [SwipeExpansionStyle fillWithDelete];
    configuration.transitionStyle = MGUSwipeTransitionStyleReveal;
    configuration.backgroundColor = [UIColor systemRedColor];
    // configuration.buttonSpacing = 4.0;
        
    return configuration;
}

//!------------------------------------------------- @optional
- (void)collectionView:(UICollectionView *)collectionView
willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView
willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView
didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}

- (void)collectionView:(UICollectionView *)collectionView
didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}

- (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView  {
    return CGRectNull;
}


#pragma mark - <MGUFlowViewDelegate>
- (void)flowView:(MGUFlowView *)flowView didSelectItemAtIndex:(NSInteger)index {
//    [flowView deselectItemAtIndex:index animated:YES];
//    [flowView scrollToItemAtIndex:index animated:YES];
}

- (void)flowViewDidScroll:(MGUFlowView *)flowView {
//    UICollectionView *collectionView = [flowView valueForKey:@"collectionView"];
//    if (collectionView.panGestureRecognizer.state == UIGestureRecognizerStatePossible) {
//        NSLog(@"UIGestureRecognizerStatePossible");
//    } else if (collectionView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"UIGestureRecognizerStateBegan");
//    } else if (collectionView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
//        collectionView.panGestureRecognizer.enabled = NO;
////        [flowView deselectItemAtIndex:index animated:YES];
//        [flowView scrollToItemAtIndex:1 animated:YES];
//        collectionView.panGestureRecognizer.enabled = YES;
//    } else if (collectionView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
//    } else if (collectionView.panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
//        NSLog(@"UIGestureRecognizerStateCancelled");
//    } else if (collectionView.panGestureRecognizer.state == UIGestureRecognizerStateFailed) {
//        NSLog(@"UIGestureRecognizerStateFailed");
//    } else if (collectionView.panGestureRecognizer.state == UIGestureRecognizerStateRecognized) {
//        NSLog(@"UIGestureRecognizerStateRecognized"); // UIGestureRecognizerStateEnded
//    }
}

@end
