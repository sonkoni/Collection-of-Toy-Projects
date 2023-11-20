//
//  MGRPub+Foundation.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-02-28
//  ----------------------------------------------------------------------
//  퍼브의 파운데이션 확장. 그때그때 필요할 때 계속 업데이트 할거여.

#import <Foundation/Foundation.h>
#import <BaseKit/MGRPub.h>
#import <BaseKit/MGRTagObject.h>
#import <BaseKit/MGRKeyObject.h>

@interface NSString (MGRPub)
// 한 글자씩 던진다.
- (MGRPub<NSString*> *)mgrPub;
@end


@interface NSArray<__covariant ObjectType> (MGRPub)
// 배열 순서대로 한 객체씩 던진다.
- (MGRPub<ObjectType> *)mgrPub;
// TagObject 형식으로 배열 인덱스와 객체를 담아 하나씩 던진다.
- (MGRPub<MGRTagObject<ObjectType>*> *)mgrPubTagObject;
@end


@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (MGRPub)
// 딕셔너리 단품을 하나씩 던진다.
- (MGRPub<NSDictionary<KeyType,ObjectType>*> *)mgrPub;
// 딕셔너리 단품을 KeyObject 에 담아 던진다.
- (MGRPub<MGRKeyObject<KeyType,ObjectType>*> *)mgrPubKeyObject;
@end


@interface NSNotificationCenter (MGRPub)
// 특정 키의 노티피케이션에 반응한다.
+ (MGRPub<NSNotification*> *)mgrPub:(NSString *)key;
@end
