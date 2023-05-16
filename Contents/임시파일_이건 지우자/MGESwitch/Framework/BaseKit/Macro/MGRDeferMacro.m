//
//  MGRDeferMacro.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGRDeferMacro.h"

void MGRDeferExecuteCleanupBlock(__strong dispatch_block_t *block) {
    (*block)();
}
