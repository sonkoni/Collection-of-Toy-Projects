//
//  MGUFlowTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUFlowTransformer.h"
#import "MGUFlowCellLayoutAttributes.h"
#import "MGUFlowView.h"

@implementation MGUFlowTransformer


#pragma mark - 생성 & 소멸
- (instancetype)init {
    self = [super init];
    if (self) {
        _minimumScale = 1.0;
        _minimumAlpha = 1.0;
    }
    return self;
}


#pragma mark - 컨트롤
- (CGFloat)proposedInteritemSpacing {
    if (self.flowView == nil) {
        return 0.0;
    }
    
    return self.flowView.interitemSpacing;
}

// MARK: - attributes에 transform 적용
//! NSInteger: zIndex, CGRect: frame, CGFloat: alpha, CGAffineTransform: transform 또는 CATransform3D: transform3D.
- (void)applyTransformTo:(MGUFlowCellLayoutAttributes *)attributes {}

- (void)flowViewWillBeginDragging:(MGUFlowView *)flowView {}
@end
