
//
// 본 클래스의 객체는 애니메이션 시작할 때, - addItemsTo: 에서만 사용된다.
// 전체 아이템에 대한 그리고 그 컨테이너뷰의 위치를 선정한다.
//
#import <UIKit/UIKit.h>
@class MGUFloatingItem;
@class MGUFloatingButton;

NS_ASSUME_NONNULL_BEGIN
typedef void (^MGRLayoutBlock)(NSMutableArray <MGUFloatingItem *> *items, MGUFloatingButton *actionButton);

@interface MGUFloatingItemsLayout : NSObject

@property (nonatomic, copy, nullable) MGRLayoutBlock layoutBlock;

/* 초기화 메서드 */
- (instancetype)initWithLayout:(MGRLayoutBlock)layoutBlock;
- (instancetype)initWithItemSpaceForVerticalLayoutBlock:(CGFloat)interItemSpacing firstItemSpacing:(CGFloat)firstItemSpacing;
- (instancetype)initWithRadiusForCircularLayoutBlock:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
