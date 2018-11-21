//
//
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSDTypes.h"
#import "XSDObjects/XSDEnums.h"

extern NSString const* kXSDClassTypeKey;

/**
 @class XSDBaseEntity
 
 Base class for any Data Trahsfer Object in wadl2objc generated code.
 - Inheritance schema:
 `XSDBaseEntity` -> <_MachineClass> -> <HumanClass>
 
 *MachineClass* contains all fields described in Client-Server Protocol [XSD](https://www.w3schools.com/xml/schema_intro.asp).
 MachineClass contains className with _Underscore_ prefix. It also has generated implementations for methods:
 * `-mappedKeys`
 * `-enumNameForMappedField:`
 * `-classNameOfMembersForMappedField:`
 
 - Example: for XSD described class `HeightDto` generator will create `_HeightDto` machine class with the same fields: \
 * heightInch
 - Important: Do not modify machine class manually. You will loose your changes after wadl2objc generates it again
 
 *HumanClass* can contain any additional fields and logic you may want to add to a class. Fill free to modify it.
 - Example: for XSD described class `HeightDto` generator will create `HeightDto` human class without any fields. \
 You may want to add conversion methods to this class, like:
 * `-heightFt`
 
 - SeeAlso:
 [wadl2objc](https://github.com/dzhurov/wadl2objc)
 */
@interface XSDBaseEntity : NSObject <NSCopying, NSCoding>

@property (nonatomic) BOOL isErrorDataReloading;

- (NSString *)xsdClassType;

-(NSArray<NSString*>*)descriptionIgnoreProperties;

/*! Date and DateTime formatters for serialization and deserialization */
+ (void)setDateFormatter:(NSDateFormatter*)dateFormatter;
+ (void)setDateTimeFormatter:(NSDateFormatter*)dateTimeFormatter;
+ (NSDateFormatter *)dateFormatter;
+ (NSDateFormatter *)dateTimeFormatter;

/*! Simple creation entities from array<NSDictionary> */
+ (NSMutableArray*)objectsWithDictionariesInfoArray:(NSArray*)array;

- (id)initWithDictionaryInfo:(NSDictionary*)dictionary;
- (NSMutableDictionary*)dictionaryInfoForKeys:(NSArray*)keys;
- (void) setDictionaryInfo:(NSDictionary*)dictInfo forKeys:(NSArray*)keys;
- (void)setDictionaryInfo:(NSDictionary *)JSONDictionary;
- (NSMutableDictionary*)dictionaryInfo;

- (void)setMappedFieldsDictionary:(NSDictionary *)dict;

/*! Reloads by Machine inheritors */
+ (NSArray *)mappedKeys;
+ (NSString *)enumNameForMappedField:(NSString*)fieldName;
+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName;

/**
 Works just like `-setValue:forKeyPath:` and also creates missing subentities
 */
- (void)setValue:(id)value forKeyPath:(NSString*)keyPath createIntermediateEntities:(BOOL)createIntermediateEntities;

- (void)propertiesEnumeration:(void(^)(NSString *propertyName, NSArray *attributes))iterationBlock;

/*! Sets all mappedKeys fields from entity to self */
- (void)setEntityForMappedFields:(XSDBaseEntity*)entity;

@end

