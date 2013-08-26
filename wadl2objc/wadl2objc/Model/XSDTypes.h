//
//  XSDTypes.h
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXSDString      @"xs:string"
#define kXSDDateTime    @"xs:dateTime"

#define kXSDInt         @"xs:int"
#define kXSDLong        @"xs:long"
#define kXSDDouble      @"xs:double"
#define kXSDDecimal     @"xs:decimal"
#define kXSDBool        @"xs:boolean"

NSString * classNameForXSDType(NSString* xsdType);
NSString * formattedType(NSString *type);