//  WADLAbstractServerAPI.m
//  wadl2objc
//

//! DO NOT MODIFY THIS CLASS !

#import "WADLAbstractServerAPI.h"
<import_services>

@implementation WADLAbstractServerAPI

#pragma mark - Lifecycle

+ (instancetype)sharedServerAPI
{
    static dispatch_once_t once;
    static WADLAbstractServerAPI *sharedInstance;
    dispatch_once(&once, ^{
        NSAssert(self conformsToProtocol:@protocol(WADLServerAPIInheritor)],
                 @"WADLAbstractServerAPI is an abstract class. It must be inherited for use. Inheritor must conform to protocol WADLAbstractServerAPI");
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Generated services

<services_getters>

#pragma mark - Serialization

- (id)deserializeData:(NSData*)data error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (NSData*)serializeObject:(id)object error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization dataWithJSONObject:object
                                        #ifdef DEBUG
                                           options:NSJSONWritingPrettyPrinted
                                        #else
                                           options:0
                                        #endif
                                             error:error];
}

#pragma mark -

- (NSURL *)baseURLForServicesResource:(WADLServicesResource *)resource
{
    return [NSURL URLWithString:@"<base_url>"];
}

- (NSString *)methodNameForMethod:(WADLRequestMethod)method
{
    switch (method) {
        case WADLRequestMethodGET:      return @"GET";
        case WADLRequestMethodPOST:     return @"POST";
        case WADLRequestMethodPUT:      return @"PUT";
        case WADLRequestMethodDELETE:   return @"DELETE";
        case WADLRequestMethodHEAD:     return @"HEAD";
        default:
            NSAssert(0, @"Method not supported: %ld", (long)method);
    }
    return nil;
}

- (WADLAbstractServerAPI<WADLServerAPIInheritor>*)child
{
    return (WADLAbstractServerAPI<WADLServerAPIInheritor>*)self;
}

@end


@implementation WADLMakeRequestInvocation

- (instancetype)initWithTarget:(WADLAbstractServerAPI*)target
                 requestMethod:(WADLRequestMethod)method
                      resource:(WADLServicesResource*)resource
                       urlPath:(NSString*)urlPath
               queryParameters:(NSDictionary*)queryParameters
                    bodyObject:(NSDictionary*)bodyObject
          HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                   outputClass:(Class)outputClass
                 responseBlock:(void (^)(id, NSError *))block
{
    self = [super init];
    if (self){
        static BOOL sIsInvoked = YES;
        _requestMethod = method;
        _resource = resource;
        _urlPath = urlPath;
        _queryParameters = queryParameters;
        _bodyObject = bodyObject;
        _HTTPHeaderParameters = HTTPHeaderParameters;
        _outputClass = outputClass;
        _responseBlock = block;
        
        SEL selector = @selector(makeRequest:resource:forURLPath:queryParameters:bodyObject:HTTPHeaderParameters:outputClass:isInvoked:responseBlock:);
        NSMethodSignature * signature = [target.class instanceMethodSignatureForSelector:selector];
        _invocation = [NSInvocation invocationWithMethodSignature:signature];
        [_invocation setTarget:target];
        [_invocation setSelector: selector];
        [_invocation setArgument:(void *)(&_requestMethod) atIndex:2];
        [_invocation setArgument:(void *)(&_resource) atIndex:3];
        [_invocation setArgument:(void *)(&_urlPath) atIndex:4];
        [_invocation setArgument:(void *)(&_queryParameters) atIndex:5];
        [_invocation setArgument:(void *)(&_bodyObject) atIndex:6];
        [_invocation setArgument:(void *)(&_HTTPHeaderParameters) atIndex:7];
        [_invocation setArgument:(void *)(&_outputClass) atIndex:8];
        [_invocation setArgument:(void *)(&sIsInvoked) atIndex:9];
        [_invocation setArgument:(void *)(&_responseBlock) atIndex:10];
    }
    return self;
}

- (void)invoke
{
    [_invocation invoke];
}

@end
