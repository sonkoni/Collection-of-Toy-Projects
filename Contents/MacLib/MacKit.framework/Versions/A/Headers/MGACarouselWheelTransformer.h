//
//  MGACarouselWheelTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <MacKit/MGACarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGACarouselWheelTransformer : MGACarouselTransformer

+ (instancetype)wheelTransformerWithInverted:(BOOL)inverted;
- (instancetype)initWithWheelTransformerWithInverted:(BOOL)inverted;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGACarouselTransformerType)type NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
