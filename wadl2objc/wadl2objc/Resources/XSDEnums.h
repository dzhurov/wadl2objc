//
//  XSDEnums.h
//  wadl2objc
//
//  Created by DZhurov on 8/29/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XSDEnums : NSObject

+ (NSUInteger)enumValueForObject:(id)object enumName:(NSString*)enumName;
+ (id)objectForEnumValue:(NSUInteger)enumValue enumName:(NSString*)enumName;

@end
