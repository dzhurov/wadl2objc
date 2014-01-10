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
// NSString
    if ( [xsdType isEqualToString:kXSDString] )
        return @"NSString";
    if ( [xsdType isEqualToString:kXSDBase64String] )
        return @"NSString/*base64*/";

// NSNumber
    /// @description int
    if ( [xsdType isEqualToString:kXSDInt] ||
        [xsdType isEqualToString:kXSDLong] ||
        [xsdType isEqualToString:kXSDDouble] ||
        [xsdType isEqualToString:kXSDBool] ||
        [xsdType isEqualToString:kXSDDecimal] ||
        [xsdType isEqualToString:kXSDFload] )
        return @"NSNumber";

// NSDate
    if ( [xsdType isEqualToString:kXSDDateTime] )
        return @"XSDDateTime";
    if ( [xsdType isEqualToString:kXSDDate] )
        return @"XSDDate";
        
    return xsdType;
}

NSString * dockCommentForXSDType(NSString* xsdType)
{
    if ( [xsdType isEqualToString:kXSDInt] )
        return @"/*! int */";
    if ( [xsdType isEqualToString:kXSDLong] )
        return @"/*! long */";
    if ( [xsdType isEqualToString:kXSDDouble] )
        return @"/*! double */";
    if ( [xsdType isEqualToString:kXSDBool] )
        return @"/*! BOOL */";
    if ( [xsdType isEqualToString:kXSDDecimal] )
        return @"/*! xs:decimal */";
    if ( [xsdType isEqualToString:kXSDFload] )
        return @"/*! float */";
    if ( [xsdType isEqualToString:kXSDBase64String] )
        return @"/*! Base64 string */";
    
    return nil;
}

NSString * formattedType(NSString *type)
{
    return [[[type substringToIndex:1] capitalizedString] stringByAppendingString:[type substringFromIndex:1]];
}