//
//  MGACarouselItem.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGACarouselItem : NSCollectionViewItem

@property (nonatomic, strong, readonly) NSView *contentView;

@end

NS_ASSUME_NONNULL_END
