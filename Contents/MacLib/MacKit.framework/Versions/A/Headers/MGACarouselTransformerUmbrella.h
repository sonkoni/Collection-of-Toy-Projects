//
//  MGACarouselTransformerUmbrella.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//
// MGACarouselTransformer 클래스를 상속받은 객체들의 모임이다.

#ifndef MGACarouselTransformerUmbrella_h
#define MGACarouselTransformerUmbrella_h

//! - Wrap 가능 - Supplementary View 이용.
#import <MacKit/MGACarouselLinearTransformer.h>
#import <MacKit/MGACarouselTimeMachineTransformer.h>
#import <MacKit/MGACarouselCoverFlowTransformer.h>
#import <MacKit/MGACarouselWheelTransformer.h>
#import <MacKit/MGACarouselCylinderTransformer.h>
#import <MacKit/MGACarouselRotaryTransformer.h>

#import <MacKit/MGACarouselCenterExpandTransformer.h>

//! - Wrap 불가능. Supplementary View 이용가능.
#import <MacKit/MGACarouselDiceTransformer.h>

#endif /* MGACarouselTransformerUmbrella_h */
