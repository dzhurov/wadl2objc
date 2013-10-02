//
//  MWEntity.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntity : NSObject <NSCopying, NSCoding>

+ (void)setDateFormatter:(NSDateFormatter*)dateFormatter;
+ (NSMutableArray*)objectsWithDictionariesInfoArray:(NSArray*)array;
+ (NSArray *)mappedKeys;

- (id)initWithDictionaryInfo:(NSDictionary*)dictionary;

- (NSMutableDictionary*)dictionaryInfoForKeys:(NSArray*)keys;
- (void) setDictionaryInfo:(NSDictionary*)dictInfo forKeys:(NSArray*)keys;

- (void)setDictionaryInfo:(NSDictionary *)JSONDictionary;
- (NSMutableDictionary*)dictionaryInfo;

+ (NSString *)entityNameForMappedField:(NSString*)fieldName;
+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName;

@end
