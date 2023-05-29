//
//  ViewController1.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2023/05/26.
//

@import IosKit;
#import "ViewController1.h"

@interface ViewController1 () <MGUSwipeTableViewCellDelegate, UITableViewDelegate>
@property (nonatomic, strong, nullable) UITableViewDiffableDataSource <NSString *, NSString *>*dataSource;
@property (nonatomic, strong, nullable) NSDiffableDataSourceSnapshot <NSString *, NSString *>*currentSnapshot;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *>*items;
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    _items = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"].mutableCopy;
    [self configureTableView];
    [self configureDataSource];
    [self updateUIAnimated:NO];
}

- (void)configureTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    [self.tableView registerClass:[MGUSwipeTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([MGUSwipeTableViewCell class])];
}

- (void)configureDataSource {
    _dataSource =
    [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView
                                                cellProvider:^MGUSwipeTableViewCell *(UITableView *tableView, NSIndexPath *indexPath, NSString *item) {
        MGUSwipeTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MGUSwipeTableViewCell class])
                                        forIndexPath:indexPath];
        UIListContentConfiguration *content = [cell defaultContentConfiguration];
        content.text = item;
        cell.contentConfiguration = content;
        cell.delegate = self;
        return cell;
    }];

    self.dataSource.defaultRowAnimation = UITableViewRowAnimationFade;
}

- (void)updateUIAnimated:(BOOL)animated {
    _currentSnapshot = [NSDiffableDataSourceSnapshot new];
    [self.currentSnapshot appendSectionsWithIdentifiers:@[@"0"]];
    [self.currentSnapshot appendItemsWithIdentifiers:self.items
                           intoSectionWithIdentifier:@"0"];
    [self.dataSource applySnapshot:self.currentSnapshot animatingDifferences:animated];
}


#pragma mark - <MGUSwipeTableViewCellDelegate>
- (MGUSwipeActionsConfiguration *)tableView:(UITableView *)tableView
leading_SwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (MGUSwipeActionsConfiguration *)tableView:(UITableView *)tableView
trailing_SwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self) weakSelf = self;
    MGUSwipeAction *deleteAction =
    [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDestructive
                                title:nil
                              handler:^(MGUSwipeAction * _Nonnull action,
                                        __kindof UIView * _Nonnull sourceView,
                                        void (^ _Nonnull completionHandler)(BOOL)) {
        NSDiffableDataSourceSnapshot <NSString *, NSString *>*snapshot = self.dataSource.snapshot;
        [snapshot deleteItemsWithIdentifiers:@[weakSelf.items[indexPath.row]]];
        [weakSelf.items removeObjectAtIndex:indexPath.row];
        [weakSelf.dataSource mgrSwipeApplySnapshot:snapshot tableView:tableView completion:nil];
    }];
            
    UIImage *image = [UIImage systemImageNamed:@"trash"];
    deleteAction.image = [image mgrImageWithColor:[UIColor whiteColor]];
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    configuration.transitionStyle = MGUSwipeTransitionStyleReveal;
    configuration.backgroundColor = [UIColor systemRedColor];
    return configuration;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.maskView != nil) {
        cell.maskView.frame = cell.bounds;
    }
}
@end
