//
//  MGRPathElement.m
//  BezierMorph
//
//  Created by Kwan Hyun Son on 2020/12/02.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGRPathElement.h"

static void MGRPathApplierFunction(void *info, const CGPathElement *element);

@interface MGRPathElement ()
- (instancetype)initPrivate;
@end
@implementation MGRPathElement
- (instancetype)initPrivate {
    return [super init];
}

@end

MGRPathElementRef MGRPathElementMake(const CGPathElement *element) {
    CGPoint *points = element->points; // CGPoint에 대한 c 배열이다.
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            {
                MGRPathElementRef element = [[MGRPathElement alloc] initPrivate];
                element.loc = points[0];
                element.elementType = kCGPathElementMoveToPoint;
                return element;
            }
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            {
                MGRPathElementRef element = [[MGRPathElement alloc] initPrivate];
                element.loc = points[0];
                element.elementType = kCGPathElementAddLineToPoint;
                return element;
            }
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            {
                MGRPathElementRef element = [[MGRPathElement alloc] initPrivate];
                element.cp1 = points[0];
                element.loc = points[1];
                element.elementType = kCGPathElementAddQuadCurveToPoint;
                return element;
                
            }
            break;

        case kCGPathElementAddCurveToPoint: // contains 3 points
            {
                MGRPathElementRef element = [[MGRPathElement alloc] initPrivate];
                element.cp1 = points[0];
                element.cp2 = points[1];
                element.loc = points[2];
                element.elementType = kCGPathElementAddCurveToPoint;
                return element;
                
            }
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            {
                MGRPathElementRef element = [[MGRPathElement alloc] initPrivate];
                element.elementType = kCGPathElementCloseSubpath;
                return element;
            }
            break;
    }
}


#pragma mark - UIBezierPath+MGRPathElement
@implementation UIBezierPath (MGRPathElement)
- (NSMutableArray <MGRPathElementRef>*)getAllPathElements {
    NSMutableArray <MGRPathElementRef>*bezierPoints = [NSMutableArray array];
    CGPathApply(self.CGPath, (__bridge void *)(bezierPoints), MGRPathApplierFunction);
    return bezierPoints;
}
@end

static void MGRPathApplierFunction(void *info, const CGPathElement *element) {
    NSMutableArray <MGRPathElementRef>*bezierPoints = (__bridge NSMutableArray *)info;
    [bezierPoints addObject:MGRPathElementMake(element)];
    return;
}
