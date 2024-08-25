//
//  ViewController.m
//  AAAAA
//
//  Created by Kwan Hyun Son on 2023/08/17.
//

#import <IosKit/IosKit.h>
#import "ToolSettingViewController.h"
#import "ConfigCommonHeaderCell.h"
#import "ToolSettingCell.h"
#import "ToolSettingViewModel.h"
#import "LineSettingViewModel.h"
#import "LineSettingViewController.h"
#import "StandardLineSettingViewController.h"


@interface AccessoryView : UIImageView
@end
@implementation AccessoryView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *settingButtonImage = [UIImage imageNamed:@"settingGo"];
        settingButtonImage = [settingButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image = settingButtonImage;
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = NO;
        self.tintColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:199.0/255.0 alpha:1.0];
        // self.tintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    return self;
    //
    // self.layer.cornerRadius = 4.0;
    // self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(56.0, 28.0);
}

@end

@interface ToolSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ToolSettingViewModel *viewModel;
@property (nonatomic, strong) UIStoryboard *board;
@end

@implementation ToolSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonInit(self);
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupToolbar];
    //
    // self.navigationController.navigationBar.prefersLargeTitles = YES;
    // self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
}

/*
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.navigationController.navigationBar sizeToFit];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}
*/

#pragma mark - 생성 & 소멸
static void CommonInit(ToolSettingViewController *self) {
    self->_board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self->_viewModel = [ToolSettingViewModel new];
    
    NSString *identifier = NSStringFromClass([ConfigCommonHeaderCell class]);
    UINib *tableHeaderNib = [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:tableHeaderNib forHeaderFooterViewReuseIdentifier:identifier];
    
    self.navigationItem.title = @"Tool Setting 목업 테스트";
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.sectionHeaderTopPadding = 0.0;
    self.tableView.rowHeight = 44.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.rowHeight = UITableViewAutomaticDimension; // 셀프 사이즈 셀
    //self.tableView.estimatedRowHeight = 100.0;
}

- (void)setupToolbar {
    self.navigationController.toolbarHidden = NO;
    UIToolbarAppearance *appearance = [UIToolbarAppearance new];
    UIBarButtonItemAppearance *plainBarButtonItemAppearance =
    [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStylePlain];
    plainBarButtonItemAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    appearance.buttonAppearance = plainBarButtonItemAppearance;
    UIBarButtonItemAppearance *doneBarButtonItemAppearance =
    [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStyleDone];
    doneBarButtonItemAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    appearance.doneButtonAppearance = doneBarButtonItemAppearance;
    
    self.navigationController.toolbar.standardAppearance = appearance;
    self.navigationController.toolbar.compactAppearance = appearance;
    if (@available(iOS 15, *)) {
        self.navigationController.toolbar.scrollEdgeAppearance = appearance;
        self.navigationController.toolbar.compactScrollEdgeAppearance = appearance;
    }
        
    UIView *seperator = [UIView new];
    seperator.backgroundColor = [UIColor separatorColor];
    [self.navigationController.toolbar addSubview:seperator];
    seperator.translatesAutoresizingMaskIntoConstraints = NO;
    [seperator.widthAnchor constraintEqualToConstant:1.0/[UIScreen mainScreen].scale].active = YES;
    [seperator.centerXAnchor constraintEqualToAnchor:seperator.superview.centerXAnchor].active = YES;
    [seperator.topAnchor constraintEqualToAnchor:seperator.superview.topAnchor].active = YES;
    [seperator.bottomAnchor constraintEqualToAnchor:seperator.superview.bottomAnchor constant:50.0].active = YES;
}

- (__kindof UIViewController *)settingViewControllerForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        StandardLineSettingViewController *standardLineSettingViewController = [self.board instantiateViewControllerWithIdentifier:@"StandardLineSettingViewController"];
        NSString *title = [self.viewModel chartLineTypeForIndexPath:indexPath];
        standardLineSettingViewController.title = title;
        ////standardLineSettingViewController.viewModel = settingViewModel;
        return standardLineSettingViewController;
    }
    LineSettingViewController *settingViewController = [self.board instantiateViewControllerWithIdentifier:@"LineSettingViewController"];
    LineSettingViewModel *settingViewModel = [self.viewModel lineSettingViewModelForIndexPath:indexPath];
    NSString *title = [self.viewModel chartLineTypeForIndexPath:indexPath];
    settingViewController.title = title;
    settingViewController.viewModel = settingViewModel;
    return settingViewController;
}

#pragma mark - Actions

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToolSettingCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"ToolSettingCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.title = [self.viewModel chartLineTypeForIndexPath:indexPath];
    if (indexPath.row == 1 || indexPath.row == 2) {
        cell.accessoryView = nil;
        cell.editingAccessoryView = nil;
    } else {
        cell.accessoryView = [AccessoryView new];
        cell.accessoryView.frame = CGRectMake(0.0, 0.0, 43.0, 28.0);
        cell.editingAccessoryView = [AccessoryView new];
        cell.editingAccessoryView.frame = CGRectMake(0.0, 0.0, 43.0, 28.0); // 56, 45
    }
        
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)) {
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    if ([sourceIndexPath isEqual:destinationIndexPath] == NO &&
        destinationIndexPath.row > 2 ) {
        NSInteger index = sourceIndexPath.row;
        ToolSettingLineType object = [self.viewModel.lineTypes objectAtIndex:index];
        [self.viewModel.lineTypes removeObjectAtIndex:index];
        [self.viewModel.lineTypes insertObject:object atIndex:destinationIndexPath.row];
    }
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // FIXME: - 테스트 코드 : 나중에 지워라.
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        StandardLineSettingViewController *viewController = [StandardLineSettingViewController new];
//        viewController.view.backgroundColor = [UIColor whiteColor];
//        [self.navigationController pushViewController:viewController animated:YES];
//        return;
//    }
    
    ToolSettingLineType lineType = [self.viewModel chartLineTypeForIndexPath:indexPath];
    if ([lineType isEqualToString:ToolSettingLineTypeDeleteAllTrendlines] ||
        [lineType isEqualToString:ToolSettingLineTypeDeleteTrendline]) {
        return;
    }
    UIViewController *vc = [self settingViewControllerForIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.section == 0 &&
        (proposedDestinationIndexPath.row == 0 ||
         proposedDestinationIndexPath.row == 1 ||
         proposedDestinationIndexPath.row == 2)
        ) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}


#pragma mark - Helper

@end


//! Stroyboard 설정
// Bounce Vertically 꺼라.
// 단순히 선택만하는 셀(ScreenSettingSelectionCell)은 버튼의 userInteractionEnabled을 NO로 했다.
// TableView의 셀렉션은 Single, TableViewCell의 셀렉션 스타일은 NO로


