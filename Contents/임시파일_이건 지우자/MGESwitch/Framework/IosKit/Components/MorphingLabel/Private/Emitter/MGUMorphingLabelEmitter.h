//
//  LTEmitter.h
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 26/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGUMorphingLabelEmitterView.h"
NS_ASSUME_NONNULL_BEGIN

// MGUMorphingLabelEmitter
// MGUMorphingLabelEmitter
@interface MGUMorphingLabelEmitter : NSObject

@property (nonatomic, assign) CGFloat duration; // 디폴트 0.6

@property (nonatomic, strong) CAEmitterLayer *layer; // lazy
@property (nonatomic, strong) CAEmitterCell *cell; // lazy

- (instancetype)initWithName:(NSString *)name particleName:(NSString *)particleName duration:(CGFloat)duration;
- (void)play;
- (void)stop;
- (MGUMorphingLabelEmitter *)update:(MGUMorphingLabelEmitterConfigureClosure)configureClosure;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
