//
//  LTCharacterLimbo.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabelCharLimbo.h"

@implementation MGUMorphingLabelCharLimbo

- (instancetype)initWithCharacter:(NSString *)character
                             rect:(CGRect)rect
                            alpha:(CGFloat)alpha
                             size:(CGFloat)size
                  drawingProgress:(CGFloat)drawingProgress {
    self = [super init];
    if(self) {
        _character = character;
        _rect = rect;
        _alpha = alpha;
        _size = size;
        _drawingProgress = drawingProgress;
    }
    return self;
}

- (NSString *)debugDescription {
    NSString *result = [NSString stringWithFormat:@"Character: %@ drawIn %f %f %f %f with alpha %f and %f pt font",
                        self.character,
                        self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height,
                        self.alpha, self.size];
    
    return result;
}

@end
