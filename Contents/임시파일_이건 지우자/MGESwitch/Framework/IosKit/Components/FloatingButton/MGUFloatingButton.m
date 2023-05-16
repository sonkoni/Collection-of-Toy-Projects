//
//  MGUFloatingButton.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGUFloatingButton.h"
#import "MGUFloatingButton+Animation.h"
#import "MGUFloatingButtonStyles.h"
#import "UIApplication+Extension.h"

@interface MGUFloatingButton ()
//! 오직 하나의 싱글 버튼(튀어 오르는 아이템 없이)일 경우를 위한 프라퍼티이다.
@property (nonatomic, assign) BOOL onlySingleButton;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) MGUFloatingItem *singleItem;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *>*dynamicConstraints;
@property (nonatomic, strong, readonly) NSArray <NSLayoutConstraint *>*imageSizeConstraints; // @dynamic
@end

@implementation MGUFloatingButton
@synthesize highlightedButtonColor = _highlightedButtonColor;
@dynamic buttonImageColor;
@dynamic enabledItems;
@dynamic imageSizeConstraints;

//===== LayerProperties Dynamic =======
@dynamic shadowColor;
@dynamic shadowOffset;
@dynamic shadowOpacity;
@dynamic shadowRadius;

//===== MGUFloatingButtonAnimationConfig Dynamic ======
// MGUFloatingButtonAnimationConfig??? 에서 사용되는 Dynamic property
@dynamic isOnLeftSideOfScreen;

//! 지정 초기화한다. : 코드로 초기화할 때.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
    //
    // [[MGUFloatingButton alloc] init] 을 호출하면 - initWithFrame: 메서드가 호출된다!
}

//! 지정 초기화한다. : XIB로 초기화 할때.
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.buttonDiameter, self.buttonDiameter);
}

//! 터치시 작동한다. : touchDown 일때는 인수가 YES touchUp 일때는 인수가 NO
- (void)setHighlighted:(BOOL)highlighted {
    super.highlighted = highlighted;
    if (highlighted == YES) {
        self.circleView.backgroundColor = self.highlightedButtonColor;
    } else {
        self.circleView.backgroundColor = self.buttonColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius    = self.frame.size.height / 2.0;
    self.circleView.layer.cornerRadius = self.bounds.size.height / 2.0;
//    self.circleView.frame = self.bounds;
    
//    CGFloat imageSizeMuliplier = 3.0 / 7.0f;
//    CGFloat imageViewWidth     = self.bounds.size.width * imageSizeMuliplier;
//    CGFloat imageViewOriginX   = (self.bounds.size.width - imageViewWidth) / 2.0;
//    self.imageView.frame       = CGRectMake(imageViewOriginX, imageViewOriginX, imageViewWidth, imageViewWidth);
}

- (void)updateConstraints {
    [self updateDynamicConstraints];
    [super updateConstraints];
}

#pragma mark - 생성 & 소멸
//! 오직 하나의 액션버튼을 초기화한다 : 튀어오르는 버튼이 없다.
- (instancetype)initOnlyActionButtonWithTitle:(NSString *_Nullable)title
                                        image:(UIImage *_Nullable)image
                                  actionBlock:(MGRFloatingActionBlock _Nullable)actionBlock {
    self = [self init]; // - initWithFrame: 이 호출된다. ∵ 지정초기화
    if (self) {
        if(image != nil) {
            self.buttonImage = image;
        }
        _onlySingleButton = YES;
        _title = title;
        
        _singleItem = [MGUFloatingItem new];
        self.singleItem.titleLabel.text = title;
        self.singleItem.imageView.image = image;
        self.singleItem.actionBlock = actionBlock;
    }
    return self;
    //
    // 일반적으로 튀어오르는 버튼으로 만들기 위해서는 최초에 init로 초기화하면된다.
}

- (void)commonInit {
    _buttonDiameter = 56.0f;
    _buttonState    = MGRFloatingActionButtonStateClosed;
    _items          = [NSMutableArray array];
    _onlySingleButton = NO;
    _itemSizeRatio    = 0.75;
    _buttonImageSize = CGSizeZero;
    _dynamicConstraints = [NSMutableArray array];
    _closeAutomatically = YES;
    
    _buttonAnimationConfiguration = [[MGUFloatingButtonAnimationConfig alloc] initWithRotationAngle:-M_PI / 4.0f];
    _itemAnimationConfiguration   = [[MGUFloatingItemAnimationConfig alloc] initWithItemSpaceForPopUp:12.0f];
    
    self.backgroundColor     = UIColor.clearColor;
    
    //! 프라퍼티로 접근해야한다. 그래야 self.background를 바꾼다.
    self.buttonColor         = [MGUFloatingButtonStyles shared].defaultButtonColor;
    
    self.clipsToBounds       = NO;
    self.userInteractionEnabled = YES;
    [self addTarget:self action:@selector(buttonWasTapped) forControlEvents:UIControlEventTouchUpInside];
    self.layer.shadowColor   = [MGUFloatingButtonStyles shared].defaultShadowColor.CGColor;
    self.layer.shadowOffset  = CGSizeMake(0.0, 1.0);
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowRadius  = 2.0f;
    
    [self addSubview:self.circleView];
    [self.circleView addSubview:self.imageView];
    
    self.buttonImage = [MGUFloatingButtonStyles shared].plusImage;
    [self createStaticConstraints];
}

//! Action Item 을 설정한다
- (MGUFloatingItem *)addItem:(NSString *_Nullable)title
                       image:(UIImage *_Nullable)image
                 actionBlock:(MGRFloatingActionBlock _Nullable)actionBlock {

    MGUFloatingItem *item = [MGUFloatingItem new];
    item.titleLabel.text = title;
    item.imageView.image = image;
    item.actionBlock = actionBlock;
    
    [self.items addObject:item];
    [self setupItem:item];
    return item;
    //
    // 뿅뿅 튀어나오는 각 아이템이다.
}

- (void)setupItem:(MGUFloatingItem *)item {
    item.imageView.tintColor = self.buttonColor;
    item.layer.shadowColor = self.layer.shadowColor;
    item.layer.shadowOpacity = self.layer.shadowOpacity;
    item.layer.shadowOffset = self.layer.shadowOffset;
    item.layer.shadowRadius = self.layer.shadowRadius;
    
    [item addTarget:self action:@selector(itemWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.itemConfiguration != nil) {
        self.itemConfiguration(item);
    }
}

- (void)displayInView:(UIView *)superview onPosition:(MGUFloatingButtonPosition)position {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (position) {
        case MGUFloatingButtonPositionLeftUp: {
            [self.leadingAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.leadingAnchor constant:16.0].active = YES;
            [self.topAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.topAnchor constant:16.0].active = YES;
            break;
        }
        case MGUFloatingButtonPositionLeftDown: {
            [self.leadingAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.leadingAnchor constant:16.0].active = YES;
            [self.bottomAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.bottomAnchor constant:-16.0].active = YES;
            break;
        }
        case MGUFloatingButtonPositionRightDown: {
            [self.trailingAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.trailingAnchor constant:-16.0].active = YES;
            [self.bottomAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.bottomAnchor constant:-16.0].active = YES;
            break;
        }
        case MGUFloatingButtonPositionRightUp: {
            [self.trailingAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.trailingAnchor constant:-16.0].active = YES;
            [self.topAnchor constraintEqualToAnchor:superview.safeAreaLayoutGuide.topAnchor constant:16.0].active = YES;
            break;
        }
        default:
            break;
    }
}

- (void)createStaticConstraints {
    self.circleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.circleView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.circleView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.circleView.widthAnchor constraintEqualToAnchor:self.circleView.heightAnchor].active = YES;
    [self.circleView.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor].active = YES;
    [self.circleView.heightAnchor constraintLessThanOrEqualToAnchor:self.heightAnchor].active = YES;
    NSLayoutConstraint *widthConstraint = [self.circleView.widthAnchor constraintEqualToAnchor:self.widthAnchor];
    widthConstraint.priority =  UILayoutPriorityDefaultHigh;
    widthConstraint.active = YES;
    NSLayoutConstraint *heightConstraint = [self.circleView.heightAnchor constraintEqualToAnchor:self.heightAnchor];
    heightConstraint.priority =  UILayoutPriorityDefaultHigh;
    heightConstraint.active = YES;

    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [self.circleView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.circleView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
}

- (void)updateDynamicConstraints {
    [NSLayoutConstraint deactivateConstraints:self.dynamicConstraints];
    [self.dynamicConstraints removeAllObjects];
    [self createDynamicConstraints];
    [NSLayoutConstraint activateConstraints:self.dynamicConstraints];
    [self setNeedsLayout];
}

- (void)createDynamicConstraints {
    [self.dynamicConstraints addObjectsFromArray:self.imageSizeConstraints];
}


#pragma mark - 세터 & 게터
//! 튀어올라오는 버튼을 통으로 담고 있는 뷰이다.
- (UIView *)itemContainerView {
    if (_itemContainerView == nil) {
        _itemContainerView = [UIView new];
        _itemContainerView.userInteractionEnabled = YES;
        _itemContainerView.backgroundColor = UIColor.clearColor;
        _itemContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _itemContainerView;
    //
    // 이 뷰는 self의 수퍼뷰에 붙을 것이다.
    // 즉, self의 수퍼뷰에 붙으면서 self 아래에 overlayView 위쪽에 위치하게 될 것이며
    // itemContainerView는 MGUFloatingItem 들에 대한 superView가 될 것이다.
}

- (void)setButtonDiameter:(CGFloat)buttonDiameter {
    _buttonDiameter = buttonDiameter;
    [self invalidateIntrinsicContentSize];
}

//! 잘 안쓸듯.
- (void)setItems:(NSMutableArray<MGUFloatingItem *> *)items {
    _items = items;
    for (MGUFloatingItem *item in items) {
        [self setupItem:item];
    }
}

- (UIView *)circleView {
    if (_circleView == nil) {
        _circleView = [UIView new];
        _circleView.userInteractionEnabled = NO;
        _circleView.backgroundColor = [MGUFloatingButtonStyles shared].defaultButtonColor;
    }
    
    return _circleView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = NO;
        _imageView.backgroundColor = UIColor.clearColor;
        _imageView.tintColor = [MGUFloatingButtonStyles shared].defaultButtonImageColor;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _imageView;
}

//! 뒤에 깔리는 배경에 해당되는 뷰로, 버튼이 클릭되면 뒷 배경을 검게 만든다.
- (UIControl *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [UIControl new];
        _overlayView.userInteractionEnabled = YES;
        _overlayView.backgroundColor = [MGUFloatingButtonStyles shared].defaultOverlayColor;
        [_overlayView addTarget:self action:@selector(overlayViewWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        _overlayView.enabled = NO;
        _overlayView.alpha = 0.0;
    }
    return _overlayView;
    //
    // 이 뷰는 self의 수퍼뷰에 붙을 것이다.
    // 즉, self의 수퍼뷰에 붙으면서 self 아래에 그리고 itemContainerView 아래에 위치할 것이다.
}

//! self.imageView.image는 트랜지션 애니메이션으로 변한다. buttonImage 프라퍼티를 이용하여 오고간다.
- (void)setButtonImage:(UIImage *)buttonImage {
    _buttonImage = buttonImage;
    self.imageView.image = _buttonImage;
}

- (void)setButtonImageSize:(CGSize)buttonImageSize {
    _buttonImageSize = buttonImageSize;
    [self setNeedsUpdateConstraints];
}

//=====  Dynamic Propertys =======
- (NSMutableArray <MGUFloatingItem *>*)enabledItems {
    NSMutableArray *result = [NSMutableArray array];
    for ( MGUFloatingItem * item in self.items ) {
        if ( item.hidden == NO && item.userInteractionEnabled == YES) {
            [result addObject:item];
        }
    }
    return result;
}

- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor =  buttonColor;
    self.circleView.backgroundColor = _buttonColor;
}

- (void)setHighlightedButtonColor:(UIColor *)highlightedButtonColor {
    _highlightedButtonColor = highlightedButtonColor;
}

- (UIColor *)highlightedButtonColor {
    if(_highlightedButtonColor == nil) {
        _highlightedButtonColor = transHighlightedColor(self.buttonColor);
    }
    return _highlightedButtonColor;
}

- (void)setButtonImageColor:(UIColor *)buttonImageColor {
    self.imageView.tintColor = buttonImageColor;
}

- (UIColor *)buttonImageColor {
    return self.imageView.tintColor;
}

- (NSArray <NSLayoutConstraint *>*)imageSizeConstraints {
    if (CGSizeEqualToSize(self.buttonImageSize, CGSizeZero) == YES) {
        CGFloat multiplier = 1.0 / sqrt(2.0);
        return @[[self.imageView.widthAnchor constraintLessThanOrEqualToAnchor:self.circleView.widthAnchor
                                                                    multiplier:multiplier],
                 [self.imageView.heightAnchor constraintLessThanOrEqualToAnchor:self.circleView.heightAnchor
                                                                     multiplier:multiplier]];
    } else {
        return @[[self.imageView.widthAnchor constraintEqualToConstant:self.buttonImageSize.width],
                 [self.imageView.heightAnchor constraintEqualToConstant:self.buttonImageSize.height]];
    }
}

//===== LayerProperties Dynamic =======
- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)shadowColor {
    if (self.layer.shadowColor == nil) {
        return nil;
    } else {
        return [UIColor colorWithCGColor:self.layer.shadowColor];
    }
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}


//===== JJButtonAnimationConfiguration Dynamic ======
// JJButtonAnimationConfiguration 에서 사용되는 Dynamic property
- (BOOL)isOnLeftSideOfScreen {
    UIView *superView = [UIApplication mgrKeyWindow];
    
    CGPoint point = [self convertPoint:self.center toCoordinateSpace:superView];
    
    if (point.x < (superView.bounds.size.width / 2.0f)) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 컨트롤
- (void)overlayViewWasTapped:(UIControl *)overlayView {
    [self closeAnimated:YES];
}

- (void)itemWasTapped:(MGUFloatingItem *)item {
    if (self.buttonState != MGRFloatingActionButtonStateOpen && self.buttonState != MGRFloatingActionButtonStateOpening) {
        return;
    }
    
    if (self.closeAutomatically == YES) {
        [self closeAnimated:YES];
    }
    [item callAction];
}

- (void)buttonWasTapped {
    if ( self.buttonState == MGRFloatingActionButtonStateOpen || self.buttonState == MGRFloatingActionButtonStateOpening) {
        [self closeAnimated:YES];
    } else if ( self.buttonState == MGRFloatingActionButtonStateClosed ) {
        if (self.onlySingleButton == NO) {
            [self openAnimated:YES];
        } else {
            [self handleSingleAction];
        }
    }
}

- (void)setItemConfiguration:(void (^)(MGUFloatingItem *))defaultItemConfiguration {
    _itemConfiguration = defaultItemConfiguration;
    if (_itemConfiguration != nil) {
        for (MGUFloatingItem *item in self.items) {
            self.itemConfiguration(item);
        }
    }
}

- (void)handleSingleAction {
    [self.singleItem callAction];
}

@end
