//
//  NSWindow+Position.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSWindow+Position.h"

@implementation NSWindow (Position)

- (void)mgrCenter {
    NSScreen *screen = [NSScreen mainScreen];
    CGRect frame = screen.visibleFrame;
    CGFloat newOriginX = CGRectGetMidX(frame) - (self.frame.size.width / 2.0); // 중심을 위한 Y좌표.
    CGFloat newOriginY = CGRectGetMidY(frame) - (self.frame.size.height / 2.0); // 중심을 위한 X좌표.
    [self setFrameOrigin:CGPointMake(newOriginX, newOriginY)];
}

- (void)mgrSetVisibleFrameOrigin:(NSPoint)point geometryFlipped:(BOOL)isGeometryFlipped {
    NSScreen *screen = [NSScreen mainScreen];
    CGRect frame = screen.visibleFrame;
    
    CGFloat newOriginX = CGRectGetMinX(frame) + point.x;
    CGFloat newOriginY = CGRectGetMinY(frame) + point.y;
    
    if (isGeometryFlipped == YES) {
        newOriginY = CGRectGetMaxY(frame) - self.frame.size.height - point.y;
    }
    
    [self setFrameOrigin:CGPointMake(newOriginX, newOriginY)];
}

//! 아직은 MGAWindowPositionTypeAboutPanel 만 존재함.
- (void)mgrSetPosition:(MGAWindowPositionType)positionType {
    NSScreen *screen = [NSScreen mainScreen];
    CGRect frame = screen.visibleFrame;
    CGFloat newOriginX = CGRectGetMidX(frame) - (self.frame.size.width / 2.0); // 가로의 중심을 위해.
    CGFloat newOriginY = CGRectGetMaxY(frame) - self.frame.size.height - (CGRectGetHeight(frame) * 0.164);
//        CGFloat newOriginY = (CGRectGetMinY(frame) + (CGRectGetHeight(frame) * 0.837)) - self.frame.size.height;
    [self setFrameOrigin:CGPointMake(newOriginX, newOriginY)];
}
@end

