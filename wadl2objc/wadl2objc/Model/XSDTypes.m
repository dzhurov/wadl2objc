//
//  XSDTypes.m
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "XSDTypes.h"

NSString * classNameForXSDType(NSString* xsdType)
{
    if ( [xsdType isEqualToString:kXSDString] )
        return @"NSString";
    
    BOOL isNumber = [xsdType isEqualToString:kXSDInt] ||
                    [xsdType isEqualToString:kXSDLong] ||
                    [xsdType isEqualToString:kXSDDouble] ||
                    [xsdType isEqualToString:kXSDBool] ||
                    [xsdType isEqualToString:kXSDDecimal];
    if ( isNumber )
        return @"NSNumber";
    if ( [xsdType isEqualToString:kXSDDateTime] )
        return @"NSDate";
    
    assert(nil);
    
    return @"WAT??";
}

NSString * formattedType(NSString *type)
{
    return [[[type substringToIndex:1] capitalizedString] stringByAppendingString:[type substringFromIndex:1]];
}