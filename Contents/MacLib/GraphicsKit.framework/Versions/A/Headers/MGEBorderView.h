//
//  MGEBorderView.h
//  MGEBorderLayer Project
//
//  Created by Kwan Hyun Son on 2021/10/10.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//


#import <GraphicsKit/MGEBorderLayer.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGEBorderView
 @abstract      MGEBorderLayer를 이ㅇㅇ할 때, 오토레이아웃 및 다크모드 대응의 편리를 위해 만들었다.
 @discussion    ...
*/
@interface MGEBorderView : MGEView

//! 칼라만 설정해주자. 다크 코드 대응을 위해.
// 단색
@property (nonatomic, strong) NSArray <MGEColor *>*borderColors; // 바깥쪽에서부터 차례로 보내준다.
// 그레디언트
@property (nonatomic, strong) NSArray <MGEColor *>*startColors;  // 바깥쪽에서부터 차례로 보내준다.
@property (nonatomic, strong) NSArray <MGEColor *>*endColors; // 바깥쪽에서부터 차례로 보내준다.


@property (nonatomic, readonly) MGEBorderLayer *borderLayer; // @dynamic
@end

NS_ASSUME_NONNULL_END
