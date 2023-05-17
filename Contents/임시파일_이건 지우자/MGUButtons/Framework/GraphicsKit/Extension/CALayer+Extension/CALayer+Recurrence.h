//
//  CALayer+Recurrence.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-04-01
//  ----------------------------------------------------------------------
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Recurrence)

- (NSArray<__kindof CALayer *> *)mgrRecurrenceAllSubLayers; // 자기자신을 포함한 모든 서브레이어
- (NSArray<__kindof CALayer *> *)mgrRecurrenceAllSubLayersOfType:(Class)classObject; // Class에 해당하는 자기자신을 포함한 모든 서브레이어들의 배열
// Class에 해당하는(__kindof) 수퍼 layer를 만날 때까지 위로 찾아서 최초로 찾으면 그 객체(1개)를 반환한다.
- (__kindof CALayer * _Nullable)mgrRecurrenceSuperLayersOfType:(Class)classObject;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-04-01 : 라이브러리 정리됨
 */
