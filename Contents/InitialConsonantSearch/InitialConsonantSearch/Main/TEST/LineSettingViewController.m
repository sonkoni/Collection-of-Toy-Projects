//
//  ChartSettingViewController.m
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/09/01.
//

#import "LineSettingViewController.h"
#import "ConfigCommonHeaderCell.h"
#import "ToolSettingViewModel.h"
#import "LineSettingViewModel.h"
#import "LineSettingCell.h"
#import <IosKit/IosKit.h>

@interface LineSettingViewController () <UITableViewDataSource, UITableViewDelegate, UIColorPickerViewControllerDelegate>
@property (nonatomic, strong) UIColorPickerViewController *colorPickerViewController;
@property (nonatomic, copy, nullable) void (^colorPickerCompletion)(UIColor *);
@end

@implementation LineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *identifier = NSStringFromClass([ConfigCommonHeaderCell class]);
    UINib *tableHeaderNib = [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:tableHeaderNib forHeaderFooterViewReuseIdentifier:identifier];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.sectionHeaderTopPadding = 0.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 셀프 사이즈 셀
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.colorPickerViewController = [UIColorPickerViewController new];
    self.colorPickerViewController.supportsAlpha = NO;
    self.colorPickerViewController.delegate = self;
    self.colorPickerViewController.modalPresentationStyle = UIModalPresentationPopover;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setViewModel:(LineSettingViewModel *)viewModel {
    _viewModel = viewModel;
    self.navigationItem.title = viewModel.mainTitle;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTOLineSetting *setting = [self.viewModel cellModelForIndexPath:indexPath];
    LineSettingCell *cell =
        [tableView dequeueReusableCellWithIdentifier:setting.identifier forIndexPath:indexPath];
    cell.data = setting;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
    // 
    // return 27.0; // 27.204081632653061
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ConfigCommonHeaderCell *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ConfigCommonHeaderCell class])];
    UIBackgroundConfiguration *backgroundConfig = [UIBackgroundConfiguration listPlainHeaderFooterConfiguration];
    [backgroundConfig setBackgroundColor: [UIColor systemGray6Color]];
    [header setBackgroundConfiguration: backgroundConfig];
    header.titleLabel.text = self.viewModel.sectionTitles[section];
    return header;
    //
    // UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    // header.backgroundView.backgroundColor = [UIColor systemRedColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(LineSettingCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - <UIColorPickerViewControllerDelegate>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 150000 // Deployment Target 이 15.0이다. 기계가 15 이상부터 다 들어온다.

- (void)colorPickerViewController:(UIColorPickerViewController *)viewController
                   didSelectColor:(UIColor *)color
                     continuously:(BOOL)continuously API_AVAILABLE(ios(15.0)) {
    UIColor *chosenColor = viewController.selectedColor; // User has chosen a color.
    if (self.colorPickerCompletion != nil) {
        self.colorPickerCompletion(chosenColor);
    }
    
    if (continuously == NO) {
        if (self.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClassCompact) {
            [viewController dismissViewControllerAnimated:YES completion:^{
                NSLog(@"chosenColor %@", chosenColor);
            }];
        }
    }
    //
    // Dismiss the color picker if the conditions are right:
    // 1) User is not doing a continous pick (tap and drag across multiple colors).
    // 2) Picker is presented on a non-compact device.
    //
    // Use the following check to determine how the color picker was presented (modal or popover).
    // For popover, we want to dismiss it when a color is locked.
    // For modal, the picker has a close button.
    //
}

#else

// NS_DEPRECATED_IOS(14_0, 15_0) Color. returned from the color picker - iOS 14.x and earlier.
- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController  {
    UIColor *chosenColor = viewController.selectedColor;
    if (self.colorPickerCompletion != nil) {
        self.colorPickerCompletion(chosenColor);
    }
    if (self.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClassCompact) {
        [viewController dismissViewControllerAnimated:YES completion:^{
            NSLog(@"chosenColor %@", chosenColor);
        }];
    }
    //
    // Use the following check to determine how the color picker was presented (modal or popover).
    // For popover, we want to dismiss it when a color is locked.
    // For modal, the picker has a close button.
}

#endif

- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController {
    // 명시적으로 X 버튼을 눌렀을 때, 실행된다.
}

#pragma mark - Actions

- (IBAction)titleButtonClicked:(UIButton *)sender { // 체크버튼
    DTOLineSetting *data = [self dataForSender:sender];
    data.selected = !data.selected;
    LineSettingCell *cell = [self cellForSender:sender];
    cell.data = data;
    [self synchronize];
}

- (IBAction)colorButtonClicked:(UIButton *)sender { // 칼라버튼
    __weak __typeof(self) weakSelf = self;
    DTOLineSetting *data = [self dataForSender:sender];
    self.colorPickerCompletion = ^(UIColor *selectedColor) {
        sender.backgroundColor = selectedColor;
        data.color = selectedColor;
        [weakSelf synchronize];
    };
    self.colorPickerViewController.selectedColor = sender.backgroundColor;
    self.colorPickerViewController.title = data.title;
    UIPopoverPresentationController *popoverPresentationController = self.colorPickerViewController.popoverPresentationController;
    popoverPresentationController.sourceView = sender;
    [self presentViewController:self.colorPickerViewController animated:YES completion:^{}];
}

- (IBAction)toggleValueChanged:(UISwitch *)sender {
    DTOLineSetting *data = [self dataForSender:sender];
    data.toggleOn = sender.isOn;
}

- (IBAction)dropdownBtnValueChanged:(MGUDropdownButton *)sender {
    DTOLineSetting *data = [self dataForSender:sender];
    data.dropBtnSelectedIndex = sender.selectedIndex;
    [self synchronize];
}

- (IBAction)boldButtonClicked:(UIButton *)sender { // 체크버튼
    DTOLineSetting *data = [self dataForSender:sender];
    data.bold = !data.isBold;
    LineSettingCell *cell = [self cellForSender:sender];
    cell.data = data;
}

- (void)synchronize {
    ToolSettingLineType lineType = self.viewModel.lineType;
    if ([lineType isEqualToString:ToolSettingLineTypeShapeEllipse] ||
        [lineType isEqualToString:ToolSettingLineTypeShapeRectangle] ||
        [lineType isEqualToString:ToolSettingLineTypeShapeTriangle]) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        LineSettingCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (cell != nil) {
            __weak __typeof(self) weakSelf = self;
            [self.viewModel synchronize:^{
                DTOLineSetting *data = [weakSelf.viewModel cellModelForIndexPath:path];
                cell.data = data;
            }];
        }
    }
}

#pragma mark - Helper
- (LineSettingCell *)cellForSender:(__kindof UIView *)sender {
    NSIndexPath *indexPath = [self.tableView mgrIndexPathOfCellWhereViewExists:sender];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (DTOLineSetting *)dataForSender:(__kindof UIView *)sender {
    NSIndexPath *indexPath = [self.tableView mgrIndexPathOfCellWhereViewExists:sender];
    return [self.viewModel cellModelForIndexPath:indexPath];
}
@end
