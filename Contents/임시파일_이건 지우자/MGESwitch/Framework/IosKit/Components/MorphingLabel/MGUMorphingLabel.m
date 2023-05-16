//
//  LTMorphingLabel.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 23/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabel.h"
#import "MGUMorphingLabel+Evaporate.h"
#import "MGUMorphingLabel+Fall.h"
#import "MGUMorphingLabel+Pixelate.h"
#import "MGUMorphingLabel+Sparkle.h"
#import "MGUMorphingLabel+Burn.h"
#import "MGUMorphingLabel+Anvil.h"
#import "MGUMorphingLabelCharLimbo.h"
#import "NSString+MorphingLabel.h"
#import "MGUMorphingLabelStrDiffResult.h"
#import "MGUMorphingLabelCharDiffResult.h"
#import "MGUMorphingLabelEmitterView.h"
@import BaseKit;
@import GraphicsKit;

static NSString *MorphingLabelEffectDescription(MGUMorphingLabelEffect effect) {
    if (effect == MGUMorphingLabelEffectEvaporate) {
            return @"Evaporate";
    } else if (effect == MGUMorphingLabelEffectFall) {
        return @"Fall";
    } else if (effect == MGUMorphingLabelEffectPixelate) {
        return @"Pixelate";
    } else if (effect == MGUMorphingLabelEffectSparkle) {
        return @"Sparkle";
    } else if (effect == MGUMorphingLabelEffectBurn) {
        return @"Burn";
    } else if (effect == MGUMorphingLabelEffectAnvil) {
        return @"Anvil";
    } else {
        return @"Scale";
    }
}


@interface MGUMorphingLabel () // <LTMorphingLabelDelegate>
@property (nonatomic, assign) BOOL tempRenderMorphingEnabled; // 디폴트 YES
@property (nonatomic, strong, nullable) CADisplayLink *displayLink;

@property (nonatomic, assign) NSInteger currentFrame; // 디폴트 0
@property (nonatomic, assign) NSInteger totalFrames; // 디폴트 0
@property (nonatomic, assign) NSInteger totalDelayFrames; // 디폴트 0

@property (nonatomic, assign) CGFloat totalWidth; // 디폴트 0.0

@property (nonatomic, assign) CGFloat charHeight; // 디폴트 0.0
@property (nonatomic, assign) NSInteger skipFramesCount; // 디폴트 0

@property (nonatomic, strong) NSString *previousText; // 디폴트 @""

@property (nonatomic, strong, nullable) MGUMorphingLabelStrDiffResult *diffResults;

@end

@implementation MGUMorphingLabel

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

- (void)didMoveToSuperview {
    if (self.superview == nil) {
        [self stop];
        return;
    }
    
    if (self.text != nil) {
        self.text = self.text;
    }

    // Load all morphing effects
    [self EvaporateLoad];
    [self FallLoad];
    [self PixelateLoad];
    [self SparkleLoad];
    [self BurnLoad];
    [self AnvilLoad];
}

- (void)drawTextInRect:(CGRect)rect {
    if ((self.tempRenderMorphingEnabled == NO) || ([self limboOfCharacters].count == 0)) {
        [super drawTextInRect:rect];
        return;
    }
    
    for (MGUMorphingLabelCharLimbo *charLimbo in [self limboOfCharacters]) {
        CGRect charRect = charLimbo.rect;
        
        BOOL willAvoidDefaultDrawing;
        NSString *closureKey =
            [NSString stringWithFormat:@"%@%@", MorphingLabelEffectDescription(self.morphingEffect), MGRMorphingPhasesDraw];
        MGRMorphingDrawingClosure closure = self.drawingClosures[closureKey];
        if (closure != nil) {
            willAvoidDefaultDrawing = closure(charLimbo);
        } else {
            willAvoidDefaultDrawing = NO;
        }
        

        if (!willAvoidDefaultDrawing) {
            NSMutableDictionary <NSAttributedStringKey, NSObject *>*attrs = @{
            NSForegroundColorAttributeName : [self.textColor colorWithAlphaComponent:charLimbo.alpha],
            NSFontAttributeName: [UIFont fontWithDescriptor:self.font.fontDescriptor size:charLimbo.size]
            }.mutableCopy;
            
            
            for (NSAttributedStringKey key in self.textAttributes) {
                attrs[key] = self.textAttributes[key];
            }
            
            NSString *s = charLimbo.character;
            [s drawInRect:charRect withAttributes:attrs];
        }
    }
}

- (UIFont *)font {
    if ([super font] != nil) {
        return [super font];
    } else {
        return [UIFont systemFontOfSize:15.0f];
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsLayout];
}

- (NSString *)text {
    if ([super text] != nil) {
        return [super text];
    } else {
        return @"";
    }
}

- (void)setText:(NSString *)text {
    if ([self.text isEqualToString:text] == YES) {
        return;
    }

    if (self.text == nil) {
        self.previousText = @"";
    } else {
        self.previousText = self.text;
    }

    self.diffResults = [self.previousText diffWith:text];

    if (text == nil) {
        [super setText:@""];
    } else {
        [super setText:text];
    }

    self.morphingProgress = 0.0;
    self.currentFrame = 0;
    self.totalFrames = 0;

    self.tempRenderMorphingEnabled = self.morphingEnabled;
    [self setNeedsLayout];

    if (self.morphingEnabled == NO) {
        return;
    }

    if (self.previousText != self.text) {
        [self start];
        NSString *closureKey = [NSString stringWithFormat:@"%@%@", MorphingLabelEffectDescription(self.morphingEffect), MGRMorphingPhasesStart];

        MGRMorphingStartClosure closure = self.startClosures[closureKey];
        if (closure != nil) {
            closure();
        }

        if ([self.delegate respondsToSelector:@selector(morphingDidStart:)] == YES) {
            [self.delegate morphingDidStart:self];
        }
    }
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    self.previousRects = [self rectsOfEachCharacter:self.previousText withFont:self.font];
    NSString *text = self.text;
    if (text == nil) {
        text = @"";
    }
    self.freshRects = [self rectsOfEachCharacter:text withFont:self.font];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsLayout];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    _morphingProgress = 0.0f;
    _morphingDuration = 0.6f;
    _morphingCharacterDelay = 0.026f;
    _morphingEnabled = YES;
    _morphingEffect = MGUMorphingLabelEffectScale;
    _tempRenderMorphingEnabled = YES;
    
    _currentFrame = 0;
    _totalFrames = 0;
    _totalDelayFrames = 0;
    
    _totalWidth = 0.0;
    _previousRects = [NSMutableArray array];
    _freshRects    = [NSMutableArray array];
    _charHeight = 0.0;
    _skipFramesCount = 0;
    
    _previousText = @"";
    
    _startClosures      = [NSMutableDictionary dictionary];
    _skipFramesClosures = [NSMutableDictionary dictionary];
    _progressClosures   = [NSMutableDictionary dictionary];
    _drawingClosures    = [NSMutableDictionary dictionary];
    _effectClosures     = [NSMutableDictionary dictionary];
}

#pragma mark - 세터 & 게터
- (void)setTextAttributes:(NSMutableDictionary<NSAttributedStringKey,NSObject *> *)textAttributes {
    _textAttributes = textAttributes;
    [self setNeedsLayout];
}

- (MGUMorphingLabelEmitterView *)emitterView { // lazy
    if (_emitterView == nil) {
        _emitterView = [[MGUMorphingLabelEmitterView alloc] initWithFrame:self.bounds];
        [self addSubview:_emitterView];
    }
    return _emitterView;
}


#pragma mark - 컨트롤
- (void)start {
    if (self.displayLink != nil) {
        return;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayFrameTick)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes]; // <- NSRunLoopCommonModes 해야 인터렉션
}

- (void)pause {
    self.displayLink.paused  = YES;
}

- (void)unpause {
    self.displayLink.paused  = NO;
}

- (void)finish {
    self.displayLink.paused  = NO;
}

- (void)stop {
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.displayLink invalidate];
    self.displayLink = nil;
}


// MARK: - Animation extension

- (void)displayFrameTick {
    if (self.totalFrames == 0) { // 최초에 한번만 실행됨. (display link가 시작될 때.)
        [self updateProgress:0];
    } else {
        self.morphingProgress += 1.0 / (CGFloat)(self.totalFrames);
        [self updateProgress:self.morphingProgress];
    }
}

- (void)updateProgress:(CGFloat)progress {
    if (self.displayLink == nil) { // 실제로 작동하지 않을 것이다.
        return;
    }
    
    if ((self.displayLink.duration > 0.0) && (self.totalFrames == 0)) { // self.displayLink.duration 언제나 0.016667
        CGFloat frameRate = 0.0f;
        NSInteger frameInterval = 1;
        
        if (self.displayLink.preferredFramesPerSecond == 60) {
            frameInterval = 1;
        } else if (self.displayLink.preferredFramesPerSecond == 30) {
            frameInterval = 2;
        } else {
            frameInterval = 1; // 항상 이거다. self.displayLink.preferredFramesPerSecond == 0
        }
        //! 60 프레임. 1초에 60번을 찍는다.
        frameRate = self.displayLink.duration / (CGFloat)frameInterval; // 한 프레임의 간격이 몇 초(frameRate)인가
        
        self.totalFrames = (NSInteger)(ceil(self.morphingDuration / frameRate)); //  올림함수.
        CGFloat totalDelay = (CGFloat)([self.text mgrCountOfCharacter]) * self.morphingCharacterDelay;
        self.totalDelayFrames = (NSInteger)(ceil(totalDelay / frameRate));
    }
    
    self.currentFrame = (NSInteger)(ceil(progress * (CGFloat)(self.totalFrames)));
    
    if (([self.previousText isEqualToString:self.text] == NO) &&
        (self.currentFrame < self.totalFrames + self.totalDelayFrames + 10)) {
        self.morphingProgress = progress;
        NSString *closureKey = [NSString stringWithFormat:@"%@%@", MorphingLabelEffectDescription(self.morphingEffect), MGRMorphingPhasesSkipFrames];

        MGRMorphingSkipFramesClosure closure = self.skipFramesClosures[closureKey];
        if (closure != nil) {
            self.skipFramesCount += 1;
            if (self.skipFramesCount > closure()) {
                self.skipFramesCount = 0;
                [self setNeedsDisplay];
            }
        } else {
            [self setNeedsDisplay];
        }

        if ([self.delegate respondsToSelector:@selector(morphingOnProgress:progress:)] == YES) {
            [self.delegate morphingOnProgress:self progress:self.morphingProgress];
        }
    } else {
        [self stop];
        if ([self.delegate respondsToSelector:@selector(morphingDidComplete:)] == YES) {
            [self.delegate morphingDidComplete:self];
        }
    }
}

//! [CGRect] CGRect를 wrapping 한 NSValue를 담은 배열을 반환한다. 인수의 문자열의 각각의 캐릭터의 프레임을 담은 배열
- (NSMutableArray <NSValue *>*)rectsOfEachCharacter:(NSString *)textToDraw withFont:(UIFont *)font {
    
    NSMutableArray <NSValue *>*charRects = NSMutableArray.array; // CGRect
    CGFloat leftOffset = 0.0f;
    self.charHeight = [@"Leg" sizeWithAttributes:@{NSFontAttributeName : font}].height;
    
    CGFloat topOffset = (self.bounds.size.height - self.charHeight) / 2.0;

    NSArray <NSString *>*characters = [textToDraw mgrCharacterArray];
    
    for (NSString *character in characters) {
        CGSize charSize = [character sizeWithAttributes:@{NSFontAttributeName : font}];
        CGRect rect = CGRectMake(leftOffset, topOffset, charSize.width, charSize.height);
        [charRects addObject:[NSValue valueWithCGRect:rect]];
        leftOffset += charSize.width;
    }
    
    self.totalWidth = leftOffset;
    CGFloat stringLeftOffSet = 0.0;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        stringLeftOffSet = ((self.bounds.size.width - self.totalWidth) / 2.0);
    } else if (self.textAlignment == NSTextAlignmentRight) {
        stringLeftOffSet = (self.bounds.size.width - self.totalWidth);
    }
    
    NSMutableArray <NSValue *>*offsetedCharRects = NSMutableArray.array; // CGRect
    for (NSValue *value in charRects) {
        CGRect rect = [value CGRectValue];
        rect = CGRectOffset(rect, stringLeftOffSet, 0.0);
        [offsetedCharRects addObject:[NSValue valueWithCGRect:rect]];
    }
    
    return offsetedCharRects;
}

- (NSMutableArray <MGUMorphingLabelCharLimbo *>*)limboOfCharacters {
    
    NSMutableArray <MGUMorphingLabelCharLimbo *>*limbo = NSMutableArray.array;
    // Iterate original characters
    NSArray <NSString *>*characters = [self.previousText mgrCharacterArray];
    for (NSInteger i = 0; i < characters.count; i++) {
        NSString *character = characters[i];
        CGFloat progress = 0.0;
        
        NSString *closureKey = [NSString stringWithFormat:@"%@%@", MorphingLabelEffectDescription(self.morphingEffect), MGRMorphingPhasesProgress];

        MGRMorphingManipulateProgressClosure closure = self.progressClosures[closureKey];
        if (closure != nil) {
            progress = closure(i, self.morphingProgress, NO);
        } else {
            progress = MIN(1.0, MAX(0.0, self.morphingProgress + self.morphingCharacterDelay * (CGFloat)i));
        }
        
        MGUMorphingLabelCharLimbo *limboOfCharacter = [self limboOfOriginalCharacter:character
                                                                      index:i
                                                                   progress:progress];
        [limbo addObject:limboOfCharacter];
    }
    
    // Add new characters
    characters = [self.text mgrCharacterArray];
    for (NSInteger i = 0; i < characters.count; i++) {
        NSString *character = characters[i];
    
        if (i >= self.diffResults.characterDiffResults.count) {
            break;
        }
        
        CGFloat progress = 0.0;
        
        NSString *closureKey = [NSString stringWithFormat:@"%@%@", MorphingLabelEffectDescription(self.morphingEffect), MGRMorphingPhasesProgress];
        MGRMorphingManipulateProgressClosure closure = self.progressClosures[closureKey];
        
        if (closure != nil) {
            progress = closure(i, self.morphingProgress, YES);
        } else {
            progress = MIN(1.0, MAX(0.0, self.morphingProgress - self.morphingCharacterDelay * (CGFloat)i));
        }
        
        // Don't draw character that already exists
        NSNumber *boolValue = self.diffResults.skipDrawingResults[i];
        if ([boolValue boolValue] == YES) {
            continue;
        }
        
        MGUMorphingLabelCharDiffResult *diffResult = self.diffResults.characterDiffResults[i];
        
        if (diffResult != nil) {
            if (diffResult.resultType == MGUMorphingLabelCharDiffResultTypeMoveAndAdd ||
                diffResult.resultType == MGUMorphingLabelCharDiffResultTypeReplace ||
                diffResult.resultType == MGUMorphingLabelCharDiffResultTypeAdd ||
                diffResult.resultType == MGUMorphingLabelCharDiffResultTypeDelete ) {
                MGUMorphingLabelCharLimbo *limboOfCharacter = [self limboOfNewCharacter:character index:i progress:progress];
                [limbo addObject:limboOfCharacter];
            }
        }
    }
    
    return limbo;
}

- (MGUMorphingLabelCharLimbo *)limboOfNewCharacter:(NSString *)character index:(NSInteger)index progress:(CGFloat)progress {
    NSValue *rectValue = self.freshRects[index];
    CGRect currentRect = [rectValue CGRectValue];
    
    NSString *closureKey = [NSString stringWithFormat:@"%@%@", MorphingLabelEffectDescription(self.morphingEffect), MGRMorphingPhasesAppear];

    MGUMorphingLabelEffectClosure closure = self.effectClosures[closureKey];
    if (closure != nil) {
        return closure(character, index, progress);
    } else {
        CGFloat currentFontSize =
            MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, 0.0, self.font.pointSize, 1.0);
        
        // For emojis
        currentFontSize = MAX(0.0001, currentFontSize);
        CGFloat yOffset = self.font.pointSize - currentFontSize;

        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:CGRectOffset(currentRect, 0.0, yOffset)
                                                     alpha:self.morphingProgress
                                                      size:currentFontSize
                                           drawingProgress:0.0];
    }
}


- (MGUMorphingLabelCharLimbo *)limboOfOriginalCharacter:(NSString *)character index:(NSInteger)index progress:(CGFloat)progress {

    NSValue *currentRectValue = self.previousRects[index];
    CGRect currentRect = [currentRectValue CGRectValue];
    CGFloat oriX = currentRect.origin.x;
    MGUMorphingLabelCharDiffResult *diffResult = self.diffResults.characterDiffResults[index];
    CGFloat currentFontSize = self.font.pointSize;
    CGFloat currentAlpha = 1.0;
    
    switch (diffResult.resultType) {
        case MGUMorphingLabelCharDiffResultTypeSame:  {
            NSValue *rectValue = self.freshRects[index];
            CGRect rect = [rectValue CGRectValue];
            CGFloat newX = rect.origin.x;
            currentRect = CGRectMake(MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, oriX, newX - oriX, 1.0), currentRect.origin.y,
                                     currentRect.size.width, currentRect.size.height);
            break;
        }
        case MGUMorphingLabelCharDiffResultTypeMove:  {
            NSValue *rectValue = self.freshRects[index + diffResult.offset];
            CGRect rect = [rectValue CGRectValue];
            CGFloat newX = rect.origin.x;
            currentRect = CGRectMake(MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, oriX, newX - oriX, 1.0), currentRect.origin.y,
                                     currentRect.size.width, currentRect.size.height);
            break;
        }
        case MGUMorphingLabelCharDiffResultTypeMoveAndAdd: {
            NSValue *rectValue = self.freshRects[index + diffResult.offset];
            CGRect rect = [rectValue CGRectValue];
            CGFloat newX = rect.origin.x;
            currentRect = CGRectMake(MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, oriX, newX - oriX, 1.0), currentRect.origin.y,
                                     currentRect.size.width, currentRect.size.height);
            break;
        }
        default: {
            // Otherwise, remove it
            // Override morphing effect with closure in extenstions
            NSString *closureKey = [NSString stringWithFormat:@"%@%@", MorphingLabelEffectDescription(self.morphingEffect), MGRMorphingPhasesDisappear];

            MGUMorphingLabelEffectClosure closure = self.effectClosures[closureKey];
            if (closure != nil) {
                return closure(character, index, progress);
            } else {
                // And scale it by default
                CGFloat fontEase =
                    MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, 0.0, self.font.pointSize, 1.0);
                // For emojis
                currentFontSize = MAX(0.0001, self.font.pointSize - fontEase);
                currentAlpha = 1.0 - progress;
                
                NSValue *rectValue = self.previousRects[index];
                CGRect rect = [rectValue CGRectValue];
                currentRect = CGRectOffset(rect, 0.0, self.font.pointSize - currentFontSize);
            }
        }
    }

    return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                  rect:currentRect
                                                 alpha:currentAlpha
                                                  size:currentFontSize
                                       drawingProgress:0.0];
}

@end
