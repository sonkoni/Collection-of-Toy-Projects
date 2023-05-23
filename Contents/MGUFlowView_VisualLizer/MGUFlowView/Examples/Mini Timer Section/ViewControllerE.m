//
//  ViewControllerE.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import IosKit;
#import "ViewControllerE.h"
#import "FavCell.h"
#import "FavCellModel.h"

@interface ViewControllerE () <MGUFlowViewDelegate>
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) MGUFlowView *flowView;
@property (nonatomic, strong) NSArray <FavCellModel *>*models;
@property (nonatomic, strong) MGUFlowDiffableDataSource <NSNumber *, FavCellModel *>*diffableDataSource;
@end

@implementation ViewControllerE

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
static void CommonInit(ViewControllerE *self) {
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"Mini Timer 2";
    [self setupModel];
    
    self->_itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 135.0, 80.0);
    
    self.flowView  = [MGUFlowView new];
    [self.flowView registerClass:[FavCell class]
      forCellWithReuseIdentifier:NSStringFromClass([FavCell class])];
    
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
                                           cellProvider:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath * indexPath, FavCellModel *cellModel) {
        
        FavCell *cell =
        (FavCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FavCell class])
                                                                forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [FavCell new];
        }
        
        [cell setData:cellModel];
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
    
    NSDiffableDataSourceSnapshot <NSNumber *, FavCellModel *>*snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@(0)]];
    [snapshot appendItemsWithIdentifiers:self.models intoSectionWithIdentifier:@(0)];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:NO completion:^{}];
}

- (void)setupModel {
    NSMutableArray <FavCellModel *>*(^modelsBlock)(void) = ^NSMutableArray <FavCellModel *>*{
        NSMutableArray <FavCellModel *>*models = [NSMutableArray array];
        FavCellModel *model0 = [FavCellModel favCellModelWithMainDescription:@"재민게임"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        FavCellModel *model1 = [FavCellModel favCellModelWithMainDescription:@"아침리뷰"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        FavCellModel *model2 = [FavCellModel favCellModelWithMainDescription:@"조깅"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        FavCellModel *model3 = [FavCellModel favCellModelWithMainDescription:@"영어공부"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        FavCellModel *model4 = [FavCellModel favCellModelWithMainDescription:@"스파게티 면"
                                                                         leftValue:@"45"
                                                                        rightValue:@"10"];
        FavCellModel *model5 = [FavCellModel favCellModelWithMainDescription:@"역사공부"
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
    
    NSMutableArray <FavCellModel *>*models = modelsBlock();
    [models addObjectsFromArray:modelsBlock()];
    [models addObjectsFromArray:modelsBlock()];
    self.models = models.copy;
}


#pragma mark - <MGUFlowViewDelegate>
// 모두 옵셔널. 샘플이므로 생략.

@end
