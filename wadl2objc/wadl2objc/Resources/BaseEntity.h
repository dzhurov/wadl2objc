//
//  MWEntity.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSDTypes.h"
#import "XSDEnums.h" 

@interface BaseEntity : NSObject <NSCopying, NSCoding>

+ (void)setDateFormatter:(NSDateFormatter*)dateFormatter;
+ (void)setDateTimeFormatter:(NSDateFormatter*)dateTimeFormatter;
+ (NSMutableArray*)objectsWithDictionariesInfoArray:(NSArray*)array;
+ (NSArray *)mappedKeys;

- (id)initWithDictionaryInfo:(NSDictionary*)dictionary;

- (NSMutableDictionary*)dictionaryInfoForKeys:(NSArray*)keys;
- (void) setDictionaryInfo:(NSDictionary*)dictInfo forKeys:(NSArray*)keys;

- (void)setDictionaryInfo:(NSDictionary *)JSONDictionary;
- (NSMutableDictionary*)dictionaryInfo;

- (void)setMappedFieldsDictionary:(NSDictionary *)dict;

+ (NSString *)enumNameForMappedField:(NSString*)fieldName;
+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName;

- (void)setValue:(id)value forKeyPath:(NSString*)keyPath createIntermediateEntities:(BOOL)createIntermediateEntities;

@end


