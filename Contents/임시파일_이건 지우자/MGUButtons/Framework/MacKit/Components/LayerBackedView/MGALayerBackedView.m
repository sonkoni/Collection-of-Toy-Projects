//
//  MGALayerBackedView.m
//  RotationTEST
//
//  Created by Kwan Hyun Son on 2022/10/25.
//

#import "MGALayerBackedView.h"
#import "NSView+Etc.h"

@implementation MGALayerBackedView
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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    
    if (self.initalBlock != nil) {
        self.initalBlock();
        self.initalBlock = nil;
    }
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
static void CommonInit(MGALayerBackedView *self) {
    self.wantsLayer = YES;
    [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    self->_userInteractionEnabled = YES;
}

@end
