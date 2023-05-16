//
//  MGUNeoSegControl
//
//

#import "MGUNeoSegControl.h"
@class MGUNeoSeg;
@class MGUNeoSegIndicator;
@class MGUNeoSegConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface MGUNeoSegControl ()

@property (nonatomic, strong, nullable) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@property (nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) UIView *fullContainerView;
@property (nonatomic) NSArray<UIView *> *segmentBackUpViews;
@property (nonatomic) UIView *separatorContainerView;
@property (nonatomic) NSArray<UIView *> *separatorViews;
@property (nonatomic) MGUNeoSegIndicator *segmentIndicator;
@property (nonatomic) UIStackView *segmentsStackView;
@property (nonatomic) NSArray<MGUNeoSeg *> *segments;
@property (nonatomic) BOOL beginTrackingOnIndicator;

- (void)adjustGradient:(MGUNeoSegConfiguration *)config; // configuration이 적용할 수 있도록.

@end

NS_ASSUME_NONNULL_END
