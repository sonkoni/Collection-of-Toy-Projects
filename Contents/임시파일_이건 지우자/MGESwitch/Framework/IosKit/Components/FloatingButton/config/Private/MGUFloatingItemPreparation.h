#import <UIKit/UIKit.h>
@class MGUFloatingItem;
@class MGUFloatingButton;

NS_ASSUME_NONNULL_BEGIN
typedef void (^MGRPrepareBlock)(MGUFloatingItem *item, NSInteger index, NSInteger numberOfItems, MGUFloatingButton *actionButton);

@interface MGUFloatingItemPreparation : NSObject

@property (nonatomic, copy, nullable) MGRPrepareBlock prepareBlock;

- (instancetype)initWithPrepareBlock:(MGRPrepareBlock)prepareBlock;
- (instancetype)initWithScaleForPrepareBlock:(CGFloat)ratio;
- (instancetype)initWithOffsetForPrepareBlock:(CGFloat)translationX translationY:(CGFloat)translationY scale:(CGFloat)scale;
- (instancetype)initWithHorizontalOffsetForPrepareBlock:(CGFloat)distance scale:(CGFloat)scale;
- (instancetype)initWithCircularOffsetForPrepareBlock:(CGFloat)distance scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
