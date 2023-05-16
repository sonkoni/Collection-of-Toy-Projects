//
//  MGUFlowFoldTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUFlowTransformer.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *MGUFlowElementKindFold NS_TYPED_EXTENSIBLE_ENUM;
static MGUFlowElementKindFold const MGUFlowElementKindFoldLeading = @"MGUFlowElementKindFoldLeading";
static MGUFlowElementKindFold const MGUFlowElementKindFoldTrailing = @"MGUFlowElementKindFoldTrailing";

@interface MGUFlowFoldTransformer : MGUFlowTransformer
@end

NS_ASSUME_NONNULL_END


