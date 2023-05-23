//
//  FavCellModel.h
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h> /* for CGFloat, CGMacro */

NS_ASSUME_NONNULL_BEGIN

@interface FavCellModel : NSObject

//! left
@property (nonatomic, strong) NSString *leftValue;

//! center
@property (nonatomic, strong) NSString *mainDescription;

//! left
@property (nonatomic, strong) NSString *rightValue;

- (instancetype)initWithMainDescription:(NSString * _Nullable)mainDescription
                              leftValue:(NSString * _Nullable)leftValue
                             rightValue:(NSString * _Nullable)rightValue NS_DESIGNATED_INITIALIZER;

//! Convenience initializer
+ (instancetype)favCellModelWithMainDescription:(NSString * _Nullable)mainDescription
                                      leftValue:(NSString * _Nullable)leftValue
                                     rightValue:(NSString * _Nullable)rightValue;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new __attribute__((unavailable("new 이용불가. 대신에 - initWithMainDescription:leftValue:rightValue: 이용바람.")));
- (instancetype)init __attribute__((unavailable("init 이용불가. 대신에 - initWithMainDescription:leftValue:rightValue: 이용바람.")));

@end

NS_ASSUME_NONNULL_END
