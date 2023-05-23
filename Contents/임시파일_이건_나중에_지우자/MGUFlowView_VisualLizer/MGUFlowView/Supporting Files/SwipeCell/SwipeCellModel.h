//
//  SwipeCellModel.h
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <CoreGraphics/CGBase.h> /* for CGFloat, CGMacro */

NS_ASSUME_NONNULL_BEGIN

// JSON 을 이용한다면 이 키를 이용하면된다. JSON에서 탑레벨은 배열 또는 딕셔너리여야만 한다.
typedef NSString * SwipeCellModelKey NS_TYPED_ENUM;
static SwipeCellModelKey const SwipeCellModelLeftKey = @"leftValue";
static SwipeCellModelKey const SwipeCellModelMainDescriptionKey = @"mainDescription";
static SwipeCellModelKey const SwipeCellModelRightKey = @"rightValue";

@interface SwipeCellModel : NSObject <NSItemProviderWriting, NSItemProviderReading, NSSecureCoding>

//! left
@property (nonatomic, strong) NSString *leftValue;

//! center
@property (nonatomic, strong) NSString *mainDescription;

//! left
@property (nonatomic, strong) NSString *rightValue;

- (instancetype)initWithMainDescription:(NSString * _Nullable)mainDescription
                              leftValue:(NSString * _Nullable)leftValue
                             rightValue:(NSString * _Nullable)rightValue;

//! Convenience initializer
+ (instancetype)favCellModelWithMainDescription:(NSString * _Nullable)mainDescription
                                      leftValue:(NSString * _Nullable)leftValue
                                     rightValue:(NSString * _Nullable)rightValue;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new __attribute__((unavailable("new 이용불가. 대신에 - initWithMainDescription:leftValue:rightValue: 이용바람.")));
- (instancetype)init __attribute__((unavailable("init 이용불가. 대신에 - initWithMainDescription:leftValue:rightValue: 이용바람.")));

@end

NS_ASSUME_NONNULL_END
