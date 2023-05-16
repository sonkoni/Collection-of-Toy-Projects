//
//  MGATextView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-24
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/11237622/using-autolayout-with-expanding-nstextviews
// https://stackoverflow.com/questions/24210153/nstextview-not-properly-resizing-with-auto-layout
// https://stackoverflow.com/questions/2654580/how-to-resize-nstextview-according-to-its-content

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGATextView
 @abstract      NSScrollView에 얹였을 때. 오토사이징이되게 만들었다.
 @discussion    ...
*/
@interface MGATextView : NSTextView

@end

NS_ASSUME_NONNULL_END

// 아래와 같이 사용할 수 있다. UIScrollView 와는 많이 다르다. scrollView.contentView는 clip 뷰로 스크롤 밖으로 삐져나와서는 안된다.
/*
_scrollView = [NSScrollView new];
self.scrollView.hasVerticalScroller = YES;
self.scrollView.identifier = @"ScrollView";
[self.container addSubview:self.scrollView];
self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
[self.scrollView.centerXAnchor constraintEqualToAnchor:self.container.centerXAnchor].active = YES;
[self.scrollView.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor].active = YES;
[self.scrollView.widthAnchor constraintEqualToConstant:400.0].active = YES;
NSLayoutConstraint *constraint = [self.scrollView.heightAnchor constraintLessThanOrEqualToConstant:140.0];
constraint.active = YES;

MGATextView *textView = [MGATextView new];
textView.translatesAutoresizingMaskIntoConstraints = NO;
textView.identifier = @"Content container";
self.scrollView.documentView = textView;
[textView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentView.leadingAnchor].active = YES;
[textView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentView.trailingAnchor].active = YES;
[textView.topAnchor constraintEqualToAnchor:self.scrollView.contentView.topAnchor].active = YES;
[textView.widthAnchor constraintEqualToAnchor:self.scrollView.contentView.widthAnchor].active = YES;

constraint = [textView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentView.bottomAnchor];
constraint.priority = NSLayoutPriorityFittingSizeCompression;
constraint.active = YES;

NSBundle *bundle = [NSBundle mainBundle];
NSString *sFile= [bundle pathForResource:@"Credits" ofType:@"rtf"];
[textView readRTFDFromFile:sFile];
*/
