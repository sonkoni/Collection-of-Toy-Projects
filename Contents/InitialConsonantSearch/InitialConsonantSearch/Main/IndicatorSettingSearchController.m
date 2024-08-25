//
//  IndicatorSettingSearchController.m
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/18/23.
//

#import <BaseKit/BaseKit.h>
#import "IndicatorSettingSearchController.h"
#import "IndicatorSettingCell.h"

@interface IndicatorSettingSearchController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MGUNOSearchResultView *noSearchResultView;
@property (nonatomic, strong) UITableViewDiffableDataSource <NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*dataSource;
@property (nonatomic, copy) MGRDispatchDebounceBlock debounceBlock;

@property (nonatomic, assign) BOOL showKeyboard;
@property (nonatomic, strong) id <NSObject> showObserver;
@property (nonatomic, strong) id <NSObject> hideObserver;
@property (nonatomic, strong, nullable) NSNotificationName previousNotificationName;
@property (nonatomic, assign) CGFloat previousKeyboardHeight;
@end


@implementation IndicatorSettingSearchController

#pragma mark - Override

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:_showObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_hideObserver];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _debounceBlock = MGRDispatchDebounceMake();
    self.view.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    // 여백 터치 및 팬 제스처 시에 내려버린다
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endSearchMode:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(endSearchMode:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    _noSearchResultView = [MGUNOSearchResultView new];
    self.noSearchResultView.imageType = MGUNOSearchResultViewImageTypeDynamic;
    self.noSearchResultView.hidden = YES;
    
    [backgroundView addSubview:self.noSearchResultView];
    [self.noSearchResultView mgrPinHorizontalEdgesToSuperviewEdges];
    [self.noSearchResultView.topAnchor constraintEqualToAnchor:backgroundView.topAnchor constant:20.0].active = YES;
    self.tableView.backgroundView = backgroundView;
    
    /// 디퍼블을 이용하느냐 마느냐.
    [self configureDataSource];
    [self setupKeyboardObserver];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) { 
    }];
    if (self.showKeyboard == YES) {
        [self.view endEditing:YES];
    }
}

#pragma mark - 생성 & 소멸

static void CommonInit(IndicatorSettingSearchController *self) {
    self->_debounceEnabled = YES;
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
        NSString *identifier = IndicatorSettingCellIDSearch;
        
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
    // 없는 것이 맞다
    // [self.dataSource applySnapshot:self.viewModel.snapshotForCurrentState animatingDifferences:NO];
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

#pragma mark - 세터 & 게터

- (void)setEmptyStringMode:(BOOL)emptyStringMode {
    _emptyStringMode = emptyStringMode;
    if (emptyStringMode == YES) { // 문자열이 없다면 (nil or empty)
        if (self.tableView.alpha != 0.0) {
            self.tableView.alpha = 0.0;
            self.noSearchResultView.hidden = YES; // debounce 때문에 여기서만 hidden 처리
            [self.dataSource applySnapshot:[NSDiffableDataSourceSnapshot new] // debounce 때문에 바로 처리
                      animatingDifferences:NO];
            self.debounceBlock(0.0, ^{}); // 기존 디바운스 예약을 무력화 시킨다
        }
    } else {
        if (self.tableView.alpha != 1.0) {
            self.tableView.alpha = 1.0;
            // self.noSearchResultView.hidden = NO; // debounce 때문에 여기서는 이 라인을 실행해서는 안된다
        }
    }
}

#pragma mark - Actions

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
        CGFloat originalMaxOffsetY = self.tableView.mgrMaxOffset.y - self.tableView.contentInset.bottom;
        if (originalMaxOffsetY < self.tableView.contentOffset.y) {
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration delay:0.0 options:animationCurve animations:^{
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

    UIWindow *window = self.view.window;
    CGRect rect = [self.view convertRect:self.view.bounds toView:window];
    
    CGFloat upLength = rect.origin.y + rect.size.height + 4.0; // 4.0은 마진..
    CGFloat total = upLength + keyboardHeight;
    CGPoint movingOffset = self.tableView.contentOffset;
    if (total > window.bounds.size.height) {
        CGFloat move = ABS(window.bounds.size.height - total);
        movingOffset = CGPointMake(movingOffset.x, movingOffset.y + move);
    }
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration delay:0.0 options:animationCurve animations:^{
        [self.tableView setContentOffset:movingOffset];
        [self.view layoutIfNeeded];
    } completion:^(UIViewAnimatingPosition finalPosition) {
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGROutlineItem <DTOIndicatorSetting *>*outlineItem = [self.dataSource itemIdentifierForIndexPath:indexPath];
    if (self.selectItemCompletion != nil) {
        self.selectItemCompletion(outlineItem);
    }
}

#pragma mark - <UISearchBarDelegate> 모두 Optional 전달 받아서 처리한다

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self updateEmptyStringModeForText:searchBar.text];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateEmptyStringModeForText:searchText];
    if (self.emptyStringMode == NO) {
        if (self.debounceEnabled == YES) {
            __weak __typeof(self) weakSelf = self;
            self.debounceBlock(0.2, ^{
                [weakSelf updateSearchResult:searchBar currentText:searchText];
            });
        } else {
            [self updateSearchResult:searchBar currentText:searchText];
        }
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    if ([self.tableView indexPathForRowAtPoint:location] != nil && self.emptyStringMode == NO) {
        return NO;
    } else {
        return YES;
    }
}

- (void)endSearchMode:(UIGestureRecognizer *)sender {
    [self.view.window endEditing:YES];
}

#pragma mark - Private Helper

- (void)updateEmptyStringModeForText:(NSString *)searchText {
    if (searchText == nil || searchText.length == 0) {
        self.emptyStringMode = YES;
    } else {
        self.emptyStringMode = NO;
    }
}

/// 디바운스(debounce) 효과가 부담스럽다면 디바운스만 제거하고 실행 Block를 그냥 실행하면된다
- (void)updateSearchResult:(UISearchBar *)searchBar currentText:(NSString *)currentText {
    NSDiffableDataSourceSnapshot<NSString *, MGROutlineItem <DTOIndicatorSetting *>*>*snp = [self.viewModel snapshotForCurrentText:currentText];
    if (snp.numberOfItems == 0) {
        self.noSearchResultView.searchText = currentText;
        self.noSearchResultView.hidden = NO;
        [self.dataSource applySnapshot:[NSDiffableDataSourceSnapshot new] animatingDifferences:NO];
    } else {
        self.noSearchResultView.hidden = YES;
        self.tableView.contentOffset = CGPointZero;
        [self.dataSource applySnapshot:snp animatingDifferences:NO];
    }
}

@end

//    NSDiffableDataSourceSnapshot <NSNumber *, MGPUser *>*snapshot  = [NSDiffableDataSourceSnapshot new];
//    [snapshot appendSectionsWithIdentifiers:@[@(RecipeListSectionMain)]];
//    if (searchText == nil || [searchText isEqualToString:@""] == YES) {
//
//        [snapshot appendItemsWithIdentifiers:self.users intoSectionWithIdentifier:@(RecipeListSectionMain)];
//
//    } else {
//        NSArray <MGPUser *>*result = [self.users mgrFilter:^BOOL(MGPUser *user) {
//            return [user.name containsString:searchText];
//        }];
//        [snapshot appendItemsWithIdentifiers:result intoSectionWithIdentifier:@(RecipeListSectionMain)];
//    }
//    [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{}];

//- (void)performQueryWith:(NSString * _Nullable)filter {
//    
//    NSArray <Mountain *>*mountains = [self.mountainsController filteredMountainsWith:filter
//                                                                               limit:NSNotFound];
//    mountains = [mountains sortedArrayUsingComparator:^NSComparisonResult(Mountain *obj1, Mountain *obj2) {
//        return [[obj1 name] compare:[obj2 name]];
//    }];
//    
//    NSDiffableDataSourceSnapshot <MGRMainSection, Mountain *>*snapshot = [NSDiffableDataSourceSnapshot new];
//    [snapshot appendSectionsWithIdentifiers:@[mainSection]];
//    [snapshot appendItemsWithIdentifiers:mountains];
//    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
//}

//- (NSArray <Mountain *>*)filteredMountainsWith:(NSString * _Nullable)filter
//                                         limit:(NSInteger)limit {
//    
//    NSArray <Mountain *>*mountains = self.mountains;
//    NSMutableArray <Mountain *>*filtered = [NSMutableArray array];
//    for (Mountain *mountain in mountains) {
//        if ([mountain contains:filter] == YES) {
//            [filtered addObject:mountain];
//        }
//    }
//    
//    if (limit != NSNotFound) {
//        return [filtered mgrSubArrayToIndex:limit]; // ex : subArrayToIndex:2    // 0, 1, 2
//    } else {
//        return filtered;
//    }
//}

//- (BOOL)contains:(NSString * _Nullable)filter {
//    if (filter == nil) {
//        return YES;
//    } else if ([filter isEqualToString:@""] == YES) {
//        return YES;
//    }
//    
//    NSString *lowercasedFilter = [filter lowercaseString];
//    NSString *lowercasedName = [self.name lowercaseString];
//    return [lowercasedName containsString:lowercasedFilter];
//}
