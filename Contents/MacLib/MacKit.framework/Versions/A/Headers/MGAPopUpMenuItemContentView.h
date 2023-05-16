//
//  MGAPopUpMenuItemContentView.h
//  NSPopUpButtonCustomizing
//
//  Created by Kwan Hyun Son on 2022/05/13.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGAPopUpMenuItemContentView : NSPopUpButton 의 컨텐츠 커스터마이징
 @abstract      NSMenuItem의 커스텀 뷰(view 프라퍼티)로 쓰일 뷰를 의미한다.
 @discussion    높이가 22.0, 상하 간의 간격은 없다.
*/
IB_DESIGNABLE @interface MGAPopUpMenuItemContentView : NSView
@property (nonatomic, strong) NSTextField *textLabel;
@property (nonatomic, strong) NSImageView *leftImageView;
@property (nonatomic, strong) NSImageView *rightImageView;
@property (nonatomic, strong) NSImageView *rightImageView2;
@property (nonatomic, assign) IBInspectable BOOL selected;
@end
NS_ASSUME_NONNULL_END
