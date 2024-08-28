//
//  ContentItem.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/09/01.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "OutlineContent.h"

@implementation OutlineContent

#pragma mark - 생성 & 소멸
- (instancetype)initWithTitle:(NSString *)title
          viewControllerClass:(Class)viewControllerClass {
    self = [super init];
    if (self) {
        _title = title;
        if ([viewControllerClass isSubclassOfClass:[UIViewController class]] == NO &&
            viewControllerClass != nil) {
            NSAssert(FALSE, @"두 번째 인수는 UIViewController 계통의 클래스 객체만 넣어야한다.");
        }
        
        _viewControllerClass = viewControllerClass;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title
          viewControllerClass:(Class)viewControllerClass {
    return [[OutlineContent alloc] initWithTitle:title viewControllerClass:viewControllerClass];
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [[OutlineContent alloc] initWithTitle:title viewControllerClass:nil];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
    
    return [self isEqualToContentItem:(__typeof(self))object];
}

- (id)copyWithZone:(NSZone *)zone {
    OutlineContent *item = [[[self class] allocWithZone:zone] init];
    if (item) {
        item->_title = [_title copyWithZone:zone];
        item->_viewControllerClass = _viewControllerClass;
    }

    return item;
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    NSUInteger result = [_title hash];
    result = prime * result + [_viewControllerClass hash];
    return result;
}

#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToContentItem:(OutlineContent *)item {
    if (self == item) {
        return YES;
    }

    if (item == nil) {
        return NO;
    }
    BOOL haveEqualTitle = (!self.title && !item.title) || [self.title isEqualToString:item.title];
    BOOL haveEqualViewControllerClass = self.viewControllerClass == item.viewControllerClass;
    return haveEqualTitle && haveEqualViewControllerClass;
}

#pragma mark - <NSSecureCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init]; // NSObject가 만약 initWithCoder:를 구현했었다라고 가정하면, self = [super initWithCoder:aDecoder];
    if(self) {
        _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _viewControllerClass = NSClassFromString([aDecoder decodeObjectOfClass:[NSString class] forKey:@"viewControllerClass"]);
    }
    return self;
    //
    // 주석친 것처럼 쓰지말고, decodeObjectOfClass:forKey:를 쓰자. 이유는 NSSecureCoding 문서를 읽어보자.
    //_personName = [aDecoder decodeObjectForKey:@"personName"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // NSObject가 만약 encodeWithCoder:를 구현했었다라고 가정하면, [super encodeWithCoder:aCoder]; 추가해야된다.
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:NSStringFromClass(self.viewControllerClass) forKey:@"viewControllerClass"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NS_UNAVAILABLE

+ (instancetype)new { NSAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSAssert(FALSE, @"- init 사용금지."); return nil; }
@end
