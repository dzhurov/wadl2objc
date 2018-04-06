//
//  WADLServerAPI.m
//  wadl2objc
//
//  Created by Sergey Konovorotskiy on 8/4/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "WADLServerAPI.h"
#import "WADLAbstractServerAPI.h"
#import "XSDBaseEntity.h"

@interface WADLServerAPI ()

@property (nonatomic, strong) NSMutableArray *reloginInvocations;

@end


@implementation WADLServerAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.errorHanlder = self;
    }
    return self;
}

#pragma mark - WADLServerAPIInheritor

- (WADLRequestTask)makeRequest:(WADLRequestMethod)method
                      resource:(WADLServicesResource*)resource
                    forURLPath:(NSString *)urlPath
               queryParameters:(NSDictionary*)queryParameters
                    bodyObject:(NSDictionary*)parameters
          HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                   outputClass:(Class)outputClass
                     isInvoked:(BOOL)isInvoked
                 responseBlock:(void (^)(id, NSError *))responseBlock
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlPath relativeToURL:[self baseURLForServicesResource:resource]];
    
    // Query Parameters
    
    if ( queryParameters.count ){
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSMutableArray *queryParametersItems = [NSMutableArray arrayWithCapacity:queryParameters.count];
        [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [queryParametersItems addObject: [NSURLQueryItem queryItemWithName:key value:obj]];
        }];
        urlComponents.queryItems = queryParametersItems;
        url = urlComponents.URL;
    }
    
    // Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = [self methodNameForMethod:method];
    [HTTPHeaderParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    // Body
    if (parameters){
        NSError *error = nil;
        request.HTTPBody = [self serializeObject:parameters error:&error];
        if (error){
            if (responseBlock)
                responseBlock(nil, error);
            return nil;
        }
    }
    
    // Token
    BOOL useToken = [self tokenRequiredForURLPath:urlPath];
    if (useToken){
        NSString *aToken = [self.tokenProvider token];
        if (aToken){
            [request setValue:[NSString stringWithFormat:@"Token token=%@", aToken] forHTTPHeaderField:@"Authorization"];
        }
        else{
            NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Token is nil"}];
            if (responseBlock)
                responseBlock(nil, error);
            return nil;
        }
    }
    
    // Invocation
    MakeRequestInvocation *invocation = nil;
    if (!isInvoked){
        invocation = [[MakeRequestInvocation alloc] initWithTarget:self
                                                     requestMethod:method
                                                           urlPath:urlPath
                                                        parameters:parameters
                                              HTTPHeaderParameters:HTTPHeaderParameters
                                                       outputClass:outputClass
                                                     responseBlock:responseBlock];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error){
            BOOL errorHandlerDealtWithIt = ![self.errorHanlder serverAPI:self
                                    shouldInvokeCompletionBlockWithError:error
                                                                 request:request
                                                                response:response
                                               repeatedRequestInvocation:invocation];
            if ( !errorHandlerDealtWithIt ){
                if (responseBlock)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        responseBlock(nil, error);
                    });
            }
        }
        else{
            if ( responseBlock ){
                id outputObject = [self deserializeData:data error:&error];
                if (error)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        responseBlock(nil, error);
                    });
                
                if ( outputClass && [outputClass isSubclassOfClass:[XSDBaseEntity class]] ){
                    outputObject = [[outputClass alloc] initWithDictionaryInfo:outputObject];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    responseBlock(outputObject, nil);
                });
            }
        }
    }];
    
    return dataTask;
}

#pragma mark - WADLServerAPIErrorHandler

- (BOOL)serverAPI:(WADLAbstractServerAPI *)serverAPI shouldInvokeCompletionBlockWithError:(NSError *)error
                                                                                  request:(NSURLRequest *)request
                                                                                 response:(NSURLResponse *)response
                                                                repeatedRequestInvocation:(MakeRequestInvocation *)invocation
{
    if (error.code == 401){ // Not Authorized
        [self addReloginInvocation:invocation error:error];
        return NO;
    }
    return YES;
}

- (void)addReloginInvocation:(MakeRequestInvocation *)invocation
                       error:(NSError*)error
{
    @synchronized (self.reloginInvocations){
        if (self.reloginInvocations.count == 0){
            [self.tokenProvider proceedLogin:^(void){
                 @synchronized (self.reloginInvocations) {
                     [self.reloginInvocations makeObjectsPerformSelector:@selector(invoke)];
                     [self.reloginInvocations removeAllObjects];
                 }
             }];
        }
        
        [self.reloginInvocations addObject:invocation];
    }
}

#pragma mark -

- (BOOL)tokenRequiredForURLPath:(NSString *)urlPath
{
    BOOL needToUseToken = YES;
    NSArray *loginMethodPossibleNames =  @[@"authenticate", @"login"];
    for (NSString *possibleLoginMethodName in loginMethodPossibleNames) {
        NSRange range = [urlPath rangeOfString:possibleLoginMethodName options:NSCaseInsensitiveSearch];
        if ( range.location != NSNotFound ){
            needToUseToken = NO;
            break;
        }
    }
    return needToUseToken;
}


@end
