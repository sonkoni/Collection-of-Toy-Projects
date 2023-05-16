//
//  MGAShrinkButton.m
//  RotationTEST
//
//  Created by Kwan Hyun Son on 2022/10/25.
//

#import "MGAShrinkButton.h"
#import "NSView+Etc.h"
#import <Quartz/Quartz.h>

@interface MGAShrinkButton () <CALayerDelegate>
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) dispatch_group_t dispatchGroup;
@end

@implementation MGAShrinkButton
@synthesize image = _image;
//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
//        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
//    }
//    if (self.initalBlock != nil) {
//        self.initalBlock();
//        self.initalBlock = nil;
//    }
//}

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

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.enabled == NO) { return; }
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    [self shrinkAnimation];
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.enabled == NO) { return; }
    [self invokeTargetAction];
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    [self inverseShrinkAnimation];
}

- (void)setImage:(NSImage *)image {
    _image = image;
    self.layer.contents = image;
}

- (NSImage *)image {
    return _image;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGAShrinkButton *self) {
    CALayer *layer = [CALayer layer];
    layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    layer.delegate = self;
    layer.contentsGravity = kCAGravityResizeAspect;
    self.layer = layer;
    self.wantsLayer = YES;
    self.bezelStyle = NSBezelStyleRegularSquare;
    [self setButtonType:NSButtonTypeMomentaryPushIn];
    self.bordered = NO;
    self.imagePosition = NSImageOnly;
    self.focusRingType = NSFocusRingTypeNone;
    self.imageScaling = NSImageScaleProportionallyUpOrDown;
    self.title = @"";
    [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
}

+ (NSButton *)mgrShinkButton:(CGFloat)scale {
    MGAShrinkButton *result = [MGAShrinkButton new];
    if (scale >= 0.1) {
        result.scale = scale;
    } else {
        result.scale = 0.85;
    }
    return result;
}


#pragma mark - 세터 & 게터
- (dispatch_group_t)dispatchGroup {
    if (_dispatchGroup == nil) {
        _dispatchGroup = dispatch_group_create();
    }
    return _dispatchGroup;
}


#pragma mark - Actions
- (void)invokeTargetAction { //! Target Action을 보낸다.
    if (self.action != NULL) {
        BOOL success = [NSApp sendAction:self.action to:self.target from:self];
#if DEBUG
        if (success == YES) {
            NSLog(@"액션 보내기 성공");
        } else {
            NSLog(@"액션 보내기 실패");
        }
#endif
    }
}

- (void)shrinkAnimation {
    dispatch_group_enter(self.dispatchGroup);
    dispatch_group_enter(self.dispatchGroup);
    
    CFTimeInterval duration = 0.2;

    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    shrinkAnimation.duration            = duration;
    shrinkAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shrinkAnimation.removedOnCompletion = NO;
    shrinkAnimation.fillMode            = kCAFillModeForwards;
    shrinkAnimation.fromValue = @(1.0);
    shrinkAnimation.toValue = @(self.scale);
    if (self.layer.presentationLayer) {
        self.layer.transform = self.layer.presentationLayer.transform;
        shrinkAnimation.fromValue = @(self.layer.presentationLayer.transform.m11);
    }
    
    [CATransaction setCompletionBlock:^{
        self.layer.transform = CATransform3DScale(CATransform3DIdentity, self.scale, self.scale, 1.0);
        [self.layer removeAnimationForKey:@"ShrinkAnimationKey"];
        dispatch_group_leave(self.dispatchGroup);
    }];
    [self.layer addAnimation:shrinkAnimation forKey:@"ShrinkAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
    dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
        [self realInverseShrinkAnimation];
    });
}

- (void)inverseShrinkAnimation {
    dispatch_group_leave(self.dispatchGroup);
    return;
}

- (void)realInverseShrinkAnimation {
    CFTimeInterval duration = 0.2;
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    shrinkAnimation.duration            = duration;
    shrinkAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shrinkAnimation.removedOnCompletion = NO;
    shrinkAnimation.fillMode            = kCAFillModeForwards;
    self.layer.transform = self.layer.presentationLayer.transform; // 항상 0.85
    shrinkAnimation.fromValue = @(self.scale);
    shrinkAnimation.toValue = @(1.0);
    [CATransaction setCompletionBlock:^{
        self.layer.transform = CATransform3DIdentity;
        [self.layer removeAnimationForKey:@"ShrinkAnimationKey"];
    }];
    [self.layer addAnimation:shrinkAnimation forKey:@"ShrinkAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}


#pragma mark - <CALayerDelegate>
//- (void)displayLayer:(CALayer *)layer {}
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {}
//- (void)layerWillDraw:(CALayer *)layer {}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    
    if (self.initalBlock != nil) {
        self.initalBlock();
        self.initalBlock = nil;
    }
}
//- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {}

@end
