//
//  MMTFavCellModel.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MMTFavCellModel.h"

@interface MMTFavCellModel ()
@end

@implementation MMTFavCellModel
+ (instancetype)favCellModelWithMainDescription:(NSString *)mainDescription
                                      leftValue:(NSString *)leftValue
                                     rightValue:(NSString *)rightValue {
    return [[MMTFavCellModel alloc] initWithMainDescription:mainDescription
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


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
