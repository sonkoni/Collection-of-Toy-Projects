//
//  NSString+Category.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSString+MorphingLabel.h"
#import "MGUMorphingLabelStrDiffResult.h"
#import "MGUMorphingLabelCharDiffResult.h"
@import BaseKit;

@implementation NSString (MorphingLabel)

- (MGUMorphingLabelStrDiffResult *)diffWith:(NSString *)anotherString {
    if (anotherString == nil) {
        NSMutableArray <MGUMorphingLabelCharDiffResult *>*diffResults = [NSMutableArray array];
        NSMutableArray <NSNumber *>*skipDrawingResults = [NSMutableArray array]; // BOOL
        
        NSInteger count = [self mgrCountOfCharacter];
        
        for (int i = 0; i < count; i++) {
            [diffResults addObject:[[MGUMorphingLabelCharDiffResult alloc] initWithEnum:MGUMorphingLabelCharDiffResultTypeDelete]];
        }
        
        for (int i = 0; i < count; i++) {
            [skipDrawingResults addObject:[NSNumber numberWithBool:NO]];
        }
        
        MGUMorphingLabelStrDiffResult *result = [[MGUMorphingLabelStrDiffResult alloc] initWithCharacterDiffResults:diffResults
                                                                           skipDrawingResults:skipDrawingResults];
        return result;
    }
    
    NSInteger lhsLength = [self mgrCountOfCharacter];
    NSInteger rhsLength = [anotherString mgrCountOfCharacter];
    NSMutableArray <NSNumber *>*skipIndexes = [NSMutableArray array]; // NSInteger
    NSArray <NSString *>*leftChars = [self mgrCharacterArray];
    NSArray <NSString *>*newChars = [anotherString mgrCharacterArray];
    NSInteger maxLength = MAX(lhsLength, rhsLength);
    
    NSMutableArray <MGUMorphingLabelCharDiffResult *>*diffResults = [NSMutableArray array];
    NSMutableArray <NSNumber *>*skipDrawingResults = [NSMutableArray array]; // BOOL
    
    for (NSInteger i = 0; i < maxLength; i++) {
        [diffResults addObject:[[MGUMorphingLabelCharDiffResult alloc] initWithEnum:MGUMorphingLabelCharDiffResultTypeAdd]];
    }
    
    for (NSInteger i = 0; i < maxLength; i++) {
        [skipDrawingResults addObject:[NSNumber numberWithBool:NO]];
    }
    
    for (NSInteger i = 0; i < maxLength; i++) {
         // If new string is longer than the original one
         if (i > (lhsLength - 1)) {
             continue;
         }
        NSString *leftChar = leftChars[i];
        // Search left character in the new string
        BOOL foundCharacterInRhs = NO;
        for (NSInteger j = 0; j < rhsLength; j++) {
            NSString *newChar = newChars[j];
            
            BOOL pass = NO;
            for (NSNumber *number in skipIndexes) {
                NSInteger integerNumber = [number integerValue];
                if (integerNumber == j) {
                    pass = YES;
                }
            }
            
            if (pass == YES) {
                continue;
            }
            
            if ([newChar isEqualToString:leftChar] == NO) {
                continue;
            }
            
            [skipIndexes addObject:[NSNumber numberWithInteger:j]];
            foundCharacterInRhs = YES;
            
            if (i == j) {
                // Character not changed
                diffResults[i] = [[MGUMorphingLabelCharDiffResult alloc] initWithEnum:MGUMorphingLabelCharDiffResultTypeSame];
            } else {
                // foundCharacterInRhs and move
                NSInteger offset = j - i;
                
                if (i <= rhsLength - 1) {
                    // Move to a new index and add a new character to new original place
                    MGUMorphingLabelCharDiffResult *characterDiffResult = [[MGUMorphingLabelCharDiffResult alloc] initWithEnum:MGUMorphingLabelCharDiffResultTypeMoveAndAdd];
                    characterDiffResult.offset = offset;
                    diffResults[i] = characterDiffResult;
                } else {
                    
                    MGUMorphingLabelCharDiffResult *characterDiffResult = [[MGUMorphingLabelCharDiffResult alloc] initWithEnum:MGUMorphingLabelCharDiffResultTypeMove];
                    characterDiffResult.offset = offset;
                    diffResults[i] = characterDiffResult;
                }
                
                skipDrawingResults[j] = [NSNumber numberWithBool:YES];
            }
            break;
        }
         ///! 여기를 고쳐라.
         if (!foundCharacterInRhs) {
             if (i < rhsLength - 1) {
                 diffResults[i] = [[MGUMorphingLabelCharDiffResult alloc] initWithEnum:MGUMorphingLabelCharDiffResultTypeReplace];
             } else {
                 diffResults[i] = [[MGUMorphingLabelCharDiffResult alloc] initWithEnum:MGUMorphingLabelCharDiffResultTypeDelete];
             }
         }
    }
    
    
    MGUMorphingLabelStrDiffResult *result = [[MGUMorphingLabelStrDiffResult alloc] initWithCharacterDiffResults:diffResults
                                                                       skipDrawingResults:skipDrawingResults];
    return result;
}

@end
