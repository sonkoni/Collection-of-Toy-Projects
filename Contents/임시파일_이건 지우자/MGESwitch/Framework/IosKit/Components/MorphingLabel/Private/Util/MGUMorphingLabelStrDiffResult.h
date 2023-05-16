//
//  LTStringDiffResult.h
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMorphingLabelCharDiffResult;
NS_ASSUME_NONNULL_BEGIN

// MGUMorphingLabelStrDiffResult : String Difference Result
@interface MGUMorphingLabelStrDiffResult : NSObject

@property (nonatomic, strong) NSMutableArray <MGUMorphingLabelCharDiffResult *>*characterDiffResults;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*skipDrawingResults; // BOOL


- (instancetype)initWithCharacterDiffResults:(NSMutableArray <MGUMorphingLabelCharDiffResult *>*)characterDiffResults
                          skipDrawingResults:(NSMutableArray <NSNumber *>*)skipDrawingResults;

- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
