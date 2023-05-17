//
//  MGAImageView.h
//  Fruta_Card_TEST_Mac
//
//  Created by Kwan Hyun Son on 2022/10/21.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE @interface MGAImageView : NSView

@property (nonatomic, strong) CALayerContentsGravity contentMode; // UIKit 의 UIViewContentMode 에 해당
@property (nonatomic, strong, nullable) NSImage *image;
@end

NS_ASSUME_NONNULL_END
