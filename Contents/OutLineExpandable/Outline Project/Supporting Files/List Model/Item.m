//
//  Item.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 13/12/2018.
//  Copyright © 2018 Mulgrim Inc. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithText:(NSString *)text detailText:(NSString *)detailText {
    self = [super init];
    if(self) {
        _textLabelText = text;
        _detailTextLabelText = detailText;
    }
    
    return self;
}

@end
