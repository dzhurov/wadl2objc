//
//  XSDTypes.h
//
//  Created by wadl2objc
//

#import <Foundation/Foundation.h>


/**
 There are two fake classes
 @class XSDDate
 @class XSDDateTime
 
 Don't create it directrly. Use methods `-[NSDate xsdDate]` and `-[NSDate xsdDateTime]`.
 This classes has been create to identify xs:date and xs:dateTime in XSD Schema.
 */
@interface XSDDate : NSDate
@end

@interface XSDDateTime : NSDate

@end

@interface NSDate (XSDDate)

- (XSDDate*)xsdDate;
- (XSDDateTime*)xsdDateTime;

@end
