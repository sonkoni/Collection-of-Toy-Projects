//
//  ForgeOnboardingViewController.m
//  MGUAlertView_koni
//
//  Created by Kwan Hyun Son on 2021/07/23.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "ForgeOnboardingViewController.h"
#import "BackgroundColorView.h"
#import "ForgeOnboardingMainCell.h"
#import "ForgeOnboardingMessageCell.h"
#import "WaveView.h"

@interface ForgeOnboardingViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, strong) NSArray <NSString *>*messages;
@property (nonatomic, strong) NSArray <UIImage *>*images;

@property (nonatomic, strong) BackgroundColorView *backgroundColorView;
@property (nonatomic, strong) WaveView *waveView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionView *messageCollectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *dimissButton;

@property (nonatomic, assign, readonly) NSTimeInterval currentTimeOffset;
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign) NSInteger sceneCount;

@property (nonatomic, strong) NSTimer *timer; // auto scroll.
@end

@implementation ForgeOnboardingViewController
@dynamic currentTimeOffset;
@dynamic currentPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonInit(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.verginLoad == YES) {
        self.dimissButton.alpha = 0.0;
    } else {
        self.dimissButton.alpha = 1.0;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelTimer];
}

- (void)dealloc {
    [self cancelTimer];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithVerginLoad:(BOOL)verginLoad {
    self = [super initWithNibName:NSStringFromClass([ForgeOnboardingViewController class]) bundle:nil];
    if (self) {
        _verginLoad = verginLoad;
    }
    return self;
}

static void CommonInit(ForgeOnboardingViewController *self) {
    //     _verginLoad = YES;
    self->_sceneCount = 4;
    self->_titles = @[@"Follow the doctor's order",
                    @"Educational use only",
                    @"Double-checking IV Set"];
        
    self->_messages = @[@"IV fluid therapy is ordered by a physician. The order must specify the type of solution or medication, amount to be administered, time period during which the IV fluid is infused.\n\nThis dosage info is different for each individual according to the medical conditions.",
                    @"IvDrop converts data to flow rate & drip rate using simple mathematical formulas, but these results are for educational purposes and should not replace medical advice.",
                    @"You can see the virtual chamber by swiping the bottom part of the ‘Check’ section.\n\nYou can either simulate drip rate values or measure the current drip rate of the actual chamber.\n\nLet’s double check!"];
        
    self->_images = @[[UIImage imageNamed:@"board_prescription_part"],
                    [UIImage imageNamed:@"board_flow_rate_formula_part"],
                    [UIImage imageNamed:@"board_drip_rate_formula_part"],
                    [UIImage imageNamed:@"board_double_check_part"]];
        
    [self setupBackgroundColorView];
    [self setupMainCollectionView];
        
    [self setupWaveView];
    [self setupMessageCollectionView];
    [self setupPageControl];
    [self setupDimissButton];
}

- (void)setupBackgroundColorView {
    _backgroundColorView = [BackgroundColorView new];
    [self.view addSubview:self.backgroundColorView];
    [self.backgroundColorView mgrPinEdgesToSuperviewEdges];
    
    [self.backgroundColorView setColors:[UIColor mgrColorFromHexString:@"EDF9FF"]
                                 bottom:[UIColor mgrColorFromHexString:@"EDF9FF"]];
}

- (void)setupWaveView {
    _waveView = [[WaveView alloc] initWithFrame:CGRectZero topWaveColor:UIColor.blueColor bottomWaveColor:UIColor.redColor];
    self.waveView.userInteractionEnabled = NO;
    [self.view addSubview:self.waveView];
    [self.waveView mgrPinEdgesToSuperviewEdges];
}

- (void)setupMainCollectionView {
    // collection view
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0;
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:layout];

    self.mainCollectionView.pagingEnabled = YES;
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.showsHorizontalScrollIndicator = NO;
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView mgrPinEdgesToSuperviewEdges];
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    UINib *nibName = [UINib nibWithNibName:NSStringFromClass([ForgeOnboardingMainCell class]) bundle:bundle];
    [self.mainCollectionView  registerNib:nibName forCellWithReuseIdentifier:NSStringFromClass([ForgeOnboardingMainCell class])];
}

- (void)setupMessageCollectionView {
    // collection view
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0;
    _messageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:layout];

    self.messageCollectionView.userInteractionEnabled = NO;
    self.messageCollectionView.pagingEnabled = YES;
    self.messageCollectionView.backgroundColor = [UIColor clearColor];
    self.messageCollectionView.delegate = self;
    self.messageCollectionView.dataSource = self;
    self.messageCollectionView.showsHorizontalScrollIndicator = NO;
    self.messageCollectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.messageCollectionView];
    [self.messageCollectionView mgrPinEdgesToSuperviewEdges];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    UINib *nibName = [UINib nibWithNibName:NSStringFromClass([ForgeOnboardingMessageCell class]) bundle:bundle];
    [self.messageCollectionView  registerNib:nibName forCellWithReuseIdentifier:NSStringFromClass([ForgeOnboardingMessageCell class])];
}

- (void)setupPageControl {
    _pageControl = [UIPageControl new];
    [self.view addSubview:self.pageControl];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pageControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.pageControl.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.pageControl.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-30.0].active = YES;
    self.pageControl.numberOfPages = 4;
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self action:@selector(pageControlPageDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupDimissButton {
    _dimissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    UIImageSymbolConfiguration *configuration =
        [UIImageSymbolConfiguration configurationWithPointSize:35.0
                                                        weight:UIImageSymbolWeightLight
                                                         scale:UIImageSymbolScaleSmall];
    UIImage *image = [UIImage systemImageNamed:@"xmark.circle.fill" withConfiguration:configuration];
    [self.dimissButton setImage:image forState:UIControlStateNormal];
    [self.dimissButton setTintColor:[UIColor whiteColor]];
    
    
    [self.view addSubview:self.self.dimissButton];
    self.dimissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dimissButton.widthAnchor constraintEqualToConstant:35.0].active = YES;
    [self.dimissButton.widthAnchor constraintEqualToAnchor:self.dimissButton.heightAnchor].active = YES;
    CGFloat sideMargin = 15.0;
    [self.dimissButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:sideMargin].active = YES;
    [self.dimissButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:sideMargin].active = YES;
    
    [self.dimissButton addTarget:self action:@selector(dimissButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pageControlPageDidChange:(UIPageControl *)control {
    UIScrollView *scrollView = (UIScrollView *)self.mainCollectionView;
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger page = self.pageControl.currentPage;
    CGFloat offset = page * pageWidth;
    
    BOOL animated = YES;
    if (@available(iOS 14, *)) {
        if (control.interactionState == UIPageControlInteractionStateContinuous) {
            animated = NO;
        }
    }
    [scrollView setContentOffset:CGPointMake(offset, 0.0) animated:animated];
}

- (void)dimissButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)pageFromOffset:(CGFloat)xOffset {
    CGFloat pageWidth = self.mainCollectionView.bounds.size.width;
    return (NSInteger)(xOffset / pageWidth);
}

- (NSInteger)currentPage {
    CGFloat pageWidth = self.mainCollectionView.bounds.size.width;
    CGFloat xOffset = self.mainCollectionView.contentOffset.x;
    return (NSInteger)(xOffset / pageWidth);
}

//! time offset은 총 4개의 scene 이므로 0, 1, 2, 3 (0.0 <= <=3.0) 스크롤을 당기면 음수 또는 3.0을 초과할 수 있다.
- (NSTimeInterval)currentTimeOffset {
    return self.mainCollectionView.contentOffset.x / self.view.bounds.size.width;
}

- (NSTimeInterval)timeOffsetFromOffset:(CGFloat)xoffset {
    return xoffset / self.view.bounds.size.width;
}

// 3.0
- (NSTimeInterval)maxTimeOffset {
    return (NSTimeInterval)(self.sceneCount - 1.0);
}

- (CGFloat)unitXOffset {
    return self.view.bounds.size.width;
}

- (CGFloat)maxXOffset {
    return self.view.bounds.size.width * (self.sceneCount - 1);
}


#pragma mark - Update.
- (void)updateWithXOffset:(CGFloat)xOffset {
    [self updateMessageCollectionViewWithXOffset:xOffset];
    [self updateWaveViewWithXOffset:xOffset];
    [self updateDimissButtonWithXOffset:xOffset];
}

- (void)updateDimissButtonWithXOffset:(CGFloat)xOffset {
    if (self.verginLoad == YES) {
        NSTimeInterval timeOffset = [self timeOffsetFromOffset:xOffset];
        timeOffset = MIN(MAX(0.0, timeOffset), [self maxTimeOffset]); // Cutting
        if (timeOffset < [self maxTimeOffset] - 1.0) {
            self.dimissButton.alpha = 0.0;
        } else if (timeOffset >= [self maxTimeOffset]) {
            self.verginLoad = NO;
            self.dimissButton.alpha = 1.0;
        } else {
            self.dimissButton.alpha = timeOffset - ([self maxTimeOffset] - 1.0);
        }
    }
}

- (void)updateMessageCollectionViewWithXOffset:(CGFloat)xOffset {
    xOffset = MAX(MIN(xOffset, [self maxXOffset]), 0.0); // cutting.
    if (xOffset <= [self unitXOffset]) {
        [self.messageCollectionView setContentOffset:(CGPointMake(xOffset, 0.0))];
    } else if (xOffset <= [self unitXOffset] * 2.0) {
        [self.messageCollectionView setContentOffset:(CGPointMake([self unitXOffset], 0.0))];
    } else {
        [self.messageCollectionView setContentOffset:(CGPointMake(xOffset - [self unitXOffset], 0.0))];
    }
}

- (void)updateWaveViewWithXOffset:(CGFloat)xOffset {
    xOffset = MAX(MIN(xOffset, [self maxXOffset]), 0.0); // cutting.
    if (xOffset <= [self unitXOffset]) {
        [self.waveView.scrollView setContentOffset:(CGPointMake(xOffset, 0.0))];
    } else if (xOffset <= [self unitXOffset] * 2.0) {
        [self.waveView.scrollView setContentOffset:(CGPointMake([self unitXOffset], 0.0))];
    } else {
        [self.waveView.scrollView setContentOffset:(CGPointMake(xOffset - [self unitXOffset], 0.0))];
    }
}


#pragma mark - Auto scroll
- (void)startTimer {
    if (self.timer != nil) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:3.0
                                         target:weakSelf
                                       selector:@selector(flipNextSender:)
                                       userInfo:nil
                                        repeats:YES];
    
    //! 타이머를 현재 런루프에서 NSRunLoopCommonModes로 실행하게 하면, 사용자 인터렉션에 의해서 타이머가 방해받지 않는다.
    //! 기본적으로 NSTimer 는 NSRunLoop에서 작동하게 되어있고, 자동으로 Main Thread NSRunLoop이다.
    //! 따라서 currentRunLoop로 변경해야한다.
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    // NSDefaultRunLoopMode, NSRunLoopCommonModes, NSEventTrackingRunLoopMode, NSModalPanelRunLoopMode, UITrackingRunLoopMode
    
    //! 허용오차. 약간의 오차를 줘야지 프로그램이 메모리를 덜먹는다. 보통 0.1
    self.timer.tolerance = 0.1;
}

- (void)cancelTimer {
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)flipNextSender:(NSTimer *)sender {
    if (self.view.superview == nil ||
        self.view.window == nil ||
        self.sceneCount <= 0 ||
        self.mainCollectionView.tracking == YES) {
        return;
    }
    
    NSInteger page = (self.currentPage + 1) % self.sceneCount;
    CGPoint contentOffset = CGPointMake(self.unitXOffset * page, 0.0);
    [self.mainCollectionView setContentOffset:contentOffset animated:YES];
}


#pragma mark - <UICollectionViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.messageCollectionView) {
        return;
    }
    [self cancelTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.messageCollectionView) {
        return;
    }
    [self updateWithXOffset:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView { // 스와이프로 스크롤이 돌다가 멈출때
    if (scrollView == self.messageCollectionView) {
        return;
    }
    CGFloat pageWidth = scrollView.bounds.size.width;
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger page = (NSInteger)(offset / pageWidth);
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView { // 손가락 없이 애니메이션으로 scroll 될 수도 있다.
    if (scrollView == self.messageCollectionView) {
        return;
    }
    CGFloat pageWidth = scrollView.bounds.size.width;
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger page = (NSInteger)(offset / pageWidth);
    
    if (@available(iOS 14, *)) {
        if (self.pageControl.interactionState != UIPageControlInteractionStateContinuous) {
            self.pageControl.currentPage = page;
        }
    } else {
        self.pageControl.currentPage = page;
    }
}


#pragma mark - <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.mainCollectionView) {
        return self.sceneCount;
    } else {
        return self.sceneCount - 1;
    }
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.mainCollectionView) {
        ForgeOnboardingMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ForgeOnboardingMainCell class])
                                                                               forIndexPath:indexPath];
        cell.mainContentContainer.backgroundColor = [UIColor mgrColorFromHexString:@"FFFFFF"];
        cell.imageView.image = self.images[indexPath.row];
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (indexPath.row % 2 == 0) {
            transform = CGAffineTransformRotate(transform, M_PI / 60.0);
        } else {
            transform = CGAffineTransformRotate(transform, - M_PI / 60.0);
        }
        
        transform = CGAffineTransformTranslate(transform, 0.0, -40.0);
        
        cell.mainContentContainer.transform = transform;
        return cell;
    } else {
        ForgeOnboardingMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ForgeOnboardingMessageCell class])
                                                                                     forIndexPath:indexPath];
        cell.titleLabel.text = self.titles[indexPath.row];
        
        //!---- 하단 message
        NSString *message = self.messages[indexPath.row];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        paragraphStyle.lineHeightMultiple = 1.2;
        NSDictionary <NSAttributedStringKey, id>*attributes =
         @{ NSFontAttributeName            : [UIFont systemFontOfSize:17.0],
            NSForegroundColorAttributeName : [UIColor mgrColorFromHexString:@"07335A"],
            NSParagraphStyleAttributeName  : paragraphStyle }.mutableCopy;

        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes:attributes];
        cell.messageLabel.attributedText = attributedMessage;
        return cell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView ==  self.mainCollectionView) {
        ForgeOnboardingMainCell *mainCell = (ForgeOnboardingMainCell *)cell;
        if (indexPath.row == 0) {
            mainCell.mainContentContainer.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
        } else {
            mainCell.mainContentContainer.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMinXMinYCorner | kCALayerMaxXMaxYCorner | kCALayerMinXMaxYCorner;
        }
    } else if (collectionView ==  self.messageCollectionView) {
        ForgeOnboardingMessageCell *messageCell = (ForgeOnboardingMessageCell *)cell;
        if (indexPath.row == 1) {
            messageCell.messageLabel2.hidden = NO;
        } else {
            messageCell.messageLabel2.hidden = YES;
        }
    }
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }

@end
