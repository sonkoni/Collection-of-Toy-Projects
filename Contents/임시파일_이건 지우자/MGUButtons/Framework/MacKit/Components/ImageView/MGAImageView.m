//
//  MGAImageView.m
//  Fruta_Card_TEST_Mac
//
//  Created by Kwan Hyun Son on 2022/10/21.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAImageView.h"

@interface MGAImageView ()

@end

@implementation MGAImageView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self makeLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.layer == nil) {
        [self makeLayer];
    }
}

#if TARGET_INTERFACE_BUILDER // 인터페이스 빌더로 확인만 하는 용. runtime에서 실행되지 않는다.
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    NSTextField *label = [NSTextField labelWithString:@""];
    [self addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary <NSAttributedStringKey, id>*unitAttributes =
         @{ NSFontAttributeName            : [NSFont boldSystemFontOfSize:20.0], // Define the font
            NSForegroundColorAttributeName : NSColor.redColor,  // Define fill color
            NSStrokeColorAttributeName     : NSColor.blueColor,
            NSStrokeWidthAttributeName     : @(-5.0), // 글자 크기의 백분율로 지정된다. 내부를 orangeColor로 채우고 stroke를 바깥에 채우려면 음수로 한다.
            NSBackgroundColorAttributeName : NSColor.grayColor, // Paint the background
            NSParagraphStyleAttributeName  : paragraphStyle }.mutableCopy;
    
    label.attributedStringValue = [[NSMutableAttributedString alloc] initWithString:@"MGAImageView"
                                                                         attributes:unitAttributes];
    self.layer = [CALayer layer];
    self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.layer.backgroundColor = [NSColor systemYellowColor].CGColor;
    self.wantsLayer = YES;
}
#endif


#pragma mark - 생성 & 소멸
- (void)makeLayer {
    self.layer = [CALayer layer];
    self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.wantsLayer = YES;
}

- (void)setContentMode:(CALayerContentsGravity)contentMode {
    _contentMode = contentMode;
    self.layer.contentsGravity = contentMode;
}

- (void)setImage:(NSImage *)image {
    _image = image;
    self.layer.contents = image;
}

@end
