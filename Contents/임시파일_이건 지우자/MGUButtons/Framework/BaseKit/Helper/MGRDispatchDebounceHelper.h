//
//  MGRDispatchDebouncer.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
// ----------------------------------------------------------------------
//  VERSION_DATE    2021-12-27
// ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

/// interval 만큼 디바운스 하여 next 블락을 queue 에서 실행해준다.
typedef void (^MGRDispatchDebounceBlock)(dispatch_queue_t queue, NSTimeInterval interval, dispatch_block_t next);

/// 디스패치 디바운스 블락 반환
MGRDispatchDebounceBlock MGRDispatchDebouncer(void);

// 사용예시
// UISearchController 에서 0.25 초 디바운스 뒤에 검색 실행되게하기 위해
// 컨트롤러에 프로퍼티 하나 만들어서
// _debouncer = MGRDispatchDebouncer();
// 해서 잡아둔 뒤 함수에서 다음과 같이 한다.
//
//  - (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//        if (!_isSearchMode) {return;}
//      __weak __typeof(self) weakSelf = self;
//      MGRPinListSearchIdx idx = _searchIdx;
//       _debouncer(MGR_MAIN_QUEUE, 0.25f, ^{[weakSelf.viewModel search:searchController.searchBar.text type:idx];});
//  }
//
