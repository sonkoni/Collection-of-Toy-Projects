//
//  MGALayerHostingView.m
//  RotationTEST
//
//  Created by Kwan Hyun Son on 2022/10/25.
//

#import "MGALayerHostingView.h"
#import "NSView+Etc.h"

@interface MGALayerHostingView () <CALayerDelegate>
@end

@implementation MGALayerHostingView
@synthesize flipped = _flipped; // 반드시 넣어줘야한다.

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}

- (BOOL)isFlipped {
    return _flipped;
}

- (NSView *)hitTest:(NSPoint)point {
    if (self.userInteractionEnabled == NO) {
        return nil;
    }
    return [super hitTest:point];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGALayerHostingView *self) {
    CALayer *layer = [CALayer layer];
    layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.layer = layer;
    self.wantsLayer = YES;
    self.layer.delegate = self;
    [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    self->_userInteractionEnabled = YES;
}


#pragma mark - <CALayerDelegate>
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    
    if (self.initalBlock != nil) {
        self.initalBlock();
        self.initalBlock = nil;
    }
}

@end
