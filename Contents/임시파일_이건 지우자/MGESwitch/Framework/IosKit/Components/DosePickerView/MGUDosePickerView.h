//
//  MGUDosePickerView.h
//  PickerView
//
//  Created by Kwan Hyun Son on 11/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUDosePickerView;
@class MGUDosePickerCollectionViewLayout;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - typedef
typedef NS_ENUM(NSInteger, MGUDosePickerViewStyle) {
    MGUDosePickerViewStyleFlat,
    MGUDosePickerViewStyleFlatCenterPop,
    MGUDosePickerViewStyleCylinder
};

typedef NS_ENUM(NSInteger, MGUDosePickerViewMode) {
    MGUDosePickerViewModeTitle,
    MGUDosePickerViewModeImage
};


#pragma mark - 프로토콜
@protocol MGUDosePickerViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInPickerView:(MGUDosePickerView *)pickerView;
@optional // 둘 중에 하나는 구현해야한다. 타이틀을 주거나 이미지를 주거나.
- (NSString *)pickerView:(MGUDosePickerView *)pickerView titleForItemIndex:(NSUInteger)itemIndex;
- (UIImage *)pickerView:(MGUDosePickerView *)pickerView imageForItemIndex:(NSUInteger)itemIndex;
@end

@protocol MGUDosePickerViewDelegate <UIScrollViewDelegate>
@optional
- (void)pickerView:(MGUDosePickerView *)pickerView didSelectItemIndex:(NSUInteger)itemIndex; // 선택되었을 때 알림이 간다면 이 메서드로 보내 줄 것이다.
@end


#pragma mark - 인터페이스
@interface MGUDosePickerView : UIView

@property (nonatomic, weak) id <MGUDosePickerViewDataSource> dataSource;
@property (nonatomic, weak) id <MGUDosePickerViewDelegate> delegate;
@property (nonatomic, assign) MGUDosePickerViewMode mode;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *highlightedFont;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;

@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) CGFloat eyePosition; // 눈과의 거리(>0) 원근감을 나타낸다. 자연스럽게 하기 위해 1000 을 추천함. 커질수록 평평하게 보인다.

@property (nonatomic, assign, getter=isMaskDisabled) BOOL maskDisabled;

@property (nonatomic, assign) MGUDosePickerViewStyle pickerViewStyle;
@property (nonatomic, assign) NSUInteger selectedItemIndex; // 선택된 item의 index
@property (nonatomic, assign, readonly) CGPoint contentOffset;

@property (nonatomic, assign) BOOL soundOn;
@property (nonatomic, copy, nullable) void (^normalSoundPlayBlock)(void);

- (void)reloadData;
- (void)selectItemIndex:(NSUInteger)itemIndex animated:(BOOL)animated notify:(BOOL)notify; // animation 유무와는 별개로 알림을 요구할 수도 안할 수도 있게 만들었다.

@end

NS_ASSUME_NONNULL_END
