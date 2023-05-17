//
//  MGATempAlert.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/11/07.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract    @c MGATempAlert 은 SnippetsLab앱의 메시지 나오는 동작을 재현했다.
 * @discussion  SnippetsLab앱에서 테이블 뷰를 스와이프하여 나온 버튼을 클릭하면서 나오는 HUD 블러된 알람 윈도우를 재현했다. 항상 모든 앱보다 앞에 뜨고 1.2 초 뒤에 자동으로 사라진다. 단순한 이미지와 텍스트로 이루어진 정사각형(200 X 200) 의 윈도우(타이틀바 없음)이다.
 */
@interface MGATempAlert : NSPanel
/*
- (IBAction)showTempAlert:(id)sender {
    if(self.tempAlert == nil) {
        NSImage *image = [NSImage imageWithSystemSymbolName:@"folder.fill" accessibilityDescription:@""];
        self.tempAlert = [MGATempAlert alertWithTitle:@"Snippet Copied" image:image];
    }
    [self.tempAlert showAndAutoHide];
}
*/
+ (instancetype)alertWithTitle:(NSString *)title image:(NSImage *)image;

- (void)showAndAutoHide; // Fade In -> Wait -> Fad Out

#pragma mark - NS_UNAVAILABLE : - initWithCoder: 메서드가 없다. xib 도 지정 초기화 메서드를 이용한다.
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)style
                            backing:(NSBackingStoreType)backingStoreType
                              defer:(BOOL)flag
                             screen:(NSScreen * _Nullable)screen  NS_UNAVAILABLE;
+ (instancetype)windowWithContentViewController:(NSViewController *)contentViewController NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
