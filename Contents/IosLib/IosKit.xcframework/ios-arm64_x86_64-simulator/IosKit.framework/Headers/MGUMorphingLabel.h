//
//  LTMorphingLabel.h
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 23/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMorphingLabel;
@class MGUMorphingLabelCharLimbo;
@class MGUMorphingLabelEmitterView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGUMorphingLabelEffect) {
    MGUMorphingLabelEffectScale = 1,
    MGUMorphingLabelEffectEvaporate,
    MGUMorphingLabelEffectFall,
    MGUMorphingLabelEffectPixelate,
    MGUMorphingLabelEffectSparkle,
    MGUMorphingLabelEffectBurn,
    MGUMorphingLabelEffectAnvil
};

#pragma mark - 프로토콜
@protocol MGUMorphingLabelDelegate <NSObject> //
@required
@optional
- (void)morphingDidStart:(MGUMorphingLabel *)label;
- (void)morphingDidComplete:(MGUMorphingLabel *)label;
- (void)morphingOnProgress:(MGUMorphingLabel *)label progress:(CGFloat)progress;
@end


#pragma mark - typedef
typedef void (^MGRMorphingStartClosure)(void);
typedef NSInteger (^MGRMorphingSkipFramesClosure)(void);
typedef CGFloat (^MGRMorphingManipulateProgressClosure)(NSInteger index, CGFloat progress, BOOL isNewChar);
typedef BOOL (^MGRMorphingDrawingClosure)(MGUMorphingLabelCharLimbo *);
typedef MGUMorphingLabelCharLimbo * _Nullable (^MGUMorphingLabelEffectClosure)(NSString *, NSInteger index, CGFloat progress);


typedef NSString * MGRMorphingPhases NS_STRING_ENUM; // buttons 딕셔너리의 키로 사용된다.
static MGRMorphingPhases const MGRMorphingPhasesStart      = @"MGRMorphingPhasesStart";
static MGRMorphingPhases const MGRMorphingPhasesAppear     = @"MGRMorphingPhasesAppear";
static MGRMorphingPhases const MGRMorphingPhasesDisappear  = @"MGRMorphingPhasesDisappear";
static MGRMorphingPhases const MGRMorphingPhasesDraw       = @"MGRMorphingPhasesDraw";
static MGRMorphingPhases const MGRMorphingPhasesProgress   = @"MGRMorphingPhasesProgress";
static MGRMorphingPhases const MGRMorphingPhasesSkipFrames = @"MGRMorphingPhasesSkipFrames";

#pragma mark - 인터페이스

IB_DESIGNABLE // 반드시 아랫줄을 붙여야한다.
@interface MGUMorphingLabel : UILabel

@property (nonatomic) IBInspectable CGFloat morphingProgress; // 디폴트 0.0
@property (nonatomic) IBInspectable CGFloat morphingDuration; // 디폴트 0.6
@property (nonatomic) IBInspectable CGFloat morphingCharacterDelay; // 디폴트 0.026
@property (nonatomic) IBInspectable BOOL morphingEnabled; // 디폴트 YES

@property (weak, nullable) IBOutlet id <MGUMorphingLabelDelegate>delegate;
@property (nonatomic, strong, nullable) NSMutableDictionary <NSAttributedStringKey, NSObject *>*textAttributes;

- (void)start;
- (void)pause;
- (void)unpause;
- (void)finish;
- (void)stop;
- (void)updateProgress:(CGFloat)progress;

/// 패밀리 공유 인터페이스.
@property (nonatomic, strong) NSMutableArray <NSValue *>*previousRects; // (CGRect) 각각의 캐릭터의 프레임을 담은 배열
@property (nonatomic, strong) NSMutableArray <NSValue *>*freshRects;    // (CGRect) 각각의 캐릭터의 프레임을 담은 배열
@property (nonatomic, strong) MGUMorphingLabelEmitterView *emitterView; // lazy;
@property (nonatomic, assign) MGUMorphingLabelEffect morphingEffect; // 디폴트 MGUMorphingLabelEffectScale

@property (nonatomic, strong) NSMutableDictionary <NSString *, MGRMorphingStartClosure>*startClosures;
@property (nonatomic, strong) NSMutableDictionary <NSString *, MGRMorphingSkipFramesClosure>*skipFramesClosures;
@property (nonatomic, strong) NSMutableDictionary <NSString *, MGRMorphingManipulateProgressClosure>*progressClosures;
@property (nonatomic, strong) NSMutableDictionary <NSString *, MGRMorphingDrawingClosure>*drawingClosures;
@property (nonatomic, strong) NSMutableDictionary <NSString *, MGUMorphingLabelEffectClosure>*effectClosures;

@end

NS_ASSUME_NONNULL_END
