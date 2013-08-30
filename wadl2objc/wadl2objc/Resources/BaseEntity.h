//
//  MWEntity.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PeriodScheduleViewControllerPeriod) {
    PeriodScheduleViewControllerPeriodWeek = 1,
    PeriodScheduleViewControllerPeriodMonth = 2,
};

#define kUndefined                                      @""
#define kPeriodScheduleViewControllerPeriodWeekString   @"lol"
#define kPeriodScheduleViewControllerPeriodMonthString  @"ok"

static unsigned const PeriodScheduleViewControllerPeriodStringsCount = 3;
static NSString *const PeriodScheduleViewControllerPeriodStrings[] = {kUndefined, kPeriodScheduleViewControllerPeriodWeekString, kPeriodScheduleViewControllerPeriodMonthString};

@interface BaseEntity : NSObject <NSCopying, NSCoding>

+ (void)setDateFormatter:(NSDateFormatter*)dateFormatter;
+ (NSMutableArray*)objectsWithDictionariesInfoArray:(NSArray*)array;

- (id)initWithDictionaryInfo:(NSDictionary*)dictionary;

- (NSMutableDictionary*)dictionaryInfoForKeys: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (void) setDictionaryInfo:(NSDictionary*)dictInfo forKeys: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setDictionaryInfo:(NSDictionary *)JSONDictionary;
- (NSMutableDictionary*)dictionaryInfo;

- (NSString *)entityNameForMappedField:(NSString*)fieldName;
- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName;

@end
