//
//  LogCell.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
@import IosKit;
#import "LogCell.h"
#import "LogCellModel.h"

@interface LogCell ()
@property (nonatomic, strong) MGEInvertStrokeMaskLayer *dashedMaskLayer;

//! 닙으로 초기화함.
@property (nonatomic, strong) IBOutlet UIView *topLevelContainer; // 닙으로부터 불러온다. 가장 큰 덩어리. 이것을 붙인다. top level 이므로 strong
@property (weak, nonatomic) IBOutlet UIView *leftCheckContainer;
@property (weak, nonatomic) IBOutlet UIView *rightCheckContainer;
@property (weak, nonatomic) IBOutlet UIView *leftTimeContainer;
@property (weak, nonatomic) IBOutlet UIView *leftAMPMContainer; // ante meridiem, post meridiem "앤티 머리디엄" "포우스트 머리디엄"
@property (weak, nonatomic) IBOutlet UIView *centerTextContainer;
@property (weak, nonatomic) IBOutlet UIView *centerLevelContainer;
@property (weak, nonatomic) IBOutlet UIView *rightDateContainer;
@property (weak, nonatomic) IBOutlet UIView *rightDayOfWeekContainer;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray <UIView *>*nibContainers;
@property (weak, nonatomic) IBOutlet UIStackView *gageStackView;

@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAMPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDayOfWeekLabel;

@property (strong, nonatomic) UIView *centerGageView;
@property (strong, nonatomic) UIView *leftCheckView;
@property (strong, nonatomic) UIView *rightCheckView;
@end

@implementation LogCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.dashedMaskLayer.frame, self.layer.bounds) == NO) {
        self.dashedMaskLayer.frame = self.layer.bounds;
        CGPathRef dashedPath = [self newUpdateMaskLayer:CGRectMake(0.0,
                                                                0.0,
                                                                self.layer.bounds.size.width,
                                                                self.layer.bounds.size.height)];
        self.dashedMaskLayer.path = dashedPath;
        CGPathRelease(dashedPath);
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(LogCell *self) {
    self.contentView.layer.masksToBounds = NO;
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.layer.shouldRasterize = YES;
    self.contentView.layer.rasterizationScale = UIScreen.mainScreen.scale;
    self.contentView.layer.shadowColor = UIColor.clearColor.CGColor;
    self.contentView.layer.shadowRadius = 0.0;
    self.contentView.layer.shadowOpacity = 0.0;
    self.contentView.layer.shadowOffset = CGSizeZero;
    
    self.backgroundColor = UIColor.clearColor;
    
    CGRect frame = self.layer.bounds;
    self->_dashedMaskLayer = [MGEInvertStrokeMaskLayer layer];
    self.dashedMaskLayer.frame = frame;
    self.layer.mask = self.dashedMaskLayer;
    self.dashedMaskLayer.lineWidth = 1.0;

    CGPathRef dashedPath = [self newUpdateMaskLayer:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
    self.dashedMaskLayer.path = dashedPath;
    CGPathRelease(dashedPath);
    [self setupNIBObject];
}

- (void)setupNIBObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    [bundle loadNibNamed:[NSString stringWithFormat:@"_%@", NSStringFromClass([LogCell class])]
                   owner:self
                 options:nil]; //! 반환되는 배열이 존재한다.
    [self.contentView addSubview:self.topLevelContainer];
    [self.topLevelContainer mgrPinEdgesToSuperviewEdges];
    //! 닙에서 초기화된 컨테이너의 배경색을 clear color 로 설정하자.
    for (UIView *view in self.nibContainers) {
        view.backgroundColor = [UIColor clearColor];
    }
    
    for (UIView *view in self.gageStackView.arrangedSubviews) {
        view.backgroundColor = [UIColor clearColor]; // 컨테이너!
        UIView *gage = [UIView new];
        [view addSubview:gage];
        [gage mgrPinEdgesToSuperviewEdges];
        gage.backgroundColor = [UIColor blackColor];
        gage.alpha = 0.0;
        gage.layer.cornerRadius = 2.0;
    }
    
    _leftCheckView = [UIView new];
    _rightCheckView = [UIView new];
    self.leftCheckView.backgroundColor = [UIColor blackColor];
    self.rightCheckView.backgroundColor = [UIColor blackColor];
    [self.leftCheckContainer addSubview:self.leftCheckView];
    [self.rightCheckContainer addSubview:self.rightCheckView];
    CGFloat diameter = self.leftCheckContainer.frame.size.width / 2.0;
    CGSize checkSize = CGSizeMake(diameter, diameter);
    [self.rightCheckView mgrPinCenterToSuperviewCenterWithFixSize:checkSize];
    [self.leftCheckView mgrPinCenterToSuperviewCenterWithFixSize:checkSize];
    self.rightCheckView.layer.cornerRadius = diameter / 2.0;
    self.leftCheckView.layer.cornerRadius = diameter / 2.0;
}

#pragma mark - Action
- (void)setData:(LogCellModel *)data {
    self.leftTimeLabel.text = data.time;
    self.leftAMPMLabel.text = data.anteMeridiemPostMeridiem;
    self.centerTextLabel.text = data.mainDescription;
    self.rightDateLabel.text = data.date;
    self.rightDayOfWeekLabel.text = data.dayOfWeek;

    NSInteger level = data.level;
    NSArray <UIView *>*arrangedSubviews = self.gageStackView.arrangedSubviews;
    NSInteger count = arrangedSubviews.count;
    for (NSInteger i = 1; i <= count; i++ ) { // 1 <= ~ <= 12
        UIView *gage = arrangedSubviews[i-1].subviews.firstObject; // arrangedSubviews[i-1] 자체가 컨테이너이다.
        if (i <= level) {
            gage.alpha = 1.0;
        } else {
            gage.alpha = 0.0;
        }
    }
}


#pragma mark - Helper
//! dash line을 제외한 영역을 마스크로 사용하기 위함이다.
- (CGPathRef)newUpdateMaskLayer:(CGRect)rect {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    CGFloat lengths[2] = {2.0, 2.0};
    return CGPathCreateCopyByDashingPath(bezierPath.CGPath,
                                         NULL, // transform
                                         0,    // phase : offset 과 같은 의미.
                                         lengths,
                                         2);
}

@end
