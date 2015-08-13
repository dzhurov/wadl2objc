//
//  WADLAuthService.h
//  wadl2objc
//
//  Created by Dmitry on 6/14/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WADLAbstractServerAPI.h"
#import "WADLServicesResource.h"

@class XSDBaseEntity;
@interface WADLAuthService : WADLServicesResource

<methods_declaration>

- (WADLRequestTask)authUserAuthenticateUser:(XSDBaseEntity*)authUserDto responseBlock:(void(^)(XSDBaseEntity *response, NSError *error))responseBlock;

@end
