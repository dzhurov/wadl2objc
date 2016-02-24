//
//  XSDBaseEntity.h
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSDTypes.h"
#import "XSDEnums.h" 

@interface XSDBaseEntity : NSObject <NSCopying, NSCoding>

/*! Date and DateTime formatters for serialization and deserialization */
+ (void)setDateFormatter:(NSDateFormatter*)dateFormatter;
+ (void)setDateTimeFormatter:(NSDateFormatter*)dateTimeFormatter;

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

- (void)setValue:(id)value forKeyPath:(NSString*)keyPath createIntermediateEntities:(BOOL)createIntermediateEntities;

- (void)propertiesEnumeration:(void(^)(NSString *propertyName, NSArray *attributes))iterationBlock;

/*! Sets all mappedKeys fields from entity to self */
- (void)setEntityForMappedFields:(XSDBaseEntity*)entity;

@end

