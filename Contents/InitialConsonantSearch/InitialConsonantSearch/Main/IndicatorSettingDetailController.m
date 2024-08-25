//
//  ViewController.m
//  StockLineTEST
//
//  Created by Kwan Hyun Son on 10/22/23.
//

#import <IosKit/IosKit.h>
#import "IndicatorSettingDetailController.h"
#import "IndicatorSettingDetailViewModel.h"
#import "ConfigCommonHeaderCell.h"
#import "IndicatorSettingDetailCell.h"

@interface IndicatorSettingDetailController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *segmentedControlContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *graphContainer;
@property (weak, nonatomic) IBOutlet UIStackView *graphSceneContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MGUStockLineInfoView *stockLineInfoView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dividerlayoutConstraint;

@property (nonatomic, strong) UIView *underLineView;
@property (nonatomic, strong) NSLayoutConstraint *underLineLeadingConstraint;

@end

@implementation IndicatorSettingDetailController

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"DMI";
    [self setupTableView];
    [self setupSegmentedControl];
    
    _stockLineInfoView = [MGUStockLineInfoView new];
    [self.graphContainer addSubview:self.stockLineInfoView];
    [self.stockLineInfoView mgrPinEdgesToSuperviewEdges];
    
    MGUStockLine *straightLine1 = [MGUStockLine new];
    straightLine1.lineWidth = 1.0;
    straightLine1.lineColor = [UIColor systemBlueColor];
    straightLine1.lineDashes = @[@(5.0), @(5.0)];
    
    MGUStockLine *straightLine2 = [MGUStockLine new];
    straightLine2.lineWidth = 1.0;
    straightLine2.lineColor = [UIColor systemGrayColor];
    
    
    MGUStockLine *curveLine1 = [MGUStockLine new];
    curveLine1.lineWidth = 5.0;
    ///curveLine1.lineWidth = 1.0;
    /// curveLine1.lineColor = [UIColor blackColor];
    curveLine1.peakLineColor = [UIColor systemMintColor];
    curveLine1.valleyLineColor = [UIColor systemBrownColor];
    curveLine1.lineDashes = @[@(0.0), @(10.0)];
    
    MGUStockLine *curveLine2 = [MGUStockLine new];
    curveLine2.lineWidth = 2.0;
    curveLine2.lineColor = [UIColor systemRedColor];
    curveLine2.peakFillColor = [UIColor colorWithRed:232.0/255.0 green:185.0/255.0 blue:153.0/255.0 alpha:1.0];
    curveLine2.valleyFillColor = [UIColor colorWithRed:157.0/255.0 green:214.0/255.0 blue:234.0/255.0 alpha:1.0];
    
    MGUStockLine *curveLine3 = [MGUStockLine new];
    curveLine3.lineWidth = 0.0;
    curveLine3.lineColor = [UIColor clearColor];
    curveLine3.fillMode = MGUStockLineFillModeBar;
    curveLine3.peakFillColor = [UIColor systemRedColor];
    curveLine3.valleyFillColor = [UIColor systemBlueColor];
    
    
    MGUStockLineInfo *info = [MGUStockLineInfo new];
    info.straightLines = @[straightLine1, straightLine2];
    info.curveLines = @[curveLine1, curveLine2, curveLine3];
    
    
    self.stockLineInfoView.lineInfo = info;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateGraphSceneAppearance:self.segmentedControl.selectedSegmentIndex
                     traitCollection:self.traitCollection];
    self.navigationItem.title = self.viewModel.mainTitle;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateUnderLineLeadingConstraint];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
    // if (self.showKeyboard == YES) {
    //     [self.view endEditing:YES];
    // }
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updateGraphSceneAppearance:self.segmentedControl.selectedSegmentIndex
                     traitCollection:newCollection];
}

- (void)updateGraphSceneAppearance:(NSInteger)selectedSegmentIndex
                   traitCollection:(UITraitCollection *)traitCollection {
    if (self.viewModel.isShowGraph == NO) {
        if (self.graphSceneContainer.isHidden != YES) {
            self.graphSceneContainer.hidden = YES;
        }
        return;
    }
    
    if (selectedSegmentIndex == 0) {
        if (traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
            if (self.graphSceneContainer.isHidden != YES) {
                self.graphSceneContainer.hidden = YES;
            }
        } else if (traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
            if (self.graphSceneContainer.isHidden != NO) {
                self.graphSceneContainer.hidden = NO;
            }
        }
    } else {
        if (self.graphSceneContainer.isHidden != YES) {
            self.graphSceneContainer.hidden = YES;
        }
    }
}

#pragma mark - 생성 & 소멸

- (void)setupTableView {
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

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DTOIndicatorDetailSetting *setting = [self.viewModel cellModelForIndexPath:indexPath];
    
    IndicatorSettingDetailCell *cell =
        [tableView dequeueReusableCellWithIdentifier:setting.identifier
                                        forIndexPath:indexPath];
    cell.data = setting;
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
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


#pragma mark - Actions
///IndicatorSettingDetailController
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSInteger selectedSegmentIndex = sender.selectedSegmentIndex;
    [self updateUnderLineLeadingConstraint];
    if (sender.selectedSegmentIndex == 0) {
        self.viewModel.detailCategory = IndicatorSettingDetailCategoryLine;
    } else if (sender.selectedSegmentIndex == 1) {
        self.viewModel.detailCategory = IndicatorSettingDetailCategoryConditions;
    } else if (sender.selectedSegmentIndex == 2) {
        self.viewModel.detailCategory = IndicatorSettingDetailCategoryDescription;
    } else {
        NSCAssert(FALSE, @"예상치 못한 인덱스가 들어옴.");
    }
    
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self.view endEditing:YES];
    [self.tableView reloadData];
    
    [self updateGraphSceneAppearance:selectedSegmentIndex
                     traitCollection:self.traitCollection];
}

- (IBAction)detailScene:(UIButton *)sender {
    
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor systemYellowColor];
    __weak __typeof(vc) weakVC = vc;
    UIAction *action = [UIAction actionWithHandler:^(UIAction *action) {
        [weakVC dismissViewControllerAnimated:YES completion:^{}];
    }];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithPrimaryAction:action];
    UIImageSymbolConfiguration *imageConfig =
    [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
    imageConfig = [imageConfig configurationByApplyingConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:36.0]];
    imageConfig = [imageConfig configurationByApplyingConfiguration:[UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightRegular]];
    UIImage *hierarchicalSymbol = [UIImage systemImageNamed:@"xmark.circle.fill"
                                          withConfiguration:imageConfig];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 34.0, 34.0) primaryAction:action];
    [button setImage:hierarchicalSymbol forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.contentMode = UIViewContentModeCenter;
    [button.widthAnchor constraintEqualToAnchor:button.heightAnchor].active = YES;
    [button.widthAnchor constraintEqualToConstant:34.0].active = YES;
    rightBarButtonItem.customView = button;
    vc.navigationItem.rightBarButtonItem = rightBarButtonItem;
    vc.navigationItem.title = @"상한선";

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    self.definesPresentationContext = NO; // 디폴트
        
    if (@available(iOS 15, *)) {
        if (nav.popoverPresentationController != nil) {
            UIPopoverPresentationController *popover = nav.popoverPresentationController;
            popover.sourceView = sender;
            UISheetPresentationController *sheet = popover.adaptiveSheetPresentationController;
            
            UISheetPresentationControllerDetentIdentifier customDetentIdentifier = @"customDetentIdentifier";
            sheet.prefersGrabberVisible = YES;
            sheet.selectedDetentIdentifier = customDetentIdentifier; // UISheetPresentationControllerDetentIdentifierMedium;
            
            if (@available(iOS 16, *)) {
                UISheetPresentationControllerDetent *custom =
                    [UISheetPresentationControllerDetent customDetentWithIdentifier:customDetentIdentifier
                                                                            resolver:^CGFloat(id <UISheetPresentationControllerDetentResolutionContext>context) {
                        UITraitCollection *containerTraitCollection = context.containerTraitCollection;
                        if (containerTraitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
                            return context.maximumDetentValue;
                        } else {
                            return 0.7 * context.maximumDetentValue;
                            //
                            // return 0.56 * context.maximumDetentValue; // mediumDetent 동일
                            // return 0.7 * context.maximumDetentValue; // 칼라 피커와 동일
                        }
                }];
                sheet.detents = @[custom];
                
            } else {
                sheet.detents = @[[UISheetPresentationControllerDetent mediumDetent], [UISheetPresentationControllerDetent largeDetent]];
            }
            
            sheet.prefersScrollingExpandsWhenScrolledToEdge = YES; // 컨텐츠가 스크롤 뷰일때 우선적으로 컨텐츠를 스크롤하지않고 뷰 전체를 밀어올린다
            
            sheet.largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
            //
            // 딤을 언제할 거냐
            // sheet.largestUndimmedDetentIdentifier = customDetentIdentifier;
            
            // 세로가 컴팩트일 때, 가로 길이를 줄일 것인가
            sheet.prefersEdgeAttachedInCompactHeight = YES; // 줄이겠다는 뜻
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = YES; // 줄인다고 가정했을 때, Preferred ContentSize를 사용하겠다는 뜻
        }
        
}
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Private Helper

- (void)updateUnderLineLeadingConstraint {
    NSInteger selectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
    CGFloat segmentWidth = self.segmentedControl.frame.size.width / (self.segmentedControl.numberOfSegments);
    self.underLineLeadingConstraint.constant = segmentWidth * selectedSegmentIndex;
}

@end

//- (NSInteger)numberOfSections {
//- (NSInteger)numberOfRowsInSection:(NSInteger)section {
