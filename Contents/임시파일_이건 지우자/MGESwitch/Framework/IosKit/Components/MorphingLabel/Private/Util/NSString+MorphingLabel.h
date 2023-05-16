//
//  #import "NSString+Parsing.h"
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMorphingLabelStrDiffResult;
NS_ASSUME_NONNULL_BEGIN

@interface NSString (MorphingLabel)

- (MGUMorphingLabelStrDiffResult *)diffWith:(NSString *)anotherString;
@end

NS_ASSUME_NONNULL_END
