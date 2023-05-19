//
//  MGUFlowVegaTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUFlowTransformer.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * MGUFlowElementKindVega NS_TYPED_EXTENSIBLE_ENUM;
static MGUFlowElementKindVega const MGUFlowElementKindVegaLeading = @"MGUFlowElementKindVegaLeading";
static MGUFlowElementKindVega const MGUFlowElementKindVegaTrailing = @"MGUFlowElementKindVegaTrailing";

@interface MGUFlowVegaTransformer : MGUFlowTransformer

+ (instancetype)vegaTransformerWithBothSides:(BOOL)bothSides;
- (instancetype)initWithvegaTransformerWithBothSides:(BOOL)bothSides NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END


