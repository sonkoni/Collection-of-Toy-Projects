//
//  MGUFlowCellLayoutAttributes.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUFlowCellLayoutAttributes.h"

@interface MGUFlowCellLayoutAttributes ()
@property (nonatomic, assign) CGFloat arbitraryFloat; // 디폴트 1.0 [1.0 ~ 0.0] MGUFlowDiceTransformer 에서만 사용함.

//! MGUFlowCenterExpandTransformer : Expand 된 상태가 0.0, 줄어든 상태가 1.0이다.
//! MGUFlowCoverFlowTransformer : 아직 사용되고 있지는 않지만, 완전히 앞을 본 상태가 0.0, 옆으로 뉘어있는 상태가 1.0이다.
@property (nonatomic, assign) CGFloat centerProgress; // 가운데가 0.0 [0.0 ~ 1.0] rubber Effect에 이용될 수 있다.
@end

@implementation MGUFlowCellLayoutAttributes

- (instancetype)init {
    self = [super init];
    if (self) {
        _position = 0.0;
        _arbitraryFloat = 1.0;
        _centerProgress = 0.0;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
    
    if ([super isEqual:object] == NO) { // super 클래스가 - isEqual: 메서드를 구현하였으므로, 반드시 넣어야된다.
        return NO;
    }

    return [self isEqualToFlowCellLayoutAttributes:(MGUFlowCellLayoutAttributes *)object];
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    NSUInteger result = [super hash]; // super의 hash가 자기 자신의 pointer가 아니라면 같이 섞어서 더 견고하게 만들어볼 수 있다.
    result = prime * result + [[NSNumber numberWithDouble:_position] hash];
    result = prime * result + [[NSNumber numberWithDouble:_arbitraryFloat] hash]; // private
    result = prime * result + [[NSNumber numberWithDouble:_centerProgress] hash]; // private
    return result;

}

//! Api:Foundation/protocol NSCopying/- copyWithZone:
- (id)copyWithZone:(NSZone *)zone {
    //! super(UICollectionViewLayoutAttributes)가 <NSCopying> 프로토콜을 따르므로 super copyWithZone:을 호출함
    //! 그렇지 않은 경우. ex: NSObject가 수퍼 클래스라면
    //! MGUFlowCollectionViewLayoutAttributes *layoutAttributes = [[[self class] allocWithZone:zone] init];
    MGUFlowCellLayoutAttributes *layoutAttributes = [super copyWithZone:zone];

    layoutAttributes->_position = _position;
    layoutAttributes->_arbitraryFloat = _arbitraryFloat; // private
    layoutAttributes->_centerProgress = _centerProgress; // private
    return layoutAttributes;
}


#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToFlowCellLayoutAttributes:(MGUFlowCellLayoutAttributes *)layoutAttributes {
    if (self == layoutAttributes) {
        return YES;
    }

    if (layoutAttributes == nil) {
        return NO;
    }

    BOOL haveEqualPosition = (self.position == layoutAttributes.position);
    BOOL haveEqualArbitraryFloat = (self.arbitraryFloat == layoutAttributes.arbitraryFloat); // private
    BOOL haveEqualCenterProgress = (self.centerProgress == layoutAttributes.centerProgress); // private
    
    return haveEqualPosition && haveEqualArbitraryFloat && haveEqualCenterProgress;
}

@end
