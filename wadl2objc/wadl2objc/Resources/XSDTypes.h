//
//  XSDTypes.h
//
//  Created by wadl2objc
//

#import <Foundation/Foundation.h>

@interface XSDDate : NSDate
@end

@interface XSDDateTime : NSDate

@end

@interface NSDate (XSDDate)

- (XSDDate*)xsdDate;
- (XSDDateTime*)xsdDateTime;

@end