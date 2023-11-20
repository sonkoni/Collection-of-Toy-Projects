//
//  MGUCarouselRotaryTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUCarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUCarouselRotaryTransformer : MGUCarouselTransformer

+ (instancetype)rotaryTransformerWithInverted:(BOOL)inverted;
- (instancetype)initWithRotaryTransformerWithInverted:(BOOL)inverted;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGUCarouselTransformerType)type NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END


