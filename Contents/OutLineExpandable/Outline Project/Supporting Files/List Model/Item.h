//
//  Item.h
//  OutlineProject
//
//  Created by Kwan Hyun Son on 13/12/2018.
//  Copyright © 2018 Mulgrim Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSObject

@property (nonatomic, strong) NSString *textLabelText;
@property (nonatomic, strong) NSString *detailTextLabelText;

- (instancetype)initWithText:(NSString *)text detailText:(NSString *)detailText;

@end

NS_ASSUME_NONNULL_END
