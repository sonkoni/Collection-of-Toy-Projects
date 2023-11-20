//
//  MGREmpty.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-05-13
//  ----------------------------------------------------------------------
//  비어있는 상태를 표시하는 클래스. 상속 불가능함
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(BOOL, MGREmptyState) {
    MGREmptyNever   = 0,
    MGREmptyDone    = 1,
};

NS_ASSUME_NONNULL_BEGIN

@protocol MGREmptying <NSObject>
- (BOOL)state;
- (id<MGREmptying>)empty;
@end

// ----------------------------------------------------------------------
// 인스턴스. 상속불가능(Final Class), 비어있는 완료 상태. state 에 따라 다름.

@interface MGREmpty : NSObject <NSCopying, MGREmptying>
@property (nonatomic, assign, readonly) MGREmptyState state;
+ (instancetype)done;       // done 인스턴스
+ (instancetype)never;      // never 인스턴스
- (id<MGREmptying>)null;    // state 에 해당하는 싱글톤 반환
@end

// ----------------------------------------------------------------------
// 싱글톤. 상속불가능(Final Class), Hash 0 / 비어있음/완료못함/완료될 수 없음.

@interface MGRNever : NSObject <MGREmptying>
- (MGREmptyState)state; // NO(MGREmptyNever)
+ (MGRNever *)null;     // never 싱글톤
- (MGREmpty *)empty;    // state 에 해당하는 인스턴스 반환
@end

// ----------------------------------------------------------------------
// 싱글톤. 상속불가능(Final Class), Hash 0 / 비어있음/완료됨/완료될 것임.

@interface MGRDone : NSObject <MGREmptying>
- (MGREmptyState)state; // YES(MGREmptyDone)
+ (MGRDone *)null;      // done 싱글톤
- (MGREmpty *)empty;    // state 에 해당하는 인스턴스 반환
@end

NS_ASSUME_NONNULL_END
