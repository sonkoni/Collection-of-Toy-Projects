//
//  SwipeCellModel.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "SwipeCellModel.h"

@interface SwipeCellModel ()
@end

@implementation SwipeCellModel
+ (instancetype)favCellModelWithMainDescription:(NSString *)mainDescription
                                      leftValue:(NSString *)leftValue
                                     rightValue:(NSString *)rightValue {
    return [[SwipeCellModel alloc] initWithMainDescription:mainDescription
                                                  leftValue:leftValue
                                                 rightValue:rightValue];
    
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithMainDescription:(NSString *)mainDescription
                              leftValue:(NSString *)leftValue
                             rightValue:(NSString *)rightValue {
    self = [super init];
    if (self) {
        _mainDescription = mainDescription;
        _leftValue = leftValue;
        _rightValue = rightValue;
    }
    return self;
}


#pragma mark - <NSSecureCoding>
- (instancetype)initWithCoder:(NSCoder *)coder { // <NSCoding> 프로토콜 메서드
    self = [super init]; // NSObject가 만약 initWithCoder:를 구현했었다라고 가정하면, self = [super initWithCoder:aDecoder];
    if(self) {
        _leftValue = [coder decodeObjectOfClass:[NSString class] forKey:@"leftValue"];
        _mainDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"mainDescription"];
        _rightValue = [coder decodeObjectOfClass:[NSString class] forKey:@"rightValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder { // <NSCoding> 프로토콜 메서드
    // NSObject가 만약 encodeWithCoder:를 구현했었다라고 가정하면, [super encodeWithCoder:aCoder]; 추가해야된다.
    [coder encodeObject:self.leftValue forKey:@"leftValue"];
    [coder encodeObject:self.mainDescription forKey:@"mainDescription"];
    [coder encodeObject:self.rightValue forKey:@"rightValue"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}


#pragma mark - <NSItemProviderWriting>
- (NSProgress *)loadDataWithTypeIdentifier:(NSString *)typeIdentifier
          forItemProviderCompletionHandler:(void (^)(NSData *data, NSError *error))completionHandler {
    
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
    
    __autoreleasing NSError *error = nil;
    @try {
        // NSDictionary *dic = @{ SwipeCellModelLeftKey : self.leftValue,
        //                        SwipeCellModelMainDescriptionKey : self.mainDescription,
        //                        SwipeCellModelRightKey : self.rightValue };
        // NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self
                                             requiringSecureCoding:NO
                                                             error:&error];
        progress.completedUnitCount = 100;
        completionHandler(data, nil);
        [error mgrMakeExceptionAndThrow];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        completionHandler(nil, error);
    }
    
    return progress;
}

+ (NSArray<NSString *> *)writableTypeIdentifiersForItemProvider {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 150000 // Deployment Target 이 15.0이다. 기계가 15 이상부터 다 들어온다.
    return @[UTTypeData.identifier];
#else // Deployment Target 이 15 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 15, *)) {
        return @[UTTypeData.identifier];
    } else {
        return @[(NSString *)kUTTypeData];
    }
#endif
}


#pragma mark - <NSItemProviderReading>
+ (instancetype)objectWithItemProviderData:(NSData *)data
                            typeIdentifier:(NSString *)typeIdentifier
                                     error:(NSError * _Nullable *)outError {
    __autoreleasing NSError *error = nil;
    @try {
        // NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        // SwipeCellModel *subject = [SwipeCellModel favCellModelWithMainDescription:dic[SwipeCellModelMainDescriptionKey]
        //                                                                   leftValue:dic[SwipeCellModelLeftKey]
        //                                                                  rightValue:dic[SwipeCellModelRightKey]];
        SwipeCellModel *subject = [NSKeyedUnarchiver unarchivedObjectOfClass:[SwipeCellModel class] fromData:data error:&error];
        
        [error mgrMakeExceptionAndThrow];
        return subject;
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        NSCAssert(FALSE, @"fatalError 발생");
    }
}

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 150000 // Deployment Target 이 15.0이다. 기계가 15 이상부터 다 들어온다.
    return @[UTTypeData.identifier];
#else // Deployment Target 이 15 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 15, *)) {
        return @[UTTypeData.identifier];
    } else {
        return @[(NSString *)kUTTypeData];
    }
#endif
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
