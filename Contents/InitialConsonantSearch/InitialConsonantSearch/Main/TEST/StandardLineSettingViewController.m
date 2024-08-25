//
//  StandardLineSettingViewController.m
//  ToolSettingTest
//
//  Created by Kwan Hyun Son on 2023/09/14.
//

#import <IosKit/IosKit.h>

#import "StandardLineSettingViewController.h"
#import "ConfigCommonHeaderCell.h"
#import "StandardLineSettingViewModel.h"
#import "StandardLineSettingCell.h"

@interface StandardLineSettingViewController () <UITableViewDelegate, UITableViewDataSource, UIColorPickerViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (weak, nonatomic) IBOutlet UITableView *bottomTableView;
@property (weak, nonatomic) IBOutlet UIView *segmentedControlContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dividerlayoutConstraint;

@property (nonatomic, strong) UIView *underLineView;
@property (nonatomic, strong) NSLayoutConstraint *underLineLeadingConstraint;

@property (nonatomic, strong) UIColorPickerViewController *colorPickerViewController;
@property (nonatomic, copy, nullable) void (^colorPickerCompletion)(UIColor *);

@property (nonatomic, assign) BOOL showKeyboard;
@property (nonatomic, strong) id <NSObject> showObserver;
@property (nonatomic, strong) id <NSObject> hideObserver;

@property (nonatomic, strong) UITextField *currentTextField;

@property (nonatomic, strong, nullable) NSNotificationName previousNotificationName;
@property (nonatomic, assign) CGFloat previousKeyboardHeight;

@end

@implementation StandardLineSettingViewController

#pragma mark - Override

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:_showObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_hideObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [StandardLineSettingViewModel new];
    [self setupKeyboardObserver];
    [self setupTableView];
    [self setupSegmentedControl];
    [self setupColorPickerViewController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateUnderLineLeadingConstraint];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
    if (self.showKeyboard == YES) {
        [self.view endEditing:YES];
    }
}

#pragma mark - 생성 & 소멸

- (void)setupKeyboardObserver {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; // search filterView의 frame을 이동시키기 위해 사용한다.
    __weak __typeof(self)weakSelf = self;
    self.showObserver = [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.showKeyboard = YES;
        [weakSelf handleKeyboardNotification:note];
    }];
    self.hideObserver = [nc addObserverForName:UIKeyboardWillHideNotification // 키보드가 내려갈 때
                                        object:nil
                                         queue:[NSOperationQueue mainQueue]
                                    usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.showKeyboard = NO;
        [weakSelf handleKeyboardNotification:note];
    }];
}

- (void)setupTableView {
    NSString *identifier = NSStringFromClass([ConfigCommonHeaderCell class]);
    UINib *tableHeaderNib = [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]];
    [self.bottomTableView registerNib:tableHeaderNib forHeaderFooterViewReuseIdentifier:identifier];
    for (UITableView *tableView in @[self.topTableView, self.bottomTableView]) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.contentInset = UIEdgeInsetsZero;
        tableView.sectionHeaderTopPadding = 0.0;
        tableView.rowHeight = UITableViewAutomaticDimension; // 셀프 사이즈 셀
        tableView.estimatedRowHeight = 100.0;
        tableView.dataSource = self;
        tableView.delegate = self;
    }
}

- (void)setupSegmentedControl {
    self.segmentedControlContainer.backgroundColor = [UIColor whiteColor];
    self.dividerlayoutConstraint.constant = 1.0 / [UIScreen mainScreen].scale;
    
    // SegmentedControl 배경 색, 디바이더 색 제거
    [self.segmentedControl setBackgroundImage:[UIImage new]
                                     forState:UIControlStateNormal
                                   barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setDividerImage:[UIImage new]
                       forLeftSegmentState:UIControlStateNormal
                         rightSegmentState:UIControlStateNormal
                                barMetrics:UIBarMetricsDefault];
    NSDictionary <NSAttributedStringKey, id>*normalAttributes =
    @{ NSFontAttributeName            : [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold],
       NSForegroundColorAttributeName : [UIColor systemGrayColor]};
    
    NSDictionary <NSAttributedStringKey, id>*selectedAttributes =
    @{ NSFontAttributeName            : [UIFont systemFontOfSize:16.0 weight:UIFontWeightHeavy],
       NSForegroundColorAttributeName : [UIColor blackColor]};
    
    [self.segmentedControl setTitleTextAttributes:normalAttributes
                                         forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:selectedAttributes
                                         forState:UIControlStateSelected];
    
    _underLineView = [UIView new];
    self.underLineView.backgroundColor = [UIColor blackColor];
    self.underLineView.translatesAutoresizingMaskIntoConstraints = NO;
    self.underLineLeadingConstraint = [self.underLineView.leadingAnchor constraintEqualToAnchor:self.segmentedControl.leadingAnchor];
    
    [self.segmentedControlContainer addSubview:self.underLineView];
    [self.underLineView.heightAnchor constraintEqualToConstant:1.0].active = YES;
    [self.underLineView.bottomAnchor constraintEqualToAnchor:self.segmentedControl.bottomAnchor].active = YES;
    [self.underLineView.widthAnchor constraintEqualToAnchor:self.segmentedControl.widthAnchor multiplier:1.0/3.0].active = YES;
    self.underLineLeadingConstraint.active = YES;
}

- (void)setupColorPickerViewController {
    self.colorPickerViewController = [UIColorPickerViewController new];
    self.colorPickerViewController.supportsAlpha = NO;
    self.colorPickerViewController.delegate = self;
    self.colorPickerViewController.modalPresentationStyle = UIModalPresentationPopover;
}

#pragma mark - 세터 & 게터

#pragma mark - Actions

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self updateUnderLineLeadingConstraint];
    if (sender.selectedSegmentIndex == 0) {
        self.viewModel.optionalTableType = StandardLineSettingTableIDYesterdayToday;
    } else if (sender.selectedSegmentIndex == 1) {
        self.viewModel.optionalTableType = StandardLineSettingTableIDPivotDemark;
    } else if (sender.selectedSegmentIndex == 2) {
        self.viewModel.optionalTableType = StandardLineSettingTableIDCustom;
    } else {
        NSCAssert(FALSE, @"예상치 못한 인덱스가 들어옴.");
    }
    [self.bottomTableView setContentOffset:CGPointZero animated:NO];
    [self.view endEditing:YES];
    [self.bottomTableView reloadData];
    
    
    // bottomTableView.setContentOffset(.zero, animated: false)
    // view.endEditing(true)
    // bottomTableView.reloadData()
}

- (IBAction)titleButtonClicked:(UIButton *)sender { // 체크버튼
    DTOStandardLineSetting *data = [self dataForSender:sender];
    data.selected = !data.selected;
    StandardLineSettingCell *cell = [self cellForSender:sender];
    cell.data = data;
}

- (IBAction)dropdownBtnValueChanged:(MGUDropdownButton *)sender {
    DTOStandardLineSetting *data = [self dataForSender:sender];
    data.dropBtnSelectedIndex = sender.selectedIndex;
}

- (IBAction)colorButtonClicked:(UIButton *)sender { // 칼라버튼
    DTOStandardLineSetting *data = [self dataForSender:sender];
    self.colorPickerCompletion = ^(UIColor *selectedColor) {
        sender.backgroundColor = selectedColor;
        data.color = selectedColor;
    };
    self.colorPickerViewController.selectedColor = sender.backgroundColor;
    if (self.viewModel.optionalTableType != StandardLineSettingTableIDCustom) {
        self.colorPickerViewController.title = data.title;
    } else {
        if (data.textFieldTitle == nil || [data.textFieldTitle isEqualToString:@""]) {
            self.colorPickerViewController.title = data.textFieldPlaceHolderTitle;
        } else {
            self.colorPickerViewController.title = data.textFieldTitle;
        }
    }
    UIPopoverPresentationController *popoverPresentationController = self.colorPickerViewController.popoverPresentationController;
    popoverPresentationController.sourceView = sender;
    [self presentViewController:self.colorPickerViewController animated:YES completion:^{}];
}

- (IBAction)ratioButtonClicked:(UIButton *)sender { // 체크버튼
    DTOStandardLineSetting *data = [self dataForSender:sender];
    data.ratio = !data.isRatio;
    StandardLineSettingCell *cell = [self cellForSender:sender];
    cell.data = data;
}

- (IBAction)endEditClicked:(id)sender {
    if (self.showKeyboard == YES) {
        [self.view endEditing:YES];
    }
}

- (void)handleKeyboardNotification:(nullable NSNotification *)notification {
    NSNotificationName previousNotificationName = self.previousNotificationName;
    CGFloat previousKeyboardHeight = self.previousKeyboardHeight;
    NSNotificationName name = notification.name; // UIKeyboardWillShowNotification OR UIKeyboardWillHideNotification
    self.previousNotificationName = name;
    
    NSValue *keyboardFrame = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (notification.userInfo == nil || keyboardFrame == nil) {
        return;
    }
    CGFloat keyboardHeight = keyboardFrame.CGRectValue.size.height;
    self.previousKeyboardHeight = keyboardHeight;
    if ([previousNotificationName isEqualToString:name] && previousKeyboardHeight == keyboardHeight) {
        return;
    }
    
    NSNumber *durationNumber = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *animationCurveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]; // 설명은 아래
    // NSNumber *isLocalUserNumber = notification.userInfo[UIKeyboardIsLocalUserInfoKey]; // NSNumber of BOOL
    
    
    NSTimeInterval duration = durationNumber.doubleValue;
    UIViewAnimationOptions animationCurve = [animationCurveNumber unsignedIntegerValue];
    // BOOL isLocalUser = [isLocalUserNumber boolValue];
    
    /// Hide
    if ([name isEqualToString:UIKeyboardWillHideNotification]) {
        CGFloat originalMaxOffsetY = self.bottomTableView.mgrMaxOffset.y - self.bottomTableView.contentInset.bottom;
        if (originalMaxOffsetY < self.bottomTableView.contentOffset.y) {
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration delay:0.0 options:animationCurve animations:^{
                [self.bottomTableView setContentOffset:CGPointMake(0.0, originalMaxOffsetY)];
                [self.view layoutIfNeeded];
            } completion:^(UIViewAnimatingPosition finalPosition) {
                self.bottomTableView.contentInset = UIEdgeInsetsZero;
                self.bottomTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
            }];
        } else {
            self.bottomTableView.contentInset = UIEdgeInsetsZero;
            self.bottomTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        }
        return; //! return 해야한다.
    }
    
    /// Show
    if ([name isEqualToString:UIKeyboardWillShowNotification]) {
        CGFloat bottomIset = keyboardHeight - self.view.safeAreaInsets.bottom;
        self.bottomTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, bottomIset, 0.0);
        self.bottomTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, bottomIset, 0.0);
    }

    UITextField *textField = self.currentTextField;
    UIWindow *window = self.currentTextField.window;
    CGRect rect = [textField convertRect:textField.bounds toView:window];
    CGFloat upLength = rect.origin.y + rect.size.height + 4.0; // 4.0은 마진..
    CGFloat total = upLength + keyboardHeight;
    CGPoint movingOffset = self.bottomTableView.contentOffset;
    if (total > window.bounds.size.height) {
        CGFloat move = ABS(window.bounds.size.height - total);
        movingOffset = CGPointMake(movingOffset.x, movingOffset.y + move);
    }
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration delay:0.0 options:animationCurve animations:^{
        [self.bottomTableView setContentOffset:movingOffset];
        [self.view layoutIfNeeded];
    } completion:^(UIViewAnimatingPosition finalPosition) {
    }];
    //
    // NSNumber *animationCurveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    // NSNumber of UIViewAnimationOptions // 문서에는 UIViewAnimationCurve (int)로 나와있는데, 실제로는 UIViewAnimationOptions 이다. uint
    // 7이 들어온다. 아래에 해당한다.
    // UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
    // UIViewAnimationOptionAllowUserInteraction      = 1 <<  1,
    // UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2,
    // UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
    // UIViewAnimationOptionTransitionNone            = 0 << 20, // default
    // UIViewAnimationOptionPreferredFramesPerSecondDefault     = 0 << 24,
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.topTableView) {
        return [self.viewModel numberOfTopSections];
    } else {
        return [self.viewModel numberOfBottomSections];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.topTableView) {
        return [self.viewModel numberOfRowsInTopSection:section];
    } else {
        return [self.viewModel numberOfRowsInBottomSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        DTOStandardLineSetting *setting = [self.viewModel topCellModelForIndexPath:indexPath];
        StandardLineSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:setting.identifier forIndexPath:indexPath];
        cell.data = setting;
        return cell;
    }
    
    DTOStandardLineSetting *setting = [self.viewModel bottomcellModelForIndexPath:indexPath];
    StandardLineSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:setting.identifier forIndexPath:indexPath];
    cell.data = setting;
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showKeyboard == YES) {
        [self.view endEditing:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.topTableView) {
        return 0.0;
    }
    /// return 27.0; // 27.204081632653061
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.topTableView) {
        return nil;
    }
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    //
    // <UITextFieldDelegate> 메서드에 해당하는 것으로 delegate 설정을 반드시 해야한다!! 자꾸 까먹는듯.
    // keyboard에서 retrun을 했을 때, 일어나는 반응을 컨트롤한다!!!
}

//! 처음 커서 1
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
    NSLog(@"textFieldShouldBeginEditing:");
    return YES;
}

//! 처음 커서 2
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing:");
}

//!- 글자를 칠때 1
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:  -- %@", textField.text);
    return YES;
}

//!- 글자를 칠때 2
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    NSLog(@"textFieldDidChangeSelection: -- %@", textField.text);
    DTOStandardLineSetting *model = [self dataForSender:textField];
    model.textFieldTitle = textField.text;
}

//! - 종료
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    NSLog(@"textFieldDidEndEditing:reason:");
}

#pragma mark - Private Helper

- (StandardLineSettingCell *)cellForSender:(__kindof UIView *)sender {
    if ([sender isDescendantOfView:self.topTableView]) {
        NSIndexPath *indexPath = [self.topTableView mgrIndexPathOfCellWhereViewExists:sender];
        return [self.topTableView cellForRowAtIndexPath:indexPath];
    } else if ([sender isDescendantOfView:self.bottomTableView]) {
        NSIndexPath *indexPath = [self.bottomTableView mgrIndexPathOfCellWhereViewExists:sender];
        return [self.bottomTableView cellForRowAtIndexPath:indexPath];
    } else {
        NSCAssert(FALSE, @"잘못된 아이템이 들어왔다");
        return nil;
    }
}

- (DTOStandardLineSetting *)dataForSender:(__kindof UIView *)sender {
    if ([sender isDescendantOfView:self.topTableView]) {
        NSIndexPath *indexPath = [self.topTableView mgrIndexPathOfCellWhereViewExists:sender];
        return [self.viewModel topCellModelForIndexPath:indexPath];
    } else if ([sender isDescendantOfView:self.bottomTableView]) {
        NSIndexPath *indexPath = [self.bottomTableView mgrIndexPathOfCellWhereViewExists:sender];
        return [self.viewModel bottomcellModelForIndexPath:indexPath];
    } else {
        NSCAssert(FALSE, @"잘못된 아이템이 들어왔다");
        return nil;
    }
}

- (void)updateUnderLineLeadingConstraint {
    NSInteger selectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
    CGFloat segmentWidth = self.segmentedControl.frame.size.width / (self.segmentedControl.numberOfSegments);
    self.underLineLeadingConstraint.constant = segmentWidth * selectedSegmentIndex;
}

@end
