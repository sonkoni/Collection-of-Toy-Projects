//
//  NSTextField+Label.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/03/09.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

//! https://stackoverflow.com/questions/1507644/sample-code-for-creating-a-nstextfield-label
//! MacOS 는 NSLabel 객체가 없다. Sierra 부터는 라벨 세팅된 객체로 반환해주는 편의 메서드가 존재한다.
@interface NSTextField (Label)

//! non-editable, selectable, wrapping : 멀티라인. 셀렉터블
+ (instancetype)mgrWrappingLabelWithString:(NSString *)stringValue;


//! non-editable, non-selectable, non-wrapping
+ (instancetype)mgrLabelWithString:(NSString *)stringValue;

//! non-editable, non-selectable : line break mode of this field is determined by the attributed string's NSParagraphStyle attribute.
+ (instancetype)mgrLabelWithAttributedString:(NSAttributedString *)attributedStringValue;

@end

NS_ASSUME_NONNULL_END
