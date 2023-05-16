//
//  MGUFlowFoldCell.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "UIView+Extension.h"
#import "MGUFlowFoldCell.h"
#import "MGUFlowCellLayoutAttributes.h"

@interface MGUFlowFoldCell ()
@property (nonatomic, strong) MGEGradientView *gradientViewEven;
@property (nonatomic, strong) MGEGradientView *gradientViewOdd;
//@property (nonatomic, strong, nullable) UIView *selectedForegroundView; // 셀렉션 또는 하이라이트 되었을 때의 색을 살짝 보여주기 위해 존재함.
@end

@implementation MGUFlowFoldCell

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)dealloc {
#if DEBUG
    printf("* DEBUG: dealloc : <%s: %p>\n", object_getClassName(self), self);
#endif
}

- (void)applyLayoutAttributes:(MGUFlowCellLayoutAttributes *)layoutAttributes { // 상속받은 메서드이다.
    [super applyLayoutAttributes:layoutAttributes];
    if (self.foldingShadowHidden == NO) {
        if (layoutAttributes.indexPath.item % 2 == 0) { // 짝수
            self.gradientViewOdd.alpha = 0.0; // 항상 0.0
            if (layoutAttributes.position >= 0.0) {
                self.gradientViewEven.alpha = 0.0;
            } else { // 0.0 < ~ < -2.0 ==> alpha 0.0 ~ 1.0
                self.gradientViewEven.alpha = ABS(layoutAttributes.position) / 2.0;
            }
        } else { // 홀수
            self.gradientViewEven.alpha = 0.0; // 항상 0.0
            if (layoutAttributes.position >= 1.0) {
                self.gradientViewOdd.alpha = 0.0;
            } else { // 1.0 < ~ < -1.0 ==> alpha 0.0 ~ 1.0
                self.gradientViewOdd.alpha = ABS(layoutAttributes.position - 1.0) / 2.0;
            }
        }
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUFlowFoldCell *self) {
    self.selectionColor = [UIColor clearColor];
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.layer.shadowColor = UIColor.clearColor.CGColor;
    
    //! 그림자 뷰 2개 설정.
    self->_gradientViewEven = [MGEGradientView new];
    self->_gradientViewOdd = [MGEGradientView new];
    [self addSubview:self.gradientViewEven];
    [self addSubview:self.gradientViewOdd];
    [self.gradientViewEven mgrPinEdgesToSuperviewEdges];
    [self.gradientViewOdd mgrPinEdgesToSuperviewEdges];
    self.gradientViewEven.colors = @[[UIColor colorWithWhite:0.0 alpha:0.55], [UIColor colorWithWhite:0.0 alpha:0.9]];
    self.gradientViewOdd.colors = @[[UIColor colorWithWhite:0 alpha:0.6], [UIColor colorWithWhite:0 alpha:0.05]];
    
    self.gradientViewEven.alpha = 0.0;
    self.gradientViewOdd.alpha = 0.0;
    self.gradientViewEven.userInteractionEnabled = NO;
    self.gradientViewOdd.userInteractionEnabled = NO;
    self->_foldingShadowHidden = NO;
}


#pragma mark - 세터 & 게터
- (void)setFoldingShadowHidden:(BOOL)foldingShadowHidden {
    if (_foldingShadowHidden != foldingShadowHidden) {
        _foldingShadowHidden = foldingShadowHidden;
        self.gradientViewEven.hidden = foldingShadowHidden;
        self.gradientViewOdd.hidden = foldingShadowHidden;
    }
}

@end


//!---
//@property (nonatomic, strong, nullable) UILabel *textLabel; // 셀의 메인 텍스트 컨텐츠에 사용된 UILabel. lazy
//@property (nonatomic, strong, nullable) UIImageView *imageView; // 셀의 이미지 뷰디폴트 값은 nil. lazy
//@property (nonatomic, strong) UIColor *selectionColor;
//#import "MGUFlowCell.h"
//
//static void *MGUFlowCellKVOContext = &MGUFlowCellKVOContext;
//
//@interface MGUFlowCell ()
//@property (nonatomic, strong, nullable) UIView *selectedForegroundView; // 셀렉션 또는 하이라이트 되었을 때의 색을 살짝 보여주기 위해 존재함.
//@end
//
//@implementation MGUFlowCell
//

//
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    if (_imageView) {
//        _imageView.frame = self.contentView.bounds;
//        _selectedForegroundView.frame = self.contentView.bounds;
//    }
//    
//    if (_textLabel) {
//        CGRect rect = self.contentView.bounds;
//        CGFloat height = _textLabel.font.pointSize * 1.5;
//        rect.size.height = height;
//        rect.origin.y = self.contentView.frame.size.height - height;
//        _textLabel.superview.frame = rect;
//        
//        rect = _textLabel.superview.bounds;
//        rect = CGRectInset(rect, 8.0, 0.0);
//        rect.size.height = rect.size.height - 1.0;
//        rect.origin.y = rect.origin.y + 1.0;
//        _textLabel.frame = rect;
//    }
//}
//
//- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//    if (highlighted) {
//        self.selectedForegroundView.layer.backgroundColor = self.selectionColor.CGColor;
//    } else if (!super.isSelected) {
//        self.selectedForegroundView.layer.backgroundColor = UIColor.clearColor.CGColor;
//    }
//}
//
//- (BOOL)isHighlighted {
//    return [super isHighlighted];
//}
//
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    self.selectedForegroundView.layer.backgroundColor = selected ? self.selectionColor.CGColor : UIColor.clearColor.CGColor;
//}
//
//- (BOOL)isSelected {
//    return [super isSelected];
//}
//

//
//
//#pragma mark - 세터 & 게터
//- (UILabel *)textLabel { // lazy
//    if (_textLabel == nil) {
//        UIView *view = [UIView new];
//        view.userInteractionEnabled = NO;
//        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
//        _textLabel = [UILabel new];
//        _textLabel.textColor = UIColor.whiteColor;
//        _textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        [self.contentView addSubview:view];
//        [view addSubview:_textLabel];
//        [_textLabel addObserver:self // 폰트가 바뀌면, 레이아웃을 갱신하여 크기를 맞춘다.
//                     forKeyPath:@"font"
//                        options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
//                        context:MGUFlowCellKVOContext];
//    }
//    return _textLabel;
//}
//
//- (UIImageView *)imageView { // lazy
//    if (_imageView == nil) {
//        _imageView = [UIImageView new];
//        [self.contentView insertSubview:_imageView atIndex:0];
//    }
//    return _imageView;
//}
//
////! Private setter getter
//- (UIView *)selectedForegroundView { // lazy
//    if (_selectedForegroundView == nil) {
//        if (_imageView == nil) {
//            return nil;
//        }
//        
//        _selectedForegroundView = [[UIView alloc] initWithFrame:_imageView.bounds];
//        [_imageView addSubview:_selectedForegroundView];
//    }
//    
//    return _selectedForegroundView;
//}
//
//
//#pragma mark - KVO 옵저빙 메서드.
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
//                       context:(void *)context {
//    
//    if (context == MGUFlowCellKVOContext) {
//        if ([keyPath isEqualToString:@"font"]) {
//            [self setNeedsLayout];
//        }
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//@end
//
