//
//  IVDropQuickView.h
//
//  Created by Kwan Hyun Son on 2020/12/23.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVDropQuickDisplay.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, IVDropQuickType) {
    IVDropQuickTypeDose = 1, // medi, bag
    IVDropQuickTypeMedication,
    IVDropQuickTypeBagVol,
    IVDropQuickTypeWeight,
    IVDropQuickTypeChamber,
    IVDropQuickTypeTime
};

@interface IVDropQuickModel : NSObject
@property (nonatomic, assign) IVDropQuickType quickType;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *unitName;
- (instancetype)initWithQuickType:(IVDropQuickType)quickType
                            value:(CGFloat)value
                         maxValue:(CGFloat)maxValue
                            title:(NSString *)title
                         unitName:(NSString *)unitName;
@end

@interface IVDropQuickView : UIView

- (instancetype)initWithFrame:(CGRect)frame quickModel:(IVDropQuickModel *)quickModel NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
