//
//  LTStringDiffResult.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabelStrDiffResult.h"

@implementation MGUMorphingLabelStrDiffResult

- (instancetype)initWithCharacterDiffResults:(NSMutableArray<MGUMorphingLabelCharDiffResult *> *)characterDiffResults
                          skipDrawingResults:(NSMutableArray<NSNumber *> *)skipDrawingResults {
    self = [super init];
    if(self) {
        _characterDiffResults = characterDiffResults;
        _skipDrawingResults = skipDrawingResults; // BOOL
    }
    return self;
}

@end
