//
//  NSScrollView+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-27
//  ----------------------------------------------------------------------
//
// iOS 처럼 편의 메서드를 추가했다.
// https://stackoverflow.com/questions/3457926/contentsize-and-contentoffset-equivalent-in-nsscroll-view
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/Introduction.html#//apple_ref/doc/uid/TP40003460-SW1

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScrollView (Extension)

// NSScrollView contentSize와는 다르다. iOS에서의 의미와 같다.
@property(nonatomic) CGSize mgrContentSize; // iOS self.collectionView.contentSize 와 동일

// iOS self.collectionView.contentOffset 와 동일
@property(nonatomic) CGPoint mgrContentOffset;

@property(nonatomic, readonly) CGPoint mgrMaxOffset;

// iOS self.collectionView.bounds 와 동일. 사이즈는 scrollView 액자 크기 origin은 offset
@property(nonatomic) CGRect clipViewBounds;

//! iOS와 유사하게 현재 스크롤이 있다면 쌩까고 할 수 있게 구현된 코드는 MGAScrollView 클래스를 참고하라.
- (void)setContentOffset:(CGPoint)contentOffset
                animated:(BOOL)animated
              completion:(void(^_Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
