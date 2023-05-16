//
//  LTCharacterLimbo.h
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//MGUMorphingLabelCharLimbo : Character Limbo
@interface MGUMorphingLabelCharLimbo : NSObject

@property (nonatomic, strong) NSString *character; // Character인데 대체할 것이 없다.
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGFloat drawingProgress;


- (instancetype)initWithCharacter:(NSString *)character
                             rect:(CGRect)rect
                            alpha:(CGFloat)alpha
                             size:(CGFloat)size
                  drawingProgress:(CGFloat)drawingProgress;

- (NSString *)debugDescription;

- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
