//
//  MGUSegment.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSegment.h"
#import "MGUSegmentTextRenderView.h"

static CGFloat const kMinimumSegmentWidth = 64.0; // 각 세그먼트의 최소의 폭은 64.0으로 확보한다.

@implementation MGUSegment

- (instancetype)initWithTitle:(NSString *)title {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.titleLabel.text = title;
    }
    return self;
    //
    // 텍스트 라벨은 내가 만든 MGUSegmentTextRenderView(UIView 서브 클래스)뷰를 프라퍼티(내가 만든 프라퍼티)로 꽂은 것이다.
    // text 역시 내가 만든 프라퍼티이다.
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isAccessibilityElement = YES; // 다른 앱(voice over 같은)에서의 접근성을 의미한다. 시각 장애인에게 self 객체가 버튼이라는 것을 알려준다.
        self.accessibilityTraits = super.accessibilityTraits | UIAccessibilityTraitButton; //The accessibility element should be treated as a button.
        self.userInteractionEnabled = NO; // userInteractionEnabled을 NO로 하는 이유는 인디케이터가 밑에 있기 때문이다.
        self.titleLabel = [[MGUSegmentTextRenderView alloc] initWithFrame:self.frame]; // 전체 세그먼트 컨트롤 바로 위에 인디케이터가 존재하고 그 위 세그먼트들과 각 라벨이 존재한다.
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.titleLabel];
    }
    return self;
    //
    // Autoresizing mask는 superview의 크기를 조정할 때 subview의 크기를 조정하거나 이동하는 방법을 정한다.
    // 즉, 반드시 변화가 있을 때, 반응하게 된다. 최초 CGRectZero로 시작하므로, 반드시 변하게 된다. 그리고 현재 프로젝트에서는 같은 크기로 변하게 될 것이다.
}

// 인수로 주어진 size에 가장 적합한 size를 계산하고 반환하도록 뷰에 요청한다. Api:UIKit/UIView/- sizeThatFits: 참고.
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [self.titleLabel sizeThatFits:size];
    return CGSizeMake(MAX(sizeThatFits.width * 1.4f, kMinimumSegmentWidth), sizeThatFits.height);
    //
    // 이 메서드의 디폴트의 구현은, view의 기존의 size를 돌려준다.
    // 이 메서드는, 리시버의 사이즈를 변경하지 않는다.
    // MGUSegmentTextRenderView의 sizeThatFits:를 이용한며, 본 메서드는 MGUSegmentedControl의 sizeThatFits: 메서드에서 이용된다.
}

- (NSString *)accessibilityLabel {
    return self.titleLabel.text;
    //
    // voice over 같은 앱에게 self(세그먼트)에게 버턴의 이름을 알려준다.
    // 버튼이나 스위치 같은 정보를 포함해서는 안된다. 이것은 self.accessibilityTraits = super.accessibilityTraits | UIAccessibilityTraitButton; 으로 알려준다.
}


#pragma mark - 세터 & 게터
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    //! 시각 장애인에게 알려줄 수 있다.
    if (selected) {
        self.accessibilityTraits = self.accessibilityTraits | UIAccessibilityTraitSelected;
    } else {
        self.accessibilityTraits = self.accessibilityTraits & ~UIAccessibilityTraitSelected;
    }
}

@end
