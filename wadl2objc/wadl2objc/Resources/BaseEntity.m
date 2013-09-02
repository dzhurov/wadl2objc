//
//  MWEntity.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "BaseEntity.h"
#import <objc/runtime.h>

__strong static NSDateFormatter const *dateFormatter = nil;

@implementation BaseEntity

#pragma mark - Static methods

+ (void)load
{
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
}

+ (void)setDateFormatter:(NSDateFormatter *)aDateFormatter
{
    dateFormatter = aDateFormatter;
}

+ (NSMutableArray *)objectsWithDictionariesInfoArray:(NSArray *)array
{
    if (array.count){
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dictionary in array) {
            BaseEntity *entity = [[self alloc] initWithDictionaryInfo:dictionary];
            [resultArray addObject:entity];
        }
        return resultArray;
    }
    return nil;
}

+ (NSArray*)mappedKays
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


- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@ %p>(", NSStringFromClass([self class]), self];
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
        if (strongReference)
            [description appendFormat:@"\n\t%@ = %@", propertyName, value];
        else
            [description appendFormat:@"\n\t%@ = <%@ %p>(",  propertyName,NSStringFromClass([value class]), value];
    }];
    
    [description appendFormat:@"\n)"];
    return description;
}

- (void) propertiesEnumeration: (void(^)(NSString *propertyName, NSArray *attributes))iterationBlock
{
    if (!iterationBlock){
        return;
    }
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
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



#pragma mark - NSCopyng

- (id)copyWithZone:(NSZone*)zone
{
	BaseEntity* copy = [[self class] new];
    return copy;
}

#pragma mark - Dictionary Info

- (NSMutableDictionary*)dictionaryInfoForKeys:(NSArray*)keys
{
    NSMutableDictionary *dictInfo = [NSMutableDictionary dictionary];
    for(NSString *key in keys){
        id valueForKey = [self valueForKey:key];
        objc_property_t property = class_getProperty([self class], [key UTF8String]);
        const char *propertyAttributes = property_getAttributes(property);
        NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
        NSString *propertyTypeStr = attributes[0];
        BOOL isPrimitive = [propertyTypeStr characterAtIndex:1] != '@'; // is it class
        if (isPrimitive){
            NSString *enumName = [BaseEntity entityNameForMappedField:key];
            NSUInteger enumValue = [(NSNumber*)valueForKey unsignedIntegerValue];
            id enumObj = [XSDEnums objectForEnumValue:enumValue enumName:enumName];
            valueForKey = enumObj;
        }
        else if ([valueForKey isKindOfClass:[BaseEntity class]]){
            valueForKey = [(BaseEntity*)valueForKey dictionaryInfo];
        }
        else if ([valueForKey isKindOfClass:[NSDate class]]){
            valueForKey = [dateFormatter stringFromDate:valueForKey];
        }
        else if ([valueForKey isKindOfClass:[NSArray class]]){
            NSString *memberClassName = [BaseEntity classNameOfMembersForMappedField:key];
            Class memberClass = NSClassFromString(memberClassName);
            if ( [memberClass isSubclassOfClass:[BaseEntity class]] ){
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
                NSString *enumName = [BaseEntity entityNameForMappedField:key];
                NSUInteger enumValue = [XSDEnums enumValueForObject:valueForKey enumName:enumName];
                [self setValue:@(enumValue) forKey:key];
            }
            if ([propClass isSubclassOfClass:[BaseEntity class]]){
                BaseEntity *entity = [[propClass alloc] initWithDictionaryInfo:valueForKey];
                [self setValue:entity forKey: key];
            }
            else if ([propClass isSubclassOfClass:[NSDate class]]){
                NSDate *date = [dateFormatter dateFromString:valueForKey];
                [self setValue:date forKey: key];
            }
            else if ([propClass isSubclassOfClass:[NSArray class]]){
                NSString *memberClassName = [BaseEntity classNameOfMembersForMappedField:key];
                Class memberClass = NSClassFromString(memberClassName);
                if ( [memberClass isSubclassOfClass:[BaseEntity class]] ){
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
    [self dictionaryInfoForKeys:[BaseEntity mappedKays]];
}

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys:[BaseEntity mappedKays]];
}

#pragma mark - Setting/Get value for key

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{
    return nil;
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
    return nil;
}

@end
