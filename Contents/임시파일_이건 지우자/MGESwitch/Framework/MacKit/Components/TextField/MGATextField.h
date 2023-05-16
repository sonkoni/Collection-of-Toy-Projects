//
//  MGATextField.h
//  TESTTextFieldCell
//
//  Created by Kwan Hyun Son on 2022/10/06.
//
// 애플의 구형코드(SourceView 프로젝트)를 참고했다. 현재는 이름이 바뀌고 내용도 내가 원하는 내용이 아니다.
// https://developer.apple.com/documentation/appkit/cocoa_bindings/navigating_hierarchical_data_using_outline_and_split_views?language=objc
// Navigating Hierarchical Data Using Outline and Split Views 현재는 이런 코드.
// https://stackoverflow.com/questions/10613870/using-image-as-a-background-for-nstextfield

#import <Cocoa/Cocoa.h>

/*!
 @enum       MGATextFieldType
 @abstract   ......
 @constant   MGATextFieldTypeNormal  애플의 Non border를 커버하고도 남는다.
 @constant   MGATextFieldTypeBackImage 나는 이미지도 넣을 수 있게 만들었다.
 @constant   MGATextFieldTypeLine             애플의 템플릿
 @constant   MGATextFieldTypeLineBackgroud    애플의 템플릿
 @constant   MGATextFieldTypeBezel            애플의 템플릿
 @constant   MGATextFieldTypeBezelBackgroud   애플의 템플릿
 @constant   MGATextFieldTypeRound            애플의 템플릿
 */
typedef NS_ENUM(NSUInteger, MGATextFieldType) {
    MGATextFieldTypeNormal = 0,
    MGATextFieldTypeBackImage,
    MGATextFieldTypeLine,
    MGATextFieldTypeLineBackgroud,
    MGATextFieldTypeBezel,
    MGATextFieldTypeBezelBackgroud,
    MGATextFieldTypeRound
};

NS_ASSUME_NONNULL_BEGIN
// 좌측에 이미지를 넣고 텍스트의 인셋을 주기 위해 만들었다. Apple의 Non border 타입을 위해 만들었다. 그래도 보더를 넣을 수 있게 만듬.
// 이미지는 알아서 줄여서 넣어야한다. MacOS 는 이미지를 잘 컨트롤하지 못한다.
// Apple의 보더가 있는 타입도 커버하게 만들었다. 기존 자료(MGABorderTextField, MGANonBorderTextField)는 폐기했다. 아카이브문서로.
@interface MGATextField : NSTextField

- (instancetype)initWithFrame:(NSRect)frameRect
              backgroundColor:(NSColor * _Nullable)backgroundColor
                  borderColor:(NSColor * _Nullable)borderColor
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius
                      padding:(CGFloat)padding
                textFieldType:(MGATextFieldType)textFieldType;

@property (nonatomic, strong, nullable) NSImage *backgroundImage;
@property (nonatomic, strong, nullable) NSImage *leftImage;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
+ (instancetype)labelWithString:(NSString *)stringValue NS_UNAVAILABLE;
+ (instancetype)wrappingLabelWithString:(NSString *)stringValue NS_UNAVAILABLE;
+ (instancetype)labelWithAttributedString:(NSAttributedString *)attributedStringValue NS_UNAVAILABLE;
+ (instancetype)textFieldWithString:(NSString *)stringValue NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

/**
MGATextField *myField =
[[MGATextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)
                             backgroundColor:[NSColor systemMintColor]
                                 borderColor:[NSColor systemPinkColor]
                                 borderWidth:0.0 // (1.0/[NSScreen mainScreen].backingScaleFactor)
                                cornerRadius:4.0
                                     padding:20];

[self.window.contentView addSubview:myField];
myField.translatesAutoresizingMaskIntoConstraints = NO;
[myField.topAnchor constraintEqualToAnchor:self.window.contentView.topAnchor constant:10.0].active = YES;
[myField.leadingAnchor constraintEqualToAnchor:self.window.contentView.leadingAnchor constant:10.0].active = YES;
[myField.widthAnchor constraintEqualToConstant:100.0].active = YES;
[myField.heightAnchor constraintEqualToConstant:20.0].active = YES;

NSImageSymbolConfiguration *config = [NSImageSymbolConfiguration configurationWithScale:NSImageSymbolScaleSmall];
NSImage *image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.up.on.square" accessibilityDescription:@""];
image = [image imageWithSymbolConfiguration:config];
image.template = YES;
myField.leftImage = image;
*/
