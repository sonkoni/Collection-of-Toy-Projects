//
//  MGUNumKeyboard+Layout.h
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/04/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUNumKeyboard.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGUNumKeyboard (Layout)

//! Done Button을 보이거나 감추게 만들어져있다.
- (void)layoutButtonForStandardStyle1;

//! Done Button을 무조건 보이게 했다. 따라서 allowsDoneButton의 값을 무시할 것이다.
- (void)layoutButtonForStandardStyle2;

//! 무조건 스페셜 키만 감춘다. Done Button을 무조건 보이게 했다. 따라서 allowsDoneButton의 값을 무시할 것이다.
- (void)layoutButtonForLowHeightStyle1;

//! 무조건 스페셜 키와 Done Button을 감춘다. 따라서 allowsDoneButton의 값을 무시할 것이다.
- (void)layoutButtonForLowHeightStyle2;

@end

NS_ASSUME_NONNULL_END
