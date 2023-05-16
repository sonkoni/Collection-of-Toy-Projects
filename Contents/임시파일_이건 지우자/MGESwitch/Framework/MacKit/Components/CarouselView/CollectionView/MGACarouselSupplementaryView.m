//
//  MGACarouselSupplementaryView.m
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "MGACarouselSupplementaryView.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "NSView+Extension.h"

@interface MGACarouselSupplementaryView ()
@property (nonatomic, strong, readwrite) NSView *contentView;
@property (nonatomic, assign) BOOL isFirstShow; // 최초에 transform을 먹였는데도 불구하고 표현되지 않는 버그가 존재한다.
@end

@implementation MGACarouselSupplementaryView

+ (NSUserInterfaceItemIdentifier)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        CommonInit(self);
    }
    return self;
}

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_isFirstShow = NO;
    });
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    [super viewWillMoveToWindow:newWindow];
    _isFirstShow = YES;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGACarouselSupplementaryView *self) {
    self->_isFirstShow = YES;
    self.layer.masksToBounds = NO;
    self.flipped = YES;
}


#pragma mark - 세터 & 게터
- (NSView *)contentView {
    if (_contentView == nil) {
        MGAView *view = [MGAView new];
        view.flipped = YES;
        view.layer.masksToBounds = NO;
        _contentView = view;
        [self addSubview:_contentView];
        _contentView.translatesAutoresizingMaskIntoConstraints = YES;
    }
    return _contentView;
}


#pragma mark - <NSCollectionViewElement>
- (void)applyLayoutAttributes:(MGACarouselCellLayoutAttributes *)layoutAttributes {
    void (^contentViewBlock)(void) = ^{
        // CATransaction 은 여기서는 생략하면 안된다. MGACarouselItem에서는 생략해야 delete 등에서 끊기지 않지만
        // 여기서 생략하면 빠르게 스크롤 했을 때, 튄다.
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.contentView.frame = layoutAttributes.dumyFrame;
        [self.contentView mgrSetAnchorPoint:CGPointMake(0.5, 0.5)];
        self.contentView.layer.transform = layoutAttributes.dumyTransform;
        self.contentView.layer.zPosition = (CGFloat)layoutAttributes.zIndex;
        [CATransaction commit];
    };

    if (_isFirstShow == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{ contentViewBlock(); });
    } else {
        contentViewBlock();
    }
}

// - (void)prepareForReuse {}
// - (NSCollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(NSCollectionViewLayoutAttributes *)layoutAttributes {}
// - (void)willTransitionFromLayout:(NSCollectionViewLayout *)oldLayout toLayout:(NSCollectionViewLayout *)newLayout {}
// - (void)didTransitionFromLayout:(NSCollectionViewLayout *)oldLayout toLayout:(NSCollectionViewLayout *)newLayout {}
@end
