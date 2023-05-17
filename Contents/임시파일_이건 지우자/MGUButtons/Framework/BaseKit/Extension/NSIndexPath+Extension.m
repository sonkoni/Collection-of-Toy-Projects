//
//  NSIndexPath+Extension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSIndexPath+Extension.h"

@implementation NSIndexPath (Node)
- (NSIndexPath *)mgrIntersect:(NSIndexPath *)target {
    NSUInteger length = MIN(self.length, target.length);
    NSUInteger diffIdx = length;
    for (NSUInteger idx = 0; idx < length; idx++) {
        NSUInteger position = [self indexAtPosition:idx];
        if (position != [target indexAtPosition:idx]) {
            diffIdx = idx;
            break;
        }
    }
    NSRange extractRange = NSMakeRange(0, diffIdx);
    if (!extractRange.length) {
        return [NSIndexPath new];
    }
    NSUInteger cArray[extractRange.length];
    [target getIndexes:cArray range:extractRange];
    return [NSIndexPath indexPathWithIndexes:cArray length:extractRange.length];
    //
    //  쓸데없이 객체를 생산하고 버리고 반복해서 삭제한 코드. 우아하지 않잖아.
    //  처음에 생각해낼 때 애써서 그런지 버리기 아깝긴 하지만... 버리겠어..
    //  다만, 무조건 immutable 한 객체에 대해, 버퍼를 쓸 수도 없는 제약 상황에서는
    //  다음과 같은 객체 순환형태의 mutable 구현이 쓸모있을 듯
    //  ---------------------------------------------------------
    //    NSUInteger length = MIN(self.length, target.length);
    //    NSIndexPath *indexPath = [NSIndexPath new];
    //    for (NSUInteger idx = 0; idx < length; idx++) {
    //        NSUInteger position = [self indexAtPosition:idx];
    //        if (position == [target indexAtPosition:idx]) {
    //            indexPath = [indexPath indexPathByAddingIndex:position];
    //        } else {
    //            break;
    //        }
    //    }
    //    return indexPath;
    //
}

- (NSIndexPath *)mgrDifference:(NSIndexPath *)target {
    NSUInteger length = MIN(self.length, target.length);
    NSUInteger diffIdx = length;
    for (NSUInteger idx = 0; idx < length; idx++) {
        NSUInteger position = [self indexAtPosition:idx];
        if (position != [target indexAtPosition:idx]) {
            diffIdx = idx;
            break;
        }
    }
    NSRange extractRange = NSMakeRange(diffIdx, target.length - diffIdx);
    if (!extractRange.length) {
        return [NSIndexPath new];
    }
    NSUInteger cArray[extractRange.length];
    [target getIndexes:cArray range:extractRange];
    return [NSIndexPath indexPathWithIndexes:cArray length:extractRange.length];
}

- (NSUInteger)mgrFirstDiff:(NSIndexPath *)target {
    NSUInteger length = MIN(self.length, target.length);
    NSUInteger diffIdx = length;
    for (NSUInteger idx = 0; idx < length; idx++) {
        NSUInteger position = [self indexAtPosition:idx];
        if (position != [target indexAtPosition:idx]) {
            diffIdx = idx;
            break;
        }
    }
    NSUInteger diffFirst = NSNotFound;
    if ((target.length - diffIdx) > 0) {
        diffFirst = [target indexAtPosition:diffIdx];
    }
    return diffFirst;
}

- (NSUInteger)mgrLast {
    return [self indexAtPosition:(self.length - 1)];
}

- (NSUInteger)mgrFirst {
    return [self indexAtPosition:0];
}

- (NSIndexPath *)mgrRemoveFirst {
    if (self.length < 1) {
        return [NSIndexPath new];
    }
    NSRange extractRange = NSMakeRange(1, self.length - 1);
    NSUInteger cArray[extractRange.length];
    [self getIndexes:cArray range:extractRange];
    return [NSIndexPath indexPathWithIndexes:cArray length:extractRange.length];
    
}

- (NSString *)mgrString {
    if (self.length < 1) {
        return [NSString new];
    }
    NSRange extractRange = NSMakeRange(0, self.length);
    NSUInteger cArray[extractRange.length];
    [self getIndexes:cArray range:extractRange];
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"%ld", cArray[0]];
    for (NSUInteger i = 1; i < self.length; i++) {
        [mStr appendFormat:@" - %ld", cArray[i]];
    }
    return mStr;
}

- (void)mgrList:(void (^)(NSUInteger))listBlock {
    for (NSUInteger idx = 0; idx < self.length; idx++) {
        listBlock([self indexAtPosition:idx]);
    }
}

- (void)mgrEnumerate:(void (^)(NSUInteger, NSUInteger, BOOL * _Nonnull))listBlock {
    BOOL stop = NO;
    for (NSUInteger idx = 0; idx < self.length; idx++) {
        listBlock([self indexAtPosition:idx], idx, &stop);
        if(stop) {
            break;
        }
    }
    // ----------- 사용 예시  -----------------
    // 패쓰에 8088 이 있으면 중지하고, 그렇지 않으면 로그뽑아
    //      [nodePath enumerateNode:^(NSUInteger value, NSUInteger idx, BOOL * _Nonnull stop) {
    //          if (value == 8088) {
    //               *stop = YES;
    //          } else {
    //             NSLog(@"----> %ld, %ld", value, idx);
    //          }
    //      }];
}

- (BOOL)mgrIsContains:(NSUInteger)value {
    BOOL isFound = NO;
    for (NSUInteger idx = 0; idx < self.length; idx++) {
        if ([self indexAtPosition:idx] == value) {
            isFound = YES;
            break;
        }
    }
    return isFound;
}
@end
