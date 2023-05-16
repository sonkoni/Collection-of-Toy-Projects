//
//  MGATableCell.h
//  JustTEST
//
//  Created by Kwan Hyun Son on 2022/11/07.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <MacKit/MGATableCellView.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGASnippetsLabCell
 @abstract      SnippetsLab 앱의 테이블뷰에 사용된 셀 모양과 같다.
 @discussion    XIB로 사용해야한다. NSTableView는 NSCollectionView와 다르게 등록이 NIB 만 가능하다. 당연히 view - based이다.
 
 등록 :
 NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MGASnippetsLabCell" bundle:[NSBundle mainBundle]];
 [self.tableView registerNib:nib forIdentifier:@"MGASnippetsLabCell"];
 
 사용 :
 _dataSource =
 [[NSTableViewDiffableDataSource alloc] initWithTableView:self.tableView
                                             cellProvider:^NSView *(NSTableView *tableView,
                                                                    NSTableColumn *column,
                                                                    NSInteger row,
                                                                    MGXItem *item) {
     MGXTableCellView *cell = (MGXTableCellView *)[tableView makeViewWithIdentifier:identifier owner:self];
     if ([cell isKindOfClass:[MGXTableCellView class]] == NO) {
         return [NSView new];
     }
     
     cell.label1.stringValue = item.text1;
     cell.label2.stringValue = item.text2;
     cell.label3.stringValue = item.text3;
     return cell;
 }];
*/
@interface MGASnippetsLabCell : MGATableCellView

@property (weak, nonatomic) IBOutlet NSTextField *label1; // 윗쪽의 라벨
@property (weak, nonatomic) IBOutlet NSTextField *label2; // 왼쪽 아래 라벨
@property (weak, nonatomic) IBOutlet NSTextField *label3; // 오른쪽 아래 라벨

@end

NS_ASSUME_NONNULL_END
