//
//  MGERingProgressGroupButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-30
//  ----------------------------------------------------------------------
//

#import <GraphicsKit/MGEAvailability.h>
@class MGERingProgressGroupView;

NS_ASSUME_NONNULL_BEGIN

//! Mac 에서 xib로 만들 때에는 NSView가 아닌 NSButton으로 만들어야 액션을 인식한다. cell이 존재하므로
//! Mac xib의 NSButton을 검색한 다음 Image Button을 선택하고 style을 inline으로 바꾼 후, 버튼과 cell의 클래스를 맞춰준다.
//! 버튼을 MGERingProgressGroupButton으로 cell을 _MGERingProgressGroupButtonCell로 
@interface MGERingProgressGroupButton : MGEButton
@property (nonatomic, strong) MGERingProgressGroupView *ringProgressGroupView;
@property (nonatomic, assign) CGFloat contentMargin;
@end

NS_ASSUME_NONNULL_END
