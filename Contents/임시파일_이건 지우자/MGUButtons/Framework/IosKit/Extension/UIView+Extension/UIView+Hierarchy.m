//
//  UIView+Hierarchy.m
//  HierarchyTest
//
//  Created by Kwan Hyun Son on 22/11/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "UIView+Hierarchy.h"

@implementation UIView (Hierarchy)

+ (NSMutableString *)printInLineHierarchyForDestinationView:(__kindof UIView *)view {
    return [UIView printHierarchyOfViews:[UIView reverseHierarchyOfView:view]];
}


#pragma mark - Private

+ (NSMutableArray <__kindof UIView *>*)reverseHierarchyOfView:(__kindof UIView *)view {
    NSMutableArray <__kindof UIView *>*views = @[view].mutableCopy;
    for ( UIView *searchView = view ; searchView.superview != nil ; searchView = searchView.superview ) {
        [views addObject:searchView.superview];
    }
    return [[views reverseObjectEnumerator] allObjects].mutableCopy;
}

+ (NSMutableString *)printHierarchyOfViews:(NSMutableArray <__kindof UIView *>*)views {
    
    NSMutableString *result = [NSMutableString stringWithFormat:@"\n%@    %p", [views.firstObject class], views.firstObject];
    NSString *unitSpace = @"    ";
    
    for (int i = 1; i < views.count; i++) {
        NSMutableString *space = unitSpace.mutableCopy;
        for (int j = 1; j < i; j++) {
            [space appendString:unitSpace];
        }
        [result appendFormat:@"\n%@L %@    %p", space, [views[i] class], views[i]];
    }
    
    return result;
}

@end
