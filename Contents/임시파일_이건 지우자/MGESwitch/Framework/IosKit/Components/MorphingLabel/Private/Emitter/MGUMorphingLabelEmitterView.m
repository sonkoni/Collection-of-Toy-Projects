//
//  LTEmitterView.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 26/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabelEmitterView.h"
#import "MGUMorphingLabelEmitter.h"

@implementation MGUMorphingLabelEmitterView


- (NSMutableDictionary <NSString *, MGUMorphingLabelEmitter *>*)emitters {
    if (_emitters == nil) {
        _emitters = [NSMutableDictionary dictionary];
    }
    return _emitters;
}

- (void)removeAllEmitters {
    // NSDictionary 객체도 fast-enumeration을 적용할 수 있다. 이 때 순회의 대상은 각각의 키가 된다.
    for (NSString *key in self.emitters) {
        MGUMorphingLabelEmitter *emitter = [self.emitters valueForKey:key];
        [emitter.layer removeFromSuperlayer];
    }
    [self.emitters removeAllObjects];
}

- (MGUMorphingLabelEmitter *)createEmitter:(NSString *)name
                particleName:(NSString *)particleName
                    duration:(CGFloat)duration
            configureClosure:(MGUMorphingLabelEmitterConfigureClosure _Nullable)configureClosure {
    
    MGUMorphingLabelEmitter *emitter = self.emitters[name];
    if (emitter != nil) {
        return emitter;
    } else {
        emitter = [[MGUMorphingLabelEmitter alloc] initWithName:name particleName:particleName duration:duration];
        configureClosure(emitter.layer, emitter.cell);
        [self.layer addSublayer:emitter.layer];
        self.emitters[name] = emitter;
        return emitter;
    }
}

@end
