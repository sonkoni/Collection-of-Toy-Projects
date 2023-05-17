//
//  MGEEEEE.h
//  GraphicsKit
//
//  Created by Kwan Hyun Son on 2022/11/14.
//

#import <GraphicsKit/MGEAvailability.h>
@class MGEPathElement;

NS_ASSUME_NONNULL_BEGIN
typedef MGEPathElement *MGEPathElementRef;

@interface MGEPathElement : NSObject

@property (nonatomic, assign) CGPathElementType elementType;
@property (nonatomic, assign) CGPoint loc; //! 목표점.
@property (nonatomic, assign) CGPoint cp1;
@property (nonatomic, assign) CGPoint cp2;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

@interface MGEBezierPath (MGEPathElement)
- (NSMutableArray <MGEPathElementRef>*)mgrGetAllPathElements;
@end

NS_ASSUME_NONNULL_END
