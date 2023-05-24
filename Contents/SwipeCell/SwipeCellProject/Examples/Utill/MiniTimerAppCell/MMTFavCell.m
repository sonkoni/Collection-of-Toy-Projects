//
//  MMTFavCell.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "MMTFavCell.h"
#import "FavCellBackgroundView.h"
#import "MMTFavCellModel.h"

@interface MMTFavCell ()

//! 닙으로 초기화함.
@property (nonatomic, strong) IBOutlet UIView *topLevelContainer; // 닙으로부터 불러온다. 가장 큰 덩어리. 이것을 붙인다. top level 이므로 strong
@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *rightContainer;
@property (weak, nonatomic) IBOutlet UIView *centerContainer;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray <UIView *>*nibContainers;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@property (strong, nonatomic) FavCellBackgroundView *favCellBackgroundView;
@end

@implementation MMTFavCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ___commonInit];
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
//    self.backgroundColor = [UIColor systemRedColor];
}

- (void)didRemoveActionsView:(UIView *)actionsView {
    [super didRemoveActionsView:actionsView];
    self.layer.shadowOpacity = 0.5;
//    self.backgroundColor = [UIColor clearColor];
}


#pragma mark - 생성 & 소멸
- (void)___commonInit {
    self.backgroundColor = UIColor.clearColor;
    self.clip = NO; // cell 밖으로 밀려나는 모습이 가능하다.
    self.cornerRadius = 10.0;
    self.swipeableContentView.layer.cornerRadius = 10.0;
    
    _favCellBackgroundView = [FavCellBackgroundView new];
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
    [bundle loadNibNamed:[NSString stringWithFormat:@"_%@", NSStringFromClass([MMTFavCell class])]
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
- (void)setData:(MMTFavCellModel *)data {
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
