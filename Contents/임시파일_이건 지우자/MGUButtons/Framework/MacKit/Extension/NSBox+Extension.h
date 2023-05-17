//
//  NSBox+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-02
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBox (Extension)

// 일반적인 면 색, 보더 색, 보더 굵기, 라디어스가 설정되는 뷰
// 투명은 transparent 프라퍼티로 조정하라.
- (void)mgrBackgroundColor:(NSColor *_Nullable)backgroundColor
               borderColor:(NSColor *_Nullable)borderColor
               borderWidth:(CGFloat)borderWidth
              cornerRadius:(CGFloat)cornerRadius;
@end

NS_ASSUME_NONNULL_END
