//
//  MGALabel.m
//  FontFit_Mac
//
//  Created by Kwan Hyun Son on 2022/10/22.
//

#import "MGALabel.h"
#import "NSFont+Extension.h"
#import "NSView+Extension.h"

@interface MGALabel ()
@property (nonatomic, strong) NSFont *maxFont;
@property (nonatomic, strong, readonly) NSFont *minFont; // @dynamic
@property (nonatomic, assign) CGSize previousSize;
@end

@implementation MGALabel
@dynamic minFont;

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}

//! iOS 의 layoutSubviews과 동일.
- (void)layout {
    [super layout];
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    
    if (self.normalMode == NO) {
        if (CGSizeEqualToSize(self.bounds.size, CGSizeZero) == NO &&
            CGSizeEqualToSize(self.bounds.size, self.previousSize) == NO) {
            _previousSize = self.bounds.size;
            [self updateFontIfNeeded];
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    if (self.initalBlock != nil) {
        self.initalBlock();
        self.initalBlock = nil;
    }
}


#pragma mark - 생성 & 소멸
+ (instancetype)mgrLabelWithString:(NSString *)str {
    return [[self class] labelWithString:str];
}

+ (instancetype)mgrMultiLineLabelWithString:(NSString *)str {
    MGALabel *label = [[self class] wrappingLabelWithString:str];
    label.selectable = NO; // 기본적으로 wrapping Label은 selectable 이 YES로 설정되어있다. 나는 이렇게 이용할 일이 거의 없을듯.
    return label;
}

static void CommonInit(MGALabel *self) {
    self.wantsLayer = YES;
    [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    self->_maxFont = [self realFont];
    self->_previousSize = CGSizeZero;
    self->_adjustsFontSizeToFitWidth = YES;
    self->_minimumScaleFactor = 0.25;
    self->_fixType = MGALabelFixTypeWidth;
    self->_normalMode = NO;
}


#pragma mark - 세터 & 게터
- (void)setFont:(NSFont *)font { // 내부에서 호출금지
    [self setMaxFont:font];
}

- (NSFont *)font { // 내부에서 호출금지
    return self.maxFont;
}

- (void)setRealFont:(NSFont *)font {
    [super setFont:font];
}

- (NSFont *)realFont {
    return [super font];
}

- (void)setMaxFont:(NSFont *)maxFont {
    _maxFont = maxFont;
    [self updateFontIfNeeded];
}

- (void)setStringValue:(NSString *)stringValue {
    [super setStringValue:stringValue];
    [self updateFontIfNeeded];
}

- (NSFont *)minFont {
    NSFontDescriptor *fontDescriptor = self.maxFont.fontDescriptor;
    NSInteger smallestFontSize = (NSInteger)(fontDescriptor.pointSize * self.minimumScaleFactor);
    return [NSFont fontWithDescriptor:fontDescriptor size:smallestFontSize];
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    if (_adjustsFontSizeToFitWidth != adjustsFontSizeToFitWidth) {
        _adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        [self updateFontIfNeeded];
    }
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor {
    if (_minimumScaleFactor != minimumScaleFactor) {
        _minimumScaleFactor = minimumScaleFactor;
        [self updateFontIfNeeded];
    }
}


#pragma mark - Actions
- (void)updateFontIfNeeded {
    if (self.adjustsFontSizeToFitWidth == NO) {
        [self setRealFont:self.maxFont];
        return;
    }
    
    if (self.lineBreakMode == NSLineBreakByClipping) {
        [self executeSingleLineAlgorithm];
        return;
    }
    
    //! 여기서 부터는 멀타리인이다. 멀티라이인데 @" " 쓰기가 없을 경우에 싱글라인까지 줄어드는지 확인해서 줄어들면 싱글라인 알고리즘으로 해결한다.
    //! 애플의 전략이므로 따라간다.
    if ([self.stringValue containsString:@" "] == YES) {
        [self executeMultiLineAlgorithm];
        return;
    }
    
    // @" " 쓰기가 없을 경우에 싱글라인까지 줄어드는지 확인
    NSString *text = self.stringValue;
    CGSize boundsSize = self.bounds.size;
    NSFontDescriptor *fontDescriptor = self.maxFont.fontDescriptor;
    
    CGRect properBounds = CGRectZero;
    if (self.fixType == MGALabelFixTypeWidth) {
        properBounds = CGRectMake(0.0, 0.0, boundsSize.width, CGFLOAT_MAX); //! height 가 자유롭다면.
    } else if (self.fixType == MGALabelFixTypeWidth) {
        properBounds = CGRectMake(0.0, 0.0, CGFLOAT_MAX, boundsSize.height);
    } else if (self.fixType == MGALabelFixTypeBoth) {
        properBounds = CGRectMake(0.0, 0.0, boundsSize.width, boundsSize.height);
    } else {
        NSCAssert(FALSE, @"여기로 들어오면 안된다.");
    }
    
    NSInteger smallestFontSize = (NSInteger)(fontDescriptor.pointSize * self.minimumScaleFactor);
    CGSize constrainingBounds = CGSizeMake(properBounds.size.width, CGFLOAT_MAX);
    NSFont *font = [NSFont fontWithDescriptor:fontDescriptor size:smallestFontSize];
    CGRect currentFrame =
        [text boundingRectWithSize:constrainingBounds
                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                        attributes:@{NSFontAttributeName:font}
                           context:nil];
    currentFrame.size.width = currentFrame.size.width + 8.0; // 양 사이드로 4.0 씩 존재하는 마진을 잡아줘야한다.
    if (CGRectContainsRect(properBounds, currentFrame) == YES) {
        // 1.0 포인트 미만의 오차가 존재해서 보정을 해야한다.
        NSInteger currentFrameLineCount = (NSInteger)(floor((currentFrame.size.height + 2.0) / font.mgrLineHeight));
        if (currentFrameLineCount == 1) { // 이게 맞는듯.
            [self executeSingleLineAlgorithm];
            return;
        }
    }
    
    [self executeMultiLineAlgorithm];
}

//! 싱글라인에서 사용하거나, 멀티라인에서 @" " 문자가 없이 이어진 긴 문자를 최소크기까지 줄여서 표현할 수 있으면 사용하는 알고리즘이다.
//! 멀티라인에서 사용한다면 이미 줄일 수 있다는 것을 확인한 다음에 사용해야한다.
- (void)executeSingleLineAlgorithm {
    NSString *text = self.stringValue;
    CGSize boundsSize = self.bounds.size;
    NSFontDescriptor *fontDescriptor = self.maxFont.fontDescriptor;
    
    CGRect properBounds = CGRectZero;
    if (self.fixType == MGALabelFixTypeWidth) {
        properBounds = CGRectMake(0.0, 0.0, boundsSize.width, CGFLOAT_MAX); //! height 가 자유롭다면.
    } else if (self.fixType == MGALabelFixTypeWidth) {
        properBounds = CGRectMake(0.0, 0.0, CGFLOAT_MAX, boundsSize.height);
    } else if (self.fixType == MGALabelFixTypeBoth) {
        properBounds = CGRectMake(0.0, 0.0, boundsSize.width, boundsSize.height);
    } else {
        NSCAssert(FALSE, @"여기로 들어오면 안된다.");
    }
    NSInteger largestFontSize = (NSInteger)fontDescriptor.pointSize; // (NSInteger)(boundsSize.height);
    NSInteger smallestFontSize = (NSInteger)(fontDescriptor.pointSize * self.minimumScaleFactor);
    CGSize constrainingBounds = CGSizeMake(properBounds.size.width, CGFLOAT_MAX);
    NSInteger bestFittingFontSize = smallestFontSize;
           
    for (NSInteger i = largestFontSize; i > smallestFontSize; i--) {
        NSFont *font = [NSFont fontWithDescriptor:self.maxFont.fontDescriptor size:(CGFloat)i];
        CGRect currentFrame =
            [text boundingRectWithSize:constrainingBounds
                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                            attributes:@{NSFontAttributeName:font}
                               context:nil];
        currentFrame.size.width = currentFrame.size.width + 8.0; // 양 사이드로 4.0 씩 존재하는 마진을 잡아줘야한다.
        if (CGRectContainsRect(properBounds, currentFrame) == YES) {
            NSInteger currentFrameLineCount = (NSInteger)(ceil(currentFrame.size.height / font.mgrLineHeight));
            if (currentFrameLineCount <= 1) { // 라인이 한 개 여야한다.
                bestFittingFontSize = i;
                break;
            }
        }
    }
    
    NSFont *font = [NSFont fontWithDescriptor:fontDescriptor size:bestFittingFontSize];
    [self setRealFont:font];
}

//! 멀티라인 전용 알고리즘이다.
- (void)executeMultiLineAlgorithm {
    NSString *text = self.stringValue;
    CGSize boundsSize = self.bounds.size;
    NSFontDescriptor *fontDescriptor = self.maxFont.fontDescriptor;
    
    CGRect properBounds = CGRectZero;
    if (self.fixType == MGALabelFixTypeWidth) {
        properBounds = CGRectMake(0.0, 0.0, boundsSize.width, CGFLOAT_MAX); //! height 가 자유롭다면.
    } else if (self.fixType == MGALabelFixTypeWidth) {
        properBounds = CGRectMake(0.0, 0.0, CGFLOAT_MAX, boundsSize.height);
    } else if (self.fixType == MGALabelFixTypeBoth) {
        properBounds = CGRectMake(0.0, 0.0, boundsSize.width, boundsSize.height);
    } else {
        NSCAssert(FALSE, @"여기로 들어오면 안된다.");
    }
    
    NSInteger largestFontSize = (NSInteger)fontDescriptor.pointSize; // (NSInteger)(boundsSize.height);
    NSInteger smallestFontSize = (NSInteger)(fontDescriptor.pointSize * self.minimumScaleFactor);
    CGSize constrainingBounds = CGSizeMake(properBounds.size.width, CGFLOAT_MAX);
    NSInteger bestFittingFontSize = smallestFontSize;
    
    for (NSInteger i = largestFontSize; i > smallestFontSize; i--) {
        NSFont *font = [NSFont fontWithDescriptor:fontDescriptor size:(CGFloat)i];
        CGRect currentFrame =
            [text boundingRectWithSize:constrainingBounds
                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                            attributes:@{NSFontAttributeName:font}
                               context:nil];
        currentFrame.size.width = currentFrame.size.width + 8.0; // 양 사이드로 4.0 씩 존재하는 마진을 잡아줘야한다.
        if (CGRectContainsRect(properBounds, currentFrame) == YES) {
            if (self.lineBreakMode == NSLineBreakByWordWrapping) { // 멀티라인 라벨
                if (self.maximumNumberOfLines == 0) { // fillContainer라면.
                    bestFittingFontSize = i;
                    break;
                } else {
                    NSInteger currentFrameLineCount = (NSInteger)(ceil(currentFrame.size.height / font.mgrLineHeight));
                    if (currentFrameLineCount <= MAX(self.maximumNumberOfLines, 1)) {
                        bestFittingFontSize = i;
                        break;
                    }
                }
            } else {
                NSCAssert(FALSE, @"라벨이 아니다.");
            }
        }
    }
    
    // 이전 버전에서는 여기서 마무리를 지었다. 띄어쓰기가 존재할 때, 분리해서 각각 넣을 수 있는지 여부를 검사해서 실행하는 것으로 바꿨다.
//    NSFont *font = [NSFont fontWithDescriptor:fontDescriptor size:bestFittingFontSize];
//    [self setRealFont:font];
//    return;
    
    //! 한번 더 검사해야한다. 띄어쓰기를 기준으로 낱말을 분리해서 각자가 인라인으로 들어갈 수 있는 최대사이즈만큼 들 중 가장 작은 사이즈와
    //! 교집합으로 한 번 더 컷팅해준다.
    NSArray <NSString *>*strs = [self.stringValue componentsSeparatedByString:@" "];
    CGSize usingSize = CGSizeMake(properBounds.size.width - 8.0, CGFLOAT_MAX);
    NSUInteger minSize = bestFittingFontSize;
    for (NSString *str in strs) {
        NSUInteger size = [self.maxFont mgrOneLineBoundingRectWithSize:usingSize
                                                                  text:str
                                                      maxFontPointSize:bestFittingFontSize
                                                      minFontPointSize:smallestFontSize];
        
        minSize = MIN(minSize, size);
    }
    
    NSFont *font = [NSFont fontWithDescriptor:fontDescriptor size:MIN(minSize, bestFittingFontSize)];
    [self setRealFont:font];
}

@end
