//
//  MGATableCell.m
//  JustTEST
//
//  Created by Kwan Hyun Son on 2022/11/07.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGASnippetsLabCell.h"

@implementation MGASnippetsLabCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        CommonInit(self);
    }
    return self;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGASnippetsLabCell *self) {
//    self->_myName = @"내가 부모여";
}

@end

//#pragma mark - 세터 & 게터
//- (NSTextField *)textField1 {
//    if (_textField1 == nil) {
//        _textField1 = [NSTextField labelWithString:@""];
//        [self addSubview:_textField1];
//        _textField1.translatesAutoresizingMaskIntoConstraints = NO;
//        [_textField1.topAnchor constraintEqualToAnchor:self.topAnchor constant:9.0].active = YES;
//        [_textField1.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:4.0].active = YES;
//        self.textField = _textField1; // 이렇게 해야 세퍼레이터가 정상으로 작동한다.
//    }
//    return _textField1;
//}
//
//- (NSTextField *)textField2 {
//    if (_textField2 == nil) {
//        _textField2 = [NSTextField labelWithString:@""];
//        _textField2.textColor = [NSColor secondaryLabelColor];
//        _textField2.font = [NSFont systemFontOfSize:11.0 weight:NSFontWeightRegular];
//        _textField2.translatesAutoresizingMaskIntoConstraints = NO;
//        [_textField2.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-9.0].active = YES;
//        [_textField2.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:4.0].active = YES;
//    }
//    return _textField2;
//}
//
//- (NSTextField *)textField3 {
//    if (_textField3 == nil) {
//        _textField3 = [NSTextField labelWithString:@""];
//        _textField3.textColor = [NSColor secondaryLabelColor];
//        _textField3.font = [NSFont systemFontOfSize:11.0 weight:NSFontWeightRegular];
//        _textField3.translatesAutoresizingMaskIntoConstraints = NO;
//        [_textField3.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-9.0].active = YES;
//        [_textField3.trailingAnchor constraintEqualToAnchor:self.leadingAnchor constant:-4.0].active = YES;
//    }
//    return _textField3;
//}
