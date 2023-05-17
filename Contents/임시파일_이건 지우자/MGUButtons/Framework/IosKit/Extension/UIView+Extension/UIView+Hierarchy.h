//
//  UIView+Hierarchy.h
//  HierarchyTest
//
//  Created by Kwan Hyun Son on 22/11/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//
//#  View의 Hierarchy를 추적해보자.
//
//## 현재 원하는 뷰를 정했을 때. UIWindow에서 뷰까지의 단선 계보이다.
//* dispatch_async(dispatch_get_main_queue(), ^{}); 이 함수를 이용하자.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Hierarchy)

+ (NSMutableString *)printInLineHierarchyForDestinationView:(__kindof UIView *)view;

@end

NS_ASSUME_NONNULL_END


//#ifdef DEBUG
//NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
//#endif