//
//  MiniTimerCell.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MiniTimerCell.h"
#import "MiniTimerCellModel.h"

/*!
 @class      FavCellBackgroundView
 @abstract   인너쉐도우 아웃터 쉐도우 및 여러가지 그래디언트가 존재하여 따로 만들게 되었다.
 */
@interface MiniTimerCellBackgroundView : UIView
@property (nonatomic, assign) CGFloat cornerRadius;
@end

@interface MiniTimerCell ()

//! 닙으로 초기화함.
@property (nonatomic, strong) IBOutlet UIView *topLevelContainer; // 닙으로부터 불러온다. top level 이므로 strong
@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *rightContainer;
@property (weak, nonatomic) IBOutlet UIView *centerContainer;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray <UIView *>*nibContainers;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (strong, nonatomic) MiniTimerCellBackgroundView *favCellBackgroundView;
@end

@implementation MiniTimerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShadowPath];
}

- (void)didAddActionsView:(UIView *)actionsView {
    [super didAddActionsView:actionsView];
    self.layer.shadowOpacity = 0.0;
}

- (void)didRemoveActionsView:(UIView *)actionsView {
    [super didRemoveActionsView:actionsView];
    self.layer.shadowOpacity = 0.5;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MiniTimerCell *self) {
    self.backgroundColor = UIColor.clearColor;
    self.clip = NO; // cell 밖으로 밀려나는 모습이 가능하다.
    self.cornerRadius = 10.0;
    self.swipeableContentView.layer.cornerRadius = 10.0;
    
    self->_favCellBackgroundView = [MiniTimerCellBackgroundView new];
    self.favCellBackgroundView.cornerRadius = 10.0;
    [self.swipeableContentView addSubview:self.favCellBackgroundView];
    [self.favCellBackgroundView mgrPinEdgesToSuperviewEdges];
    
    [self setupNIBObject];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(-1.0, 1.0);
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 0.5;
    [self updateShadowPath];
}

- (void)setupNIBObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    [bundle loadNibNamed:[NSString stringWithFormat:@"%@_", NSStringFromClass([MiniTimerCell class])]
                   owner:self
                 options:nil]; //! 반환되는 배열이 존재한다.
    
    [self.swipeableContentView addSubview:self.topLevelContainer];
    [self.topLevelContainer mgrPinEdgesToSuperviewEdges];
    
    //! 닙에서 초기화된 컨테이너의 배경색을 clear color 로 설정하자.
    for (UIView *view in self.nibContainers) {
        view.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Action
- (void)setData:(MiniTimerCellModel *)data {
    self.leftLabel.text = data.leftValue;
    self.rightLabel.text = data.rightValue;
    self.centerLabel.text = data.mainDescription;
}


#pragma mark - Helper
- (void)updateShadowPath {
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds
                                                  byRoundingCorners:UIRectCornerAllCorners
                                                        cornerRadii:CGSizeMake(self.layer.cornerRadius,
                                                                               self.layer.cornerRadius)].CGPath;
}

@end


//! private class
@interface MiniTimerCellBackgroundView ()
@property (nonatomic, strong) UIView *outContainer;
@property (nonatomic, strong) UIView *inContainer;

//! Inner Part
@property (nonatomic, strong) UIView *noiseView;
@property (nonatomic, strong) MGEGradientView *gradientView;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayer1;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayer2;
@end

@implementation MiniTimerCellBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        [self setupOutContainer];
        [self setupInContainer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.outContainer layoutIfNeeded];
    [self.inContainer layoutIfNeeded];
    self.innerShadowLayer1.frame = self.inContainer.layer.bounds;
    self.innerShadowLayer2.frame = self.inContainer.layer.bounds;
}


#pragma mark - 생성 & 소멸
- (void)setupOutContainer {
    _outContainer = [UIView new];
    self.outContainer.backgroundColor = [UIColor clearColor]; // clear 하고 path 로 그려야 삐져나오는 일이 발생하지 않는다.
    self.outContainer.clipsToBounds = NO;
    self.outContainer.layer.masksToBounds = NO;
    [self insertSubview:self.outContainer atIndex:0];
    [self.outContainer mgrPinEdgesToSuperviewEdges];
}

- (void)setupInContainer {
    _inContainer = [UIView new];
    self.inContainer.backgroundColor = [UIColor clearColor];
    self.inContainer.clipsToBounds = YES;
    self.inContainer.layer.masksToBounds = YES;
    [self addSubview:self.inContainer];
    [self.inContainer mgrPinEdgesToSuperviewEdges];
    
    _noiseView = [UIView new]; // 노이즈
    self.noiseView.backgroundColor = [[UIColor whiteColor] mgrColorWithNoiseWithOpacity:0.05
                                                                           andBlendMode:kCGBlendModeNormal];
    [self.inContainer addSubview:self.noiseView];
    [self.noiseView mgrPinEdgesToSuperviewEdges];
    
    _gradientView = [MGEGradientView new];
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:0.5]; // white
    UIColor *endColor = [UIColor colorWithWhite:0.0 alpha:0.5]; // black
    self.gradientView.colors = @[startColor, endColor];
    
    self.gradientView.gradientLayer.startPoint = CGPointMake(1.0, 0.0);
    self.gradientView.gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    self.gradientView.alpha = 0.1;
    
    [self.inContainer addSubview:self.gradientView];
    [self.gradientView mgrPinEdgesToSuperviewEdges];
    
    _innerShadowLayer1 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.1].CGColor
                                                             innerShadowOffset:CGSizeMake(2.0, -2.0)
                                                         innerShadowBlurRadius:2.0];
    self.innerShadowLayer1.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayer1.frame = self.inContainer.layer.bounds;
    [self.inContainer.layer addSublayer:self.innerShadowLayer1];
    
    _innerShadowLayer2 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor
                                                             innerShadowOffset:CGSizeMake(-2.0, 2.0)
                                                         innerShadowBlurRadius:1.0];
    self.innerShadowLayer2.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayer2.frame = self.inContainer.layer.bounds;
    [self.inContainer.layer addSublayer:self.innerShadowLayer2];
}


#pragma mark - 세터 & 게터
- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        self.outContainer.layer.cornerRadius = cornerRadius;
        self.inContainer.layer.cornerRadius = cornerRadius;
        self.innerShadowLayer1.cornerRadius = cornerRadius;
        self.innerShadowLayer2.cornerRadius = cornerRadius;
        [self setNeedsLayout];
    }
}

@end
