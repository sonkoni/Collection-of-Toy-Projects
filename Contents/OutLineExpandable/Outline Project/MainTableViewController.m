//
//  MainTableViewController.m
//  MGRLatex
//
//  Created by Kwan Hyun Son on 2021/07/20.
//

#import "MainTableViewController.h"
#import "ItemsForTableView.h"
#import "Item.h"
#import "ViewController.h"
#import "ViewControllerX1.h"
#import "ViewControllerX2.h"
#import "ViewControllerY1.h"
#import "ViewControllerY2.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (@available(iOS 13, *)) {
        self = [super initWithStyle:UITableViewStyleInsetGrouped];
    } else {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    
    if(self) {
        self.navigationItem.title = @"Outline Project";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class]
//           forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ItemsForTableView.sharedItems.allItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ItemsForTableView.sharedItems.allItems[section].allValues.firstObject.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableDictionary <NSString *, NSArray <Item *>*>*itemsDic =
    ItemsForTableView.sharedItems.allItems[section];
    if (section == 0) {
        return itemsDic.allKeys.firstObject;
    } else if (section == 1) {
        return itemsDic.allKeys.firstObject;
    } else {
        return itemsDic.allKeys.firstObject;
    }

    return @"뉘미럴";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jotto"];
    if (cell == nil) {
//        NSLog(@"처음만들어");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jotto"];
    } else {
//        NSLog(@"재사용이야");
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; /// 오른쪽에 > 표시를 만든다.
    
    NSMutableDictionary <NSString *, NSArray <Item *>*>*itemsDic =
    ItemsForTableView.sharedItems.allItems[indexPath.section];
    Item *item = itemsDic.allValues.firstObject[indexPath.row];
    
    if (@available(iOS 14, *)) {
        UIListContentConfiguration *content = [cell defaultContentConfiguration];
        content.text = item.textLabelText;
        content.secondaryText = item.detailTextLabelText;

// 이거 쓰면 방향 Portrait <=> Landscape 일때, 이상 발생한다.
//        NSDirectionalEdgeInsets directionalEdgeInsets = cell.directionalLayoutMargins;
//        directionalEdgeInsets.top = directionalEdgeInsets.top + 1.0;
//        directionalEdgeInsets.bottom = directionalEdgeInsets.bottom + 1.0;
        content.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
        content.textToSecondaryTextVerticalPadding = 5.0;
        cell.contentConfiguration = content;
    } else {
        cell.textLabel.text = item.textLabelText;
        cell.detailTextLabel.text = item.detailTextLabelText;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIListContentConfiguration *listContentConfiguration = (UIListContentConfiguration *)cell.contentConfiguration;
    UIViewController *viewController;
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            viewController = [ViewController new];
        } 
        if (@available(iOS 14, *)) {
            viewController.navigationItem.title = listContentConfiguration.text;
        } else {
            viewController.navigationItem.title = cell.detailTextLabel.text;
        }
    }
    
    if (indexPath.section == 1) {
        if(indexPath.row == 0){
            viewController = [ViewControllerX1 new];
        } else if (indexPath.row == 1) {
            viewController = [ViewControllerX2 new];
        }
        if (@available(iOS 14, *)) {
            viewController.navigationItem.title = [NSString stringWithFormat:@"%@ %@", listContentConfiguration.text, listContentConfiguration.secondaryText];
        } else {
            viewController.navigationItem.title = [NSString stringWithFormat:@"%@ %@", cell.textLabel.text, cell.detailTextLabel.text];
        }
    }
    
    if (indexPath.section == 2) {
        if(indexPath.row == 0){
            viewController = [ViewControllerY1 new];
        } else if(indexPath.row == 1){
            viewController = [ViewControllerY2 new];
        }
        
        if (@available(iOS 14, *)) {
            viewController.navigationItem.title = [NSString stringWithFormat:@"%@ %@", listContentConfiguration.text, listContentConfiguration.secondaryText];
        } else {
            viewController.navigationItem.title = [NSString stringWithFormat:@"%@ %@", cell.textLabel.text, cell.detailTextLabel.text];
        }
    }
    
    if (viewController != nil) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
