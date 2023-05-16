//
//  NSView+Recurrence.m
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "NSView+Recurrence.h"

@implementation NSView (Recurrence)

- (NSArray<NSView *> *)mgrRecurrenceAllSubviews {
    NSMutableArray <NSView *> *all = @[].mutableCopy;
    void (^getSubViewsBlock)(NSView *current) = ^(NSView *current){
        [all addObject:current];
        for (NSView *sub in current.subviews) {
            [all addObjectsFromArray:[sub mgrRecurrenceAllSubviews]];
        }
    };
    getSubViewsBlock(self);
    return [NSArray arrayWithArray:all];
}

- (NSArray<__kindof NSView *> *)mgrRecurrenceAllSubviewsOfType:(Class)classObject {
    NSMutableArray <NSView *> *all = @[].mutableCopy;
    void (^getSubViewsBlock)(NSView *current) = ^(NSView *current){
        
        if ([current isKindOfClass:classObject] == YES) {
            [all addObject:current];
        }
        
        for (NSView *sub in current.subviews) {
            [all addObjectsFromArray:[sub mgrRecurrenceAllSubviewsOfType:classObject]];
        }
    };
    getSubViewsBlock(self);
    return [NSArray arrayWithArray:all];
}

- (__kindof NSView * _Nullable)mgrRecurrenceSearchFirstSubviewOfType:(Class)classObject {
    __block __kindof NSView *result = nil;
    void (^getFindSubViewBlock)(NSView *current) = ^(NSView *current){
        if ([current isKindOfClass:classObject] == YES) {
            result = current;
            return;
        }

        for (NSView *sub in current.subviews) {
            id temp = [sub mgrRecurrenceSearchFirstSubviewOfType:classObject];
            if (temp != nil) {
                result = temp;
                return;
            }
        }
    };
    getFindSubViewBlock(self);
    return result;
}

- (__kindof NSView * _Nullable)mgrRecurrenceSuperviewsOfType:(Class)classObject {
    NSView *view = self;
    while (view.superview != nil) {
        view = view.superview;
        if ([view isKindOfClass:classObject] == YES) {
            return view;
        }
    }
    return nil;
}

@end

/** swift 버전
https://stackoverflow.com/questions/7243888/how-to-list-out-all-the-subviews-in-a-UIViewcontroller-in-ios
https://stackoverflow.com/a/45297466/5321670
extension NSView {
    func recurrenceAllSubviews() -> [NSView] {
        var all = [NSView]()
        func getSubview(view: NSView) {
            all.append(view)
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
 **/
