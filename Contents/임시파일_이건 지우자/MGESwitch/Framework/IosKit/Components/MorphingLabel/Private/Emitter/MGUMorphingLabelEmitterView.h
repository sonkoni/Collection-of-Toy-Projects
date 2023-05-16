//
//  LTEmitterView.h
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 26/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMorphingLabelEmitter;
//  
NS_ASSUME_NONNULL_BEGIN

typedef void (^MGUMorphingLabelEmitterConfigureClosure)(CAEmitterLayer *, CAEmitterCell *);

@interface MGUMorphingLabelEmitterView : UIView

@property (nonatomic, strong) NSMutableDictionary <NSString *, MGUMorphingLabelEmitter *>*emitters; // lazy

- (void)removeAllEmitters;

- (MGUMorphingLabelEmitter *)createEmitter:(NSString *)name
                particleName:(NSString *)particleName
                    duration:(CGFloat)duration
            configureClosure:(MGUMorphingLabelEmitterConfigureClosure _Nullable)configureClosure;

@end

NS_ASSUME_NONNULL_END
