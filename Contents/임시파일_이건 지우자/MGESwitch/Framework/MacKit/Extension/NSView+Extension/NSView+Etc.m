//
//  NSView+Etc.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSView+Etc.h"

@implementation NSView (Etc)

+ (NSView *)mgrHorizontalLineViewWithBottomShadow {
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    NSView *lineView = [NSView new];
    lineView.wantsLayer = YES;
    lineView.layer = [CALayer layer];
    lineView.layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.15].CGColor;
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:1.0/3.0];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = NSMakeSize(0.0, -1.0 / scale);
    lineView.shadow = shadow;
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [lineView.heightAnchor constraintEqualToConstant:1.0 / scale].active = YES;
    return lineView;
}

+ (NSView *)mgrHorizontalLineViewWithTopShadow {
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    NSView *lineView = [NSView new];
    lineView.wantsLayer = YES;
    lineView.layer = [CALayer layer];
    lineView.layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.15].CGColor;
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:1.0/3.0];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = NSMakeSize(0.0, 1.0 / scale);
    lineView.shadow = shadow;
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [lineView.heightAnchor constraintEqualToConstant:1.0 / scale].active = YES;
    return lineView;
}

+ (NSView *)mgrVerticalLineViewWithLeadingShadow {
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    NSView *lineView = [NSView new];
    lineView.wantsLayer = YES;
    lineView.layer = [CALayer layer];
    lineView.layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.15].CGColor;
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:1.0/3.0];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = NSMakeSize(-1.0 / scale, 0.0);
    lineView.shadow = shadow;
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [lineView.widthAnchor constraintEqualToConstant:1.0 / scale].active = YES;
    return lineView;
}

+ (NSView *)mgrVerticalLineViewWithTrailingShadow {
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    NSView *lineView = [NSView new];
    lineView.wantsLayer = YES;
    lineView.layer = [CALayer layer];
    lineView.layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.15].CGColor;
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:1.0/3.0];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = NSMakeSize(1.0 / scale, 0.0);
    lineView.shadow = shadow;
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [lineView.widthAnchor constraintEqualToConstant:1.0 / scale].active = YES;
    return lineView;
}

- (void)mgrInsertSubview:(NSView *)view aboveSubview:(NSView *)siblingSubview {
    [self addSubview:view positioned:NSWindowAbove relativeTo:siblingSubview];
}

- (void)mgrInsertSubview:(NSView *)view belowSubview:(NSView *)siblingSubview {
    [self addSubview:view positioned:NSWindowBelow relativeTo:siblingSubview];
}

- (void)mgrInsertSubview:(NSView *)view atIndex:(NSInteger)index {
    index = ABS(index);
    NSArray <NSView *>*subviews = self.subviews;
    NSUInteger count = subviews.count;
    if (subviews == nil || subviews.count == 0 || index >= count) { // 우선 타당성 검사를한다.
        [self addSubview:view];
    } else {
        NSView *originalIndexView = subviews[index];
        [self addSubview:view positioned:NSWindowBelow relativeTo:originalIndexView];
    }
    //
    /*
     ex : X X X - 3개.
     
     ^ X X X - 0번
     X ^ X X - 1번
     X X ^ X - 2번
     X X X ^ - 3번 <- 여기서부터는 - addSubview: 사용.
    */
}


- (__kindof NSView *)mgrCopyView {
    NSLog(@"- mgrCopyView 이것은 디버깅용이다.");
    NSError *error = nil;
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [archiver encodeObject:self forKey:@"view"];
    [archiver finishEncoding];
    NSData *data = [archiver encodedData];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
    if (error != nil) { NSLog(@"error 발생 %@", error); }
    unarchiver.requiresSecureCoding = NO;
    NSView *result = [unarchiver decodeObjectForKey:@"view"];
    [result removeConstraints:result.constraints]; // 반드시 필요하다. 자기자신의 가로세로가 고정되어있다면 이것도 복사가 되기 때문이다.
    return result;
    
    /*! Deprecated 된 메서드를 이용하는 방법.
    NSError *error = nil;
    NSData *viewCopyData =
    [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
    if (error != nil) {
        NSLog(@"에러 %@", error);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSView *result = [NSKeyedUnarchiver unarchiveObjectWithData:viewCopyData];
    [result removeConstraints:result.constraints];
    return result;
#pragma clang diagnostic pop
     
     // 애플이 예전에 사용했던 방식과 유사하다. MenuItemViewEmbeddinganNSViewinsideanNSMenuItem 프로젝트 아카이브 문서에 있음.
     NSData *viewCopyData = [NSArchiver archivedDataWithRootObject:self.myButtonView];
     id viewCopy = [NSUnarchiver unarchiveObjectWithData:viewCopyData];
     */
    
    /* Unpublished APIs를 이용하는 방법. 이거를 상단에 적어준다.
    @interface UINibEncoder : NSCoder
    - initForWritingWithMutableData:(NSMutableData*)data;
    - (void)finishEncoding;
    @end

    @interface UINibDecoder : NSCoder
    - initForReadingWithData:(NSData *)data error:(NSError **)err;
    @end
    
    // 이제 다음의 방식으로 복제한다.
    NSError *error = nil;
    NSMutableData *mData = [NSMutableData new];
    UINibEncoder *encoder = [[UINibEncoder alloc] initForWritingWithMutableData:mData];
    [encoder encodeObject:self forKey:@"view"];
    [encoder finishEncoding];
    UINibDecoder *decoder = [[UINibDecoder alloc] initForReadingWithData:mData error:&error];
    UIView *result = [decoder decodeObjectForKey:@"view"];
    [result removeConstraints:result.constraints];
    return result;
    */
}

- (void)mgrSetAnchorPoint:(CGPoint)anchorPoint {
    CALayer *layer = self.layer;
    if (layer != nil) {
        CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x,
                                       self.bounds.size.height * anchorPoint.y);
        CGPoint oldPoint = CGPointMake(self.bounds.size.width * layer.anchorPoint.x,
                                       self.bounds.size.height * layer.anchorPoint.y);
        
        newPoint = CGPointApplyAffineTransform(newPoint, layer.affineTransform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, layer.affineTransform);
        
        CGPoint position = layer.position;
        layer.position = CGPointMake(position.x - oldPoint.x + newPoint.x,
                                     position.y - oldPoint.y + newPoint.y);
        layer.anchorPoint = anchorPoint;
    }
}

- (void)mgrMakeHostingLayer {
    CALayer *layer = [CALayer layer];
    layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.layer = layer; //! 순서가 중요하다.
    self.wantsLayer = YES; // back up layer는 이것만 하면된다.
}
@end
