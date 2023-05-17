//
//  CALayer+Recurrence.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "CALayer+Recurrence.h"

@implementation CALayer (Recurrence)

- (NSArray <__kindof CALayer *>*)mgrRecurrenceAllSubLayers {
    NSMutableArray <CALayer *> *all = @[].mutableCopy;
    void (^getSubViewsBlock)(CALayer *current) = ^(CALayer *current){
        [all addObject:current];
        for (CALayer *sub in current.sublayers) {
            [all addObjectsFromArray:[sub mgrRecurrenceAllSubLayers]];
        }
    };
    getSubViewsBlock(self);
    return [NSArray arrayWithArray:all];
}

- (NSArray <__kindof CALayer *>*)mgrRecurrenceAllSubLayersOfType:(Class)classObject {
    NSMutableArray <CALayer *> *all = @[].mutableCopy;
    void (^getSubViewsBlock)(CALayer *current) = ^(CALayer *current){
        if ([current isKindOfClass:classObject] == YES) {
            [all addObject:current];
        }
        
        for (CALayer *sub in current.sublayers) {
            [all addObjectsFromArray:[sub mgrRecurrenceAllSubLayersOfType:classObject]];
        }
    };
    getSubViewsBlock(self);
    return [NSArray arrayWithArray:all];
}

- (__kindof CALayer * _Nullable)mgrRecurrenceSuperLayersOfType:(Class)classObject {
    CALayer *layer = self;
    while (layer.superlayer != nil) {
        layer = layer.superlayer;
        if ([layer isKindOfClass:classObject] == YES) {
            return layer;
        }
    }
    return nil;
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
