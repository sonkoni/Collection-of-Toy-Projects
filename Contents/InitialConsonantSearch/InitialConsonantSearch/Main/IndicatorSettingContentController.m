//
//  IndicatorSettingContentController.m
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/10/23.
//

#import <BaseKit/BaseKit.h>
#import "IndicatorSettingContentController.h"
#import "IndicatorSettingDetailController.h"
#import "IndicatorSettingCell.h"

@interface IndicatorSettingContentController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableViewDiffableDataSource <NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*dataSource;
@property (nonatomic, strong) UIStoryboard *board; // lazy
//@property (nonatomic, strong) IndicatorSettingDetailController *detailController; // lazy
@end

@implementation IndicatorSettingContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 44.0;
    self.tableView.estimatedRowHeight = 44.0;
    /// 디퍼블을 이용하느냐 마느냐.
    [self configureDataSource];
}

- (void)configureDataSource {
    self.tableView.dataSource = nil;
    
    __weak __typeof(self) weakSelf = self;
    _dataSource =
    [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView
                                                cellProvider:^UITableViewCell *(UITableView *tableView,
                                                                                NSIndexPath *indexPath,
                                                                                MGROutlineItem <DTOIndicatorSetting *>*outlineItem) {
        __strong __typeof(weakSelf) self = weakSelf;
        
        NSString *identifier = outlineItem.contentItem.identifier;
        if ([weakSelf.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryFavorites]) {
            if ([identifier isEqualToString:IndicatorSettingCellIDSubMinus] == YES) {
                identifier = IndicatorSettingCellIDFavoriteSub;
            } else if ([identifier isEqualToString:IndicatorSettingCellIDSubPlus] == YES ||
                       [identifier isEqualToString:IndicatorSettingCellIDSubNormal] == YES ||
                       [identifier isEqualToString:IndicatorSettingCellIDRegion] == YES) {
                identifier = IndicatorSettingCellIDFavorite;
            }
        }
        
        IndicatorSettingCell *cell =
        [tableView dequeueReusableCellWithIdentifier:identifier
                                        forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell isKindOfClass:[IndicatorSettingCell class]] == NO) {
            NSAssert(FALSE, @"Could not create new cell");
        }
        
        cell.data = outlineItem.contentItem;
        return cell;
    }];

    self.dataSource.defaultRowAnimation = UITableViewRowAnimationFade;
    [self.dataSource applySnapshot:self.viewModel.snapshotForCurrentState animatingDifferences:NO];
}

#pragma mark - 세터 & 게터

- (UIStoryboard *)board {
    if (_board == nil) {
        _board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    }
    return _board;
}

//- (IndicatorSettingDetailController *)detailController {
//    if (_detailController == nil) {
//        IndicatorSettingDetailController *vc = [self.board instantiateViewControllerWithIdentifier:@"IndicatorSettingDetailController"];
//        _detailController = vc;
//        ////_detailController.viewModel = self.viewModel;
//    }
//    return _detailController;
//}

#pragma mark - Actions

- (IBAction)selectionButtonClicked:(UIButton *)sender {
    NSIndexPath *indexPath = [self.tableView mgrIndexPathOfCellWhereViewExists:sender];
    MGROutlineItem <DTOIndicatorSetting *>*outlineItem = [self.dataSource itemIdentifierForIndexPath:indexPath];
    IndicatorSettingCell *cell = (IndicatorSettingCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    outlineItem.contentItem.selected = !(outlineItem.contentItem.selected);
    cell.data = cell.data;
    MGROutlineItem <DTOIndicatorSetting *>*progenitor = outlineItem.progenitor;
    NSIndexPath *progenitorPath = [self.dataSource indexPathForItemIdentifier:progenitor];
    IndicatorSettingCell *progenitorCell = [self.tableView cellForRowAtIndexPath:progenitorPath];
    progenitorCell.data = progenitor.contentItem;
}

- (IBAction)favButtonClicked:(UIButton *)sender {
    MGROutlineItem <DTOIndicatorSetting *>*outlineItem = [self outlineDataForSender:sender];
    DTOIndicatorSetting *data = [self dataForSender:sender];
    IndicatorSettingCell *cell = [self cellForSender:sender];
    data.favorite = !data.favorite;
    cell.data = data;
    
    __weak __typeof(self) weakSelf = self;
    [self.viewModel updateFavoriteItem:outlineItem completion:^{
        if ([weakSelf.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryFavorites]) {
            [weakSelf.dataSource applySnapshot:weakSelf.viewModel.snapshotForCurrentState animatingDifferences:YES];
        }
    }];
}

- (IBAction)plusButtonClicked:(UIButton *)sender {
    NSIndexPath *indexPath = [self.tableView mgrIndexPathOfCellWhereViewExists:sender];
    MGROutlineItem <DTOIndicatorSetting *>*outlineItem = [self.dataSource itemIdentifierForIndexPath:indexPath];
    [self.viewModel addChildItemForItem:outlineItem];
    [self.dataSource applySnapshot:self.viewModel.snapshotForCurrentState
              animatingDifferences:YES
                        completion:^{}];
}

- (IBAction)minusButtonClicked:(UIButton *)sender {
    NSIndexPath *indexPath = [self.tableView mgrIndexPathOfCellWhereViewExists:sender];
    MGROutlineItem <DTOIndicatorSetting *>*outlineItem = [self.dataSource itemIdentifierForIndexPath:indexPath];
    MGROutlineItem <DTOIndicatorSetting *>*progenitor = outlineItem.progenitor;
    [self.viewModel deleteItem:outlineItem];
    NSIndexPath *progenitorPath = [self.dataSource indexPathForItemIdentifier:progenitor];
    IndicatorSettingCell *progenitorCell = [self.tableView cellForRowAtIndexPath:progenitorPath];
    progenitorCell.data = progenitor.contentItem;
    [self.dataSource applySnapshot:self.viewModel.snapshotForCurrentState
              animatingDifferences:YES
                        completion:^{}];
}

- (IBAction)settingButtonClicked:(UIButton *)sender {
    
    NSString *subString = IndiSetMainCategoryIndicators;
    if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        // 그대로
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategorySignals]) {
        subString = IndiSetMainCategorySignals;
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
        subString = IndiSetMainCategoryPatterns;
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        subString = IndiSetMainCategoryRanges;
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryFill]) {
        subString = IndiSetMainCategoryFill;
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryFavorites]) {
        subString = IndiSetMainCategoryFavorites;
    } else {
        NSCAssert(FALSE, @"예상치 못한 값이 들어왔다. 수정하라");
    }
    NSString *title = [NSString stringWithFormat:@"지표설정/%@", subString];
    self.navigationController.topViewController.navigationItem.backButtonTitle = title;
    DTOIndicatorSetting *contentItem = [self dataForSender:sender];
    UIViewController *vc = [self settingViewControllerForIndicatorSetting:contentItem];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadData:(void(^)(void))completion {
    [self.dataSource applySnapshotUsingReloadData:self.viewModel.snapshotForCurrentState completion:completion];
}

- (void)scrollToRowAtItem:(MGROutlineItem <DTOIndicatorSetting *>*)item
         atScrollPosition:(UITableViewScrollPosition)scrollPosition
                 animated:(BOOL)animated {
    NSInteger index = [self.dataSource.snapshot indexOfItemIdentifier:item];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:scrollPosition
                                      animated:animated];
    }
}


- (UIViewController *)settingViewControllerForIndicatorSetting:(DTOIndicatorSetting *)indicatorSetting {
    IndicatorSettingDetailController *vc = [self.board instantiateViewControllerWithIdentifier:@"IndicatorSettingDetailController"];
    
    vc.viewModel = [self.viewModel detailViewModelForIndicatorSetting:indicatorSetting];
    return vc;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGROutlineItem <DTOIndicatorSetting *>*outlineItem = [self.dataSource itemIdentifierForIndexPath:indexPath];
    IndicatorSettingCell *cell = (IndicatorSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([outlineItem.contentItem.identifier isEqualToString:IndicatorSettingCellIDSection] == YES &&
        outlineItem.hasSubitem == YES) {
        outlineItem.expanded = !outlineItem.isExpanded;
        
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.3
                                                              delay:0.0
                                                            options:kNilOptions
                                                         animations:^{ cell.data = cell.data; }
                                                         completion:^(UIViewAnimatingPosition finalPosition) {}];
        [self.dataSource applySnapshot:self.viewModel.snapshotForCurrentState
                  animatingDifferences:YES
                            completion:^{}];
    }
}


#pragma mark - Helper
- (IndicatorSettingCell *)cellForSender:(__kindof UIView *)sender {
    NSIndexPath *indexPath = [self.tableView mgrIndexPathOfCellWhereViewExists:sender];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (DTOIndicatorSetting *)dataForSender:(__kindof UIView *)sender {
    return [self outlineDataForSender:sender].contentItem;
}

- (MGROutlineItem <DTOIndicatorSetting *>*)outlineDataForSender:(__kindof UIView *)sender {
    NSIndexPath *indexPath = [self.tableView mgrIndexPathOfCellWhereViewExists:sender];
    return [self.dataSource itemIdentifierForIndexPath:indexPath];
}

@end
