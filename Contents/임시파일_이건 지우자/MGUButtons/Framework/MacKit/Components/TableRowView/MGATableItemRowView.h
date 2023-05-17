//
//  MGATableItemRowView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-05
//  ----------------------------------------------------------------------
//
//! Diffable로 오면서 NSTableRowView의 등록은 일반 item row view와 group row view (section header view)를 다른 방식으로 등록해야한다.
//! 이 클래스는 item row view를 의미한다.
//! NSCollectionView와는 다르게 reusable을 위한 등록이 nib만 가능하다. (NSTableView, NSOutlineView 등)

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

//! 셀렉션 스타일 종류.(선택된 셀의 색깔:하이라이팅 색깔)
//! 0. 셀렉션 효과 제거 : outlineView(테이블뷰).selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
//! 1. 디폴트 : SourceList의 경우에는 "AccentColor" - 비쥬얼 이펙트 존재 / 그렇지 않을 경우 일반적인 색.
//! 2. 회색 : Emphasized 가 NO. - 비쥬얼 이펙트 존재
//! 3. 임의의 색 : outlineView(테이블뷰).style = NSTableViewStyleSourceList; 에서는 사용할 수 없다. - 비쥬얼 이펙트 없음.

/*!
 @enum       MGATableItemRowViewHighlightStyle
 @abstract   ......
 @constant   MGATableItemRowViewHighlightStyleDefault 시스템에서 제공하는 파란색. NSTableViewSelectionHighlightStyleNone이면 효과 없음.
 @constant   MGATableItemRowViewHighlightStyleGray  Emphasized 가 NO 된 상태
 @constant   MGATableItemRowViewHighlightStyleCustom  NSTableViewStyleSourceList 가 아니면 발동되는 색.
 */
typedef NS_ENUM(NSUInteger, MGATableItemRowViewHighlightStyle) {
    MGATableItemRowViewHighlightStyleDefault = 0,
    MGATableItemRowViewHighlightStyleGray,  //! NSTableViewStyleSourceList 에서만 사용할 듯.
    MGATableItemRowViewHighlightStyleCustom //! NSTableViewStyleSourceList에서는 사용불가.
};


/*!
 @class         MGATableItemRowView - NSTableRowView의 서브 클래스
 @abstract      tableView(outlineView)의 배경색, 셀렉션(emphasized YES/NO), 세퍼레이터에 대한 커스터마이징 담당.
 @warning       Diffable로 오면서 group row(section header view)는 애플이 정해준 identifier로 따로 설정해야한다.
 @see           group row는 MGATableGropRowView 를 참고하라. 등록방법도 중요하다.
 @discussion    위키 -> Project:Mac-ObjC/셀렉션, 세퍼레이터, 스와이프 // SnippetsLab 앱에 정리있음.
                디퍼블일 때에는 self.dataSource.rowViewProvider 이용. ※ grop row는 nib과 애플이 정해준 identifier를 이용.
                    self.dataSource.rowViewProvider =
                        ^MGATableItemRowView *(NSTableView *tableView, NSInteger row, MGXItem *itemId) {
                        MGATableItemRowView *rowView = [[MGATableItemRowView alloc] initWithTableView:tableView
                                                                                   insetStyle:YES
                                                                                 useInsetMask:NO];
                    //! 닙을 등록했다면 만들어졌다면 다음과 같이 만든다.
                    //! 등록: NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MGATableItemRowView" bundle:[NSBundle mainBundle]];
                    //! 등록:[self.tableView registerNib:nib forIdentifier:@"MGATableItemRowViewKey"];
 
                    MGATableItemRowView *rowView = [tableView makeViewWithIdentifier:@"MGATableItemRowViewKey"
                                                                               owner:weakSelf];
                    rowView.tableView = weakSelf.tableView;
                    rowView.insetStyle = YES;
                    rowView.useInsetMask = YES;
                        ....
                        return rowView;
                    };
                디퍼블이 아닐 때에는
                    NSTableViewDelegate : - tableView:rowViewForRow: 이용
                    NSOutlineViewDelegate : - outlineView:rowViewForItem: 이용
*/
@interface MGATableItemRowView : NSTableRowView

@property (nonatomic, assign) MGATableItemRowViewHighlightStyle highlightStyle;
@property (nonatomic, strong) NSColor *selectionHighlightColor; // MGATableItemRowViewHighlightStyleCustom 일때만 이용.

- (instancetype)initWithTableView:(NSTableView *)tableView // weak 로 잡힌다.
                       insetStyle:(BOOL)insetStyle    // 셀렉션에서 인셋 & 라이어스를 줄지 여부
                     useInsetMask:(BOOL)useInsetMask; // insetStyle 이 YES 일때, 스와이프로 밀릴 때, 마스크를 줄지 여부.

@property (nonatomic, assign) BOOL useCustomSeparator; // 디폴트 NO
@property (nonatomic, strong, nullable) NSColor *customSeparatorColor; // useCustomSeparator YES 일때만 가능.
//@property (nonatomic, assign) CGFloat customSeparatorInset; // 우선은 좌우 똑같이 주는 걸로 만들었다.
@property (nonatomic, assign) CGPoint customSeparatorInsets;
// 애플은 NSTableViewStyleInset, NSTableViewStyleSourceList에서 (20, 16)이다.
@property (nonatomic, assign) BOOL drawLastRowSeparator; // 아래 설명참고.

//! nib에서 만들어졌다면 아래의 세 가지 프라퍼티를 설정하자.
// tableView.style이 NSTableViewStyleInset, NSTableViewStyleSourceList 일때 YES에 해당할 듯.
@property (nonatomic, assign) BOOL insetStyle;
@property (nonatomic, assign) BOOL useInsetMask;
@property (nonatomic, weak, nullable) NSTableView *tableView; // 아래 설명참고.
// tableView의 스타일이 NSTableViewStyleInset, NSTableViewStyleSourceList일 때에는 마지막 셀의 separator를
// 그리지 않는 특성이 있다. 이 특성을 따라하고 싶다면 drawLastRowSeparator를 YES로 하라.
// 마지막 row에 대한 판단은 tableView에 물어봐야하고 애플은 private으로 사용하고 있다. 나는 명시적으로 프라퍼티로 잡겠다.
// Gradient 스타일로 separator를 만들고 싶다면 HoverTableDemo 프로젝트 참고
// tableView의 스타일이 NSTableViewStyleFullWidth, NSTableViewStylePlain일 때에는 셀이 없는 곳에도
// separator가 그려지며 이것은 tableView의 영역이다. HoverTableDemo 프로젝트 참고

//#pragma mark - NS_UNAVAILABLE
//+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;
//- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
//- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end


/*!
 * @abstract    @c SnippetsLabRowView 은 SnippetsLab 앱 처럼 스와이프로 밀리는 모습을 표현한다.
 * @discussion  별다른게 없다. 그냥 drawRect:에서 super만 호출해주면 끝이다. 애플 노트앱처럼 작동하려면 아무것도 안하면 된다.
 * @note        커스텀 셀렉션 색, 커스텀 세퍼레이터(인셋 조정 때문에)를 사용하려면 많은 커스텀이 필요하다. MGATableItemRowView 참고. 커스텀 색을 사용하려면 재정의를 해야하고 스와이프에 대한 프레임 조정이 필수다. source list는 회색 밖에 안된다. 세퍼레이터는 색은 기본적으로 설정가능하지만, 인셋 및 굵기를 조절하려면 마찬가지의 노력이 필요하다.
 */
@interface SnippetsLabRowView : NSTableRowView
@end
NS_ASSUME_NONNULL_END
/*
 중요 : source list 스타일은 셀렉션 칼라가 커스텀이 안되는 것 같다.
 https://stackoverflow.com/questions/26884021/custom-selection-style-for-view-based-source-list-nsoutlineview
 또한 여기에는 비쥬얼 이펙트가 add 되는 것을 감지해서 Plat 한 색으로 설정하는 트릭이 있기는 한데, 지금은 통하지 않는다.
 별개로 popup button에서 선택되는 메뉴아이템을 커스터마이징하면서 비쥬얼 이펙트 뷰를 직접 붙인 경우가 있기는 한데(NSPopUpButton_Customizing_Project), 기존의 색을 바꾸는 것은 아니었다.
 
 Are you using Yosemite? From Apple's document Adopting Advanced Features of the new UI in Yosemite

 When selectionHighlightStyle == NSTableViewSelectionHighlightStyleSourceList • Selection is now a special blue material that does behind window blending - The material size and drawing can not be customized
 결론 : 소스 리스트일 때에는 비쥬얼 이펙트 효과를 그대로 쓰면서 색을 바꾸고 싶다면 Accent Color 를 바꾸는 수 밖에 없다. 그렇지 않다면 Gray style을 사용하던가 해야함. 소스 리스트 일때, 플레인한 색으로 설정은 불가능하다.
 
 참고 프로젝트 : HoverTableDemo, NSTableViewSwipeAndSelectingColor

*/

/*
 세퍼레이터 관련. 스닙펫 앱에서 정리 참고바람.
 참고 프로젝트 : TableView_basic_TEST, HoverTableDemo, Fruta_Card_TEST, NSTableViewSwipeAndSelectingColor
 기본 설정을 따라갈지, 자신이 원하는 스타일로 가야할지 먼저 결정해야한다.
 정리하기가 쉽지 않다. HoverTableDemo 프로젝트를 중심으로 필요에 따라서 구성해야겠다.
 
 //! 셀이 없는 곳도 그리는 스타일
 // NSTableViewStyleFullWidth
 // NSTableViewStylePlain

 //! 셀이 있는 곳만 그리는 스타일 (마지막 row는 그리지 않는다.). 셀렉션이 발생하면 셀렉션 해당 위, 아래 세퍼레이터를 감춘다.
 // NSTableViewStyleSourceList
 // NSTableViewStyleInset
 
 //! 셀이 있는 곳에 그리려면. NSTableRowView 메서드
 - (void)drawSeparatorInRect:(NSRect)dirtyRect

 //! 셀이 없는 곳에 그리려면. NSTableView 메서드 : HoverTableDemo 프로젝트 참고하라.
 - (void)drawGridInClipRect:(NSRect)clipRect;
 */

/*
 기타 정보: 스닙펫 앱처럼 스와이프 & 셀렉션 & 세퍼레이터를 작동 시키려면 NSTableRowView 를 상속 받은 후 drawRect: 에서 super를 호출하면 끝이다. 그냥 NSTableRowView를 쓰는 것과는 다르게 작동한다. tableView 가 inset style에서 trailing 스와이프를 작동하여 밀릴 때, 디폴트보다 좀 더 이쁘게 밀린다.(내 주관) 세퍼레이터 움직이는 것도 다르다. 색은 똑같다. 비교해 보려면 스닙펫 앱과 애플의 노트앱을 비교해 보라.
 */


#pragma mark - 샘플
/* SnippetsLab 앱 - 테이블 뷰스타일
 self.dataSource.rowViewProvider = ^MGATableItemRowView *(NSTableView *tableView, NSInteger row, MGXItem *itemId) {
     MGATableItemRowView *rowView = [[MGATableItemRowView alloc] initWithTableView:tableView
                                                                insetStyle:YES
                                                              useInsetMask:NO];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleDefault;
     rowView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
     return rowView;
 };
 
 self.tableView.dataSource = self.dataSource;
 self.tableView.style = NSTableViewStyleInset;
 self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
 */
/* Note 앱 - 테이블 뷰스타일 - 그냥 row view를 설정 안해도 된다.
 self.dataSource.rowViewProvider = ^MGATableItemRowView *(NSTableView *tableView, NSInteger row, MGXItem *itemId) {
     MGATableItemRowView *rowView = [[MGATableItemRowView alloc] initWithTableView:tableView
                                                                insetStyle:YES
                                                              useInsetMask:YES];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleDefault;
     rowView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
     return rowView;
 };
 
 self.tableView.dataSource = self.dataSource;
 self.tableView.style = NSTableViewStyleInset;
 self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
 */
/* Finder 앱 - outline뷰 스타일 - 이미지는 템플릿이아닌 쌩 칼라로 넣어야한다. 셀렉션이 회색이다. 비쥬얼 이펙트
 <NSOutlineViewDelegate>
 - (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(MGROutlineItem <Item *>*)item {
     MGATableItemRowView *rowView = [[MGATableItemRowView alloc] initWithTableView:self.outlineView
                                                                insetStyle:YES
                                                              useInsetMask:YES];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleGray;
     return rowView;
 }

 // 이게 소용이 없다. Emphasized 가 NO 이기 때문이다.
 - (NSTintConfiguration *)outlineView:(NSOutlineView *)outlineView tintConfigurationForItem:(MGROutlineItem <Item *>*)item {
     return [NSTintConfiguration tintConfigurationWithFixedColor:[NSColor systemRedColor]];
 }
 
 self.outlineView.floatsGroupRows = NO; // Source List 일때는 NO. 애플 지침. Api:AppKit/NSTableView/floatsGroupRows 참고.
 self.outlineView.style = NSTableViewStyleSourceList;
 self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
 */

/* 이전에 작성해 놓은거라서 안맞을 수도 있다.
 1. 만약 셀렉션 하이라이팅 자체를 안할꺼면
 self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone; 충분.
 
 2-1. SourceList 스타일에서 디폴트 파란색을 사용하려면
 self.outlineView.style = NSTableViewStyleSourceList;
 self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;

 2-2. SourceList 스타일에서 디폴트 회색을 사용하려면
 self.outlineView.style = NSTableViewStyleSourceList;
 self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
 
 #pragma mark - <NSOutlineViewDelegate>
 - (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
     MGATableItemRowView *rowView = [MGATableItemRowView new];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleGray;
     return rowView;
 }
 
 #pragma mark - <NSTableViewDelegate>
 - (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
     MGATableItemRowView *rowView = [MGATableItemRowView new];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleGray;
     return rowView;
 }
 
 3-1. SourceList 스타일이 아닌 곳에서 디폴트 파란색을 사용하려면
 self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;

 3-2. SourceList 스타일이 아닌 곳에서 디폴트 회색을 사용하려면
 self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
 
 #pragma mark - <NSOutlineViewDelegate>
 - (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
     MGATableItemRowView *rowView = [MGATableItemRowView new];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleGray;
     return rowView;
 }
 
 #pragma mark - <NSTableViewDelegate>
 - (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
     MGATableItemRowView *rowView = [MGATableItemRowView new];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleGray;
     return rowView;
 }
 
 3-3. SourceList 스타일이 아닌 곳에서 커스텀 색을 사용하려면 (비쥬얼 이팩트 없음.)
 self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
 
 #pragma mark - <NSOutlineViewDelegate>
 - (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
     MGATableItemRowView *rowView = [MGATableItemRowView new];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleCustom;
     rowView.selectionHighlightColor = [NSColor systemRedColor]; // [NSColor selectedContentBackgroundColor];
     // 만약, 애플의 적용 알고리즘을 원한다면 [NSColor systemMintColor] 값의 R,G,B에 각각 0.882353 곱합. 알파는 동일.
     return rowView;
 }
 
 #pragma mark - <NSTableViewDelegate>
 - (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
     MGATableItemRowView *rowView = [MGATableItemRowView new];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleCustom;
     rowView.selectionHighlightColor = [NSColor systemRedColor]; // [NSColor selectedContentBackgroundColor];
     // 만약, 애플의 적용 알고리즘을 원한다면 [NSColor systemMintColor] 값의 R,G,B에 각각 0.882353 곱합. 알파는 동일.
     return rowView;
 }
 
 // Diffable - 아직은 테이블뷰만 가능.
 self.dataSource.rowViewProvider = ^MGATableItemRowView *(NSTableView *tableView, NSInteger row, MGXItem *itemId) {
     MGATableItemRowView *rowView = [MGATableItemRowView new];
     rowView.highlightStyle = MGATableItemRowViewHighlightStyleCustom;
     rowView.selectionHighlightColor = [NSColor systemMintColor]; // [NSColor selectedContentBackgroundColor];
     // 만약, 애플의 적용 알고리즘을 원한다면 [NSColor systemMintColor] 값의 R,G,B에 각각 0.882353 곱합. 알파는 동일.
     return rowView;
 };
 */
