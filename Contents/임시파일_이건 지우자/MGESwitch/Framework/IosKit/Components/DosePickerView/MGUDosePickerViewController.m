//
//  MGRDoseViewController.m
//  PickerView
//
//  Created by Kwan Hyun Son on 11/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUDosePickerViewController.h"
@import BaseKit;

@interface MGUDosePickerViewController () <MGUDosePickerViewDataSource, MGUDosePickerViewDelegate>

@property (weak) IBOutlet UIView *leftContainerView;    // 약품의 용량 Mg, Mcg, Grams, None
@property (weak) IBOutlet UIView *centerContainerView;  // 몸무게 Kg, None
@property (weak) IBOutlet UIView *rightContainerView;   // 시간 Hr, Min, None

@property (weak) IBOutlet UIView *selectionView;     // 가운데 세로로 긴 뷰
@property (weak) IBOutlet UIView *leftSeparatorView; //
@property (weak) IBOutlet UIView *rightSeparatorView; //
@property (weak) IBOutlet NSLayoutConstraint *separatorViewHeightConstraint;

@property (nonatomic, strong) MGUDosePickerView *dosePickerView;   // topContainerView 에 붙음
@property (nonatomic, strong) MGUDosePickerView *weightPickerView; // middleContainerView 에 붙음
@property (nonatomic, strong) MGUDosePickerView *timePickerView;   // bottomContainerView 에 붙음
@property (nonatomic, strong) NSArray <MGUDosePickerView *>*pickerViews;

@property (nonatomic, strong) NSMutableArray <NSString *>*dosePickerTitles;
@property (nonatomic, strong) NSMutableArray <NSString *>*weightPickerTitles;
@property (nonatomic, strong) NSMutableArray <NSString *>*timePickerTitles;

@property (nonatomic, strong, nullable) NSMutableArray <NSString *>*initialTitles; // 최초 초기화 단계에서만 사용한다.

@end

@implementation MGUDosePickerViewController
@dynamic selectedTitles;
@dynamic selectedDosePickerTitle;
@dynamic selectedWeightPickerTitle;
@dynamic selectedTimePickerTitle;
@dynamic selectedIndexes;
@dynamic selectedDosePickerIndex;
@dynamic selectedWeightPickerIndex;
@dynamic selectedTimePickerIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    self.leftContainerView.backgroundColor   = UIColor.clearColor;
    self.centerContainerView.backgroundColor = UIColor.clearColor;
    self.rightContainerView.backgroundColor  = UIColor.clearColor;
    self.leftContainerView.clipsToBounds = YES;
    self.centerContainerView.clipsToBounds = YES;
    self.rightContainerView.clipsToBounds = YES;
    self.leftContainerView.layer.masksToBounds = YES;
    self.centerContainerView.layer.masksToBounds = YES;
    self.rightContainerView.layer.masksToBounds = YES;
    
    self.selectionView.backgroundColor = self.selectionViewColor;
    self.selectionView.clipsToBounds = NO;
    self.selectionView.layer.cornerRadius = self.selectionViewRadius;
    self.selectionView.layer.shadowOpacity   = self.selectionViewShadowOpacity;
    self.selectionView.layer.shadowOffset    = self.selectionViewShadowOffset;
    self.selectionView.layer.shadowColor     = self.selectionViewShadowColor.CGColor;
    self.selectionView.layer.shadowRadius    = self.selectionViewShadowRadius;
    self.selectionView.layer.borderWidth  = self.selectionViewBorderWidth;
    self.selectionView.layer.borderColor = self.selectionViewBorderColor.CGColor;
    
    self.view.clipsToBounds = NO;
    self.view.layer.masksToBounds = NO;
    self.view.layer.cornerRadius = self.radius;
    
    [self setupSeparatorView];
    
    self.dosePickerView = [[MGUDosePickerView alloc] initWithFrame:self.leftContainerView.bounds];
    [self.leftContainerView addSubview:self.dosePickerView];
    [self configurePickerView:self.dosePickerView];
    
    self.weightPickerView = [[MGUDosePickerView alloc] initWithFrame:self.centerContainerView.bounds];
    [self.centerContainerView addSubview:self.weightPickerView];
    [self configurePickerView:self.weightPickerView];
    
    self.timePickerView = [[MGUDosePickerView alloc] initWithFrame:self.rightContainerView.bounds];
    [self.rightContainerView addSubview:self.timePickerView];
    [self configurePickerView:self.timePickerView];
    _pickerViews = @[self.dosePickerView, self.weightPickerView, self.timePickerView];
    
    if (self.normalSoundPlayBlock != nil) {
        for (MGUDosePickerView *pickerView in self.pickerViews) {
            pickerView.normalSoundPlayBlock = self.normalSoundPlayBlock;
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.dosePickerView.frame   = self.leftContainerView.bounds;
    self.weightPickerView.frame = self.centerContainerView.bounds;
    self.timePickerView.frame   = self.rightContainerView.bounds;
    [self.view layoutIfNeeded];
    [self selectItemIndexes:self.selectedIndexes.mutableCopy animated:NO notify:NO];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self selectItemIndexes:self.selectedIndexes.mutableCopy animated:NO notify:NO];
    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self.traitCollection performAsCurrentTraitCollection:^{
            self.selectionView.layer.shadowColor  = self.selectionViewShadowColor.CGColor;
            self.selectionView.layer.borderColor = self.selectionViewBorderColor.CGColor;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.parentViewController == nil) {
        NSCAssert(FALSE, @"parentViewController 를 설정하라.");
        /***
        - (void)viewDidLoad {
            [super viewDidLoad];
            ....
            [self addChildViewController:self.pickerViewController];
            [self.backView addSubview:self.pickerViewController.view];
            [self.pickerViewController didMoveToParentViewController:self];
            self.pickerViewController.delegate = self;
        }

        - (void)viewDidDisappear:(BOOL)animated {
            [super viewDidDisappear:animated];
            [self.pickerViewController willMoveToParentViewController:nil]; // - removeFromParentViewController 호출 전에 반드시 호출해줘야한다.
            [self.pickerViewController.view removeFromSuperview];
            [self.pickerViewController removeFromParentViewController]; // [childController didMoveToParentViewController:nil]; 이 코드를 자동호출 시킨다.
        }
        */
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithDoseTitles:(NSMutableArray <NSString *>* _Nonnull)doseTitles
                      weightTitles:(NSMutableArray <NSString *>* _Nonnull)weightTitles
                        timeTitles:(NSMutableArray <NSString *>* _Nonnull)timeTitles
                     initialTitles:(NSMutableArray <NSString *>* _Nullable)initialTitles {
    NSBundle *bundle = [NSBundle mgrIosRes];
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:bundle];
    if(self) {
        self.dosePickerTitles   = doseTitles;
        self.weightPickerTitles = weightTitles;
        self.timePickerTitles   = timeTitles;
        self.initialTitles      = initialTitles;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUDosePickerViewController *self) {
    self->_radius = 0.0;
    self->_textColor = [UIColor colorWithRed:96.0/225.0 green:125.0/225.0 blue:168.0/225.0 alpha:1.0];
    self->_highlightedTextColor = UIColor.whiteColor;
    self->_separatorColor = [UIColor colorWithRed:35.0 / 255.0 green:96.0 / 255.0 blue:173.0 / 255.0 alpha:1.0];
    
    self->_selectionViewColor = [UIColor.whiteColor colorWithAlphaComponent:0.06];
    self->_selectionViewRadius = 0.0;
    self->_selectionViewShadowColor = [UIColor blackColor];
    self->_selectionViewShadowOpacity = 0.0;
    self->_selectionViewShadowRadius = 0.0;
    self->_selectionViewShadowOffset = CGSizeZero;
    self->_selectionViewBorderColor = [UIColor clearColor];
    self->_selectionViewBorderWidth = 0.0;
    
    self->_font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self->_highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    
    self->_pickerViewStyle = MGUDosePickerViewStyleFlatCenterPop;
    self->_maskDisabled = NO;
    self->_soundOn = YES;

}

- (void)setupSeparatorView {
    self.leftSeparatorView.backgroundColor = self.separatorColor;
    self.rightSeparatorView.backgroundColor = self.separatorColor;
    self.separatorViewHeightConstraint.active = NO;
    self.leftSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftSeparatorView.heightAnchor constraintEqualToAnchor:self.leftSeparatorView.superview.heightAnchor multiplier:0.8].active = YES;
}

- (void)configurePickerView:(MGUDosePickerView *)pickerView {
    pickerView.delegate   = self;
    pickerView.dataSource = self;
    
    pickerView.font                 = self.font;
    pickerView.highlightedFont      = self.highlightedFont;
    pickerView.highlightedTextColor = self.highlightedTextColor;
    pickerView.textColor = self.textColor;
    pickerView.eyePosition = 1000; // 거리가 1000 커질수록 평평하게 보인다.
    
    pickerView.pickerViewStyle = self.pickerViewStyle;
    pickerView.maskDisabled = self.maskDisabled;
    pickerView.soundOn = self.soundOn;
    
    if (self.initialTitles != nil) {
        if(pickerView == self.dosePickerView){
            pickerView.selectedItemIndex = [self.dosePickerTitles indexOfObject:self.initialTitles[0]];
        } else if (pickerView == self.weightPickerView) {
            pickerView.selectedItemIndex = [self.weightPickerTitles indexOfObject:self.initialTitles[1]];
        } else {
            pickerView.selectedItemIndex = [self.timePickerTitles indexOfObject:self.initialTitles[2]];
        }
    }
    
    [pickerView reloadData];
}


#pragma mark - 세터 & 게터
- (NSArray<NSString *> *)selectedTitles {
    return @[self.selectedDosePickerTitle, self.selectedWeightPickerTitle, self.selectedTimePickerTitle];
}

- (NSString *)selectedDosePickerTitle {
    return self.dosePickerTitles[self.dosePickerView.selectedItemIndex];
}

- (NSString *)selectedWeightPickerTitle {
    return self.weightPickerTitles[self.weightPickerView.selectedItemIndex];
}

- (NSString *)selectedTimePickerTitle {
    return self.timePickerTitles[self.timePickerView.selectedItemIndex];
}

- (NSArray<NSNumber *> *)selectedIndexes {
    return @[@(self.dosePickerView.selectedItemIndex), @(self.weightPickerView.selectedItemIndex), @(self.timePickerView.selectedItemIndex)];
}

- (NSUInteger)selectedDosePickerIndex {
    return self.dosePickerView.selectedItemIndex;
}

- (NSUInteger)selectedWeightPickerIndex {
    return self.weightPickerView.selectedItemIndex;
}

- (NSUInteger)selectedTimePickerIndex {
    return self.timePickerView.selectedItemIndex;
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    _highlightedTextColor = highlightedTextColor;
    self.dosePickerView.highlightedTextColor = self.highlightedTextColor;
    self.weightPickerView.highlightedTextColor = self.highlightedTextColor;
    self.timePickerView.highlightedTextColor = self.highlightedTextColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.dosePickerView.textColor = self.textColor;
    self.weightPickerView.textColor = self.textColor;
    self.timePickerView.textColor = self.textColor;
}

- (void)setSelectionViewRadius:(CGFloat)selectionViewRadius {
    _selectionViewRadius = selectionViewRadius;
    self.selectionView.layer.cornerRadius = selectionViewRadius;
}

- (void)setSelectionViewShadowColor:(UIColor *)selectionViewShadowColor {
    _selectionViewShadowColor = selectionViewShadowColor;
    self.selectionView.layer.shadowColor = selectionViewShadowColor.CGColor;
}

- (void)setSelectionViewShadowOpacity:(CGFloat)selectionViewShadowOpacity {
    _selectionViewShadowOpacity = selectionViewShadowOpacity;
    self.selectionView.layer.shadowOpacity = selectionViewShadowOpacity;
}

- (void)setSelectionViewShadowRadius:(CGFloat)selectionViewShadowRadius {
    _selectionViewShadowRadius = selectionViewShadowRadius;
    self.selectionView.layer.shadowRadius = selectionViewShadowRadius;
}

- (void)setSelectionViewShadowOffset:(CGSize)selectionViewShadowOffset {
    _selectionViewShadowOffset = selectionViewShadowOffset;
    self.selectionView.layer.shadowOffset = selectionViewShadowOffset;
}
- (void)setSelectionViewBorderWidth:(CGFloat)selectionViewBorderWidth {
    _selectionViewBorderWidth = selectionViewBorderWidth;
    self.selectionView.layer.borderWidth = selectionViewBorderWidth;
    
}
- (void)setSelectionViewBorderColor:(UIColor *)selectionViewBorderColor {
    _selectionViewBorderColor = selectionViewBorderColor;
    self.selectionView.layer.borderColor = selectionViewBorderColor.CGColor;
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.view.layer.cornerRadius = radius;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.dosePickerView.font = font;
    self.weightPickerView.font = font;
    self.timePickerView.font = font;
}

- (void)setHighlightedFont:(UIFont *)highlightedFont {
    _highlightedFont = highlightedFont;
    self.dosePickerView.font = highlightedFont;
    self.weightPickerView.font = highlightedFont;
    self.timePickerView.font = highlightedFont;
}

- (void)setSelectionViewColor:(UIColor *)selectionViewColor {
    _selectionViewColor = selectionViewColor;
    self.selectionView.backgroundColor = selectionViewColor;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.leftSeparatorView.backgroundColor = separatorColor;
    self.rightSeparatorView.backgroundColor = separatorColor;
}

- (void)setMaskDisabled:(BOOL)maskDisabled {
    _maskDisabled = maskDisabled;
    self.dosePickerView.maskDisabled = maskDisabled;
    self.weightPickerView.maskDisabled = maskDisabled;
    self.timePickerView.maskDisabled = maskDisabled;
}

- (void)setSoundOn:(BOOL)soundOn {
    _soundOn = soundOn;
    self.dosePickerView.soundOn = soundOn;
    self.weightPickerView.soundOn = soundOn;
    self.timePickerView.soundOn = soundOn;
}

- (void)setPickerViewStyle:(MGUDosePickerViewStyle)pickerViewStyle {
    _pickerViewStyle = pickerViewStyle;
    self.dosePickerView.pickerViewStyle = pickerViewStyle;
    self.weightPickerView.pickerViewStyle = pickerViewStyle;
    self.timePickerView.pickerViewStyle = pickerViewStyle;
}

- (void)setNormalSoundPlayBlock:(void (^)(void))normalSoundPlayBlock {
    _normalSoundPlayBlock = normalSoundPlayBlock;
    if (self.pickerViews != nil) {
        for (MGUDosePickerView *pickerView in self.pickerViews) {
            pickerView.normalSoundPlayBlock = _normalSoundPlayBlock;
        }
    }
}


#pragma mark - 컨트롤
- (void)selectItemIndexes:(NSMutableArray <NSNumber *>*)itemIndexes animated:(BOOL)animated notify:(BOOL)notify {
    [self.dosePickerView selectItemIndex:[itemIndexes[0] unsignedIntegerValue] animated:animated notify:notify];
    [self.weightPickerView selectItemIndex:[itemIndexes[1] unsignedIntegerValue] animated:animated notify:notify];
    [self.timePickerView selectItemIndex:[itemIndexes[2] unsignedIntegerValue] animated:animated notify:notify];
}

- (void)selectItemTitles:(NSMutableArray <NSString *>*)itemTitles animated:(BOOL)animated notify:(BOOL)notify {
    NSArray *itemIndexes = @[@([self.dosePickerTitles indexOfObject:itemTitles[0]]),
                             @([self.weightPickerTitles indexOfObject:itemTitles[1]]),
                             @([self.timePickerTitles indexOfObject:itemTitles[2]])];
    [self selectItemIndexes:itemIndexes.mutableCopy animated:animated notify:notify];
}


#pragma mark - MGRHRPickerViewDataSource
- (NSUInteger)numberOfItemsInPickerView:(MGUDosePickerView *)pickerView {
    if (self.dosePickerView == pickerView) {
        return self.dosePickerTitles.count;
    } else if (self.weightPickerView == pickerView) {
        return self.weightPickerTitles.count;
    } else if (self.timePickerView == pickerView) {
        return self.timePickerTitles.count;
    }
    NSCAssert(FALSE, @"picker view가 없다.");
    return 0;
}

//! 데이터가 타이틀일 때. 본 앱에서는 image로 설정하지 않늗다. 따라서 데이터를 건내주는 델리게이트 메서드를 구현하지 않는다.
- (NSString *)pickerView:(MGUDosePickerView *)pickerView titleForItemIndex:(NSUInteger)item {
    if (self.dosePickerView == pickerView) {
        return self.dosePickerTitles[item];
    } else if (self.weightPickerView == pickerView) {
        return self.weightPickerTitles[item];
    } else if (self.timePickerView == pickerView) {
        return self.timePickerTitles[item];
    }
    NSCAssert(FALSE, @"picker view가 없다.");
    return nil;
}


#pragma mark - MGRHRPickerViewDelegate
- (void)pickerView:(MGUDosePickerView *)pickerView didSelectItemIndex:(NSUInteger)item {
    if (self.dosePickerView == pickerView) {
        if ( item == self.dosePickerTitles.count -1 ) { // None을 선택했다면, 모두 None이 되어야한다.
            [self.weightPickerView selectItemIndex:self.weightPickerTitles.count -1 animated:YES notify:NO];
            [self.timePickerView selectItemIndex:self.timePickerTitles.count -1 animated:YES notify:NO];
        } else if (self.timePickerView.selectedItemIndex == self.timePickerTitles.count - 1) { // None을 선택하지 않았는데, time이 none이라면 옮겨
            [self.timePickerView selectItemIndex:self.timePickerTitles.count-2 animated:YES notify:NO];
        }
        
    } else if (self.weightPickerView == pickerView) {
        if (item != self.weightPickerTitles.count -1) { // None을 선택하지 않았는데, dose와 picker는 None이 되어서는 안된다.
            if ( self.dosePickerView.selectedItemIndex == self.dosePickerTitles.count -1 ) { // none이면 옮긴다.
                [self.dosePickerView selectItemIndex:self.dosePickerTitles.count-2 animated:YES notify:NO];
            }
            if ( self.timePickerView.selectedItemIndex == self.timePickerTitles.count -1 ) { // none이면 옮긴다.
                [self.timePickerView selectItemIndex:self.timePickerTitles.count-2 animated:YES notify:NO];
            }
        }
        
    } else if (self.timePickerView == pickerView) {
        if ( item == self.timePickerTitles.count -1 ) { // None을 선택했다면, 모두 None이 되어야한다.
            [self.dosePickerView selectItemIndex:self.dosePickerTitles.count -1 animated:YES notify:NO];
            [self.weightPickerView selectItemIndex:self.weightPickerTitles.count -1 animated:YES notify:NO];
        } else if (self.dosePickerView.selectedItemIndex == self.dosePickerTitles.count - 1) { // None을 선택하지 않았는데, dose가  none이라면 옮겨
            [self.dosePickerView selectItemIndex:self.dosePickerTitles.count-2 animated:YES notify:NO];
        }
        
    }
    NSAttributedString *buttonTitle = resultPickerTitle(self.selectedDosePickerTitle,
                                                        self.selectedWeightPickerTitle,
                                                        self.selectedTimePickerTitle);
    
    
    
    if ([self.delegate respondsToSelector:@selector(pickerViewDidSelectItem:)]) {
        [self.delegate pickerViewDidSelectItem:buttonTitle];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerViewDidSelectTitles:)]) {
        [self.delegate pickerViewDidSelectTitles:@[self.selectedDosePickerTitle,
                                                   self.selectedWeightPickerTitle,
                                                   self.selectedTimePickerTitle]];
    }
    
    
    //
    // 규칙 1. dose가 none이면 모두 none이다. time이 none이면 모두 none이다. (따라서, weight가 none이 아니면 dose와 time 모두 none이 아니다.)
    // 규칙 2. dose가 none이 아니면 time은 none이 아니다.
    // 규칙 3. time가 none이 아니면 dose은 none이 아니다.
    // NSLog(@"%@ 가 선택되었다.", self.dosePickerTitles[item]);   <-- self.dosePickerView   == pickerView 일때
    // NSLog(@"%@ 가 선택되었다.", self.weightPickerTitles[item]); <-- self.weightPickerView == pickerView 일때
    // NSLog(@"%@ 가 선택되었다.", self.timePickerTitles[item]);   <-- self.timePickerView   == pickerView 일때
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{}


#pragma mark - 지원함수 but pulic
NSAttributedString * resultPickerTitle(NSString *dosePickerTitle, NSString *weightPickerTitle, NSString *timePickerTitle) {
    NSMutableString *selectTitle;
    if ([dosePickerTitle caseInsensitiveCompare:@"None"] == NSOrderedSame) {
        selectTitle = [NSMutableString stringWithString:@"None"];
    } else if ([weightPickerTitle caseInsensitiveCompare:@"None"] == NSOrderedSame) {
        selectTitle = [NSMutableString stringWithFormat:@"%@/%@", dosePickerTitle, timePickerTitle];
    } else {
        selectTitle = [NSMutableString stringWithFormat:@"%@/%@/%@", dosePickerTitle, weightPickerTitle, timePickerTitle];
    }
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:selectTitle];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *characterAttr = @{NSFontAttributeName            : [UIFont fontWithName:@"Futura-CondensedMedium" size:17.0f],
                                    NSForegroundColorAttributeName : UIColor.grayColor,
                                    NSParagraphStyleAttributeName  : paragraphStyle };
    
    NSDictionary *slashAttr = @{NSFontAttributeName            : [UIFont fontWithName:@"Futura-CondensedMedium" size:17.0f],
                                NSForegroundColorAttributeName : UIColor.blueColor,
                                NSParagraphStyleAttributeName  : paragraphStyle };
    
    [mutableAttributedString addAttributes:characterAttr range:NSMakeRange(0, selectTitle.length)];
    
    NSMutableArray <NSValue *>*slashRanges = [NSMutableArray arrayWithCapacity:2];
    
    NSString *temp = [selectTitle copy];
    
    while ([temp rangeOfString: @"/"].location != NSNotFound) {
        NSRange subRange = [temp rangeOfString: @"/"];
        [slashRanges addObject:[NSValue valueWithRange:subRange]];
        temp = [temp stringByReplacingCharactersInRange:subRange withString: @"X"];
    }
    
    for (NSValue *value in slashRanges) {
        NSRange range = [value rangeValue];
        [mutableAttributedString addAttributes:slashAttr range:range];
    }
    
    return mutableAttributedString;
    //
    // [UIFont fontWithName:@"Futura-Medium" size:17.0f];  [UIFont fontWithName:@"Futura-CondensedMedium" size:17.0f];
    // pickerButtonTitle을 함수로 제공하는 이유는 MGRPickerViewController를 컨트롤하는 컨트롤러가 MGRPickerViewController 초기화 하지 않은 상태에서도
    // 자신의 picker button title을 설정할 수 도 있기 때문이다.
}

@end
