//
//  FavCell.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "FavCell.h"
#import "FavCellModel.h"

@interface FavCell ()

//! 닙으로 초기화함.
@property (nonatomic, strong) IBOutlet UIView *topLevelContainer; // 닙으로부터 불러온다. 가장 큰 덩어리. 이것을 붙인다. top level 이므로 strong
@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *rightContainer;
@property (weak, nonatomic) IBOutlet UIView *centerContainer;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray <UIView *>*nibContainers;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@end

@implementation FavCell

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
}


#pragma mark - 생성 & 소멸
static void CommonInit(FavCell *self) {
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.layer.shouldRasterize = YES;
    self.contentView.layer.rasterizationScale = UIScreen.mainScreen.scale;
    self.contentView.layer.shadowColor = UIColor.clearColor.CGColor;
    self.contentView.layer.shadowRadius = 0.0;
    self.contentView.layer.shadowOpacity = 0.0;
    self.contentView.layer.shadowOffset = CGSizeZero;
    self.backgroundColor = UIColor.clearColor;
    [self setupNIBObject];
}

- (void)setupNIBObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    [bundle loadNibNamed:[NSString stringWithFormat:@"_%@", NSStringFromClass([FavCell class])]
                   owner:self
                 options:nil]; //! 반환되는 배열이 존재한다.
    [self.contentView addSubview:self.topLevelContainer];
    [self.topLevelContainer mgrPinEdgesToSuperviewEdges];
    
    //! 닙에서 초기화된 컨테이너의 배경색을 clear color 로 설정하자.
    for (UIView *view in self.nibContainers) {
        view.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Action
- (void)setData:(FavCellModel *)data {
    self.leftLabel.text = data.leftValue;
    self.rightLabel.text = data.rightValue;
    self.centerLabel.text = data.mainDescription;
}


#pragma mark - Helper

@end
