//
//  WADLDocument.m
//  wadl2objc
//
//  Created by Dmitry on 9/29/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLDocument.h"
#import "TBXML+NSDictionary.h"

@implementation WADLDocument

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if ( self ){
        NSError *error = nil;
        NSDictionary *wadlDictionary = [TBXML dictionaryWithXMLData:data error: &error];
        NSLog(@"\n\nXSD: \n%@", wadlDictionary);
        [self setWADLDictionary:wadlDictionary];
    }
    return self;
}

- (void)setWADLDictionary:(NSDictionary *)dictionary
{
    
}

@end
