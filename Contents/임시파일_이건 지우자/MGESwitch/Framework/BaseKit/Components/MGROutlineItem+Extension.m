//
//  MGROutlineItem+Mulgrim.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGROutlineItem+Extension.h"


@implementation MGROutlineItem (Mulgrim)

+ (instancetype)mgrContent:(id)contentItem subitems:(NSArray <MGROutlineItem *>*)subitems {
    return [[self class] outlineWithContentItem:contentItem subitems:subitems];
}

+ (instancetype)mgrContent:(id)contentItem {
    return [[self class] outlineWithContentItem:contentItem];
}

@end
