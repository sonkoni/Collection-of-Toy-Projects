//
//  UIFeedbackGenerator+Extension.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UIFeedbackGenerator+Extension.h"
#import <AudioToolbox/AudioToolbox.h>


#pragma mark - UINotificationFeedbackGenerator 카테고리
@implementation UINotificationFeedbackGenerator (Extension)
+ (instancetype)mgrNew {
    UINotificationFeedbackGenerator *notificationFeedbackGenerator = [UINotificationFeedbackGenerator new];
    [notificationFeedbackGenerator prepare];
    return notificationFeedbackGenerator;
}
- (void)mgrNotificationOccurred:(UINotificationFeedbackType)notificationType {
    [self notificationOccurred:notificationType];
    [self prepare];
}
@end


#pragma mark - UIImpactFeedbackGenerator 카테고리
@implementation UIImpactFeedbackGenerator (Extension)
+ (instancetype)mgrImpactFeedbackGeneratorWithStyle:(UIImpactFeedbackStyle)style {
    UIImpactFeedbackGenerator *impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
    [impactFeedbackGenerator prepare];
    return impactFeedbackGenerator;
}
- (void)mgrImpactOccurred {
    [self impactOccurred];
    [self prepare];
}

- (void)mgrImpactOccurredWithIntensity:(CGFloat)intensity {
    [self impactOccurredWithIntensity:intensity];
    [self prepare];
}
@end


#pragma mark - UISelectionFeedbackGenerator 카테고리
@implementation UISelectionFeedbackGenerator (Extension)
+ (instancetype)mgrNew {
    UISelectionFeedbackGenerator *selectionFeedbackGenerator = [UISelectionFeedbackGenerator new];
    [selectionFeedbackGenerator prepare];
    return selectionFeedbackGenerator;
}
- (void)mgrSelectionChanged {
    [self selectionChanged];
    [self prepare];
}
@end


#pragma mark - 진동함수
void mgrSystemSoundID_Vibrate(void) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//     AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}
