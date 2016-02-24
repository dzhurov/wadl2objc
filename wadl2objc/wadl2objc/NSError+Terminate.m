//
//  NSError+Terminate.m
//  wadl2objc
//
//  Created by DZhurov on 8/11/15.
//  Copyright © 2015 zimCo. All rights reserved.
//

#import "NSError+Terminate.h"

@implementation NSError (Terminate)

- (void)terminate
{
    NSLog(@"ERROR: %@", self);
    exit((int)self.code);
}

@end
