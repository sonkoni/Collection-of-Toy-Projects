//
//  MGACarouselSupplementaryView.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-12
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>
#import <MacKit/MGAView.h>

NS_ASSUME_NONNULL_BEGIN


@interface MGACarouselSupplementaryView : MGAView <NSCollectionViewElement>
@property (nonatomic, strong, readonly) NSView *contentView;
+ (NSUserInterfaceItemIdentifier)reuseIdentifier;
@end

NS_ASSUME_NONNULL_END
