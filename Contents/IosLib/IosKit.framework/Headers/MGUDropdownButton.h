//
//  MGUDropdownButton.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-09-05
//  ----------------------------------------------------------------------
//

#import <IosKit/MGULineDashDropdownCell.h>
#import <IosKit/MGULineWidthDropdownCell.h>
#import <IosKit/MGUFillTypeDropdownCell.h>
#import <IosKit/MGUTextDropdownCell.h>
#import <IosKit/MGUImageDropdownCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGUDropdownCellInterface
@property (nonatomic, assign, getter=isCellMode) BOOL cellMode; // 디폴트 YES
- (void)setDropdownData:(id <NSObject>)data;
@end

/**
[dropdownButton addTarget:self
                   action:@selector(dropDownButtonValueChanged:)
         forControlEvents:UIControlEventValueChanged];
// intrinsicContentSize  - 100.0, 28.0
*/
@interface MGUDropdownButton : UIControl
@property (nonatomic, assign) CGFloat itemHeight; // 디폴트 28.0
@property (nonatomic, strong) NSArray *dropdownData;
@property (nonatomic, strong) Class cellClass;
@property(nonatomic, assign) NSInteger selectedIndex; // 디폴트 0
@property (nonatomic, assign) NSTextAlignment placeHolderTextAlignment; // TextDropdownCell 전용, 디폴트 Right
@property (nonatomic, assign) NSTextAlignment textAlignment;            // TextDropdownCell 전용, 디폴트 Left

@property (nonatomic, strong, nullable) UIColor *defaultBackgroundColor;
@property (nonatomic, strong, nullable) UIColor *disabledBackgroundColor;

@property(nonatomic, assign) BOOL dismissOnRotation; // 디폴트 YES

- (instancetype)initWithCellClass:(Class)cellClass
                     dropdownData:(NSArray *)dropdownData;
@end

NS_ASSUME_NONNULL_END
