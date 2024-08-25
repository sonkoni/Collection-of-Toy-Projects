//
//  IndicatorSettingViewController.m
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 2023/09/26.
//

#import "IndicatorSettingViewController.h"
#import "IndicatorSettingContentController.h"
#import "IndicatorSettingSearchController.h"
#import "IndicatorSettingViewModel.h"
#import <IosKit/IosKit.h>

@interface IndicatorSettingViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *segmentContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerHeightConstraint;
@property (nonatomic, strong) UIView *underLineView;
@property (nonatomic, strong) NSLayoutConstraint *underLineLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UIView *searchResultContainer;

@property (nonatomic, strong) NSMutableArray <NSValue *>*lastOffsets;
@property (nonatomic, strong) IndicatorSettingViewModel *viewModel;
@property (nonatomic, strong) UIStoryboard *board; // lazy
@property (nonatomic, strong) IndicatorSettingContentController *contentController; // lazy
@property (nonatomic, strong) IndicatorSettingSearchController *searchController; // lazy

@end

@implementation IndicatorSettingViewController

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonInit(self);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext>context) {
        [self updateCurrentIndex:self.segmentedControl.selectedSegmentIndex];
    } completion:^(id <UIViewControllerTransitionCoordinatorContext>context) {
        
    }];
}

#pragma mark - 생성 & 소멸

static void CommonInit(IndicatorSettingViewController *self) {
    self->_viewModel = [IndicatorSettingViewModel new];
    self->_lastOffsets = @[@(CGPointZero), @(CGPointZero), @(CGPointZero), @(CGPointZero), @(CGPointZero), @(CGPointZero)].mutableCopy;
    
    self.dividerHeightConstraint.constant = 1.0 / [UIScreen mainScreen].scale;
    
    self->_underLineView = [UIView new];
    self.underLineView.backgroundColor = [UIColor blackColor];
    [self.segmentContainer addSubview:self.underLineView];
    self.underLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.underLineView.heightAnchor constraintEqualToConstant:1.0].active = YES;
    [self.underLineView.bottomAnchor constraintEqualToAnchor:self.segmentedControl.bottomAnchor].active = YES;
    [self.underLineView.widthAnchor constraintEqualToAnchor:self.segmentedControl.widthAnchor
                                                 multiplier:1.0/self.segmentedControl.numberOfSegments].active = YES;
    self->_underLineLeadingConstraint = [self.underLineView.leadingAnchor constraintEqualToAnchor:self.segmentedControl.leadingAnchor];
    CGFloat segmentWidth = self.segmentedControl.frame.size.width / self.segmentedControl.numberOfSegments;
    self.underLineLeadingConstraint.constant = segmentWidth * self.segmentedControl.selectedSegmentIndex;
    self.underLineLeadingConstraint.active = YES;
    [self setupSearhControl];
    [self setupSegmentedControl];
    [self mgrAddChildViewController:self.contentController targetView:self.contentContainer];
}

- (void)setupSearhControl {
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"취소";
    self.definesPresentationContext = YES; // 디폴트 NO. 보통 searchBar를 만드는 컨트롤러에서 YES로 설정한다
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor systemBlueColor];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchResultContainer.hidden = YES;
    [self mgrAddChildViewController:self.searchController targetView:self.searchResultContainer];
    [self setupJointAction];
    
    // MARK: - 디버깅을 위해서는 아래의 코드를 주석처리하면 좀 더 편리하게 관찰할 수 있다.
    self.searchResultContainer.backgroundColor = [UIColor clearColor];
}

- (void)setupSegmentedControl { // SegmentedControl 배경 색, 디바이더 색 제거
    [self.segmentedControl setBackgroundImage:[UIImage new]
                                     forState:UIControlStateNormal
                                   barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setDividerImage:[UIImage new]
                       forLeftSegmentState:UIControlStateNormal
                         rightSegmentState:UIControlStateNormal
                                barMetrics:UIBarMetricsDefault];
    // 16.0 에서 줄임.
    NSDictionary <NSAttributedStringKey,id>*normalDic =
    @{ NSFontAttributeName : [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold],
       NSForegroundColorAttributeName : [UIColor systemGrayColor] };
    [self.segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    
    
    NSDictionary<NSAttributedStringKey,id> *selectedDic =
    @{ NSFontAttributeName : [UIFont systemFontOfSize:13.0 weight:UIFontWeightHeavy],
       NSForegroundColorAttributeName : [UIColor blackColor] };
    [self.segmentedControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
    // self.segmentedControl.apportionsSegmentWidthsByContent = YES; // 밑에 붙여서 움직일 인디케이터 때문에 곤란함.
}

- (void)setupJointAction {
    __weak __typeof(self) weakSelf = self;
    
    void (^selectBlock)(MGROutlineItem <DTOIndicatorSetting *>*) = ^(MGROutlineItem <DTOIndicatorSetting *>*item) {
        DTOIndicatorSetting *contentItem = item.contentItem;
        NSInteger index = 0;

        if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
            
        } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategorySignals]) {
            index = 1;
        } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
            index = 2;
        } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryRanges]) {
            index = 3;
        } else if ([contentItem.mainCategory isEqualToString:IndiSetMainCategoryFill]) {
            index = 4;
        }
        weakSelf.segmentedControl.selectedSegmentIndex = index;
        [weakSelf updateCurrentIndex:index]; // model 분류 작업
        if (item.superItem != nil) {
            item.superItem.expanded = YES; // 닫혔으면 열어야지.
            // 구간과 즐겨찾기를 제외한 나머지 카테고리
            
            // 선택한 아이템을 맨 상단으로 올리려면 offset이 부족할 수도 있는 상황을 대비해야한다
            NSInteger itemIndex = [weakSelf.viewModel.currentItems indexOfObject:item.superItem];
            if (itemIndex < weakSelf.viewModel.currentItems.count - 1) {
                for (NSInteger i = itemIndex + 1; i < weakSelf.viewModel.currentItems.count; i++) {
                    MGROutlineItem <DTOIndicatorSetting *>*nextItem = weakSelf.viewModel.currentItems[i];
                    if (nextItem.isExpanded == NO && nextItem.subitems.count > 0) {
                        nextItem.expanded = YES;
                    }
                }
            }
        }

        [weakSelf.contentController reloadData:^{
            [weakSelf.contentController scrollToRowAtItem:item atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [weakSelf.view endEditing:YES];
        }];
    };
    self.searchController.selectItemCompletion = selectBlock;
    // searchController 생성 시 작동한다
}

#pragma mark - 세터 & 게터

- (IndicatorSettingContentController *)contentController {
    if (_contentController == nil) {
        IndicatorSettingContentController *vc = [self.board instantiateViewControllerWithIdentifier:@"IndicatorSettingContentController"];
        _contentController = vc;
        _contentController.viewModel = self.viewModel;
    }
    return _contentController;
}

- (IndicatorSettingSearchController *)searchController {
    if (_searchController == nil) {
        IndicatorSettingSearchController *vc = [self.board instantiateViewControllerWithIdentifier:@"IndicatorSettingSearchController"];
        _searchController = vc;
        _searchController.viewModel = self.viewModel;
         _searchController.debounceEnabled = NO; // 디폹트 YES
    }
    return _searchController;
    //
    // Debounce 효과를 없애고 싶다면 _searchController.debounceEnabled = NO 하라.
}

- (UIStoryboard *)board {
    if (_board == nil) {
        _board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    }
    return _board;
}

#pragma mark - Actions

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self updateCurrentIndex:sender.selectedSegmentIndex]; // 여기서 viewModel도 index에 맞게 분류됨
    __block CGPoint targetOffset = [self.lastOffsets[sender.selectedSegmentIndex] CGPointValue];
    __weak __typeof(self) weakSelf = self;
    [self.contentController reloadData:^{
        CGPoint maxOffset = [weakSelf.contentController.tableView mgrMaxOffset];
        targetOffset = CGPointMake(MIN(maxOffset.x, targetOffset.x),
                                   MIN(maxOffset.y, targetOffset.y));
        weakSelf.contentController.tableView.contentOffset = targetOffset;
    }];
}

- (void)updateCurrentIndex:(NSInteger)index {
    [self updateUnderLineLeadingConstraintWithIndex:index];
    
    // 기존(현재) 인덱스의 lastOffsets 저장
    if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        self.lastOffsets[0] = @(self.contentController.tableView.contentOffset);
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategorySignals]) {
        self.lastOffsets[1] = @(self.contentController.tableView.contentOffset);
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
        self.lastOffsets[2] = @(self.contentController.tableView.contentOffset);
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        self.lastOffsets[3] = @(self.contentController.tableView.contentOffset);
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryFill]) {
        self.lastOffsets[4] = @(self.contentController.tableView.contentOffset);
    } else if ([self.viewModel.currentMainCategory isEqualToString:IndiSetMainCategoryFavorites]) {
        self.lastOffsets[5] = @(self.contentController.tableView.contentOffset);
    }
    
    // 현재 index로 viewModel 설정
    if (index == 0) {
        self.viewModel.currentMainCategory = IndiSetMainCategoryIndicators;
    } else if (index == 1) {
        self.viewModel.currentMainCategory = IndiSetMainCategorySignals;
    } else if (index == 2) {
        self.viewModel.currentMainCategory = IndiSetMainCategoryPatterns;
    } else if (index == 3) {
        self.viewModel.currentMainCategory = IndiSetMainCategoryRanges;
    } else if (index == 4) {
        self.viewModel.currentMainCategory = IndiSetMainCategoryFill;
    } else if (index == 5) {
        self.viewModel.currentMainCategory = IndiSetMainCategoryFavorites;
    }
}


#pragma mark - <UISearchBarDelegate>

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar { // first responder가 되지 않으려면 NO를 반환한다
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.searchController searchBarShouldBeginEditing:searchBar];
    self.searchResultContainer.hidden = NO;
    ////////
    NSLog(@"searchBarShouldBeginEditing:");
    //    _isSearchMode = YES;
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar { // 텍스트 편집이 시작될 때 호출된다
    NSLog(@"searchBarTextDidBeginEditing:");
    ///[self.view addGestureRecognizer:self.tapGestureRecognizer];
}

 - (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar { // first responder 사임하지 않으려면 NO를 반환한다
     self.searchResultContainer.hidden = YES;
     [searchBar setShowsCancelButton:NO animated:YES]; // 사임
     return YES;
 }

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar { // 텍스트 편집이 끝나면 호출된다
    searchBar.text = nil;
    NSLog(@"searchBarTextDidEndEditing:");
//    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText { // 텍스트가 변경되면 호출된다(`clear` 포함)
    [self.searchController searchBar:searchBar textDidChange:searchText];
    NSLog(@"searchBar:textDidChange: %@", searchText);
}

// - (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {} // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar { // 키보드 검색(완료) 버튼을 눌렀을 때 호출됨
    [searchBar resignFirstResponder]; // NSLog(@"searchBarSearchButtonClicked:!!!!!");
    // searchBar.text = nil; // 완료(키보드 버튼)되었을 때. 글자를 지우는 것이 나을 것으로 사료되어 이렇게 처리함. searchBarTextDidEndEditing: 에서 처리
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar { // 취소버튼 눌렀을 시
    [searchBar resignFirstResponder];
    // searchBar.text = nil; searchBarTextDidEndEditing: 에서 처리
    NSLog(@"searchBarCancelButtonClicked:!!!!!");
    //    _isSearchMode = NO;
    //    [self.viewModel updateList];
    
    ///[searchBar resignFirstResponder];
    ///NSDiffableDataSourceSnapshot <NSNumber *, MGPUser *>*snapshot  = [NSDiffableDataSourceSnapshot new];
    ///[snapshot appendSectionsWithIdentifiers:@[@(RecipeListSectionMain)]];
    ///[snapshot appendItemsWithIdentifiers:self.users intoSectionWithIdentifier:@(RecipeListSectionMain)];
    ///[self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{}];
}

// - (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar; // called when bookmark button pressed
// - (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar; // called when search results button pressed
// - (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {} // 네비게이션바 사용시 제공되는 세그먼트 버튼을 누를 때 호출된다.

#pragma mark - Helper

- (void)updateUnderLineLeadingConstraintWithIndex:(NSInteger)index {
    CGFloat segmentWidth = (CGFloat)self.segmentedControl.frame.size.width / self.segmentedControl.numberOfSegments;
    self.underLineLeadingConstraint.constant = segmentWidth * index;
}


@end
