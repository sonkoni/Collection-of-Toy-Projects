//
//  MGRPathElement.h
//  BezierMorph
//
//  Created by Kwan Hyun Son on 2020/12/02.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#if TARGET_OS_OSX
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@class MGRPathElement;

NS_ASSUME_NONNULL_BEGIN

typedef MGRPathElement *MGRPathElementRef;

@interface MGRPathElement : NSObject
@property (nonatomic, assign) CGPathElementType elementType;
@property (nonatomic, assign) CGPoint loc; //! 목표점.
@property (nonatomic, assign) CGPoint cp1;
@property (nonatomic, assign) CGPoint cp2;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end


#pragma mark - UIBezierPath+MGRPathElement
@interface UIBezierPath (MGRPathElement)
- (NSMutableArray <MGRPathElementRef>*)getAllPathElements;
@end

NS_ASSUME_NONNULL_END
