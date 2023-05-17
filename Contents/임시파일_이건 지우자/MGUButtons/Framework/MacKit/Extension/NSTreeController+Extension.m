//
//  NSTreeController+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//


#import "NSTreeController+Extension.h"

@implementation NSTreeController (Extension)

- (NSIndexPath * _Nullable)mgrIndexPathOfObject:(id)object {
    return [self mgrIndexPathOfObject:object nodes:self.arrangedObjects.childNodes];
}

- (NSIndexPath * _Nullable)mgrIndexPathOfObject:(id)object nodes:(NSArray <NSTreeNode *>*)nodes{
    for (NSTreeNode *node in nodes) {
        id representedObject = node.representedObject;
        if ([object isEqual:representedObject] == YES && [representedObject isKindOfClass:[object class]] == YES) {
            return node.indexPath;
        } else if (node.childNodes != nil && node.childNodes.count > 0) {
            NSIndexPath *path = [self mgrIndexPathOfObject:object nodes:node.childNodes];
            if (path != nil) {
                return path;
            }
        }
    }
    return nil;
}
/* 이렇게 한방에 끝낼 수 있을 것 같다.
- (NSIndexPath * _Nullable)mgrIndexPathOfObject:(id)object {
    __weak NSIndexPath * (^__block weakConditionalBlock)(NSArray <NSTreeNode *>*);
    NSIndexPath * (^__block conditionalBlock)(NSArray <NSTreeNode *>*);
    weakConditionalBlock = conditionalBlock = ^NSIndexPath * (NSArray <NSTreeNode *>*nodes){
        NSIndexPath * (^__block strongConditionalBlock)(NSArray <NSTreeNode *>*) = weakConditionalBlock;
        for (NSTreeNode *node in nodes) {
            id representedObject = node.representedObject;
            if ([object isEqual:representedObject] == YES && [representedObject isKindOfClass:[object class]] == YES) {
                return node.indexPath;
            } else if (node.childNodes != nil && node.childNodes.count > 0) {
                NSIndexPath *path = strongConditionalBlock(node.childNodes);
                if (path != nil) {
                    return path;
                }
            }
        }
        return nil;
    };
    return conditionalBlock(self.arrangedObjects.childNodes);
}
*/

@end
