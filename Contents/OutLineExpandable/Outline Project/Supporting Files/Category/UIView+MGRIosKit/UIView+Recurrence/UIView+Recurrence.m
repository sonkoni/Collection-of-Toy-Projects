//
//  UIView+Recurrence.m
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "UIView+Recurrence.h"

@implementation UIView (Recurrence)

- (NSArray<UIView *> *)mgrRecurrenceAllSubviews {
    NSMutableArray <UIView *> *all = @[].mutableCopy;
    void (^getSubViewsBlock)(UIView *current) = ^(UIView *current){
        [all addObject:current];
        for (UIView *sub in current.subviews) {
            [all addObjectsFromArray:[sub mgrRecurrenceAllSubviews]];
        }
    };
    getSubViewsBlock(self);
    return [NSArray arrayWithArray:all];
}

- (NSArray<__kindof UIView *> *)mgrRecurrenceAllSubviewsOfType:(Class)type {
    NSMutableArray <UIView *> *all = @[].mutableCopy;
    void (^getSubViewsBlock)(UIView *current) = ^(UIView *current){
        
        if ([current isKindOfClass:type] == YES) {
            [all addObject:current];
        }
        
        for (UIView *sub in current.subviews) {
            [all addObjectsFromArray:[sub mgrRecurrenceAllSubviewsOfType:type]];
        }
    };
    getSubViewsBlock(self);
    return [NSArray arrayWithArray:all];
}

@end

/** swift 버전
https://stackoverflow.com/questions/7243888/how-to-list-out-all-the-subviews-in-a-uiviewcontroller-in-ios
https://stackoverflow.com/a/45297466/5321670
extension UIView {
    func recurrenceAllSubviews() -> [UIView] {
        var all = [UIView]()
        func getSubview(view: UIView) {
            all.append(view)
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
 **/
