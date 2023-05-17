//
//  MGALabel.h
//  FontFit_Mac
//
//  Created by Kwan Hyun Son on 2022/10/22.
//
//  폰트 크기를 찾는 알고리즘을 최적화하라.
// https://medium.com/@joncardasis/dynamic-text-resizing-in-swift-3da55887beb3
// https://github.com/joncardasis/FontFit  <- 2019년도 자료인듯 이 자료에 영감을 얻어서 만들었다. iOS용 이지만 참고해서 만들었음.
// https://stackoverflow.com/questions/2908704/get-nstextfield-contents-to-scale <- 2018년도 자료인듯
// https://stackoverflow.com/questions/4503307/change-nstextfield-font-size-to-fit
// https://stackoverflow.com/questions/3324354/how-can-i-tell-nstextfield-to-autoresize-its-font-size-to-fit-its-text

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGALabelFixType
 @abstract   보통 Width를 고정해서 사용할 것이다. 그 크기에 맞춰서 Height는 자유를 주고 font를 조정하는 것으로 사용할 듯.
 @constant   MGALabelFixTypeWidth   width가 고정된 상태에서 Height를 Free로 했을 때, 폰트 크기 조정. 라인 갯수는 프로그래머가 결정.
 @constant   MGALabelFixTypeHeight   .....
 @constant   MGALabelFixTypeBoth   .....
 */
typedef NS_ENUM(NSUInteger, MGALabelFixType) {
    MGALabelFixTypeWidth = 0, // 디폴트: 이것만 사용할 것으로 사료된다. 추후에 필요에 따라서 구현을 하자.
    MGALabelFixTypeHeight,
    MGALabelFixTypeBoth
};

/*!
 * @abstract    @c MGALabel 은 UILabel 이 갖는 bounds의 크기에 따라 font 사이즈를 조절하는 알고리즘을 구현한 객체이다. backup layer 존재함.
 * @discussion  기능도 역시 비슷하다. 그러나 UILabel 과 다르게 Single Line과 Multi Line으로 구분한다.
 *              UILabel은 라인의 갯수만 셀렉팅하는데 MacOS는 아예 모드가 다르게 진행된다.
 *              + labelWithString: <- 싱글라인
 *              + wrappingLabelWithString:  <- 멀티라인, 추가로 maximumNumberOfLines를 설정하면된다.
 *              + labelWithAttributedString:
 * @note        멀티 라인일 경우, 띄어쓰기가 존재하지 않을 때, 최소 크기에서 one line으로 표기할 수 있으면 표기한다.(애플 전략) anchorPoint (0.5, 0.5)이다. 초기 transform 안먹는 버그를 해결하기 위해 initalBlock 프라퍼티가 존재한다.
 * @warning     오토레이아웃으로 잡을 때, widthAnchor를 안잡으면 문제가 발생한다. 내부 알고리즘에 중복이 조금 많다. 건들기만 하면 버그가 생기니깐, 냅두겠다. 더 필요성이 생기면 그때 업데이트 하겠다. 
 */
@interface MGALabel : NSTextField

@property (nonatomic, assign) BOOL adjustsFontSizeToFitWidth; // 디폴트 YES
@property (nonatomic, assign) CGFloat minimumScaleFactor; // 디폴트 0.25
//@property NSInteger maximumNumberOfLines; super에 존재한다. iOS의 numberOfLines에 해당한다.
@property (nonatomic, assign) MGALabelFixType fixType; // 디폴트 MGALabelFixTypeWidth
- (void)updateFontIfNeeded;

+ (instancetype)mgrLabelWithString:(NSString *)str; // 싱글라인 라벨
+ (instancetype)mgrMultiLineLabelWithString:(NSString *)str; // 멀티라인 라벨

@property (nonatomic, copy, nullable) void (^initalBlock)(void); // 최초에 transform 이 안먹는 버그를 해결한다.

@property (nonatomic, assign) BOOL normalMode; // 일반 NSTextField 처럼 행동
- (NSFont *)realFont;
- (void)setRealFont:(NSFont *)font;
@end

NS_ASSUME_NONNULL_END
