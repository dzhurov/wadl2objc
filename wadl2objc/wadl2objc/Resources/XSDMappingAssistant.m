//
//  XSDMappingAssistant.m
//  wadl2objc
//

#import "XSDMappingAssistant.h"

@implementation XSDMappingAssistant

+ (NSDictionary<NSString *,NSString *> *)mappingDictionaryObjCToXSDFields
{
    static NSDictionary *sMappingDictionaryObjCToXSDFields = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMappingDictionaryObjCToXSDFields = @{  <#xsd_to_objc_fields#>};
    });
    return sMappingDictionaryObjCToXSDFields;
}

+ (NSDictionary<NSString *,NSString *> *)mappingDictionaryXSDToObjCFields
{
    static NSDictionary *sMappingDictionaryXSDToObjCFields = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMappingDictionaryXSDToObjCFields = @{  <#objc_to_xsd_fields#>};
    });
    return sMappingDictionaryXSDToObjCFields;
}

@end
