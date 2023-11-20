//
//  MGEGradientView.h
//
//  Created by Kwan Hyun Son on 2020/07/23.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <GraphicsKit/MGEAvailability.h>
@class MGEGradientLayer;

NS_ASSUME_NONNULL_BEGIN

@interface MGEGradientView : MGEView
@property (nonatomic, strong) NSArray <MGEColor *>*colors;
@property (nonatomic, strong, readonly) MGEGradientLayer *gradientLayer;
@end

NS_ASSUME_NONNULL_END
