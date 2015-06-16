//
//  Utilities.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 31.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define synthesizeLazzyProperty(propertyName, propertyType) \
- (propertyType *)propertyName \
{ \
    if ( !_##propertyName ){ \
        _##propertyName = [[propertyType alloc] init]; \
    } \
    return _##propertyName; \
} \

#define safeString(aString) (aString ? aString : @"")

@interface Utilities : NSObject

+ (NSString*)NSStringBase64FromData: (NSData *)data;

@end

@interface NSString (XMLPrefix)

- (NSString*)stringBySplittingXMLPrefix:(out NSString **)prefix;

@end

@interface NSDictionary (XMLPrefix)

- (id)objectForKeyIgnoringXMLPrefix:(NSString*)key;

/*! @return dictionary with objects and keys without prefix. E.g.
  @{@"xmlns:ns1": @"namespaceIdentifier:1"} for prefix "xmlns" will return :
  @{@"ns1": @"namespaceIdentifier:1"}*/
- (NSDictionary*)objectsForKeysWithPrefix:(NSString*)prefix;

@end
