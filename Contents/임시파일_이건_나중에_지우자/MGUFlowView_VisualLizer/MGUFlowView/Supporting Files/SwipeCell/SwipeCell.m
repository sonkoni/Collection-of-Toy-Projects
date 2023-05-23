//
//  SwipeCell.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "SwipeCell.h"
#import "SwipeCellBackgroundView.h"
#import "SwipeCellModel.h"

@interface SwipeCell ()

//! 닙으로 초기화함.
@property (nonatomic, strong) IBOutlet UIView *topLevelContainer; // 닙으로부터 불러온다. 가장 큰 덩어리. 이것을 붙인다. top level 이므로 strong
@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *rightContainer;
@property (weak, nonatomic) IBOutlet UIView *centerContainer;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray <UIView *>*nibContainers;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@property (strong, nonatomic) SwipeCellBackgroundView *SwipeCellBackgroundView;
@end

@implementation SwipeCell

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
    self.backgroundColor = [UIColor systemRedColor];
}

- (void)didRemoveActionsView:(UIView *)actionsView {
    [super didRemoveActionsView:actionsView];
    self.layer.shadowOpacity = 0.5;
    self.backgroundColor = [UIColor clearColor];
}

- (void)dragStateDidChange:(UICollectionViewCellDragState)dragState {
    [super dragStateDidChange:dragState];
    //! 리프팅만하고 놔버릴 경우. 내려진 상태를 디텍팅할 방법이 이것 뿐이다.
    if (dragState == UICollectionViewCellDragStateNone) {
        UICollectionView *collectionView = [self mgrRecurrenceSuperviewsOfType:[UICollectionView class]];
        [collectionView.dropDelegate collectionView:collectionView dropSessionDidEnd:(id<UIDropSession>)[NSNull null]];
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(SwipeCell *self) {
    self.backgroundColor = UIColor.clearColor;
    
    self.clip = NO; // cell 밖으로 밀려나는 모습이 가능하다.
    self.cornerRadius = 10.0;
//    self.layer.cornerRadius = 11.0;
    self->_SwipeCellBackgroundView = [SwipeCellBackgroundView new];
    self.SwipeCellBackgroundView.cornerRadius = 10.0;
    [self.swipeableContentView addSubview:self.SwipeCellBackgroundView];
    [self.SwipeCellBackgroundView mgrPinEdgesToSuperviewEdges];
    
    [self setupNIBObject];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(-1.0, 1.0);
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 0.5;
    [self updateShadowPath];
}

- (void)setupNIBObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    [bundle loadNibNamed:[NSString stringWithFormat:@"_%@", NSStringFromClass([SwipeCell class])]
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
- (void)setData:(SwipeCellModel *)data {
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
