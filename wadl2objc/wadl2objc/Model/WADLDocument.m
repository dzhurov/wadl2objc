//
//  WADLDocument.m
//  wadl2objc
//
//  Created by Dmitry on 9/29/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLDocument.h"
#import "TBXML+NSDictionary.h"
#import "XMLDictionary.h"
#import "WADLServiceSection.h"

@implementation WADLDocument

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if ( self ){
        NSError *error = nil;
        NSDictionary *xmlDicti = [NSDictionary dictionaryWithXMLData:data];
        NSLog(@"\n\nWADL: \n%@",xmlDicti);
        
        
        NSDictionary *wadlDictionary = [TBXML dictionaryWithXMLData:data error: &error];
        NSLog(@"\n\nWADL: \n%@", wadlDictionary);
        [self setWADLDictionary:wadlDictionary];
    }
    return self;
}

- (void)setWADLDictionary:(NSDictionary *)dictionary
{
    NSArray *parantServiceSectionsDicts = [dictionary valueForKeyPath:@"resources.resource"];
    for (NSDictionary *sectionDict in parantServiceSectionsDicts) {
        WADLServiceSection *section = [[WADLServiceSection alloc] initWithDictionary:sectionDict];
    }
}

@end
