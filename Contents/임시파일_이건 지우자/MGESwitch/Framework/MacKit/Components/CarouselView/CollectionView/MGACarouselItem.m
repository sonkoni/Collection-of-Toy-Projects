//
//  MGACarouselItem.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGACarouselItem.h"
#import "MGAView.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "NSView+Extension.h"

@interface MGACarouselItem ()
@property (nonatomic, strong, readwrite) NSView *contentView;
@property (nonatomic, assign) BOOL isFirstShow; // 최초에 transform을 먹였는데도 불구하고 표현되지 않는 버그가 존재한다.
@end

@implementation MGACarouselItem

- (void)loadView {
    MGAView *view = [MGAView new];
    view.layer.masksToBounds = NO;
    view.flipped = YES;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstShow = YES;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    _isFirstShow = NO;
}


#pragma mark - 세터 & 게터
- (NSView *)contentView {
    if (_contentView == nil) {
        MGAView *view = [MGAView new];
        view.flipped = YES;
        view.layer.masksToBounds = NO;
        _contentView = view;
        [self.view addSubview:_contentView];
        _contentView.translatesAutoresizingMaskIntoConstraints = YES;
    }
    return _contentView;
}

- (void)applyLayoutAttributes:(MGACarouselCellLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    void (^contentViewBlock)(void) = ^{
        // CATransaction 주석 처리 안하면 Delete 시에 점프해 버린다. SupplementaryView 는 반대로
        // CATransaction 존재해야 정상적으로 작동한다.
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
        self.contentView.frame = layoutAttributes.dumyFrame;
        [self.contentView mgrSetAnchorPoint:CGPointMake(0.5, 0.5)];
        self.contentView.layer.transform = layoutAttributes.dumyTransform;
        self.contentView.layer.zPosition = (CGFloat)layoutAttributes.zIndex;
//        [CATransaction commit];
    };
    
    if (_isFirstShow == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{ contentViewBlock(); });
    } else {
        contentViewBlock();
    }
}

@end
