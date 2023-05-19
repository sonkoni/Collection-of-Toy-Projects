//
//  MGRBlockType.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-05-13
//  ----------------------------------------------------------------------
//  기본 블락 타입 정의

#ifndef MGRBlockType_h
#define MGRBlockType_h
#import <Foundation/Foundation.h>

/// 사운드 재생 블락
//    일반객체에서 사운드 재생이 필요할 경우 다음과 같이 주입용 프로퍼티를 열어주고
//    @property (nonatomic, nullable) MGRSoundPlayBlock actionSound;
//    코디네이터에서 특정 사운드를 주입해준다.
typedef void (^MGRSoundPlayBlock)(void);



#endif /* MGRBlockType_h */
