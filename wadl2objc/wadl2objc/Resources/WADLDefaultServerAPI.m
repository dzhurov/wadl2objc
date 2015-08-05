//
//  WADLDefaultServerAPI.m
//  wadl2objc
//
//  Created by Sergey Konovorotskiy on 8/4/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "WADLDefaultServerAPI.h"

@implementation WADLDefaultServerAPI

- (WADLRequestTask)makeRequestWithMethod:(WADLRequestMethod)method
                                resource:(WADLServicesResource*)resource
                                 URLPath:(NSString *)urlPath
                                useToken:(BOOL)useToken
                         inputParameters:(NSDictionary*)parameters
                    HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                             outputClass:(Class)outputClass
                               isInvoked:(BOOL)isInvoked
                           responseBlock:(void (^)(id, NSError *))responseBlock
{
    // This part of code takes a name of funcion/method where was called current method.
    // If this method has been called from another method of ServerInteracionManager, NSInvocation (see part B) will be created.
    // Otherwhise if thos methos has been invoked (caller sctring contains "__invoking___"), variable isInvoked will be YES.
    // It means that this method has been called after token error and synchronous login.
    BOOL isInvoked = NO;
    void *addr[2];
    int nframes = backtrace(addr, sizeof(addr)/sizeof(*addr));
    if (nframes > 1) {
        char **syms = backtrace_symbols(addr, nframes); // equal to [[NSThread  callStackSymbols] objectAtIndex:1]
        NSString *caller = [NSString stringWithUTF8String:syms[1]];
        static NSString *invokeMarker = @"__invoking___";
        isInvoked = [caller rangeOfString:invokeMarker].location != NSNotFound;
        
        free(syms);
    }
    else {
        DDLogError(@"%s: *** Failed to generate backtrace.", __func__);
        return nil;
    }
    
    //token
    if (useToken){
        NSString *aToken;
        NSError *anError = nil;
        aToken = [_accountManager token: &anError];
        if (anError){
            responseBlock(nil, anError);
            return nil;
        }
        [_requestSerializer setAuthorizationHeaderFieldWithToken:aToken];
    }
    
    AFHTTPRequestOperation *resultOperation = nil;
    void(^successBlock)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // Part B
        NSInvocation * invocation = nil;
        if (useToken && !isInvoked){
            NSMethodSignature * signature = [ServerInteractionManager instanceMethodSignatureForSelector:_cmd];
            invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector: _cmd];
            [invocation setArgument:(void *)(&method) atIndex:2];
            [invocation setArgument:(void *)(&urlPath) atIndex:3];
            [invocation setArgument:(void *)(&useToken) atIndex:4];
            [invocation setArgument:(void *)(&parameters) atIndex:5];
            [invocation setArgument:(void *)(&outputClass) atIndex:6];
            [invocation setArgument:(void *)(&responseBlock) atIndex:7];
        }
        [self handleResponse:responseObject outputClass:outputClass forURLRequest:operation.request callBlock:responseBlock invocation:invocation];
    };
    void(^failureBlock)(AFHTTPRequestOperation*, NSError*) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInvocation * invocation = nil;
        if (useToken && !isInvoked){
            NSMethodSignature * signature = [ServerInteractionManager instanceMethodSignatureForSelector:_cmd];
            invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector: _cmd];
            [invocation setArgument:(void *)(&method) atIndex:2];
            [invocation setArgument:(void *)(&urlPath) atIndex:3];
            [invocation setArgument:(void *)(&useToken) atIndex:4];
            [invocation setArgument:(void *)(&parameters) atIndex:5];
            [invocation setArgument:(void *)(&outputClass) atIndex:6];
            [invocation setArgument:(void *)(&responseBlock) atIndex:7];
        }
        [self handleError:error forRequestOperation:operation callBlock:responseBlock invocation:invocation];
    };
    
    switch (method) {
        case RequestMethodGET:
            resultOperation = [_requestOperationManager GET:urlPath parameters:parameters success:successBlock failure:failureBlock];
            break;
        case RequestMethodPOST:
            resultOperation = [_requestOperationManager POST:urlPath parameters:parameters success:successBlock failure:failureBlock];
            break;
        case RequestMethodPUT:
            resultOperation = [_requestOperationManager PUT:urlPath parameters:parameters success:successBlock failure:failureBlock];
            break;
        case RequestMethodDELETE:
            resultOperation = [_requestOperationManager DELETE:urlPath parameters:parameters success:successBlock failure:failureBlock];
            break;
        default:
            DDLogError(@"Undefined request method");
            break;
    }
    return resultOperation;

}

@end
