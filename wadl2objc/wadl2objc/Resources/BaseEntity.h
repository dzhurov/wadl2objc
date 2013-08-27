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

- (id)initWithDictionaryInfo:(NSDictionary*)dictionary;

- (NSMutableDictionary*)dictionaryInfoForKeys: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (void) setDictionaryInfo:(NSDictionary*)dictInfo forKeys: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setDictionaryInfo:(NSDictionary *)JSONDictionary;
- (NSMutableDictionary*)dictionaryInfo;

@end
