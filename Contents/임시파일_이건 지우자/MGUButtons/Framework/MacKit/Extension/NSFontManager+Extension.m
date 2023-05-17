//
//  NSFontManager+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSFontManager+Extension.h"
#import <CoreText/CoreText.h> //! kFractionsType를 쓰기 위해서 필요하다.
//!
@implementation NSFontManager (Extension)

+ (void)mgrDescription {    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    for (NSString *family in fontManager.availableFontFamilies) {
        NSLog(@"family Name : %@", family);
        NSArray <NSArray *>*fonts = [fontManager availableMembersOfFontFamily:family];
        for (NSArray *font in fonts){
            NSLog(@"font => %@", font);
        }
    }
}


@end
