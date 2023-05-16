//
//  MGEEEEE.m
//  GraphicsKit
//
//  Created by Kwan Hyun Son on 2022/11/14.
//

#import "MGEPathElement.h"
#import "MGEPathHelper.h"

static void MGEPathApplierFunction(void *info, const CGPathElement *element);

@interface MGEPathElement ()
- (instancetype)initPrivate;
@end
@implementation MGEPathElement
- (instancetype)initPrivate {
    return [super init];
}

@end

MGEPathElementRef MGEPathElementMake(const CGPathElement *element) {
    CGPoint *points = element->points; // CGPoint에 대한 c 배열이다.
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            {
                MGEPathElementRef element = [[MGEPathElement alloc] initPrivate];
                element.loc = points[0];
                element.elementType = kCGPathElementMoveToPoint;
                return element;
            }
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            {
                MGEPathElementRef element = [[MGEPathElement alloc] initPrivate];
                element.loc = points[0];
                element.elementType = kCGPathElementAddLineToPoint;
                return element;
            }
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            {
                MGEPathElementRef element = [[MGEPathElement alloc] initPrivate];
                element.cp1 = points[0];
                element.loc = points[1];
                element.elementType = kCGPathElementAddQuadCurveToPoint;
                return element;
                
            }
            break;

        case kCGPathElementAddCurveToPoint: // contains 3 points
            {
                MGEPathElementRef element = [[MGEPathElement alloc] initPrivate];
                element.cp1 = points[0];
                element.cp2 = points[1];
                element.loc = points[2];
                element.elementType = kCGPathElementAddCurveToPoint;
                return element;
                
            }
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            {
                MGEPathElementRef element = [[MGEPathElement alloc] initPrivate];
                element.elementType = kCGPathElementCloseSubpath;
                return element;
            }
            break;
    }
}

#if TARGET_OS_OSX
@implementation NSBezierPath (MGEPathElement)
- (NSMutableArray <MGEPathElementRef>*)mgrGetAllPathElements {
    NSMutableArray <MGEPathElementRef>*bezierPoints = [NSMutableArray array];
    CGPathRef result = MGECGPathGetPath(self); // CFAutorelease 된 결과 값이 반환된다.
    CGPathApply(result, (__bridge void *)(bezierPoints), MGEPathApplierFunction);
    return bezierPoints;
}
@end

#elif TARGET_OS_IPHONE
@implementation UIBezierPath (MGEPathElement)
- (NSMutableArray <MGEPathElementRef>*)mgrGetAllPathElements {
    NSMutableArray <MGEPathElementRef>*bezierPoints = [NSMutableArray array];
    CGPathApply(self.CGPath, (__bridge void *)(bezierPoints), MGEPathApplierFunction);
    return bezierPoints;
}
@end

#endif

static void MGEPathApplierFunction(void *info, const CGPathElement *element) {
    NSMutableArray <MGEPathElementRef>*bezierPoints = (__bridge NSMutableArray *)info;
    [bezierPoints addObject:MGEPathElementMake(element)];
    return;
}
