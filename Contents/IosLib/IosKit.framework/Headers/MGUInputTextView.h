//
//  MGUInputTextView.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-21
//  ----------------------------------------------------------------------
//
//  유동적으로 높이가 조절되는 텍스트필드
//  - heightConstraint 을 맞추면 그에 따라 줄내림이 될 때 텍스트뷰의 높이가 유동적으로 조절된다
//  - 늘어날 Text View 의 height에 대한 constraint를 프라퍼티로 뽑는다.(priority를 낮게) 왜냐하면, 유동적으로 움직여야하므로
//    Text View의 수퍼뷰의 height에 대한 constraint height를 2개(less than equal, greater than equal)로 범위를 잡는다.
//    Text View의 텍스트가 들어올때마다, 적절한 height를 계산하여 갱신한다.
//  - sizeDelegate 를 받으면 self 가 처리하지 않고 delegate 에 사이즈 갱신을 넘긴다.
//  - reactThatWillChangePitchingHeight 블락을 걸면 self 가 처리하지 않고 react 가 처리한다.
//  - react 는 delegate 보다 우선권이 낮다

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGUInputTextViewSizeDelegate <NSObject>
/// 인풋텍스트뷰의 사이즈(높이) 변경을 의뢰한다
/// @discussion 변경할 값이 pitchHeight 이므로 현재 frame.size.height 에 더해줘야 한다.
/// @discussion pitchHeight 은 늘릴 때는 + 로 줄일 때는 - 로 간다.
- (void)inputTextViewWillChangePitchingHeight:(CGFloat)pitchHeight animated:(BOOL)animated; // 늘이고 줄이고 할 증감 높이 ± 로 던진다.
@end


@interface MGUInputTextView : UITextView

@property (nonatomic, strong) NSString *placeHolderText;

@property (nonatomic, assign) NSUInteger minimumLine; // 최수줄. 기본값 1. IB 는 영향을 안 받는다. IB 에서 조정하도록
@property (nonatomic, assign) NSUInteger maximumLine; // 최대줄. 기본값 4. IB 는 영향을 안 받는다. IB 에서 조정하도록
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, copy, nullable) void (^sendCompletion)(NSString *);

@property (nonatomic, weak) id<MGUInputTextViewSizeDelegate> sizeDelegate;
@property (nonatomic, copy, nullable) void (^reactThatWillChangePitchingHeight)(CGFloat pitchingHeight, BOOL animated);

@end



NS_ASSUME_NONNULL_END


/* ----------------------------------------------------------------------
 2020.03.03 - 프로젝트 DropFactor / PinDetail 노트 처리에 반영됨
 2020.03.03 - 델리게이트와 리엑트를 추가
            IB 를 통해 자신의 크기를 늘리는 것에 따라 수퍼의 사이즈가 조정되는 것이 이상적이지만
            콜렉션뷰 등과 같이 그럴 수 없는 경우 대장 컨트롤러가 사이즈를 늘려줄 수 있도록 처리함.
 
 2024.03.21 - keyboard_system+customizing
   ---------------------------------------------------------------------- */
