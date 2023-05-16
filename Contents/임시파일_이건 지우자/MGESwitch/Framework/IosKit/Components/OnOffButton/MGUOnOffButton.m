//
//  MGUOnOffButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUOnOffButton.h"
#import "MGUOnOffSkinInterface.h"
#import "UIView+AutoLayout.h"
#import "UIFeedbackGenerator+Extension.h"

@interface MGUOnOffButton ()
@property (nonatomic, assign) BOOL selected_internal;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@end

@implementation MGUOnOffButton

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame skinView:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.skinView layoutIfNeeded];
  
    if (_selected_internal == YES) { // ON 상태.
        [self.skinView setSkinType:MGUOnOffSkinTypeOn animated:NO];
    } else {
        [self.skinView setSkinType:MGUOnOffSkinTypeOff animated:NO];
    }
}

- (BOOL)isSelected {
    return _selected_internal;
}

- (void)setSelected:(BOOL)selected {
    if (_selected_internal != selected) {
        [self setSelected:selected animated:NO notify:NO];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.touchArea == MGUOnOffButtonTouchAreaNormal) {
        return [super pointInside:point withEvent:event];
    } else if (self.touchArea == MGUOnOffButtonTouchAreaOneAndHalfTimes || self.touchArea == MGUOnOffButtonTouchAreaTwice) {
        CGFloat width = -1 * (self.bounds.size.width / (CGFloat)self.touchArea);
        CGFloat height = -1 * (self.bounds.size.height / (CGFloat)self.touchArea);
        CGRect extendBounds = CGRectInset(self.bounds, width, height);
        return CGRectContainsPoint(extendBounds, point);
    } else {
        NSCAssert(FALSE, @"여기에 들어오면 안된다.");
        return [super pointInside:point withEvent:event];
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                     skinView:(UIView <MGUOnOffSkinInterface>*)skinView {
    self = [super initWithFrame:frame];
    if (self) {
        _skinView = skinView;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _impactOff = NO;
    [self addSubview:self.skinView];
    [self.skinView mgrPinEdgesToSuperviewEdges];
    
    _impactFeedbackStyle = UIImpactFeedbackStyleMedium;
    _selected_internal = NO;
    [self addTarget:self action:@selector(showHighlight:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(showHighlight:) forControlEvents:UIControlEventTouchDragEnter];
    
    //! 이거는 지우는 게 나을듯.
//    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchCancel];
    
    [self addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    _impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:_impactFeedbackStyle];
}

- (void)setSkinView:(UIView <MGUOnOffSkinInterface>*)skinView {
    if (_skinView != skinView) {
        if (_skinView != nil) {
            [_skinView removeFromSuperview];
            _skinView = nil;
        }
        
        if (skinView != nil) {
            _skinView = skinView;
            [self addSubview:self.skinView];
            [self.skinView mgrPinEdgesToSuperviewEdges];
        }
    }
}

- (void)setImpactFeedbackStyle:(UIImpactFeedbackStyle)impactFeedbackStyle {
    if (_impactFeedbackStyle != impactFeedbackStyle) {
        _impactFeedbackStyle = impactFeedbackStyle;
        self.impactFeedbackGenerator = nil;
        _impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:_impactFeedbackStyle];
    }
}


#pragma mark - Action
- (void)setSelected:(BOOL)selected animated:(BOOL)animated notify:(BOOL)notify {
    if (selected != _selected_internal) {
        _selected_internal = selected;
        if (selected == YES) {
            [self.skinView setSkinType:MGUOnOffSkinTypeOn animated:animated];
        } else {
            [self.skinView setSkinType:MGUOnOffSkinTypeOff animated:animated];
        }
        [super setSelected:selected];
        if (notify == YES) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)showHighlight:(MGUOnOffButton *)sender { // 터치 다운에서 발생한다.
    if (_selected_internal == NO) { // off 상태에서 눌렀다.
        [self.skinView setSkinType:MGUOnOffSkinTypeTouchDown1 animated:YES];
    } else { // ON 상태에서 눌렀다.
        [self.skinView setSkinType:MGUOnOffSkinTypeTouchDown2 animated:YES];
    }
    [self impactOccurred];
}

- (void)showUnHighlight:(MGUOnOffButton *)sender {
    if (_selected_internal == NO) { // off 상태로 돌아간다.
        [self.skinView setSkinType:MGUOnOffSkinTypeOff animated:YES];
    } else { // ON 상태에서 눌렀다.
        [self.skinView setSkinType:MGUOnOffSkinTypeOn animated:YES];
    }
}

- (void)didTouchUpInside:(id)sender {
    [self setSelected:!_selected_internal animated:YES notify:YES];
}

//! 터치로 인해서만 임팩트가 오게 한다.
- (void)impactOccurred {
    if (self.impactOff == NO) {
        [self.impactFeedbackGenerator mgrImpactOccurred];
    }
}

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame
                primaryAction:(UIAction *)primaryAction  {
    NSCAssert(FALSE, @"- initWithFrame:primaryAction: 사용금지."); return nil;
}

@end
