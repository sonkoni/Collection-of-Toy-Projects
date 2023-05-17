//
//  MGRDelegateProxy.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
// ----------------------------------------------------------------------
//  VERSION_DATE    2020-10-22                 (MGRCombine 의 일부. 독립형태)
// ----------------------------------------------------------------------
//  특정 프로토콜을 따르는 델리게이트를 특정 에이전트 딱 1개로 프록시 할 수 있다.
//  매우매우 작고 가볍게 작동하도록 최소한의 기능만 담는다. 컨트롤 권한은 agent 에게 있다.
//  필요한 델리게이트마다 프록시를 한 개씩 만들면 된다. 최소한으로 프록시 해라.
//                                      ┌───┐
//                                ┌─────●   │ agent
//                                │     └───┘ =====
//    ┌───┐   ┌───┐     ┌───┐   ┌─○─┐   ┌───┐
//    │   ○───┤   │     │   ○───┤   ○───┤   │
//    └───┘   └───┘     └───┘   └───┘   └───┘
//     view    ctrl      view   proxy    ctrl
//                              =====
//     보통의 델리게이트         딱 1개 프록시 형태
//
//  사용예시 : /Combine/UIKit+Combine/UITextField+MGRCombine.m
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRDelegateProxy : NSProxy
@property (nonatomic, weak) id delegate;
+ (instancetype)proxy:(Protocol *)protocol to:(id)agent;
- (instancetype)initWithProtocol:(Protocol *)protocol agent:(id)agent;
@end

// ----------------------------------------------------------------------

@interface MGRDelegateAgent : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@property (nonatomic, weak) id object;
@property (nonatomic, weak, nullable) id delegate;
- (instancetype)initWith:(id)object protocol:(Protocol *)protocol key:(NSString *)key NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
