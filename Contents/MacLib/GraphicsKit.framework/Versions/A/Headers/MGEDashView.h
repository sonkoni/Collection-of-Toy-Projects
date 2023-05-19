//
//  MGEDashView.h
//  MGRFlow Project
//
//  Created by Kwan Hyun Son on 2021/12/21.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGEDashView : MGEView
@property (nonatomic, strong) MGEColor *dashColor;
@property (nonatomic, strong, nullable) MGEBezierPath *dashPath; // 없으면, 보더와 라디어스로 실행한다.
@property (nonatomic, assign) CGFloat dashLineWidth; // 디폴트 1.0
@property (nonatomic, strong) CAShapeLayerLineCap lineCap; // 디폴트 kCALineCapButt
@property (nonatomic, strong) CAShapeLayerLineJoin lineJoin; // 디폴트 kCALineJoinMiter
@property (nonatomic, strong) NSArray <NSNumber *>*lineDashPattern; // 디폴트 @[@(5), @(5)];
@property (nonatomic, assign) CGFloat lineDashPhase; // 디폴트 0.0
@property (nonatomic, assign) CGFloat cornerRadius; // 디폴트 0.0 self.dashLayer.path = path.CGPath; 이거 대신 쓰겠다.
@property (nonatomic, assign) CFTimeInterval duration; // 디폴트 0.5
@property (nonatomic, assign) BOOL visibleWhenAnimation; // 디폴트 NO Only visible when animation is in progress


- (void)dashAnimationActive:(BOOL)active;
@end

NS_ASSUME_NONNULL_END
