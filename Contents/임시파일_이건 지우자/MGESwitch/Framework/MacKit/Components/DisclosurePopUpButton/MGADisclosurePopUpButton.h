//
//  MGADisclosurePopUpButton.h
//  ButtonTEST
//
//  Created by Kwan Hyun Son on 2022/10/03.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*
 NSPopUpButton 로도 충분히 가능한데, NSPopover 에서 배경색이 안먹는 버그 때문에 쌩으로 만들었다.
 highlightedColor는 넣지 않는 것을 추천한다. nil을 넣으면 알아서 조금 어둡게 해준다.
 
 */
@interface MGADisclosurePopUpButton : NSPopUpButton
@property (nonatomic, strong, nullable) NSColor *highlightedColor; // 메뉴가 열렸을 때 배경색
@property (nonatomic, strong, nullable) NSColor *normalColor; // 메뉴가 열리지 않고 마우스 오버 되었을 때의 배경색

- (void)resetItemArray:(NSArray <NSMenuItem *>*)itemArray; // 중간에 메뉴를 교체해서 보여주고 싶을 때 사용한다.

// Target - Action 은 itemArray가 하는 것. 이미지만 넣는 것으로 예상하고 만들었다.
- (instancetype)initWithFrame:(NSRect)frameRect
                    itemArray:(NSArray <NSMenuItem *>*)itemArray
                  normalColor:(NSColor *)normalColor
             highlightedColor:(NSColor * _Nullable)highlightedColor
                      toolTip:(NSString *)toolTip NS_DESIGNATED_INITIALIZER;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)buttonFrame pullsDown:(BOOL)flag NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
