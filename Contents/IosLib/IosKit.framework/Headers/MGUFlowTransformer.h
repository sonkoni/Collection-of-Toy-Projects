//
//  MGUFlowTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//
// 편하게 사용할 수 있는 Convenience Transformer - 구체적인 Transformer는 Additional configuration 폴더에 만든다.

#import <UIKit/UIKit.h>
@class MGUFlowView;
@class MGUFlowCellLayoutAttributes;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MGUFlowViewTransformer 클래스
@interface MGUFlowTransformer : NSObject

@property (nonatomic, weak, nullable) MGUFlowView *flowView;
@property (nonatomic, assign) CGFloat minimumScale;                 // 디폴트 0.65
@property (nonatomic, assign) CGFloat minimumAlpha;                 // 디폴트 0.6

- (void)applyTransformTo:(MGUFlowCellLayoutAttributes *)attributes;
- (CGFloat)proposedInteritemSpacing;
- (void)flowViewWillBeginDragging:(MGUFlowView *)flowView; // 필요할 경우 사용한다.
@end

NS_ASSUME_NONNULL_END
