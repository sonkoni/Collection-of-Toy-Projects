//
//  LTCharacterDiffResult.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabelCharDiffResult.h"

@implementation MGUMorphingLabelCharDiffResult

- (instancetype)initWithEnum:(MGUMorphingLabelCharDiffResultType)resultType {
    self = [super init];
    if (self) {
        _resultType = resultType;
    }
    return self;
}

- (BOOL)isEqual:(MGUMorphingLabelCharDiffResult *)object {
    if (self.resultType == object.resultType) {
        if ((self.resultType == MGUMorphingLabelCharDiffResultTypeSame) || (self.resultType == MGUMorphingLabelCharDiffResultTypeAdd) ||
            (self.resultType == MGUMorphingLabelCharDiffResultTypeDelete) || (self.resultType == MGUMorphingLabelCharDiffResultTypeReplace)) {
            return YES;
        } else if (self.offset == self.offset) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSString *)debugDescription {
    if (self.resultType == MGUMorphingLabelCharDiffResultTypeSame) {
        return @"The character is unchanged.";
    } else if (self.resultType == MGUMorphingLabelCharDiffResultTypeAdd) {
        return @"A new character is ADDED.";
    } else if (self.resultType == MGUMorphingLabelCharDiffResultTypeDelete) {
        return @"The character is DELETED.";
    } else if (self.resultType == MGUMorphingLabelCharDiffResultTypeReplace) {
        return @"The character is REPLACED with a new character.";
    } else if (self.resultType == MGUMorphingLabelCharDiffResultTypeMove) {
        return [NSString stringWithFormat:@"The character is MOVED to %ld.", (long)self.offset];
    } else {
        return [NSString stringWithFormat:@"The character is MOVED to %ld and a new character is ADDED.", (long)self.offset];
    }
}

@end
