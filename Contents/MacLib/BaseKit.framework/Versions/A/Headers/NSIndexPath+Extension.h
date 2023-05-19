//
//  NSIndexPath+Extension.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-04-24
//  ----------------------------------------------------------------------
//  MGRNode : 인덱스패쓰를 노드로 사용할 때 지원하는 확장
//      - 헷갈리면 안 되는게... 이런 식으로 패쓰를 뒤에 계속 추가하게 했으니까
//        어디까지 같이 왔고 어디서부터 달라지는지 알 수 있게 다음과 같이 했어.
//        수학의 교집합 차집합 용어와는 좀 달라. 적당한 말이 없어서 걍 그렇게 이름 붙였어.
//           source     1 - 5 - 7 - 3 - 8 - 2 .....
//           target     1 - 5 - 6 - 2 - 8 - 2 .....
//                      =====   ===================
//                      교집합        차집합
//                      = (1,5)     = (6,2,8,2)
//      - 이걸 통해서 지금 target 이 (1,5) 로부터 분기되어 source 와 다른 길을 걸었다는 걸 알 수 있거든
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (Node)
/// 타겟패쓰 교집합 추출 : 없으면 빈 NSIndexPath 반환
- (NSIndexPath *)mgrIntersect:(NSIndexPath *)target;

/// 타겟패쓰 차집합 추출 : 없으면 빈 NSIndexPath 반환
- (NSIndexPath *)mgrDifference:(NSIndexPath *)target;

/// 타겟패쓰 차집합의 첫 번째 값 추출 : 없으면 NSNotFound 반환(주의)
- (NSUInteger)mgrFirstDiff:(NSIndexPath *)target;

/// 마지막 패쓰 값 추출 : 없으면 NSNotFound 반환(주의)
- (NSUInteger)mgrLast;

/// 첫째 패쓰 값 추출 : 없으면 NSNotFound 반환(주의)
- (NSUInteger)mgrFirst;

/// 첫 패쓰 삭제된 패쓰 반환 : 없으면 빈 NSIndexPath 반환
- (NSIndexPath *)mgrRemoveFirst;

/// 패쓰를 문자열로 반환
- (NSString *)mgrString;

/// 패쓰를 나열한다 : 끝까지 나열한다.
- (void)mgrList:(void (^)(NSUInteger value))listBlock;

/// 패쓰를 나열한다 : 조건에 따라 stop 을 걸 수 있다.
- (void)mgrEnumerate:(void (^)(NSUInteger value, NSUInteger idx, BOOL *stop))listBlock;

/// 특정 값이 있으면 YES.
- (BOOL)mgrIsContains:(NSUInteger)value;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2020-04-24 : 1.2 - mgrIntersect 에서 배열길이가 0ㅇ로 만들어질 수 있는 문제 수정
 * 2020-04-15 : 라이브러리 정리됨
 */
