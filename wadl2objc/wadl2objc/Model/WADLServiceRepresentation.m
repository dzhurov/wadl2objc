//
//  WADLServiceRepresentation.m
//  wadl2objc
//
//  Created by DZhurov on 6/15/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "WADLServiceRepresentation.h"
#import "Utilities.h"
#import "SettingsManager.h"
#import "XSDNamespase.h"
#import  "WADLService.h"
#import "WADLServiceSection.h"
#import "WADLDocument.h"

@implementation WADLServiceRepresentation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(WADLService*)service
{
    self = [super init];
    if (self) {
        self.service = service;
        [self setDictionary:dictionary];
    }
    return self;
}

+ (instancetype)serviceRepresentationWithDictionary:(NSDictionary*)dictionary service:(WADLService*)service
{
    WADLServiceRepresentation *rep = [WADLServiceRepresentation new];
    rep.service = service;
    if ([rep setDictionary:dictionary]){
        return rep;
    }
    return nil;
}

- (BOOL)setDictionary:(NSDictionary*)dictionary
{
    NSString *rootKey = @"request";
    NSDictionary *representationDict = dictionary[rootKey];
    if (! representationDict){
        rootKey = @"response";
        representationDict = dictionary[rootKey];
    }
    else{
        self.representationType = WADLServiceRepresentationRequest;
    }
    if ([representationDict isKindOfClass:[NSNull class]])
        return NO;
    
    representationDict = [representationDict objectForKeyIgnoringXMLPrefix:@"representation"];
    NSMutableDictionary *localNamespaces = [[representationDict objectsForKeysWithPrefix:@"_xmlns"] mutableCopy];
    if (representationDict[@"_xmlns"]){
        [localNamespaces setObject:representationDict[@"_xmlns"] forKey:@""];
    }
    
    
    self.xsdTypeWithNSPrefix = representationDict[@"_element"];
    NSString *elementPrefix;
    self.xsdType = [self.xsdTypeWithNSPrefix stringBySplittingXMLPrefix:&elementPrefix];
    if (!elementPrefix){
        elementPrefix = @"";
    }
    NSString *namespaceId = localNamespaces[elementPrefix];
    if ( !namespaceId ){
        namespaceId = self.globalNamespaces[elementPrefix];
    }
    self.namespaceId = namespaceId;
    XSDNamespase *namespace = [[SettingsManager sharedSettingsManager] namespaceForIdentifier:namespaceId];
    self.objcClassName = [namespace classNameForXSDType:self.xsdType];
    
    return YES;
}

- (NSDictionary *)globalNamespaces
{
    return [self.service.parentServiceSection.rootServiceSection.wadlDocument globalNamespaces];
}


@end
