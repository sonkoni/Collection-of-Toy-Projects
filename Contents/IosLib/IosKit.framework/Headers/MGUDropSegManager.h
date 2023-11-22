//
//  MGUDropSegManager.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-11-16
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
@class DTODropSeg;

NS_ASSUME_NONNULL_BEGIN

// Segment 하나에 대한 매니저
@interface MGUDropSegManager : NSObject
@property (nonatomic, strong) NSArray <DTODropSeg *>*dtoDropSegs;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong, readonly) DTODropSeg *selectedDTODropSeg;

- (instancetype)initWithDropSegs:(NSArray <DTODropSeg *>*)dropSegs selectedIndex:(NSInteger)selectedIndex;
@end

@interface DTODropSeg : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *extendedTitle;

- (instancetype)initWithTitle:(NSString *)title extendedTitle:(NSString *)extendedTitle;

@end

NS_ASSUME_NONNULL_END
