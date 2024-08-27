//
//  ViewController.m
//  IosObjcFinancialKeyboard
//
//  Created by Kwan Hyun Son on 1/10/24.
//

#import <IosKit/IosKit.h>
#import "ViewControllerB.h"
#import "ViewControllerC.h"

@interface ViewControllerC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) NSArray <DTOMinTick *>*minDataArr;
@property (nonatomic, strong) NSArray <DTOMinTick *>*tickDataArr;

@property (nonatomic, assign) BOOL showKeyboard;
@property (nonatomic, strong) id <NSObject> showObserver;
@property (nonatomic, strong) id <NSObject> hideObserver;

@property (nonatomic, strong) MGUFinancialTextField *currentTextField;

@property (nonatomic, strong, nullable) NSNotificationName previousNotificationName;
@property (nonatomic, assign) CGFloat previousKeyboardHeight;
@end

@implementation ViewControllerC

#pragma mark - Override

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:_showObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_hideObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"분/틱 목업 테스트";
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.sectionHeaderTopPadding = 0.0;
    
    self.minDataArr = @[[DTOMinTick dtoWithCyle:1 selected:YES],
                        [DTOMinTick dtoWithCyle:3 selected:YES],
                        [DTOMinTick dtoWithCyle:5 selected:YES],
                        [DTOMinTick dtoWithCyle:10 selected:YES],
                        [DTOMinTick dtoWithCyle:15 selected:YES],
                        [DTOMinTick dtoWithCyle:30 selected:YES],
                        [DTOMinTick dtoWithCyle:45 selected:YES],
                        [DTOMinTick dtoWithCyle:60 selected:YES],
                        [DTOMinTick dtoWithCyle:90 selected:YES],
                        [DTOMinTick dtoWithCyle:120 selected:YES]];
    
    self.tickDataArr = @[[DTOMinTick dtoWithCyle:1 selected:YES],
                         [DTOMinTick dtoWithCyle:3 selected:YES],
                         [DTOMinTick dtoWithCyle:5 selected:YES],
                         [DTOMinTick dtoWithCyle:10 selected:YES],
                         [DTOMinTick dtoWithCyle:15 selected:YES],
                         [DTOMinTick dtoWithCyle:20 selected:YES],
                         [DTOMinTick dtoWithCyle:30 selected:YES],
                         [DTOMinTick dtoWithCyle:45 selected:YES],
                         [DTOMinTick dtoWithCyle:60 selected:YES],
                         [DTOMinTick dtoWithCyle:80 selected:YES]];
    
    [self setupKeyboardObserver];
    
//    self.minData = @[@(1), @(3), @(5), @(10), @(15), @(30), @(45), @(60), @(90), @(120)];
//    self.tickData = @[@(1), @(3), @(5), @(10), @(15), @(20), @(30), @(45), @(60), @(80)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"?? %@", self.testView);
//    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // self.navigationController.navigationBar.prefersLargeTitles = YES;
    // self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    [self setupToolbar];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.navigationController.navigationBar sizeToFit];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}


#pragma mark - 생성 & 소멸
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

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    DTOMinTick *minData = self.minDataArr[index];
    DTOMinTick *tickData = self.tickDataArr[index];
    
    cell.minField.buttonOptions = MGUFinancialKeyboardBtnOptionsNone;
//    cell.minField.allowsPMButton = NO; // 부호 사용 안함
//    cell.minField.allowsDotButton = NO; // 정수만 사용
    cell.minField.alertMessage = @"1 이상 200 이하의 숫자만 유효합니다."; // @"1 이상 3,000 이하의 숫자만 유효합니다.";
    cell.minField.maxDataValue = 200.0; // 3000.0;
    __weak __typeof(cell.minField) weakTextField = cell.minField;
    cell.minField.completionBlock = ^(CGFloat dataValue) {
        CGFloat result = MIN(MAX(1.0, dataValue), 200.0); // 3000.0
        NSInteger finalResult = lround(result);
        weakTextField.dataValue = result; // 실제 사용되는 숫자로 바꿔줘야할 필요가 있을 수 있다
        NSLog(@"finalResult ==> %ld", finalResult);
    };
    cell.minField.dataValue = (CGFloat)(minData.cycle);
    //cell.minTextField.text = [@(minData.cycle) stringValue];
    [cell.tickModifyBtn setTitle:[@(tickData.cycle) stringValue] forState:UIControlStateNormal];
    cell.minCheckBtn.selected = minData.selected;
    cell.tickCheckBtn.selected = tickData.selected;
    for (UIView *button in @[cell.minField, cell.tickModifyBtn, cell.minCheckBtn, cell.tickCheckBtn]) {
        button.tag = index;
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 31; // 31.382352941176471
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableViewHeaderFooterView *header = self.testView;
    UIBackgroundConfiguration *backgroundConfig = [UIBackgroundConfiguration listPlainHeaderFooterConfiguration];
    [backgroundConfig setBackgroundColor: [UIColor systemGray6Color]];
    [header setBackgroundConfiguration: backgroundConfig];
    return header;
    //
    // UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    // header.backgroundView.backgroundColor = [UIColor systemRedColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(TableViewHeaderFooterView *)view forSection:(NSInteger)section {
    //
    // view.backgroundConfiguration.backgroundColor = [UIColor systemRedColor];
    // view.backgroundConfiguration.visualEffect = nil;
    // view.backgroundColor = [UIColor systemRedColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(TableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.minCheckBtn.hidden = YES;
        cell.tickCheckBtn.hidden = YES;
    } else {
        cell.minCheckBtn.hidden = NO;
        cell.tickCheckBtn.hidden = NO;
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//! 처음 커서 1
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    /////////self.currentTextField = textField;
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
    // DTOStandardLineSetting *model = [self dataForSender:textField];
    // model.textFieldTitle = textField.text;
}

//! - 종료
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    NSLog(@"textFieldDidEndEditing:reason:");
}

#pragma mark - Actions

/// TEST
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollView.contentOffset.y %f", scrollView.contentOffset.y);
}

- (void)handleKeyboardNotification:(nullable NSNotification *)notification {
    NSLog(@"알려줄래????? %@", notification.object);
    
    NSArray <TableViewCell *>*visibleCells = self.tableView.visibleCells;
    __block MGUFinancialTextField *minField = nil;
    [visibleCells enumerateObjectsUsingBlock:^(TableViewCell *cell, NSUInteger idx, BOOL *stop) {
        if (cell.minField.isFocusState) {
            minField = cell.minField;
            *stop = YES;
        }
    }];
    
    
    self.currentTextField = minField;
    
    NSDictionary *userInfo = notification.userInfo;
    NSNotificationName previousNotificationName = self.previousNotificationName;
    CGFloat previousKeyboardHeight = self.previousKeyboardHeight;
    NSNotificationName name = notification.name; // UIKeyboardWillShowNotification OR UIKeyboardWillHideNotification
    self.previousNotificationName = name;
    
    NSValue *keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey];
    if (userInfo == nil || keyboardFrame == nil) {
        return;
    }
    CGFloat keyboardHeight = keyboardFrame.CGRectValue.size.height;
    self.previousKeyboardHeight = keyboardHeight;
    if ([previousNotificationName isEqualToString:name] && previousKeyboardHeight == keyboardHeight) {
        return;
    }
    
    NSNumber *durationNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = durationNumber.doubleValue;
    UIViewAnimationOptions options = (UIViewAnimationOptions)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    // NSNumber *isLocalUserNumber = userInfo[UIKeyboardIsLocalUserInfoKey]; // NSNumber of BOOL
    // BOOL isLocalUser = [isLocalUserNumber boolValue];
    
    /// Hide
    if ([name isEqualToString:UIKeyboardWillHideNotification]) {
        CGFloat originalMaxOffsetY = self.tableView.mgrMaxOffset.y - self.tableView.contentInset.bottom; // show에서 더해준것을 뺀다.
        originalMaxOffsetY = MAX(0.0, originalMaxOffsetY);
        if (originalMaxOffsetY < self.tableView.contentOffset.y) {
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration
                                                                  delay:0.0
                                                                options:options
                                                             animations:^{
                [self.tableView setContentOffset:CGPointMake(0.0, originalMaxOffsetY)];
                [self.view layoutIfNeeded];
            } completion:^(UIViewAnimatingPosition finalPosition) {
                self.tableView.contentInset = UIEdgeInsetsZero;
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
            }];
        } else {
            self.tableView.contentInset = UIEdgeInsetsZero;
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        }
        return; //! return 해야한다.
    }
    
    /// Show
    if ([name isEqualToString:UIKeyboardWillShowNotification]) {
        CGFloat bottomIset = keyboardHeight - self.view.safeAreaInsets.bottom;
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, bottomIset, 0.0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, bottomIset, 0.0);
    }

    MGUFinancialTextField *textField = self.currentTextField;
    UIWindow *window = self.currentTextField.window;
    CGRect rect = [textField convertRect:textField.bounds toView:window];
    CGFloat upLength = rect.origin.y + rect.size.height + 4.0; // 4.0은 마진..
    CGFloat total = upLength + keyboardHeight;
    CGPoint movingOffset = self.tableView.contentOffset;
    if (total > window.bounds.size.height) {
        CGFloat move = ABS(window.bounds.size.height - total);
        movingOffset = CGPointMake(movingOffset.x, movingOffset.y + move);
    }
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration 
                                                          delay:0.0
                                                        options:options
                                                     animations:^{
        [self.tableView setContentOffset:movingOffset];
        [self.view layoutIfNeeded];
    } completion:^(UIViewAnimatingPosition finalPosition) {
    }];
}

- (IBAction)clickedMinuteCheckButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger index = sender.tag;
    DTOMinTick *data = self.minDataArr[index];
    data.selected = sender.selected;
}

- (IBAction)clickedTickCheckButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger index = sender.tag;
    DTOMinTick *data = self.tickDataArr[index];
    data.selected = sender.selected;
}

@end
