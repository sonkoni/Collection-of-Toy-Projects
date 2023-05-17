//
//  MGATableGroupRowView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-05
//  ----------------------------------------------------------------------
//
//! Diffable로 오면서 NSTableRowView의 등록은 일반 item row view와 group row view (section header view)를 다른 방식으로 등록해야한다.
//! 이 클래스는 group row view를 의미한다.
//! NSCollectionView와는 다르게 reusable을 위한 등록이 nib만 가능하다. (NSTableView, NSOutlineView 등)

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGATableGroupRowView - NSTableRowView의 서브 클래스
 @abstract      tableView(outlineView)의 배경색, 셀렉션(emphasized YES/NO), 세퍼레이터에 대한 커스터마이징 담당.
 @warning       Diffable로 오면서 group row(section header view)는 애플이 정해준 identifier로 따로 설정해야한다.
 @see           item row view는 MGATableItemRowView 를 참고하라. 등록방법도 중요하다.
 @discussion    위키 -> Project:Mac-ObjC/셀렉션, 세퍼레이터, 스와이프 // SnippetsLab 앱에 정리있음.
                'NSTableViewRowViewKey'는 애플이 정해놓은 디폴트 키 상수 값이다.
                NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MGATableGroupRowView"
                                                      bundle:[NSBundle mainBundle]];
                [self.tableView registerNib:nib forIdentifier:NSTableViewRowViewKey];
                정말 지랄 같은 것은 객체만 선택할 수 있다는 것이다. 이 객체의 설정을 변경할 수 없다. 그냥 객체 그대로 사용해야한다.
                애플이 Diffable을 만들면서, self.dataSource.rowViewProvider = ...에서 group를 빼먹은 것 같다. 앱에 따라서
                적절한것을 만들어서 제공하자. 아주 기본적인 full length의 세퍼레이터만 넣었다.
*/
@interface MGATableGroupRowView : NSTableRowView

@end

NS_ASSUME_NONNULL_END
