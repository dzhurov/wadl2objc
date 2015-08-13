//
//  WADLAuthService.m
//  wadl2objc
//
//  Created by Dmitry on 6/14/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "WADLAuthService.h"
#import "APIConsts.h"

@implementation WADLAuthService

- (WADLRequestTask)authUserAuthenticateUser:(XSDBaseEntity*)authUserDto responseBlock:(void(^)(XSDBaseEntity *response, NSError *error))responseBlock
{
    NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthUserURLPath];
    NSDictionary *queryParmeters = nil;
    NSDictionary *bodyObject = nil;
    NSDictionary *headParameters = nil;
    return [self.serverAPI makeRequest:WADLRequestMethodPOST resource:self forURLPath:thePath queryParameters:queryParmeters bodyObject:bodyObject HTTPHeaderParameters:headParameters outputClass:[AuthUserDto class] isInvoked:NO responseBlock:responseBlock];
}


@end
