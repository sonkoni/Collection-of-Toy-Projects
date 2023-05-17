//
//  MGUOnOffSkinInterface.h
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @enum       MGUOnOffSkinType
 @abstract   4가지 모양.
 @constant   MGUOnOffSkinTypeOff        OFF 상태일 때의 모양
 @constant   MGUOnOffSkinTypeOn         ON 상태일 때의 모양
 @constant   MGUOnOffSkinTypeTouchDown1 OFF -> ON 으로 가기 위해 눌렀을 때의 모양. 누른 상태
 @constant   MGUOnOffSkinTypeTouchDown2 ON -> OFF 으로 가기 위해 눌렀을 때의 모양. 누른 상태
 */
typedef NS_ENUM(NSUInteger, MGUOnOffSkinType) {
    MGUOnOffSkinTypeOff = 1, // 0은 피하는 것이 좋다.
    MGUOnOffSkinTypeOn,
    MGUOnOffSkinTypeTouchDown1,
    MGUOnOffSkinTypeTouchDown2
};

@protocol MGUOnOffSkinInterface <NSObject>
- (CGFloat)duration; //@property (nonatomic, assign) CGFloat duration; // 디폴트 0.1;
- (void)setDuration:(CGFloat)duration;
- (void)setSkinType:(MGUOnOffSkinType)skinType animated:(BOOL)animated;
@end



NS_ASSUME_NONNULL_END
