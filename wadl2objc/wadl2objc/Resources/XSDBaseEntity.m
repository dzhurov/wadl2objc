//
//  XSDBaseEntity
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "XSDBaseEntity.h"
#import <objc/runtime.h>

__strong static NSDateFormatter const *sXSDBaseEntityDateFormatter = nil;
__strong static NSDateFormatter const *sXSDBaseEntityDateTimeFormatter = nil;

@interface XSDBaseEntity ()
{
    BOOL _isDirty;
}
@end

@implementation XSDBaseEntity

#pragma mark - Static methods

+ (void)load
{
    sXSDBaseEntityDateTimeFormatter = [[NSDateFormatter alloc] init];
    sXSDBaseEntityDateTimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    sXSDBaseEntityDateFormatter = [[NSDateFormatter alloc] init];
    sXSDBaseEntityDateFormatter.dateFormat = @"yyyy-MM-dd";
}

+ (void)setDateFormatter:(NSDateFormatter *)aDateFormatter
{
    sXSDBaseEntityDateFormatter = aDateFormatter;
}

+ (void)setDateTimeFormatter:(NSDateFormatter *)dateTimeFormatter
{
    sXSDBaseEntityDateTimeFormatter = dateTimeFormatter;
}

+ (NSMutableArray *)objectsWithDictionariesInfoArray:(NSArray *)array
{
    if (array.count){
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dictionary in array) {
            XSDBaseEntity *entity = [[self alloc] initWithDictionaryInfo:dictionary];
            [resultArray addObject:entity];
        }
        return resultArray;
    }
    return nil;
}

+ (NSArray*)mappedKeys;
{
    return nil;
}

#pragma mark -

- (id)initWithDictionaryInfo:(NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        self.dictionaryInfo = dictionary;
    }
    return self;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@ %p>(", NSStringFromClass([self class]), self];
    NSMutableString *insetString = [NSMutableString string];
    for (int i = 0; i < level; i++) {
        [insetString appendFormat:@"\t"];
    }
    [self propertiesEnumeration:^(NSString *propertyName, NSArray *attributes) {
        BOOL strongReference = ! [[attributes objectAtIndex:0] hasPrefix:@"T@"]; // if attribute has prefix T@ it is a obj-C object ( id )
        if (! strongReference){
            for (NSString *oneAttribute in attributes) {
                if (([oneAttribute isEqualToString:@"C"] || [oneAttribute isEqualToString:@"&"])){ // Copy or Retain property
                    strongReference = YES;
                    break;
                }
            }
        }
        id value = [self valueForKey:propertyName];
        if (strongReference){
            if ( [value respondsToSelector:@selector(descriptionWithLocale:indent:)] )
                [description appendFormat:@"\n\t%@%@ = %@", insetString, propertyName, [value descriptionWithLocale:locale indent:level + 1]];
            else
                [description appendFormat:@"\n\t%@%@ = %@", insetString, propertyName, value];
        }
        else
            [description appendFormat:@"\n\t%@%@ = <%@ %p>(", insetString, propertyName,NSStringFromClass([value class]), value];
    }];
    
    [description appendFormat:@"\n%@)", insetString];
    return description;
}

- (NSString *)description
{
    return [self descriptionWithLocale:nil indent:0];
}

- (void) propertiesEnumeration: (void(^)(NSString *propertyName, NSArray *attributes))iterationBlock
{
    if (!iterationBlock){
        return;
    }
    Class aClass = [self class];
    while ([aClass isSubclassOfClass:[XSDBaseEntity class]]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            const char *propertyAttributes = property_getAttributes(property);
            if(propName) {
                NSString *propertyName = [NSString stringWithUTF8String: propName];
                NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
                iterationBlock(propertyName, attributes);
            }
        }
        free(properties);
        aClass = [aClass superclass];
    }
}

- (BOOL)isEqual:(id)object
{
    if ( ![object isKindOfClass:[self class]] ) 
        return NO;
    
    for (NSString *key in [[self class] mappedKeys]) {
        id selfValue = [self valueForKey:key];
        id anotherObjectValue = [object valueForKey:key];
        if ( (selfValue != anotherObjectValue) && ![selfValue isEqual:anotherObjectValue] )
            return NO;
    }
    return YES;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
    	objc_property_t property = properties[i];
    	const char *propName = property_getName(property);
    	if(propName) {
            NSString *propertyName = [NSString stringWithUTF8String: propName];
            id value = [self valueForKey:propertyName];
            [encoder encodeObject:value forKey:propertyName];
    	}
    }
    free(properties);
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if(propName) {
                NSString *propertyName = [NSString stringWithUTF8String: propName];
                id value = [decoder decodeObjectForKey:propertyName];
                [self setValue:value forKey:propertyName];
            }
        }
        free(properties);
    }
    return self;
}



#pragma mark - NSCopying

- (id)copyWithZone:(NSZone*)zone
{
	XSDBaseEntity* copy = [[[self class] allocWithZone:zone] init];
    for (NSString *key in [[self class] mappedKeys]) {
        
        id sourceValue = [self valueForKey:key];
        id resultValue = nil;
        
        if ([sourceValue isKindOfClass:[NSArray class]]) {
            resultValue = [[NSArray alloc] initWithArray:sourceValue copyItems:YES];
        } else {
            resultValue = [sourceValue copy];
        }
        
        [copy setValue:resultValue forKey:key];
    }
    return copy;
}

#pragma mark - Dictionary Info

- (NSMutableDictionary*)dictionaryInfoForKeys:(NSArray*)keys
{
    NSMutableDictionary *dictInfo = [NSMutableDictionary dictionary];
    for(NSString *key in keys){
        id valueForKey = [self valueForKey:key];
        if ( !valueForKey || [valueForKey isKindOfClass:[NSNull class]] )
            continue;
        objc_property_t property = class_getProperty([self class], [key UTF8String]);
        const char *propertyAttributes = property_getAttributes(property);
        NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
        NSString *propertyTypeStr = attributes[0];
        BOOL isPrimitive = [propertyTypeStr characterAtIndex:1] != '@'; // is it class
        NSString *className = [propertyTypeStr substringFromIndex:2]; // 2 is length of "T@""
        className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        Class propClass = NSClassFromString(className);
        if (isPrimitive){
            NSString *enumName = [[self class] enumNameForMappedField:key];
            if ( enumName ){
                NSUInteger enumValue = [(NSNumber*)valueForKey unsignedIntegerValue];
                id enumObj = [XSDEnums objectForEnumValue:enumValue enumName:enumName];
                valueForKey = enumObj;
            }
        }
        else if ([propClass isSubclassOfClass:[XSDBaseEntity class]]){
            valueForKey = [(XSDBaseEntity*)valueForKey dictionaryInfo];
        }
        else if ([propClass isSubclassOfClass:[XSDDate class]]){
            valueForKey = [sXSDBaseEntityDateFormatter stringFromDate:valueForKey];
        }
        else if ([propClass isSubclassOfClass:[XSDDateTime class]]){
            valueForKey = [sXSDBaseEntityDateTimeFormatter stringFromDate:valueForKey];
        }
        else if ([propClass isSubclassOfClass:[NSArray class]]){
            NSString *memberClassName = [[self class] classNameOfMembersForMappedField:key];
            Class memberClass = NSClassFromString(memberClassName);
            if ( [memberClass isSubclassOfClass:[XSDBaseEntity class]] ){
                NSArray *array = [(NSArray*)valueForKey valueForKey:@"dictionaryInfo"];
                valueForKey = array;
            }
        }
        
        if (valueForKey && ![valueForKey isKindOfClass:[NSNull class]]){
            [dictInfo setObject:valueForKey forKey:key];
        }
    }
    return dictInfo;
}

- (void) setDictionaryInfo:(NSDictionary*)dictInfo forKeys:(NSArray*)keys
{
    for(NSString *key in keys){
        id valueForKey = [dictInfo objectForKey:key];
        if (valueForKey && ![valueForKey isKindOfClass:[NSNull class]])
        {
            objc_property_t property = class_getProperty([self class], [key UTF8String]);
            const char *propertyAttributes = property_getAttributes(property);
            NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
            NSString *propertyTypeStr = attributes[0];
            BOOL isPrimitive = [propertyTypeStr characterAtIndex:1] != '@'; // is it class
            NSString *className = [propertyTypeStr substringFromIndex:2]; // 2 is length of "T@""
            className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            Class propClass = NSClassFromString(className);
            
            if (isPrimitive){ // isEnum
                NSString *enumName = [[self class] enumNameForMappedField:key];
                if ( enumName ){
                    NSUInteger enumValue = [XSDEnums enumValueForObject:valueForKey enumName:enumName];
                    [self setValue:@(enumValue) forKey:key];
                }
                else{
                    [self setValue:valueForKey forKey:key];
                }
            }
            else if ([propClass isSubclassOfClass:[XSDBaseEntity class]]){
                XSDBaseEntity *entity = [[propClass alloc] initWithDictionaryInfo:valueForKey];
                [self setValue:entity forKey: key];
            }
            else if ([propClass isSubclassOfClass:[XSDDate class]]){
                NSDate *date = [sXSDBaseEntityDateFormatter dateFromString:valueForKey];
                [self setValue:date forKey: key];
            }
            else if ([propClass isSubclassOfClass:[XSDDateTime class]]){
                NSDate *date = [sXSDBaseEntityDateTimeFormatter dateFromString:valueForKey];
                [self setValue:date forKey:key];
            }
            else if ([propClass isSubclassOfClass:[NSArray class]]){
                NSString *memberClassName = [[self class] classNameOfMembersForMappedField:key];
                Class memberClass = NSClassFromString(memberClassName);
                if ( [memberClass isSubclassOfClass:[XSDBaseEntity class]] ){
                    NSArray *array = [memberClass objectsWithDictionariesInfoArray:valueForKey];
                    [self setValue:array forKey:key];
                }
                else{
                    [self setValue:valueForKey forKey:key];
                }
            }
            else{
                [self setValue:valueForKey forKey:key];
            }
        }
    }
}

- (NSMutableDictionary*)dictionaryInfo
{
    return [self dictionaryInfoForKeys:[[self class] mappedKeys]];
}

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys:[[self class] mappedKeys]];
}

#pragma mark - Mapped Dict

- (void)setMappedFieldsDictionary:(NSDictionary *)dict
{
    for (NSString *key in [dict allKeys]) {
        id value = dict[key];
        NSArray *keyComponents = [key componentsSeparatedByString:@"."];
        if ( keyComponents.count > 1 ){
            XSDBaseEntity *subObject = [self valueForKey:keyComponents[0]];
            if ( !subObject ){
                objc_property_t property = class_getProperty([self class], [keyComponents[0] UTF8String]);
                const char *propertyAttributes = property_getAttributes(property);
                NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
                NSString *propertyTypeStr = attributes[0];
                NSString *className = [propertyTypeStr substringFromIndex:2]; // 2 is length of "T@""
                className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                Class propClass = NSClassFromString(className);
                subObject = [propClass new];
                [self setValue:subObject forKey:keyComponents[0]];
            }
            [subObject setValue:value forKey:keyComponents[1]];
        }
        else{
            [self setValue:value forKey:key];
        }
    }
}

#pragma mark - Setting/Get value for key

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
    return nil;
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
    return nil;
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath createIntermediateEntities:(BOOL)createIntermediateEntities
{
    NSArray *keyComponents = [keyPath componentsSeparatedByString:@"."];
    objc_property_t property = class_getProperty([self class], [keyComponents[0] UTF8String]);
    const char *propertyAttributes = property_getAttributes(property);
    NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
    NSString *propertyTypeStr = attributes[0];
    NSString *className = [propertyTypeStr substringFromIndex:2]; // 2 is length of "T@""
    BOOL isPrimitive = [propertyTypeStr characterAtIndex:1] != '@'; // is it class
    className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    Class propClass = NSClassFromString(className);
    
    if ( !createIntermediateEntities){
        if (isPrimitive && !value)
            [self setValue:@0 forKey:keyPath];
        else
            [self setValue:value forKeyPath:keyPath];
    }
    else{
        if ( keyComponents.count <= 1 ){
            if (isPrimitive && !value)
                [self setValue:@0 forKey:keyPath];
            else
                [self setValue:value forKeyPath:keyPath];
        }
        else{
            XSDBaseEntity *subObject = [self valueForKey:keyComponents[0]];
            
            if ( !subObject ){
                subObject = [propClass new];
            }
            NSString *newKeyPath = [[keyComponents subarrayWithRange:NSMakeRange(1, keyComponents.count - 1)] componentsJoinedByString:@"."];
            if ( [propClass isSubclassOfClass:[XSDBaseEntity class]] ){
                [subObject setValue:value forKeyPath:newKeyPath createIntermediateEntities:YES];
            }
            else{
                [subObject setValue:value forKeyPath:newKeyPath];
            }
        }
    }
}

- (void)setEntityForMappedFields:(XSDBaseEntity*)entity
{
    if ([self isKindOfClass:[entity class]])
        NSLog(@"%s Classes doesn't match", __PRETTY_FUNCTION__);
    
    for (NSString *fieldName in [[self class] mappedKeys]) {
        id value = [entity valueForKey:fieldName];
        [self setValue:value forKey:fieldName];
    }
}


@end
