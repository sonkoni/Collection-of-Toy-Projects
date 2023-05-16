//
//  MGAUserInteractionPausableWindow.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
/**
 내가 만든 userInteractionEnabled 프라퍼티를 통해 userInteraction을 비활성화할 수 있게 만든 window이다.
 사용자가 너무 빨리 클릭할 때 애니메이션이 깨지는 것을 방지하는 데 사용된다. 애니메이션 중 사용자 상호 작용을 비활성화하면 설정된다.
 
*/
@interface MGAUserInteractionPausableWindow : NSWindow
@property (nonatomic, assign) BOOL userInteractionEnabled;
@end

NS_ASSUME_NONNULL_END
