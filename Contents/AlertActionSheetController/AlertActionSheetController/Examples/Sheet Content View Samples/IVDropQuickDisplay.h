//
//  IVDropQuickDisplay.h
//
//  Created by Kwan Hyun Son on 2020/12/22.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//
// 자체 높이가 56정도 된다.

#import <UIKit/UIKit.h>
@class IVDropQuickModel;

NS_ASSUME_NONNULL_BEGIN

// display 모양은 일반적인 스타일, 키보드가 달릴때 모양, 시간이 나올때에 따라 레이아웃의 변화가 존재한다.
typedef NS_ENUM(NSUInteger, IVDropQuickDisplayType) {
    IVDropQuickDisplayTypeDefault = 1,
    IVDropQuickDisplayTypeKeyboard,
    IVDropQuickDisplayTypeTime
};

@interface IVDropQuickDisplay : UIView
@property (nonatomic, strong) UIImageView *symbolImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *firstValueLabel;
@property (nonatomic, strong) UILabel *firstUnitLabel;
@property (nonatomic, strong) UILabel *secondValueLabel;
@property (nonatomic, strong) UILabel *secondUnitLabel;

- (void)setFirstValueString:(NSString *)str1 secondValueString:(NSString * _Nullable)str2;

- (instancetype)initWithFrame:(CGRect)frame
                   quickModel:(IVDropQuickModel *)quickModel NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
