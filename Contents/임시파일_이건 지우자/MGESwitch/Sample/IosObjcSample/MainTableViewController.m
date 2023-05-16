//
//  MainTableViewController.m
//  MGRLatex
//
//  Created by Kwan Hyun Son on 2021/07/20.
//

#import "MainTableViewController.h"
#import "ItemsForTableView.h"
#import "Item.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "MaterialTableViewController.h"
#import "ViewController5.h"
#import "ViewController6.h"
#import "ViewControllerF.h"
#import "ViewController8.h"


/** 이렇게 섹션을 잡을 수도 있다.
typedef NSString * MGRMainSection NS_STRING_ENUM;
static MGRMainSection const config  = @"config";
static MGRMainSection const networks  = @"networks";
*/

@interface TableViewDiffableDataSource : UITableViewDiffableDataSource<NSString *, Item *>
@end
@implementation TableViewDiffableDataSource
#pragma mark - header/footer titles support
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableArray <NSMutableDictionary <NSString *, NSArray <Item *>*>*>*allItems = ItemsForTableView.sharedItems.allItems;
    NSMutableDictionary <NSString *, NSArray <Item *>*>*sectionDic = allItems[section];
    return sectionDic.allKeys.firstObject; // 어차피 하나밖에 없다.
}
@end

@interface MainTableViewController () <UITableViewDelegate>
@property (nonatomic, strong, nullable) TableViewDiffableDataSource *dataSource;
@property (nonatomic, strong, nullable) NSDiffableDataSourceSnapshot <NSString *, Item *>*currentSnapshot;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGUSwitch Project";
    [self configureTableView];
    [self configureDataSource];
    [self updateUIAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //! 현재 컨트롤러가 UITableViewController 가 아니므로, clearsSelectionOnViewWillAppear가 없다.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath != nil) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; // 원래 뷰로 돌아 올때, 셀렉션을 해제시킨다. 이게 더 멋지다.
    }
}

- (void)configureTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.delegate = self;
}

- (void)configureDataSource {
    _dataSource =
    [[TableViewDiffableDataSource alloc] initWithTableView:self.tableView
                                                cellProvider:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, Item *item) {
        UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                        forIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; /// 오른쪽에 > 표시를 만든다.
        if (@available(iOS 14, *)) {
            UIListContentConfiguration *content = [cell defaultContentConfiguration];
            content.text = item.textLabelText;
            content.secondaryText = item.detailTextLabelText;
            content.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
            content.textToSecondaryTextVerticalPadding = 5.0;
            cell.contentConfiguration = content;
        } else {
            cell.textLabel.text = item.textLabelText;
            cell.detailTextLabel.text = item.detailTextLabelText;
        }
        return cell;
    }];

    self.dataSource.defaultRowAnimation = UITableViewRowAnimationFade;
}

- (void)updateUIAnimated:(BOOL)animated {
    _currentSnapshot = [NSDiffableDataSourceSnapshot new];
    
    NSMutableArray <NSMutableDictionary <NSString *, NSArray <Item *>*>*>*allItems = ItemsForTableView.sharedItems.allItems;
    
    for (NSInteger i = 0; i < allItems.count; i++) {
        NSMutableDictionary <NSString *, NSArray <Item *>*>*section = allItems[i];
        NSString *sectionTitle = section.allKeys.firstObject; // 어차피 하나밖에 없다.
        NSArray <Item *>*items = section.allValues.firstObject; // 어차피 하나밖에 없다.
        [self.currentSnapshot appendSectionsWithIdentifiers:@[sectionTitle]];
        [self.currentSnapshot appendItemsWithIdentifiers:items
                               intoSectionWithIdentifier:sectionTitle];
    }
    [self.dataSource applySnapshot:self.currentSnapshot animatingDifferences:animated];
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController;
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            viewController = [ViewController1 new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        }
    }
    
    if (indexPath.section == 1) {
        if(indexPath.row == 0){
            viewController = [ViewController2 new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        }
    }
    
    if (indexPath.section == 2) {
        if(indexPath.row == 0){
            viewController = [ViewController3 new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        } else if(indexPath.row == 1){
            viewController = [MaterialTableViewController new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        }
    }
    
    if (indexPath.section == 3) {
        if(indexPath.row == 0){
            viewController = [ViewController5 new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        } else if(indexPath.row == 1){
            viewController = [ViewController6 new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        }
    }
    
    if (indexPath.section == 4) {
        if(indexPath.row == 0){
            viewController = [ViewControllerF new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        }
    }
    if (indexPath.section == 5) {
        if(indexPath.row == 0){
            viewController = [ViewController8 new];
            viewController.navigationItem.title = [self.dataSource tableView:self.tableView titleForHeaderInSection:indexPath.section];
        }
    }
    
    if (viewController != nil) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
