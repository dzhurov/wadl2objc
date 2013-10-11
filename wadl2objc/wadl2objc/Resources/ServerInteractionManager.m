
//
//  ServerInteractionManager.m
//  GroupManager
//
//  Created by Dmitry Zhurov on 14.09.12.
//  Copyright (c) 2012 The Mens Wearhouse. All rights reserved.
//

#import "ServerInteractionManager.h"
#include <execinfo.h>
#import "AFHTTPRequestOperationManager.h"

#ifndef DDLogError
#define DDLogError NSLog
#endif

#ifndef DDLogResponseOk
#define DDLogResponseOk NSLog
#endif



@interface JSONResponseSerializer : AFJSONResponseSerializer
@end

@implementation JSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DDLogResponseOk(@"<<<< %@\n\n%@",response.URL, responseString);
    return [super responseObjectForResponse:response data:data error:error];
}

@end


@interface ServerInteractionManager ()
{
    AFHTTPRequestOperationManager *_requestOperationManager;
    AFJSONRequestSerializer *_requestSerializer;
    JSONResponseSerializer *_responseSerializer;
}

- (void)parseResponseData: (NSData*)data forURLRequest: (NSURLRequest*)request callBlock:(ResponseBlock)responseBlock invocation:(NSInvocation*)invocation;
- (AFHTTPRequestOperation*)makeGETRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters responseBlock:(void (^)(id, NSError *))responseBlock;
- (AFHTTPRequestOperation*)makePOSTRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken HTTPBody: (NSData*)body responseBlock:(void (^)(id, NSError *))responseBlock;

@end

@implementation ServerInteractionManager


+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    static XMLDictionaryParser *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[ServerInteractionManager alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kServerURL]];
        _requestSerializer = [[AFJSONRequestSerializer alloc] init];
        _responseSerializer = [[JSONResponseSerializer alloc] init];
    }
    return self;
}

- (void)dealloc
{
    _requestOperationManager = nil;
    _requestSerializer = nil;
    _responseSerializer = nil;
}


#pragma mark - Private methods

- (void)handleResponse:(NSDictionary*)responseObject outputClass:(Class)outputClass forURLRequest:(NSURLRequest *)request callBlock:(ResponseBlock)responseBlock invocation:(NSInvocation*)invocation
{
    ///TODO: handle errors
    if ( responseBlock ){
        id outputObject = responseObject;
        if ( outputClass && [outputClass isSubclassOfClass:[BaseEntity class]]  ){
            outputObject = [[outputClass alloc] initWithDictionaryInfo:responseObject];
        }
        responseBlock(responseObject, nil);
    }
}

- (AFHTTPRequestOperation*)makeRequestWithMethod:(RequestMethod)method URLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters outputClass:(Class)outputClass responseBlock:(void (^)(id, NSError *))responseBlock
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
        DDLogError(@"<<<< RESPONSE: %@\n\nERROR: %@", operation.request.URL, error);
        if (responseBlock)
            responseBlock(nil, error);
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
    DDLogRequest(@">>>> %@", resultOperation.request.URL);
    return resultOperation;
}

- (AFHTTPRequestOperation*)makeGETRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters outputClass:(Class)outputClass responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:RequestMethodGET URLPath:urlPath useToken:useToken inputParameters:parameters outputClass:outputClass responseBlock:responseBlock];
}

- (AFHTTPRequestOperation*)makePOSTRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters outputClass:(Class)outputClass responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:RequestMethodPOST URLPath:urlPath useToken:useToken inputParameters:parameters outputClass:outputClass responseBlock:responseBlock];
}

- (AFHTTPRequestOperation*)makePUTRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters outputClass:(Class)outputClass responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:RequestMethodPUT URLPath:urlPath useToken:useToken inputParameters:parameters outputClass:outputClass responseBlock:responseBlock];
}

- (AFHTTPRequestOperation*)makeDELETERequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters outputClass:(Class)outputClass responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:RequestMethodDELETE URLPath:urlPath useToken:useToken inputParameters:parameters outputClass:outputClass responseBlock:responseBlock];
}

#pragma mark - Human Mehthods

#pragma mark - Generated Services

#pragma mark -

@end
