//
//  ViewControllerY2.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/08/24.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "ViewControllerY2.h"
#import "MGROutlineItem.h"
#import "MGROutlineContent.h"
#import "MGROutlineIndicatorLineView.h"
#import "EmptyViewController.h"
#import "NSArray+MGRBase.h"

typedef NSString * MGRMainSection NS_STRING_ENUM;
static MGRMainSection const mainSection  = @"mainSection";

@interface ViewControllerY2 () <UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate>

@property (nonatomic, strong) UICollectionViewDiffableDataSource <MGRMainSection, MGROutlineItem <MGROutlineContent *>*>*dataSource;
@property (nonatomic, strong, readonly) NSDiffableDataSourceSectionSnapshot <MGROutlineItem <MGROutlineContent *>*>*sectionSnapshot; // @dynamic
@property (nonatomic, strong, nullable) MGROutlineItemLocation dropLocationInfoValue;
@property (nonatomic, strong) UICollectionView *outlineCollectionView;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <MGROutlineContent *>*>*menuItems;
@property (nonatomic, strong) MGROutlineIndicatorLineView *indicatorLineView;
@property (nonatomic, strong) UIView *indicatorSuperFaceView;
@property (nonatomic) CGFloat indentationWidth; // 디폴트 20.0으로 잡는다.

//! Drag Preview를 추적하기 위해. https://stackoverflow.com/questions/51020273/get-frame-of-drag-preview/61308512#61308512
@property (nonatomic) CGPoint initialDragLocation;
@property (nonatomic) CGRect initialDragCellFrame;
@end

@implementation ViewControllerY2
@dynamic sectionSnapshot;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _commonInit];
    [self configureCollectionView];
    [self configureDataSource];
}

#pragma mark - 생성 & 소멸
- (void)_commonInit {
    Class classObjc = [EmptyViewController class];
    
    MGROutlineItem <MGROutlineContent *>*item0 =
    [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Compositional Layout"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Getting Started"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Grid" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Inset Items Grid" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Two-Column Grid" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Per-Section Layout"] subitems:@[
                [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Distinct Sections" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Adaptive Sections" viewControllerClass:classObjc]]]]]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Advanced Layouts"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Supplementary Views"] subitems:@[
                [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Item Badges" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Section Headers/Footers" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Pinned Section Headers" viewControllerClass:classObjc]]]],
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Section Background Decoration" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Nested Groups" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Orthogonal Sections"] subitems:@[
                [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Orthogonal Sections" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Orthogonal Section Behaviors" viewControllerClass:classObjc]]]]]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Conference App"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Videos" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"News" viewControllerClass:classObjc]]]]
    ]];
    
    MGROutlineItem *item1 =
    [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Diffable Data Source"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Mountains Search" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Settings: Wi-Fi" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Insertion Sort Visualization" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"UITableView: Editing" viewControllerClass:classObjc]]]];
    
    MGROutlineItem *item2 =
    [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Lists"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Simple List" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Reorderable List" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"List Appearances" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"List with Custom Cells" viewControllerClass:classObjc]]]];
    
    MGROutlineItem *item3 =
    [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Outlines"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Emoji Explorer" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Emoji Explorer - List" viewControllerClass:classObjc]]]];
    
    MGROutlineItem *item4 =
    [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Cell Configurations"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[MGROutlineContent itemWithTitle:@"Custom Configurations" viewControllerClass:classObjc]]]];
    
    _menuItems = @[item0, item1, item2, item3, item4].mutableCopy;
    
    _indicatorLineView = [MGROutlineIndicatorLineView new];
    _indicatorSuperFaceView = [UIView new];
    self.indicatorSuperFaceView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    self.indicatorSuperFaceView.userInteractionEnabled = NO;
    _indentationWidth = 20.0;
}

- (void)configureCollectionView {
    UICollectionView *collectionView =
    [[UICollectionView alloc] initWithFrame:self.view.bounds
                       collectionViewLayout:[self generateLayout]];
    [self.view addSubview:collectionView];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.outlineCollectionView = collectionView;
    collectionView.delegate = self;
    
    collectionView.dragDelegate = self;
    collectionView.dropDelegate = self;
    collectionView.dragInteractionEnabled = YES;
}

- (void)configureDataSource {
    //! UICollectionViewCellRegistration iOS 14 이상부터 가능.
    UICollectionViewCellRegistration *containerCellRegistration =
    [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class]
    configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, MGROutlineItem <MGROutlineContent *>*  _Nonnull item) {
        
        // Populate the cell with our item description.
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = item.contentItem.title;
        contentConfiguration.textProperties.font =
        [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryOutlineDisclosure *cellAccessoryOutlineDisclosure = [UICellAccessoryOutlineDisclosure new];
        cellAccessoryOutlineDisclosure.style = UICellAccessoryOutlineDisclosureStyleHeader;
        cell.accessories = @[cellAccessoryOutlineDisclosure];
        cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
        cell.indentationWidth = self.indentationWidth;
    }];

    UICollectionViewCellRegistration *cellRegistration =
    [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class]
    configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, MGROutlineItem <MGROutlineContent *>*  _Nonnull item) {
        
        // Populate the cell with our item description.
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = item.contentItem.title;
        cell.contentConfiguration = contentConfiguration;
        cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
        cell.indentationWidth = self.indentationWidth;
    }];

    _dataSource =
    [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.outlineCollectionView
    cellProvider:^UICollectionViewCell * _Nullable(UICollectionView *collectionView, NSIndexPath *indexPath, MGROutlineItem <MGROutlineContent *>*item) {
        // Return the cell.
        if (item.subitems.count == 0) {
            return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration
                                                                    forIndexPath:indexPath
                                                                            item:item];
        } else {
            return [collectionView dequeueConfiguredReusableCellWithRegistration:containerCellRegistration
                                                                    forIndexPath:indexPath
                                                                            item:item];
        }
    }];

    // load our initial data
    NSDiffableDataSourceSectionSnapshot <MGROutlineItem <MGROutlineContent *>*>*snapshot = [self sectionSnapshot];
    
    [self.dataSource applySnapshot:snapshot
                         toSection:mainSection
              animatingDifferences:YES // YES로 안하면 버벅임.
                        completion:nil];
}

- (UICollectionViewLayout *)generateLayout {
    UICollectionLayoutListConfiguration *listConfiguration =
    [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceSidebar];
    return [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
}


#pragma mark - 세터 & 게터
- (NSDiffableDataSourceSectionSnapshot<MGROutlineItem <MGROutlineContent *>*> *)sectionSnapshot {
    NSDiffableDataSourceSectionSnapshot <MGROutlineItem <MGROutlineContent *>*>*sectionSnapshot = [NSDiffableDataSourceSectionSnapshot new];
    void (^__block addItemsBlock)(NSArray <MGROutlineItem <MGROutlineContent *>*>*, MGROutlineItem <MGROutlineContent *>* _Nullable);

    __weak __block __typeof(addItemsBlock) weakAddItemsBlock = addItemsBlock = ^(NSArray <MGROutlineItem <MGROutlineContent *>*>*menuItems, MGROutlineItem <MGROutlineContent *>* _Nullable parent){
        [sectionSnapshot appendItems:menuItems intoParentItem:parent];
        for (MGROutlineItem <MGROutlineContent *>*menuItem in menuItems) {
            if (menuItem.subitems.count > 0) {
                weakAddItemsBlock(menuItem.subitems, menuItem);
            }
        }
    };
        
    addItemsBlock(self.menuItems, nil);
    return sectionSnapshot;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MGROutlineItem <MGROutlineContent *>*outlineItem = [self.dataSource itemIdentifierForIndexPath:indexPath];
    if (outlineItem == nil) {
        return;
    }

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Class viewControllerClass = [outlineItem.contentItem viewControllerClass];
    if (viewControllerClass != nil) {
        [self.navigationController pushViewController:[viewControllerClass new] animated:YES];
    }
}


#pragma mark - <UICollectionViewDragDelegate>
//! ~ Required
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView
             itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    MGROutlineItem <MGROutlineContent *>*item = [self.dataSource itemIdentifierForIndexPath:indexPath];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:item];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = item;
    
    //! 최초 Drag를 시작한 손가락의 위치와 그에 해당하는 cell의 frame을 저장한다. 드래그로 움직이는 셀의 프레임을 추적하기 위함이다.
    _initialDragLocation = [session locationInView:collectionView];
    NSIndexPath *path = [collectionView indexPathForItemAtPoint:_initialDragLocation];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:path];
    _initialDragCellFrame = [cell.contentView convertRect:cell.contentView.bounds toView:collectionView];
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
    MGROutlineItem <MGROutlineContent *>*item = [self.dataSource itemIdentifierForIndexPath:indexPath];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:item];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = item;
    return @[dragItem];
}*/


// 드래그하는 동안 지정된 위치에 아이템을 표시하는 방법에 대한 커스텀 정보를 반환한다. 드래그하면서 표시될 뷰를 꾸민다.
- (UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView
    dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.outlineCollectionView) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CGRect cellContentViewFrame = [cell.contentView convertRect:cell.contentView.bounds toView:cell];
        UIDragPreviewParameters *previewParameters = [UIDragPreviewParameters new];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cellContentViewFrame cornerRadius:5.0];
//        previewParameters.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        return previewParameters;
    }
    return nil;
}


#pragma mark - <UICollectionViewDropDelegate>
//! 이 메서드를 구현하지 않으면 collectionView 는 YES를 반환한 것으로 간주한다.
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[MGROutlineItem class]];
}

//! Drop 할때, 어떻게 보여지는 애니메이션에서 최종적인 모양.
- (UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView
    dropPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.outlineCollectionView) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
         CGRect cellContentViewFrame = [cell.contentView convertRect:cell.contentView.bounds toView:cell];
        UIDragPreviewParameters *previewParameters = [UIDragPreviewParameters new];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cellContentViewFrame cornerRadius:5.0];
//        previewParameters.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        return previewParameters;
    }
    return nil;
}

//! 팬이 시작되면 계속해서 반복적으로 치게된다.
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView
                            dropSessionDidUpdate:(id<UIDropSession>)session
                        withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    if (session.localDragSession != nil &&
        collectionView.hasActiveDrag == YES &&
        destinationIndexPath != nil &&
        [collectionView.indexPathsForVisibleItems containsObject:destinationIndexPath]) {  // 현재 collectionView 위에서 드래깅 되고 있을 때.
        
        UIDragItem *sourceItem = session.items.firstObject;
        MGROutlineItem <MGROutlineContent *>*sourceOutlineItem = sourceItem.localObject;
        MGROutlineItem <MGROutlineContent *>*currentGestureItem = [self.dataSource itemIdentifierForIndexPath:destinationIndexPath];
//      NSIndexPath *sourceIndexPath = [self.dataSource indexPathForItemIdentifier:sourceOutlineItem];
        NSArray <MGROutlineItem <MGROutlineContent *>*>*recurrenceAllSubitems = [sourceOutlineItem recurrenceAllSubitems];
        
        if ([sourceOutlineItem isEqual:currentGestureItem] == NO &&
            [recurrenceAllSubitems containsObject:currentGestureItem] == NO) {
            UIDropOperation dropOperation = [self _privateCollectionView:collectionView
                                                    dropSessionDidUpdate:session
                                                withDestinationIndexPath:destinationIndexPath];
            
            return [[UICollectionViewDropProposal alloc] initWithDropOperation:dropOperation
                                                                        intent:UICollectionViewDropIntentUnspecified];
        }
    }
    
    [self removeIndicatorLineView];
    return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCancel
                                                                intent:UICollectionViewDropIntentUnspecified];
    //! UIDropOperation
//        UIDropOperationCancel
//        UIDropOperationForbidden
//        UIDropOperationMove
//        UIDropOperationCopy
    
    //! UICollectionViewDropIntent
//        UICollectionViewDropIntentUnspecified,
//        UICollectionViewDropIntentInsertAtDestinationIndexPath,
//        UICollectionViewDropIntentInsertIntoDestinationIndexPath,
}

- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnter:(id<UIDropSession>)session {}
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidExit:(id<UIDropSession>)session {
    [self removeIndicatorLineView];
}
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnd:(id<UIDropSession>)session {
    [self removeIndicatorLineView];
}

//! 최초 시작 인덱스가 아닌 곳에서 멈추면 들어온다.
- (void)collectionView:(UICollectionView *)collectionView
performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    [self removeIndicatorLineView];
    
    id <UICollectionViewDropItem>itemToDrop = coordinator.items.firstObject;
    NSIndexPath *sourceIndexPath = itemToDrop.sourceIndexPath;
    UIDragItem *dragItem = itemToDrop.dragItem;
    MGROutlineItem <MGROutlineContent *>*sourceOutlineItem = dragItem.localObject;
//    MGROutlineItem <MGROutlineContent *>*oldSourceItemSuper = sourceOutlineItem.superItem;
//    NSIndexPath *finalFingerLocationIndexPath = coordinator.destinationIndexPath;
//    MGROutlineItem <MGROutlineContent *>*finalFingerLocationOutlineItem = [self.dataSource itemIdentifierForIndexPath:finalFingerLocationIndexPath];
    
    if (self.dropLocationInfoValue == nil) {
        [coordinator dropItem:dragItem toItemAtIndexPath:sourceIndexPath];
        return;
    } else if ([sourceOutlineItem isKindOfClass:[MGROutlineItem class]] == NO || sourceIndexPath == nil) {
        self.dropLocationInfoValue = nil;
        return;
    }
    
    if (coordinator.proposal.operation == UIDropOperationCopy) {
        NSMutableArray <MGROutlineItem *>*reloadItems = @[sourceOutlineItem].mutableCopy;
        MGROutlineItem <MGROutlineContent *>*willCloseItem = nil;
        if (sourceOutlineItem.superItem != nil && sourceOutlineItem.superItem.subitems.count == 1) {
            willCloseItem = sourceOutlineItem.superItem;
        }
        //! menuItems 업데이트 : 드래그 아이템 제거
        if (sourceOutlineItem.superItem == nil) { // 드래그 된 아이템이 루트 아이템 이라면
            [self.menuItems removeObject:sourceOutlineItem];
        } else { // 루트 아이템이 아닐 경우.
            [sourceOutlineItem removeFromSuperitem];
        }
        
        //! menuItems 업데이트 : 드래그 아이템 적절한 위치 집어 넣기
        if (self.dropLocationInfoValue.superItem == nil) { // 드래그 된 아이템이 들어가게 되는 곳이 루트 아이템 이라면
            if (self.dropLocationInfoValue.afterItem != nil) {
                NSInteger index = [self.menuItems indexOfObject:self.dropLocationInfoValue.afterItem] + 1;
                [self.menuItems insertObject:sourceOutlineItem atIndex:index];
            } else {
                [self.menuItems insertObject:sourceOutlineItem atIndex:0];
            }
        } else { // 들어가게 되는 곳이 루트 아이템이 아닐 경우.
            MGROutlineItem <MGROutlineContent *>*targetItem = self.dropLocationInfoValue.superItem;
            [reloadItems addObject:targetItem];
            if (self.dropLocationInfoValue.afterItem != nil) {
                [targetItem insertSubitems:@[sourceOutlineItem] afterItem:self.dropLocationInfoValue.afterItem];
            } else if (self.dropLocationInfoValue.beforeItem != nil) {
                [targetItem insertSubitems:@[sourceOutlineItem] beforeItem:self.dropLocationInfoValue.beforeItem];
            } else {
                [targetItem appendSubitems:@[sourceOutlineItem]];
            }
        }
        
        NSDiffableDataSourceSectionSnapshot <MGROutlineItem <MGROutlineContent *>*>*sectionSnapshot = [self.dataSource snapshotForSection:mainSection];
        MGROutlineItem <MGROutlineContent *>*targetItem = self.dropLocationInfoValue.superItem;
        
        NSMutableArray <MGROutlineItem <MGROutlineContent *>*>*expandedItems = [sectionSnapshot expandedItems].mutableCopy;
        if (willCloseItem != nil) {
            [reloadItems addObject:willCloseItem];
            [expandedItems removeObject:willCloseItem];
        }
        
        if ([expandedItems containsObject:targetItem] == NO && targetItem != nil) {
            [expandedItems addObject:targetItem];
        }

        sectionSnapshot = [self sectionSnapshot];
        [sectionSnapshot expandItems:expandedItems];
        
        // https://developer.apple.com/forums/thread/126742
        __weak __typeof(self) weakSelf = self;
        [self.dataSource applySnapshot:sectionSnapshot
                             toSection:mainSection
                  animatingDifferences:YES
                            completion:^{
            [weakSelf.dataSource applySnapshot:sectionSnapshot
                                     toSection:mainSection
                          animatingDifferences:NO
                                    completion:^{}];
        }];
        
        if (@available(iOS 15, *)) {
//        https://stackoverflow.com/questions/60620906/how-can-i-reload-items-without-removing-and-inserting-with-uitableviewdiffableda
            [self.dataSource applySnapshotUsingReloadData:self.dataSource.snapshot completion:^{}];
//            [self.outlineCollectionView reloadData]; // 효과가 윗줄과 동일한듯.
        } else {
//        [self.dataSource.snapshot reloadSectionsWithIdentifiers:@[mainSection]]; // 이게 맞는것 같다.
            [self.dataSource.snapshot reloadItemsWithIdentifiers:@[sourceOutlineItem]];
            [self.dataSource applySnapshot:self.dataSource.snapshot animatingDifferences:NO];
        }

//        ! 드랍 애니메이션을 위해.
        [coordinator dropItem:dragItem
            toItemAtIndexPath:[self.dataSource indexPathForItemIdentifier:sourceOutlineItem]]; // 콜렉션뷰의 특정 위치에 놓는다.
    }
    
    self.dropLocationInfoValue = nil;
    return;
    //
    //        NSDiffableDataSourceSectionSnapshot <MGROutlineItem <MGROutlineContent *>*>*deleteSectionSnapshot =
    //        [sectionSnapshot snapshotOfParentItem:sourceOutlineItem includingParentItem:YES];
    //        [sectionSnapshot deleteItems:deleteSectionSnapshot.items];
}


#pragma mark - Helper
- (void)removeIndicatorLineView {
    [self.indicatorLineView removeFromSuperview];
    [self.indicatorSuperFaceView removeFromSuperview];
}

- (CGRect)currentDragPreviewFrameAtLocation:(CGPoint)location {
    CGPoint displacement = CGPointZero;
    displacement.x = location.x - self.initialDragLocation.x;
    displacement.y = location.y - self.initialDragLocation.y;

    CGRect newFrame = self.initialDragCellFrame;
    newFrame.origin.x = newFrame.origin.x + displacement.x;
    newFrame.origin.y = newFrame.origin.y + displacement.y;
    return newFrame;
}

//! outline collection view 위의 임의의 셀 위에서 놀고 있을 때 && source item(recurrence subitems를 포함하여)이 아닌 다른 아이템에 있을 때.
- (UIDropOperation)_privateCollectionView:(UICollectionView *)collectionView
                                    dropSessionDidUpdate:(id<UIDropSession>)session
                                withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UIDragItem *sourceItem = session.items.firstObject;
    MGROutlineItem <MGROutlineContent *>*sourceOutlineItem = sourceItem.localObject;
    MGROutlineItem <MGROutlineContent *>*currentGestureItem = [self.dataSource itemIdentifierForIndexPath:destinationIndexPath];
//    NSIndexPath *sourceIndexPath = [self.dataSource indexPathForItemIdentifier:sourceOutlineItem];
//    UICollectionViewCell *sourceCell = [collectionView cellForItemAtIndexPath:sourceIndexPath];
    UICollectionViewCell *currentCell = [collectionView cellForItemAtIndexPath:destinationIndexPath];
    
    CGPoint touchLocation = [session locationInView:collectionView]; // previewProvider 가 제공되었다는 가정하에 이렇다.
    CGRect dragPreviewFrame = [self currentDragPreviewFrameAtLocation:touchLocation];
    CGRect currentCellFrame = [currentCell.contentView convertRect:currentCell.contentView.bounds toView:collectionView];
    
    BOOL isInnerLocation = (CGRectGetMinX(dragPreviewFrame) >= CGRectGetMinX(currentCellFrame)) ? YES : NO;
    
    NSDiffableDataSourceSectionSnapshot <MGROutlineItem <MGROutlineContent *>*>*sectionSnapshot = [self.dataSource snapshotForSection:mainSection];
    BOOL isCurrentGestureItemExpanded = [sectionSnapshot isExpanded:currentGestureItem];
//    BOOL isCurrentGestureItemExpanded = currentGestureItem.expanded; <- 13 버전에서는 다 컨트롤 해줘서 가져왔다.
//    BOOL isCurrentGestureItemFolder = currentGestureItem.isFolder; // 이건 상황에 맞게 구성해야한다.
    BOOL isKnobBottom = YES;
    CGFloat xKnobOriginOut = 0.0;
    CGFloat xKnobOriginIn = 20.0; // 이 둘의 차이는 눈에 보이는 정도로 판단했다.
    CGFloat xKnobOrigin = 0.0;
    
    MGROutlineItemLocation sourceItemLocationInfo;
    //! superItem 이 없을 경우에는 위치를 판단할 수 없으므로 임시로 만들어 준다.
    MGROutlineItem <MGROutlineContent *>*tempRoot = [MGROutlineItem tempRootWithSubitems:self.menuItems];
    sourceItemLocationInfo = sourceOutlineItem.currentLocationInfo;
    if ([sourceItemLocationInfo.superItem isEqual:tempRoot] == YES) {
        sourceItemLocationInfo.superItem = nil;
    }
    
    MGROutlineItemLocation dropLocationInfoValue; //! destination을 찾아보자.
    if (self.menuItems.firstObject == currentGestureItem &&
        CGRectGetMidY(dragPreviewFrame) <= CGRectGetMidY(currentCellFrame)) { // 현재 제스처 아이템이 루트 아이템 중에서 첫 번째이면서 한도초과
        dropLocationInfoValue = MGROutlineItemLocationMake(nil, nil, currentGestureItem);
        isKnobBottom = NO;
        xKnobOrigin = xKnobOriginOut;
    } else if ( (currentGestureItem.subitems.count > 0 && isCurrentGestureItemExpanded == YES) ||
               isInnerLocation == YES) { // 안쪽 인디케이터가 그려진다.
        dropLocationInfoValue = MGROutlineItemLocationMake(currentGestureItem, nil, currentGestureItem.subitems.firstObject);
        xKnobOrigin = xKnobOriginIn;
    } else { // 바깥쪽 인디케이터가 그려진다.
        // 현재 제스처가 위치한 곳의 셀이 단일 셀이거나, 그룹셀이지만 닫혀 있는 경우.
        MGROutlineItem <MGROutlineContent *>*targetItem = ([currentGestureItem.superItem isEqual:tempRoot]) ? nil : currentGestureItem.superItem;
        MGROutlineItem <MGROutlineContent *>*afterItem = currentGestureItem;
        MGROutlineItem <MGROutlineContent *>*beforeItem = currentGestureItem.currentLocationInfo.beforeItem;
        xKnobOrigin = xKnobOriginOut;
        
        //! 더 이동할 수도 있는 가능성을 열어두자. 이 부분을 접으면 제한적으로 이동한다.
        if (targetItem != nil && currentGestureItem == currentGestureItem.superItem.subitems.lastObject) {
            CGFloat distance = CGRectGetMinX(currentCellFrame) - CGRectGetMinX(dragPreviewFrame);
            if (distance > self.indentationWidth) {
                NSInteger index = distance / self.indentationWidth;
                NSArray <MGROutlineItem *>*superitemsToUpperLimit = [currentGestureItem superitemsToUpperLimit];
                index = MIN(index, superitemsToUpperLimit.count - 1);
                targetItem = superitemsToUpperLimit[index] == tempRoot ? nil : superitemsToUpperLimit[index];
                afterItem = superitemsToUpperLimit[index-1];
                beforeItem = afterItem.currentLocationInfo.beforeItem;
                xKnobOrigin = xKnobOriginOut - (self.indentationWidth * index);
            }
        }
        
        dropLocationInfoValue = MGROutlineItemLocationMake(targetItem, afterItem, beforeItem);
    }
    // MGROutlineItem <MGROutlineContent *>*beforeItem = currentGestureItem.currentLocationInfo.beforeItem; 를 확인해야하므로 여기서 제거하는것이 옳다.
    [tempRoot deleteAllSubitems]; //! 반드시 제거해야한다.
        
    self.indicatorLineView.knobPosition = MGROutlineIndicatorKnobPositionMake(isKnobBottom, xKnobOrigin);
    if (self.indicatorLineView.superview != currentCell.contentView) {
        [currentCell.contentView addSubview:self.indicatorLineView];
    }
    self.indicatorLineView.frame = currentCell.contentView.bounds;
    
    if (dropLocationInfoValue.superItem == nil) {
        [self.indicatorSuperFaceView removeFromSuperview];
    } else {
        NSIndexPath *indexPath = [self.dataSource indexPathForItemIdentifier:dropLocationInfoValue.superItem];
        if (indexPath != nil) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (self.indicatorSuperFaceView.superview != cell) {
                [cell addSubview:self.indicatorSuperFaceView];
            }
            self.indicatorSuperFaceView.frame = cell.bounds;
        }
    }
    
    self.dropLocationInfoValue = dropLocationInfoValue;
    //! 변할 필요가 없는 곳.
    if (MGROutlineItemLocationEqualToLocation(sourceItemLocationInfo, dropLocationInfoValue) == YES ||
        dropLocationInfoValue.superItem == sourceOutlineItem ||
        dropLocationInfoValue.afterItem == sourceOutlineItem ||
        dropLocationInfoValue.beforeItem == sourceOutlineItem) {
        self.dropLocationInfoValue = nil;
    }

    return UIDropOperationCopy; // copy이면 + 기호가 생긴다 .실제 Move 지만 UIDropOperationCopy 사용
}

@end
