//
//  MGUSideBarView.h
//  SlideSideBarMenuProject
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUSideBarConfig;

NS_ASSUME_NONNULL_BEGIN

@interface MGUSideBarView : UIView

@property (nonatomic, strong) UIView *containerView; // 여기에 뷰컨트롤러의 뷰가 붙게 될 것이다.
@property (nonatomic, strong) UIView *shadowView; // reveal 일때만 만들어진다. lazy

- (instancetype)initWithConfiguration:(MGUSideBarConfig *)configuration NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
