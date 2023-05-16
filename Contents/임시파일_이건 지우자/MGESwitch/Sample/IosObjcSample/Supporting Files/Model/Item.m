//
//  Item.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "Item.h"
@interface Item ()
// 이 자체를 아예 빼고 Equal 및 hash를 지워야하는지 판단이 서지 않는다. 데이터를 넣지 않는 것은 확실하다.
@property (nonatomic, strong) NSUUID *identifier; // string = [[NSUUID new] UUIDString];
@end

@implementation Item

- (instancetype)initWithText:(NSString *)text detailText:(NSString *)detailText {
    self = [super init];
    if(self) {
        _textLabelText = text;
        _detailTextLabelText = detailText;
        _identifier = [NSUUID new];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }

    return [self isEqualToItem:(__typeof(self))object];
}


#pragma mark - <NSSecureCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder { // <NSCoding> 프로토콜 메서드
    self = [super init]; // NSObject가 만약 initWithCoder:를 구현했었다라고 가정하면, self = [super initWithCoder:aDecoder];
    if(self) {
        /// 주석친 것처럼 쓰지말고, decodeObjectOfClass:forKey:를 쓰자. 이유는 NSSecureCoding 문서를 읽어보자.
        ///_personName = [aDecoder decodeObjectForKey:@"personName"];
        _textLabelText = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"textLabelText"];
        _detailTextLabelText = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"detailTextLabelText"];
        _identifier = [aDecoder decodeObjectOfClass:[NSUUID class] forKey:@"identifier"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder { // <NSCoding> 프로토콜 메서드
    // NSObject가 만약 encodeWithCoder:를 구현했었다라고 가정하면, [super encodeWithCoder:aCoder]; 추가해야된다.
    [aCoder encodeObject:self.textLabelText forKey:@"textLabelText"];
    [aCoder encodeObject:self.detailTextLabelText forKey:@"detailTextLabelText"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSUInteger)hash {
//    const NSUInteger prime = 31;
    NSUInteger result = [_identifier hash];
    return result;
}

//! 카피를 했을 때, 다르게 나와야 더 좋을 것이다.
- (id)copyWithZone:(NSZone *)zone {
    /* 내가 init를 막았다. init을 안막았을 때에는 이렇게 사용해도 될듯.
    Item *item = [[[self class] allocWithZone:zone] init];
    if (item) {
        item->_textLabelText = [_textLabelText copyWithZone:zone];
        item->_detailTextLabelText = [_detailTextLabelText copyWithZone:zone];
        item->_identifier = [NSUUID new]; // [_identifier copyWithZone:zone]; <- 이건 아닌듯. 고유성이 복사되서는 안된다.
    }
     */
    Item *item = [[[self class] allocWithZone:zone] initWithText:[_textLabelText copyWithZone:zone]
                                                      detailText:[_detailTextLabelText copyWithZone:zone]];
    return item;
}


#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToItem:(Item *)item {
    if (self == item) {
        return YES;
    }

    if (item == nil) {
        return NO;
    }
    
    BOOL haveEqualIdentifier = (!self.identifier && !item.identifier) || [self.identifier isEqual:item.identifier];
    return haveEqualIdentifier;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
