//
//  MGRBlockType.h
//

#ifndef MGRBlockType_h
#define MGRBlockType_h
#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------
// 반환값이 없고, 한 가지 타입만 받는 블락 정의

/// 약속된 사운드타입 재생 블락
//    일반객체에서 사운드 재생이 필요할 경우 다음과 같이 주입용 프로퍼티를 열어주고
//    @property (nonatomic, nullable) MGRSoundPlayBlock actionSound;
//    코디네이터에서 특정 사운드를 주입해준다.
typedef void (^MGRSoundPlayBlock)(void);








#endif /* MGRBlockType_h */



#ifndef Def_Assets_Sound
#define Def_Assets_Sound

#endif /* Def_Assets_Sound */
