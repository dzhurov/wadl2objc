//
//  WADLAuthService.m
//  wadl2objc
//
//  Created by Dmitry on 6/14/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "WADLAuthService.h"

@implementation WADLAuthService

- (WADLRequestTask)authUserAuthenticateUser:(XSDBaseEntity*)authUserDto responseBlock:(void(^)(XSDBaseEntity *response, NSError *error))responseBlock
{
    
}

- (WADLRequestTask)authStoreGetRegisterSessionWithResponseBlock:(void(^)(XSDBaseEntity *response, NSError *error))responseBlock
{
    
}

- (WADLRequestTask)authStoreOpenRegisterSession:(XSDBaseEntity*)authStoreDto responseBlock:(void(^)(id *response, NSError *error))responseBlock
{
    
}

- (WADLRequestTask)authStoreCloseRegisterSessionWithResponseBlock:(void(^)(XSDBaseEntity *response, NSError *error))responseBlock
{
    
}

- (NSOperation*)authUserAuthenticateUser:(AuthUserDto*)authUserDto responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock
{
    NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthUserURLPath];
    NSDictionary *inputParameters = [authUserDto dictionaryInfo];
    return [self makePOSTRequestForURLPath:thePath useToken:NO inputParameters:inputParameters outputClass:[AuthUserDto class] responseBlock:responseBlock];
}

- (NSOperation*)authStoreGetRegisterSessionWithResponseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock
{
    NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthStoreURLPath];
    NSDictionary *inputParameters = nil;
    return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[AuthStoreStateDto class] responseBlock:responseBlock];
}

- (NSOperation*)authStoreOpenRegisterSession:(AuthStoreDto*)authStoreDto responseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock
{
    NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthStoreURLPath];
    NSDictionary *inputParameters = [authStoreDto dictionaryInfo];
    return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[AuthStoreStateDto class] responseBlock:responseBlock];
}

- (NSOperation*)authStoreCloseRegisterSessionWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
    NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthStoreURLPath];
    NSDictionary *inputParameters = nil;
    return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}

@end
