//
//  WADLServiceRepresentation.h
//  wadl2objc
//
//  Created by DZhurov on 6/15/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WADLService;

typedef enum : NSUInteger {
    WADLServiceRepresentationRequest,
    WADLServiceRepresentationResponse,
    
} WADLServiceRepresentationType;

@interface WADLServiceRepresentation : NSObject

@property (nonatomic, weak) WADLService *service;
@property (nonatomic) WADLServiceRepresentationType representationType;
@property (nonatomic, strong) NSString *objcClassName;
@property (nonatomic, strong) NSString *xsdTypeWithNameSapcePrefix;
@property (nonatomic, strong) NSString *xsdType;
@property (nonatomic, strong) NSString *namespaceId;

+ (instancetype)serviceRepresentationWithDictionary:(NSDictionary*)dictionary service:(WADLService*)service;


@end
