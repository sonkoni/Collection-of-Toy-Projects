//
//  MGRDoseViewController.h
//  PickerView
//
//  Created by Kwan Hyun Son on 11/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//
//! TODO: <MGUDosePickerViewDataSource> 프로토콜의 - pickerView:imageForItemIndex: 를 구현하지 않았다.

#import <IosKit/MGUDosePickerView.h>
NS_ASSUME_NONNULL_BEGIN

#pragma mark - 프로토콜

@protocol MGUDosePickerViewControllerDelegate <UIScrollViewDelegate>
@optional
- (void)pickerViewDidSelectItem:(NSAttributedString *)attributedText; // 선택이 되었으므로 버튼의 타이틀을 갱신하라.
- (void)pickerViewDidSelectTitles:(NSArray <NSString *>*)titles;
@end


#pragma mark - 인터페이스
@interface MGUDosePickerViewController : UIViewController

@property (nonatomic, weak, nullable) id <MGUDosePickerViewControllerDelegate> delegate;

- (instancetype)initWithDoseTitles:(NSMutableArray <NSString *>* _Nonnull)doseTitles
                      weightTitles:(NSMutableArray <NSString *>* _Nonnull)weightTitles
                        timeTitles:(NSMutableArray <NSString *>* _Nonnull)timeTitles
                     initialTitles:(NSMutableArray <NSString *>* _Nullable)initialTitles;

@property (nonatomic, readonly) NSArray <NSString *>*selectedTitles; // @dynamic
@property (nonatomic, readonly) NSString *selectedDosePickerTitle;   // @dynamic
@property (nonatomic, readonly) NSString *selectedWeightPickerTitle; // @dynamic
@property (nonatomic, readonly) NSString *selectedTimePickerTitle;   // @dynamic

@property (nonatomic, readonly) NSArray <NSNumber *>*selectedIndexes; // @dynamic
@property (nonatomic, readonly) NSUInteger selectedDosePickerIndex;   // @dynamic
@property (nonatomic, readonly) NSUInteger selectedWeightPickerIndex; // @dynamic
@property (nonatomic, readonly) NSUInteger selectedTimePickerIndex;   // @dynamic

#pragma mark - config
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;

@property (nonatomic, strong) UIColor *selectionViewColor;
@property (nonatomic, assign) CGFloat selectionViewRadius;
@property (nonatomic, strong) UIColor *selectionViewBorderColor;
@property (nonatomic, assign) CGFloat selectionViewBorderWidth;
@property (nonatomic, strong) UIColor *selectionViewShadowColor;
@property (nonatomic, assign) CGFloat selectionViewShadowOpacity;
@property (nonatomic, assign) CGFloat selectionViewShadowRadius; // 블러되는 반경
@property (nonatomic, assign) CGSize selectionViewShadowOffset;  // 디폴트 (0.0, -3.0)

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *highlightedFont;
@property (nonatomic, assign) MGUDosePickerViewStyle pickerViewStyle; // 디폴트 MGUDosePickerViewStyleFlatCenterPop
@property (nonatomic, assign) BOOL maskDisabled; // 디폴트 NO - 즉, 양 끝을 연하게 하는 것이 Default
@property (nonatomic, assign) BOOL soundOn; // 디폴트 YES
@property (nonatomic, copy, nullable) void (^normalSoundPlayBlock)(void);

- (void)selectItemIndexes:(NSMutableArray <NSNumber *>*)itemIndexes animated:(BOOL)animated notify:(BOOL)notify;
- (void)selectItemTitles:(NSMutableArray <NSString *>*)itemTitles animated:(BOOL)animated notify:(BOOL)notify;

NSAttributedString * resultPickerTitle(NSString *dosePickerTitle, NSString *weightPickerTitle, NSString *timePickerTitle);

@end

NS_ASSUME_NONNULL_END
//
// pickerButtonTitle을 함수로 제공하는 이유는 MGUDosePickerViewController를 컨트롤하는 컨트롤러가 MGUDosePickerViewController 초기화 하지 않은 상태에서도
// 자신의 picker button title을 설정할 수 도 있기 때문이다.
