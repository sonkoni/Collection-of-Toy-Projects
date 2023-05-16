//
//  MGACarouselScrollView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/19399242/soft-scroll-animation-nsscrollview-scrolltopoint
// https://apptyrant.com/2015/05/18/how-to-disable-nsscrollview-scrolling/
// https://stackoverflow.com/questions/5169355/callbacks-when-an-nsscrollview-is-scrolled
// https://stackoverflow.com/questions/3457926/contentsize-and-contentoffset-equivalent-in-nsscroll-view

#import "NSScrollView+Extension.h"
@class MGACarouselScrollView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 프로토콜 선언 <MGACarouselScrollViewDelegate>
//! iOS와 완전히 메커니즘이 같지 않으므로 똑같이 구현할 수는 없다.
@protocol MGACarouselScrollViewDelegate <NSObject>
@required
@optional
- (void)scrollViewWillBeginScrolling:(MGACarouselScrollView *)scrollView;
- (void)scrollViewDidScroll:(MGACarouselScrollView *)scrollView;

//! 손가락이 때어지면서 굴러가는 현상이 발동할 때에만 호출된다. 굴러가기 시작할 때.
- (void)scrollViewWillBeginDecelerating:(MGACarouselScrollView *)scrollView;

//! rollingStop NO이면 손가락이 떨어진 후 굴러간 것 없이 바로 stop.
//! offset 한계를 넘어서 직각으로 놓아서 놓은 곳에서 끌려가도 NO이다. 이 점은 iOS와 다르다.
//! rollingStop YES이면 손가락이 떨어진 후 굴러가다가 멈춘것. 강제로 손가락으로 멈추든, 자연스럽게 멈추든 그것은 구분할 수 없다.
- (void)scrollViewDidEndScrolling:(MGACarouselScrollView *)scrollView rollingStop:(BOOL)rollingStop;


- (void)scrollViewMayBeginScrolling:(MGACarouselScrollView *)scrollView; // 어떻게 될지는 알 수 없다.
- (void)scrollViewCancelledScrolling:(MGACarouselScrollView *)scrollView; // MayBegin 발동 후 아무 일 없이 손을 땜.

- (void)scrollViewDidEndScrollingAnimation:(MGACarouselScrollView *)scrollView; // programatically
@end


@interface MGACarouselScrollView : NSScrollView
@property (nonatomic, weak, nullable) id <MGACarouselScrollViewDelegate>scrollViewDelegate; // 애플이 Private으로 delegate 프라퍼티를 사용함.
@property(nonatomic, readonly, getter=isTracking) BOOL tracking; // @dynamic

@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled; // default YES.

@property(nonatomic, strong) NSEvent *currentEvent;

@end

NS_ASSUME_NONNULL_END
