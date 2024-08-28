//
//  ViewControllerX1.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/08/20.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "ViewControllerX1.h"
#import "OutlineContent.h"
#import "OutlineIndicatorLineView.h"
#import "MGROutlineCell.h"
#import "EmptyViewController.h"

typedef NSString * MGRMainSection NS_STRING_ENUM;
static MGRMainSection const mainSection  = @"mainSection";

@interface ViewControllerX1 ()  <UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate>
@property (nonatomic, strong) UITableViewDiffableDataSource <MGRMainSection, MGROutlineItem <OutlineContent *>*>*dataSource;
@property (nonatomic, strong, readonly) NSDiffableDataSourceSnapshot <MGRMainSection, MGROutlineItem <OutlineContent *>*>*snapshotForCurrentState; // @dynamic
@property (nonatomic, strong) UITableView *outlineTableView;
@property (nonatomic, strong) NSMutableArray <MGROutlineItem <OutlineContent *>*>*menuItems;
@property (nonatomic, strong, nullable) MGROutlineItemLocation dropLocationInfoValue;
@property (nonatomic, strong) OutlineIndicatorLineView *indicatorLineView;
@property (nonatomic, strong) UIView *indicatorSuperFaceView;
@property (nonatomic) CGFloat indentationWidth; // 디폴트 20.0으로 잡는다.
//! Drag Preview를 추적하기 위해. https://stackoverflow.com/questions/51020273/get-frame-of-drag-preview/61308512#61308512
@property (nonatomic) CGPoint initialDragLocation;
@property (nonatomic) CGRect initialDragCellFrame;

@end

@implementation ViewControllerX1
@dynamic snapshotForCurrentState;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _commonInit];
    [self configureTableView];
    [self configureDataSource];
//    [self updateUIAnimated:NO];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MGROutlineItem *item  = self.menuItems.lastObject.subitems.lastObject;
        NSData *data =[NSKeyedArchiver archivedDataWithRootObject:item
                                            requiringSecureCoding:NO
                                                            error:nil];
        MGROutlineItem <OutlineContent *>*item2 = [NSKeyedUnarchiver unarchivedObjectOfClass:[MGROutlineItem class] fromData:data error:nil];
        NSLog(@"item2 %@", item2.contentItem);
        NSLog(@"%@", item2.contentItem.title);
        NSLog(@"%@", item2.contentItem.viewControllerClass);
    });
}*/

#pragma mark - 생성 & 소멸
- (void)_commonInit {
    Class classObjc = [EmptyViewController class];
    
    MGROutlineItem *item0 =
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Compositional Layout"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Getting Started"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"List" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Grid" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Inset Items Grid" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Two-Column Grid" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Per-Section Layout"] subitems:@[
                [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Distinct Sections" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Adaptive Sections" viewControllerClass:classObjc]]]]]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Advanced Layouts"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Supplementary Views"] subitems:@[
                [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Item Badges" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Section Headers/Footers" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Pinnned Section Headers" viewControllerClass:classObjc]]]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Section Background Decoration" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Nested Groups" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Orthogonal Sections"] subitems:@[
                [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Orthogonal Sections" viewControllerClass:classObjc]],
                [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Orthogonal Section Behaviors" viewControllerClass:classObjc]]]]]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Conference App"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Videos" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"News" viewControllerClass:classObjc]]]]
    ]];
    
    MGROutlineItem *item1 =
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Diffable Data Source"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Mountains Search" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Settings: Wi-Fi" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Insertion Sort Visualization" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"UITableView: Editing" viewControllerClass:classObjc]]]];
        
    _menuItems = @[item0, item1].mutableCopy;
    
    _indicatorLineView = [OutlineIndicatorLineView new];
    _indicatorSuperFaceView = [UIView new];
    self.indicatorSuperFaceView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    self.indicatorSuperFaceView.userInteractionEnabled = NO;
    
    _indentationWidth = 20.0;
}

- (void)configureTableView {
    _outlineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.outlineTableView];
    self.outlineTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.outlineTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.outlineTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.outlineTableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.outlineTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.outlineTableView registerClass:[MGROutlineCell class]
                  forCellReuseIdentifier:NSStringFromClass([MGROutlineCell class])];
    
    
    self.outlineTableView.rowHeight = 44.0;
    self.outlineTableView.delegate = self;
    self.outlineTableView.dragDelegate = self;
    self.outlineTableView.dropDelegate = self;
    self.outlineTableView.dragInteractionEnabled = YES;
    self.outlineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)configureDataSource {
    __weak __typeof(self) weakSelf = self;
    _dataSource =
    [[UITableViewDiffableDataSource alloc] initWithTableView:self.outlineTableView
                                                cellProvider:^UITableViewCell *(UITableView *tableView,
                                                                                NSIndexPath *indexPath,
                                                                                MGROutlineItem <OutlineContent *>*outlineItem) {
        __strong __typeof(weakSelf) self = weakSelf;
        MGROutlineCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MGROutlineCell class])
                                        forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[MGROutlineCell class]] == NO) {
            NSAssert(FALSE, @"Could not create new cell");
        }
        
        cell.label.text = outlineItem.contentItem.title;
        cell.indentationLevel = outlineItem.indentationLevel;
        cell.indentationWidth = self.indentationWidth;
        cell.group = outlineItem.hasSubitem;
        cell.expanded = outlineItem.isExpanded;
        return cell;
    }];

    self.dataSource.defaultRowAnimation = UITableViewRowAnimationFade;
    
    // load our initial data
    NSDiffableDataSourceSnapshot <MGRMainSection, MGROutlineItem <OutlineContent *>*>*snapshot = [self snapshotForCurrentState];
    [self.dataSource applySnapshot:snapshot animatingDifferences:NO];
}

- (void)updateUI {
    NSDiffableDataSourceSnapshot <MGRMainSection, MGROutlineItem <OutlineContent *>*>*snapshot = [self snapshotForCurrentState];
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

#pragma mark - 세터 & 게터
- (NSDiffableDataSourceSnapshot <MGRMainSection, MGROutlineItem *>*)snapshotForCurrentState {
    NSDiffableDataSourceSnapshot <MGRMainSection, MGROutlineItem *>*snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[mainSection]];

    void (^__block addItemsBlock)(MGROutlineItem * _Nullable);

    __weak __block __typeof(addItemsBlock) weakAddItemsBlock = addItemsBlock = ^(MGROutlineItem *menuItem){
        [snapshot appendItemsWithIdentifiers:@[menuItem]];
        if (menuItem.isExpanded == YES) {
            for (MGROutlineItem *item in menuItem.subitems) {
                weakAddItemsBlock(item);
            }
        }
    };

    for (MGROutlineItem *item in self.menuItems) {
        addItemsBlock(item);
    }

    return snapshot;
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGROutlineItem <OutlineContent *>*outlineItem = [self.dataSource itemIdentifierForIndexPath:indexPath];
    if (outlineItem == nil) {
        return;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (outlineItem.hasSubitem == YES) {
        outlineItem.expanded = !outlineItem.isExpanded;
        
        MGROutlineCell *cell = (MGROutlineCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[MGROutlineCell class]] == YES) {
            [UIView animateWithDuration:0.2
                             animations:^{
                cell.expanded = outlineItem.isExpanded;
                [self updateUI];
            }];
        }
    } else {
        Class viewControllerClass = [outlineItem.contentItem viewControllerClass];
        if (viewControllerClass != nil) {
            UINavigationController *nav =
            [[UINavigationController alloc] initWithRootViewController:[viewControllerClass new]];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backgroundView;
}


#pragma mark - <UITableViewDragDelegate>
- (NSArray <UIDragItem *>*)tableView:(UITableView *)tableView
        itemsForBeginningDragSession:(id<UIDragSession>)session
                         atIndexPath:(NSIndexPath *)indexPath {
    MGROutlineItem <OutlineContent *>*item = [self.dataSource itemIdentifierForIndexPath:indexPath];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:item];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = item;

    //! 최초 Drag를 시작한 손가락의 위치와 그에 해당하는 cell의 frame을 저장한다. 드래그로 움직이는 셀의 프레임을 추적하기 위함이다.
    _initialDragLocation = [session locationInView:tableView];
    NSIndexPath *path = [tableView indexPathForRowAtPoint:_initialDragLocation];
    MGROutlineCell *cell = (MGROutlineCell *)[tableView cellForRowAtIndexPath:path];
    _initialDragCellFrame = [cell.containerView convertRect:cell.containerView.bounds toView:tableView];
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
- (NSArray <UIDragItem *>*)tableView:(UITableView *)tableView
         itemsForAddingToDragSession:(id<UIDragSession>)session
                         atIndexPath:(NSIndexPath *)indexPath
                               point:(CGPoint)point {
    MGROutlineItem <OutlineContent *>*item = [self.dataSource itemIdentifierForIndexPath:indexPath];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:item];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = item;
    return @[dragItem];
    
}
*/

// 드래그하는 동안 지정된 위치에 아이템을 표시하는 방법에 대한 커스텀 정보를 반환한다. 드래그하면서 표시될 뷰를 꾸민다.
- (UIDragPreviewParameters *)tableView:(UITableView *)tableView
dragPreviewParametersForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.outlineTableView) {
        
        MGROutlineCell *cell = (MGROutlineCell *)[tableView cellForRowAtIndexPath:indexPath];
        CGRect cellContainerViewFrame = [cell.containerView convertRect:cell.containerView.bounds toView:cell];
        UIDragPreviewParameters *previewParameters = [UIDragPreviewParameters new];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cellContainerViewFrame cornerRadius:5.0];
        return previewParameters;
    }
    return nil;
//
//        CGRect cellContentViewFrame = cell.contentView.frame;
//        previewParameters.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
}


#pragma mark - <UITableViewDropDelegate>
//! 이 메서드를 구현하지 않으면 collectionView 는 YES를 반환한 것으로 간주한다.
- (BOOL)tableView:(UITableView *)tableView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[MGROutlineItem class]];
}

//! Drop 할때, 어떻게 보여지는 애니메이션에서 최종적인 모양.
- (UIDragPreviewParameters *)tableView:(UITableView *)tableView
dropPreviewParametersForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.outlineTableView) {
        MGROutlineCell *cell = (MGROutlineCell *)[tableView cellForRowAtIndexPath:indexPath];
        CGRect cellContainerViewFrame = [cell.containerView convertRect:cell.containerView.bounds toView:cell];
        UIDragPreviewParameters *previewParameters = [UIDragPreviewParameters new];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cellContainerViewFrame cornerRadius:5.0];
//        previewParameters.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        return previewParameters;
    }
    return nil;
}

//! 팬이 시작되면 계속해서 반복적으로 치게된다.
- (UITableViewDropProposal *)tableView:(UITableView *)tableView
                  dropSessionDidUpdate:(id<UIDropSession>)session
              withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    if (session.localDragSession != nil &&
        tableView.hasActiveDrag == YES &&
        destinationIndexPath != nil &&
        [tableView.indexPathsForVisibleRows containsObject:destinationIndexPath]) {  // 현재 collectionView 위에서 드래깅 되고 있을 때.
        
        UIDragItem *sourceItem = session.items.firstObject;
        MGROutlineItem *sourceOutlineItem = sourceItem.localObject;
        MGROutlineItem *currentGestureItem = [self.dataSource itemIdentifierForIndexPath:destinationIndexPath];
//      NSIndexPath *sourceIndexPath = [self.dataSource indexPathForItemIdentifier:sourceOutlineItem];
        NSArray <MGROutlineItem *>*recurrenceAllSubitems = [sourceOutlineItem recurrenceAllSubitems];

        
        if ([sourceOutlineItem isEqual:currentGestureItem] == NO &&
            [recurrenceAllSubitems containsObject:currentGestureItem] == NO) {
            UIDropOperation dropOperation = [self _privateTableView:tableView
                                               dropSessionDidUpdate:session
                                           withDestinationIndexPath:destinationIndexPath];

            return [[UITableViewDropProposal alloc] initWithDropOperation:dropOperation intent:UITableViewDropIntentUnspecified];
        }
    }

    [self removeIndicatorLineView];
    return [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationCancel intent:UITableViewDropIntentUnspecified];
//! UIDropOperation
//        UIDropOperationCancel
//        UIDropOperationForbidden
//        UIDropOperationMove
//        UIDropOperationCopy

//! UITableViewDropIntent
//        UITableViewDropIntentUnspecified,
//        UITableViewDropIntentInsertAtDestinationIndexPath,
//        UITableViewDropIntentInsertIntoDestinationIndexPath,
//        UITableViewDropIntentAutomatic
}

- (void)tableView:(UITableView *)tableView dropSessionDidEnter:(id<UIDropSession>)session {}
- (void)tableView:(UITableView *)tableView dropSessionDidExit:(id<UIDropSession>)session {
    [self removeIndicatorLineView];
}
- (void)tableView:(UITableView *)tableView dropSessionDidEnd:(id<UIDropSession>)session {
    [self removeIndicatorLineView];
}

//! 최초 시작 인덱스가 아닌 곳에서 멈추면 들어온다.
- (void)tableView:(UITableView *)tableView performDropWithCoordinator:(id<UITableViewDropCoordinator>)coordinator {
    
    [self removeIndicatorLineView];
    id<UITableViewDropItem> itemToDrop = coordinator.items.firstObject;
    NSIndexPath *sourceIndexPath = itemToDrop.sourceIndexPath;
    UIDragItem *dragItem = itemToDrop.dragItem;
    MGROutlineItem *sourceOutlineItem = dragItem.localObject;
//    OutlineItem *oldSourceItemSuper = sourceOutlineItem.superItem;
//    NSIndexPath *finalFingerLocationIndexPath = coordinator.destinationIndexPath;
//    OutlineItem *finalFingerLocationOutlineItem = [self.dataSource itemIdentifierForIndexPath:finalFingerLocationIndexPath];

    if (self.dropLocationInfoValue == nil) {
        [coordinator dropItem:dragItem toRowAtIndexPath:sourceIndexPath];
        return;
    } else if ([sourceOutlineItem isKindOfClass:[MGROutlineItem class]] == NO || sourceIndexPath == nil) {
        self.dropLocationInfoValue = nil;
        return;
    }

    //! FIXME: 수정해야한다.
    if (coordinator.proposal.operation == UIDropOperationCopy) {
        NSMutableArray <MGROutlineItem *>*reloadItems = @[sourceOutlineItem].mutableCopy;
        MGROutlineItem *willCloseItem = nil;
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
            MGROutlineItem *targetItem = self.dropLocationInfoValue.superItem;
            [reloadItems addObject:targetItem];
            if (self.dropLocationInfoValue.afterItem != nil) {
                [targetItem insertSubitems:@[sourceOutlineItem] afterItem:self.dropLocationInfoValue.afterItem];
            } else if (self.dropLocationInfoValue.beforeItem != nil) {
                [targetItem insertSubitems:@[sourceOutlineItem] beforeItem:self.dropLocationInfoValue.beforeItem];
            } else {
                [targetItem appendSubitems:@[sourceOutlineItem]];
            }
        }

        //! expand 해야할 item 모으기. 임시 Root가 필요하다.
        MGROutlineItem <OutlineContent *>*tempRoot = [MGROutlineItem tempRootWithSubitems:self.menuItems];
        NSMutableArray <MGROutlineItem *>*expandedItems = [tempRoot recurrenceAllExpandedSubitems].mutableCopy;
        [tempRoot deleteAllSubitems]; //! 반드시 제거해야한다.

        if (willCloseItem != nil) {
            willCloseItem.expanded = NO;
            [reloadItems addObject:willCloseItem];
        }

        MGROutlineItem *targetItem = self.dropLocationInfoValue.superItem;
        if ([expandedItems containsObject:targetItem] == NO && targetItem != nil) {
            targetItem.expanded = YES;
        }

        NSDiffableDataSourceSnapshot *snapshot = [self snapshotForCurrentState];

        __weak __typeof(self) weakSelf = self;
        // https://developer.apple.com/forums/thread/126742
        [snapshot reloadItemsWithIdentifiers:reloadItems];
        [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
            [weakSelf.dataSource applySnapshot:snapshot animatingDifferences:NO completion:^{}];
        }];

        // 테이블뷰의 특정 위치에 놓는다.
        [coordinator dropItem:dragItem toRowAtIndexPath:[self.dataSource indexPathForItemIdentifier:sourceOutlineItem]];
    }

    self.dropLocationInfoValue = nil;
    return;
//
//        NSDiffableDataSourceSectionSnapshot <OutlineItem *>*deleteSectionSnapshot =
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

//! outline tableView view 위의 임의의 셀 위에서 놀고 있을 때 && source item(recurrence subitems를 포함하여)이 아닌 다른 아이템에 있을 때.
- (UIDropOperation)_privateTableView:(UITableView *)tableView
                dropSessionDidUpdate:(id<UIDropSession>)session
            withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UIDragItem *sourceItem = session.items.firstObject;
    MGROutlineItem *sourceOutlineItem = sourceItem.localObject;
    MGROutlineItem *currentGestureItem = [self.dataSource itemIdentifierForIndexPath:destinationIndexPath];
//    NSIndexPath *sourceIndexPath = [self.dataSource indexPathForItemIdentifier:sourceOutlineItem];
//    UICollectionViewCell *sourceCell = [collectionView cellForItemAtIndexPath:sourceIndexPath];
    MGROutlineCell *currentCell = (MGROutlineCell *)[tableView cellForRowAtIndexPath:destinationIndexPath];

    CGPoint touchLocation = [session locationInView:tableView]; // previewProvider 가 제공되었다는 가정하에 이렇다.
    CGRect dragPreviewFrame = [self currentDragPreviewFrameAtLocation:touchLocation]; // cell의 containerview를 collectionview에서 해석.
    CGRect currentCellFrame = [currentCell.containerView convertRect:currentCell.containerView.bounds toView:tableView];

    BOOL isInnerLocation = (CGRectGetMinX(dragPreviewFrame) >= CGRectGetMinX(currentCellFrame)) ? YES : NO;
    BOOL isCurrentGestureItemExpanded = currentGestureItem.expanded;
//! 설정할때, 뷰컨트롤러를 갖고 있지 않은 아이템은 폴더로 설정했지만, 사용하지를 않았다.
//    BOOL isCurrentGestureItemFolder = currentGestureItem.isFolder; // 이건 상황에 맞게 구성해야한다.

    BOOL isKnobBottom = YES;
    CGFloat xKnobOriginOut = 15.0;
    CGFloat xKnobOriginIn = 40.0; // 이 둘의 차이는 눈에 보이는 정도로 판단했다. 이미지의 가로 사이즈가 25.0 이므로 이정도 차이가 생김.
    CGFloat xKnobOrigin;

    MGROutlineItemLocation sourceItemLocationInfo;
//! superItem 이 없을 경우에는 위치를 판단할 수 없으므로 임시로 만들어 준다.
    MGROutlineItem <OutlineContent *>*tempRoot = [MGROutlineItem tempRootWithSubitems:self.menuItems];
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
        MGROutlineItem *targetItem = currentGestureItem.superItem == tempRoot ? nil : currentGestureItem.superItem;
        MGROutlineItem *afterItem = currentGestureItem;
        MGROutlineItem *beforeItem = currentGestureItem.currentLocationInfo.beforeItem;
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
// MGROutlineItem *beforeItem = currentGestureItem.currentLocationInfo.beforeItem; 를 확인해야하므로 여기서 제거하는것이 옳다.
    [tempRoot deleteAllSubitems]; //! 반드시 제거해야한다.

    self.indicatorLineView.knobPosition = MGROutlineIndicatorKnobPositionMake(isKnobBottom, xKnobOrigin);
    if (self.indicatorLineView.superview != currentCell.containerView) {
        [currentCell.containerView addSubview:self.indicatorLineView];
    }
    self.indicatorLineView.frame = currentCell.containerView.bounds;

    if (dropLocationInfoValue.superItem == nil) {
        [self.indicatorSuperFaceView removeFromSuperview];
    } else {
        NSIndexPath *indexPath = [self.dataSource indexPathForItemIdentifier:dropLocationInfoValue.superItem];
        if (indexPath != nil) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
