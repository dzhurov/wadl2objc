//
//  NSString+FirstCharacter.m
//  wadl2objc
//
//  Created by Dmitry on 10/13/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "NSString+FirstCharacter.h"

@implementation NSString (FirstCharacter)

- (NSString *)lowercaseFirstCharacterString
{
    if (self.length)
        return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
    return @"";
}
- (NSString *)uppercaseFirstCharacterString
{
    if (self.length)
        return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
    return @"";
}
@end
