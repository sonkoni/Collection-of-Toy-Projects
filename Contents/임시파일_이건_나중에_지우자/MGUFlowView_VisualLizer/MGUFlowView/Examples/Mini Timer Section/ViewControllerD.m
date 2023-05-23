//
//  ViewControllerD.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import GraphicsKit;
@import IosKit;
#import "ViewControllerD.h"
#import "LogCell.h"
#import "LogCellModel.h"

@interface ViewControllerD () <MGUFlowViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) MGUFlowView *flowView;

@property (nonatomic, strong) NSMutableArray <LogCellModel *>*models;
@property (nonatomic, strong) MGUFlowDiffableDataSource <NSNumber *, LogCellModel *>*diffableDataSource;

//! ------------------------ Delete Cell Part
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, assign) CGPoint longPressInitialLocation;
@property (nonatomic, strong) NSIndexPath *longPressInitialIndexPath;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@property (nonatomic, strong) UIView *deleteContainer;
@property (nonatomic, strong) MGEDashView *dashView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) NSMutableArray <__kindof UICollectionViewCell *>*deleteCells;
@property (nonatomic, strong) NSMutableArray <LogCellModel *>*deleteCellModels;
@end

@implementation ViewControllerD

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonInit(self);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _itemSize = CGSizeMake(self.view.bounds.size.width - 95.0, 50.0);
    if (CGSizeEqualToSize(self.flowView.itemSize, _itemSize) == NO) {
        self.flowView.itemSize = _itemSize;
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(ViewControllerD *self) {
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"Mini Timer 1";
    [self setupModel];
   
    self->_itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 95.0, 50.0);
    
    self.flowView  = [MGUFlowView new];
    [self.flowView registerClass:[LogCell class]
          forCellWithReuseIdentifier:NSStringFromClass([LogCell class])];
    
    [self.flowView registerClass:[MGUFlowIndicatorSupplementaryView class]
      forSupplementaryViewOfKind:MGUFlowElementKindFoldLeading
             withReuseIdentifier:MGUFlowElementKindFoldLeading];

    self.flowView.itemSize = self.itemSize;
    self.flowView.leadingSpacing = 20.0;
    self.flowView.interitemSpacing = 0.0;
    self.flowView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowView.decelerationDistance = [MGUFlowView automaticDistance];
    self.flowView.transformer = nil;
    self.flowView.delegate = self;
    self.flowView.bounces = YES;
    self.flowView.alwaysBounceVertical = YES;
    
    self.flowView.clipsToBounds = YES;
    MGUFlowFoldTransformer *transformer = [MGUFlowFoldTransformer new];
    self.flowView.transformer = transformer;
    [self.view addSubview:self.flowView];
    [self.flowView mgrPinEdgesToSuperviewSafeAreaLayoutGuide];
    
    self->_longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleLongPressGesture:)];
    [self.flowView.collectionView addGestureRecognizer:self.longPressGestureRecognizer];
    self.longPressGestureRecognizer.minimumPressDuration  = 0.3;
    self.longPressGestureRecognizer.delegate = self;
    // self.longPressGestureRecognizer.cancelsTouchesInView = NO;
    // self.longPressGestureRecognizer.delaysTouchesBegan = NO;
    // self.longPressGestureRecognizer.delaysTouchesEnded = NO;
    self->_impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleHeavy];
    
    self->_diffableDataSource =
    [[MGUFlowDiffableDataSource alloc] initWithFlowView:self.flowView
                                           cellProvider:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath * indexPath, LogCellModel *cellModel) {
        
        LogCell *cell =
        (LogCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LogCell class])
                                                                 forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [LogCell new];
        }
        
        [cell setData:cellModel];
        return cell;
    }];

    
    self.diffableDataSource.elementOfKinds = @[MGUFlowElementKindFoldLeading];
    
    self.diffableDataSource.supplementaryViewProvider =
    ^UICollectionReusableView *(UICollectionView *collectionView, NSString * elementKind, NSIndexPath *indexPath) {
        MGUFlowIndicatorSupplementaryView * cell =
        [collectionView dequeueReusableSupplementaryViewOfKind:elementKind
                                           withReuseIdentifier:elementKind
                                                  forIndexPath:indexPath];
        
        if ([elementKind isEqualToString:MGUFlowElementKindFoldLeading] == YES) {
            cell.indicatorColor = [UIColor whiteColor];
        } else {
            NSCAssert(FALSE, @"뭔가 잘못들어왔다.");
        }
    
        return cell;
    };
    self.diffableDataSource.volumeType = MGUFlowVolumeTypeFinite; // 디폴트
    NSDiffableDataSourceSnapshot <NSNumber *, LogCellModel *>*snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@(0)]];
    [snapshot appendItemsWithIdentifiers:self.models intoSectionWithIdentifier:@(0)];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:YES completion:^{}];
}

- (void)setupModel {
    //! 아이템의 유일성 문제로 인해서 블락으로 만들었다.
    NSMutableArray <LogCellModel *>*(^makeArrayBlock)(void) = ^NSMutableArray <LogCellModel *>* {
        NSMutableArray <LogCellModel *>*models = [NSMutableArray array];
        LogCellModel *model0 = [LogCellModel prtCellModelWithMainDescription:@"재민게임"
                                                                             level:6
                                                                              time:@"5:45"
                                                          anteMeridiemPostMeridiem:@"PM"
                                                                              date:@"25"
                                                                         dayOfWeek:@"FRI"];
        LogCellModel *model1 = [LogCellModel prtCellModelWithMainDescription:@""
                                                                             level:3
                                                                              time:@"2:55"
                                                          anteMeridiemPostMeridiem:@"PM"
                                                                              date:@"25"
                                                                         dayOfWeek:@"FRI"];
        LogCellModel *model2 = [LogCellModel prtCellModelWithMainDescription:@"스파게티 면"
                                                                             level:2
                                                                              time:@"12:38"
                                                          anteMeridiemPostMeridiem:@"PM"
                                                                              date:@"25"
                                                                         dayOfWeek:@"FRI"];
        LogCellModel *model3 = [LogCellModel prtCellModelWithMainDescription:@""
                                                                             level:3
                                                                              time:@"11:24"
                                                          anteMeridiemPostMeridiem:@"AM"
                                                                              date:@"25"
                                                                         dayOfWeek:@"FRI"];
        LogCellModel *model4 = [LogCellModel prtCellModelWithMainDescription:@"조깅"
                                                                             level:12
                                                                              time:@"7:06"
                                                          anteMeridiemPostMeridiem:@"AM"
                                                                              date:@"25"
                                                                         dayOfWeek:@"FRI"];
        LogCellModel *model5 = [LogCellModel prtCellModelWithMainDescription:@"Review Report"
                                                                             level:7
                                                                              time:@"8:20"
                                                          anteMeridiemPostMeridiem:@"PM"
                                                                              date:@"24"
                                                                         dayOfWeek:@"THU"];
        LogCellModel *model6 = [LogCellModel prtCellModelWithMainDescription:@"Learn History"
                                                                             level:4
                                                                              time:@"5:30"
                                                          anteMeridiemPostMeridiem:@"PM"
                                                                              date:@"24"
                                                                         dayOfWeek:@"THU"];
        LogCellModel *model7 = [LogCellModel prtCellModelWithMainDescription:@"재민게임"
                                                                             level:6
                                                                              time:@"4:20"
                                                          anteMeridiemPostMeridiem:@"PM"
                                                                              date:@"24"
                                                                         dayOfWeek:@"THU"];
        [models addObject:model0];
        [models addObject:model1];
        [models addObject:model2];
        [models addObject:model3];
        [models addObject:model4];
        [models addObject:model5];
        [models addObject:model6];
        [models addObject:model7];
        return models;
    };
    self.models = [NSMutableArray array];
    [self.models addObjectsFromArray:makeArrayBlock()];
    [self.models addObjectsFromArray:makeArrayBlock()];
    [self.models addObjectsFromArray:makeArrayBlock()];
}


#pragma mark - <MGUFlowViewDelegate>
// 모두 옵셔널. 샘플이므로 생략.


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UICollectionView *collectionView = self.flowView.collectionView;
    NSIndexPath *currentIndexPath = [collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:collectionView]];
    if (currentIndexPath == nil) {
        // NSLog(@"없어!!!");
        return NO;
    } else {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:currentIndexPath];
        if (cell.alpha == 0.0) {
            // NSLog(@"안보여!!!");
            return NO;
        } else {
            // NSLog(@"보여!!!");
            // 인덱스 저장.
            _longPressInitialIndexPath = currentIndexPath;
            return YES;
        }
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.impactFeedbackGenerator mgrImpactOccurred];
        _longPressInitialLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
        [self setupDeletion];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
        if (currentLocation.y > self.longPressInitialLocation.y) {
            // 굵기 변화.
            CGFloat widgth = currentLocation.y - self.longPressInitialLocation.y;
            widgth = MAX(1.0, MIN(3.0, (widgth / 2.0)));
            self.dashView.dashLineWidth = widgth;
            if (currentLocation.y > self.longPressInitialLocation.y + 10.0) {
                // 제거.
                [self performDeletion];
                gestureRecognizer.enabled = NO;
            }
        } else {
            self.dashView.dashLineWidth = 1.0;
            // 굵기는 원래 상태....
        }
    } else {
        if (gestureRecognizer.enabled == YES) { // 그냥 땠다. 알아서 제거.
            [self cancelDeletion];
        } else {
            gestureRecognizer.enabled = YES;
        }
    }
}

- (void)setupDeletion {
    if (self.deleteContainer != nil) {
        [self.deleteContainer removeFromSuperview];
        self.deleteContainer = nil;
        [self.dashView removeFromSuperview];
        self.dashView = nil;
    }
    if (self.visualEffectView != nil) {
        [self.visualEffectView removeFromSuperview];
        self.visualEffectView = nil;
    }
    
    NSInteger currentIndex = self.longPressInitialIndexPath.item;
    NSInteger totalCount = self.models.count;
    NSInteger lastIndex = totalCount - 1;
    self.deleteCellModels = nil;
    // self.deleteInexPaths = nil;
    _deleteCellModels = [NSMutableArray array];
    for (NSInteger i = currentIndex; i <= lastIndex; i++) {
        [self.deleteCellModels addObject:self.models[i]];
    }
    
    LogCell *currentCell = [self.flowView cellForItemAtIndex:currentIndex];
    CGSize size = currentCell.frame.size;
    NSArray <UICollectionViewCell *>*visibleCells = self.flowView.visibleCells;
    NSInteger tempIndex = currentIndex;
    self.deleteCells = nil;
    _deleteCells = [NSMutableArray array];
    for (NSInteger i = 0; i < visibleCells.count; i++) {
        if (tempIndex > lastIndex) {
            break;
        } else {
            LogCell *currentCell = [self.flowView cellForItemAtIndex:tempIndex];
            if ([visibleCells containsObject:currentCell] == YES) {
                [self.deleteCells addObject:currentCell];
                tempIndex++;
            } else {
                break;
            }
        }
    }
    
    NSInteger count = self.deleteCells.count;
    self.deleteContainer = [UIView new];
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewCell *cell = self.deleteCells[i];
        UIImageView *imageView = [cell mgrRenderSnapshot];
        imageView.frame = CGRectMake(0.0, size.height * i, size.width, size.height);
        [self.deleteContainer addSubview:imageView];
    }
    
    CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height *count);
    CGPoint origin = [currentCell convertPoint:CGPointZero toView:self.flowView];
    frame.origin = origin;
    self.deleteContainer.frame = frame;
    [self.flowView addSubview:self.deleteContainer];
    
    self.dashView = [[MGEDashView alloc] initWithFrame:self.deleteContainer.bounds];
    self.dashView.lineCap = kCALineCapRound;
    self.dashView.lineJoin = kCALineJoinRound;
    self.dashView.dashColor = [UIColor blackColor];
    UIBezierPath *dashPath = [UIBezierPath bezierPath];
    [dashPath moveToPoint:CGPointZero];
    [dashPath addLineToPoint:CGPointMake(frame.size.width, 0.0)];
    self.dashView.dashPath = dashPath;
    [self.deleteContainer addSubview:self.dashView];
    // [self.dashView dashAnimationActive:YES];
    
    if (currentIndex != [self.flowView currentIndex]) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialLight];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self.flowView insertSubview:self.visualEffectView belowSubview:self.deleteContainer];
        CGRect visualEffectViewFrame = frame;
        visualEffectViewFrame.size.height = currentCell.frame.size.height * ABS([self.flowView currentIndex] - currentIndex);
        visualEffectViewFrame.origin.y = visualEffectViewFrame.origin.y - visualEffectViewFrame.size.height;
        self.visualEffectView.frame = visualEffectViewFrame;
        // [self.visualEffectView mgrPinEdgesToSuperviewEdges];
        self.visualEffectView.alpha = 0.0;
    }
    
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear
                                                     animations:^{ self.visualEffectView.alpha = 0.6; }
                                                     completion:^(UIViewAnimatingPosition finalPosition) {}];
}

- (void)performDeletion {
    for (UICollectionViewCell *cell in self.deleteCells) {
        cell.contentView.alpha = 0.0;
    }
    
    NSInteger initialIndex = self.longPressInitialIndexPath.item;
    [self.deleteContainer mgrHingeWithAnchor:MGRViewHingeAnchorTopRight
                                      radian:(M_PI_2 * (1.0/18.0))
                                tearDuration:0.2
                                fallDuration:0.2
                                  completion:^{
        
        NSDiffableDataSourceSnapshot <NSNumber *, LogCellModel *>*snapshot = self.diffableDataSource.snapshot;
        if (initialIndex - 1 >= 0) {
            self.models = [self.models mgrSubArrayToIndex:initialIndex - 1].mutableCopy;
        } else {
            self.models = @[].mutableCopy;
        }
        [snapshot deleteItemsWithIdentifiers:self.deleteCellModels];
        __weak __typeof(self) weakSelf = self;
        [self.diffableDataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear
                                                             animations:^{
                weakSelf.visualEffectView.alpha = 0.0;
            } completion:^(UIViewAnimatingPosition finalPosition) {
                [weakSelf.visualEffectView removeFromSuperview];
                weakSelf.visualEffectView = nil;
            }];
            [weakSelf.deleteContainer removeFromSuperview];
            weakSelf.deleteContainer = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (UICollectionViewCell *cell in weakSelf.deleteCells) {
                    cell.contentView.alpha = 1.0;
                }
            });
        }];
    }];
}

// 실제 deletion 이 발생하지 않고 취소되었다.
- (void)cancelDeletion {
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear
                                                         animations:^{
            self.visualEffectView.alpha = 0.0;
            self.dashView.alpha = 0.0;
        } completion:^(UIViewAnimatingPosition finalPosition) {
            [self.visualEffectView removeFromSuperview];
            self.visualEffectView = nil;
            [self.deleteContainer removeFromSuperview];
            self.deleteContainer = nil;
        }];
}

@end
