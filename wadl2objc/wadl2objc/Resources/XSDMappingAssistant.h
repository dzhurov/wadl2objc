//
//  XSDMappingAssistant.h
//  wadl2objc
//

#import <Foundation/Foundation.h>

@interface XSDMappingAssistant : NSObject

+ (NSDictionary<NSString*, NSString*>*)mappingDictionaryXSDToObjCFields;
+ (NSDictionary<NSString*, NSString*>*)mappingDictionaryObjToCXSDFields;

@end
