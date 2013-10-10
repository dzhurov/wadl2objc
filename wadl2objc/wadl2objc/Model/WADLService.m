//
//  WADLService.m
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLService.h"

@implementation WADLService

- (id)initWithDictionary:(NSDictionary*)dictionary parantSection:(WADLServiceSection*)parantSection
{
    self = [super init];
    if (self){
        self.parantServiceSection = parantSection;
        [self setDictionary:dictionary];
    }
    return self;
}


- (void)setDictionary:(NSDictionary*)dictionary
{
    self.name = dictionary[@"_id"];
    self.method = dictionary[@"_name"];
    NSString *responseElement = [dictionary valueForKeyPath:@"response.ns2:representation._element"];
    self.responseObjectClass = responseElement;
    NSString *requestElement = [dictionary valueForKeyPath:@"request.ns2:representation._element"];
    self.requestObjectClass = requestElement;
}

@end
