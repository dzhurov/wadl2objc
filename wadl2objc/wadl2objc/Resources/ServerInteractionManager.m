
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


@interface JSONRequestSerializer : AFJSONRequestSerializer @end
@implementation JSONRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(NSDictionary *)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *resultRequest = (NSMutableURLRequest*)[super requestBySerializingRequest:request withParameters:parameters error:error];
    resultRequest.timeoutInterval = kRequestTimeoutInterval;
#ifdef DEBUG
    NSDictionary *headerFields = [resultRequest allHTTPHeaderFields];
    NSMutableString *log = [NSMutableString stringWithFormat:@">>>> %@\nmethod: %@\nheader: %@", resultRequest.URL, resultRequest.HTTPMethod, headerFields];
    if (resultRequest.HTTPBody){
        NSString *body = [[NSString alloc] initWithData:resultRequest.HTTPBody encoding:NSUTF8StringEncoding];
        [log appendFormat:@"body:\n%@", body];
    }
    DDLogRequest(@"%@",log);
#endif
    return resultRequest;
}

- (void)setAuthorizationHeaderFieldWithToken:(NSString *)token
{
    [self setValue:[NSString stringWithFormat:@"Token token=%@", token] forHTTPHeaderField:@"Authorization"];
}

@end


@interface JSONResponseSerializer : AFJSONResponseSerializer @end
@implementation JSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSURLResponse *resultResponse = [super responseObjectForResponse:response data:data error:error];
    if ( *error ){
        NSError *jsonParseError = nil;
        DDLogResponseError(@"<<<< %@\n\n%@",response.URL, responseString);
        NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonParseError];
        if ( jsonParseError ){
            return resultResponse;
        }
        NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionaryWithDictionary:errorDict];
        [errorUserInfo setObject:errorDict[@"errorDescription"] forKey:NSLocalizedDescriptionKey];
        NSInteger code = [errorDict[@"code"] integerValue];
        *error = [NSError errorWithDomain:@"JSONResponseSerializer" code:code userInfo:errorUserInfo];
    }
    else{
        DDLogResponseOk(@"<<<< %@\n\n%@",response.URL, responseString);
    }
    return resultResponse;
}

@end


@interface ServerInteractionManager ()
{
    AFHTTPRequestOperationManager *_requestOperationManager;
    JSONRequestSerializer *_requestSerializer;
    JSONResponseSerializer *_responseSerializer;
}

@end

@implementation ServerInteractionManager


+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    static ServerInteractionManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[ServerInteractionManager alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupRequestOperationManager];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    _requestOperationManager = nil;
    _requestSerializer = nil;
    _responseSerializer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self setupRequestOperationManager];
}

- (void)setupRequestOperationManager
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *host = [defaults objectForKey:kServerHostKey];
    NSString *port = [defaults objectForKey:kServerPortKey];
    NSString *servicesPath = [defaults objectForKey:kServerServicesPathKey];
    NSMutableString *serverUrlString = [NSMutableString stringWithFormat:@"%@:%@/%@", host, port, servicesPath];
    
    if (![[serverUrlString substringFromIndex:(serverUrlString.length - 1)] isEqualToString:@"/"])
    {
        [serverUrlString appendString:@"/"];
    }
    
    NSURL *serverUrl = [NSURL URLWithString:serverUrlString];
    
    if (!_requestOperationManager || ![serverUrl isEqual:_requestOperationManager.baseURL])
    {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:serverUrl];
        _requestSerializer = [JSONRequestSerializer new];
        _responseSerializer = [JSONResponseSerializer new];
        _requestOperationManager.requestSerializer = _requestSerializer;
        _requestOperationManager.responseSerializer = _responseSerializer;
    }
}

#pragma mark - Private methods

- (void)handleResponse:(NSDictionary*)responseObject outputClass:(Class)outputClass forURLRequest:(NSURLRequest *)request callBlock:(ResponseBlock)responseBlock invocation:(NSInvocation*)invocation
{
    ///TODO: handle errors
    if ( responseBlock ){
        id outputObject = responseObject;
        if ( outputClass && [outputClass isSubclassOfClass:[XSDBaseEntity class]]  ){
            outputObject = [[outputClass alloc] initWithDictionaryInfo:responseObject];
        }
        responseBlock(outputObject, nil);
    }
}



- (void)handleError:(NSError*)error forRequestOperation:(AFHTTPRequestOperation *)operation callBlock:(ResponseBlock)responseBlock invocation:(NSInvocation*)invocation
{
    //TODO: handle error
    if (error.code == 401){ // not autorized
        NSString *absoluteString = operation.request.URL.absoluteString;
        
        NSString *urlPath = [NSString stringWithFormat:@"%@/%@",
                                    [absoluteString stringByDeletingLastPathComponent].lastPathComponent,
                                    absoluteString.lastPathComponent];
        
        if (![urlPath isEqualToString:kWADLServiceAuthUserURLPath])
        {
            DDLogResponseError(@"<<<< %@\n",operation.response.URL);
            [self.accountManager proceedLogin:^(NSError *loginError, BOOL isCacneled)
            {
                if (responseBlock)
                {
                    if ( loginError )
                    {
                        responseBlock(nil, loginError);
                    }
                    else if ( !isCacneled )
                    {
                        [invocation invoke];
                    }
                    else
                    {
                        responseBlock(nil, error);
                    }
                }
            }];
        }
        else
        {
            DDLogError(@"<<<< RESPONSE: %@\n\nERROR: %@", operation.request.URL, error);
            if (responseBlock){
                responseBlock(nil, error);
            }
        }
    }
    else{
        DDLogError(@"<<<< RESPONSE: %@\n\nERROR: %@", operation.request.URL, error);
        if (responseBlock){
            responseBlock(nil, error);
        }
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

- (AFHTTPRequestOperation*)makeGETRequestForURLPath: (NSString *)urlPath
                                           useToken: (BOOL)useToken
                                    inputParameters: (NSDictionary*)parameters
                                        outputClass:(Class)outputClass
                                      responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:RequestMethodGET URLPath:urlPath useToken:useToken inputParameters:parameters outputClass:outputClass responseBlock:responseBlock];
}

- (AFHTTPRequestOperation*)makePOSTRequestForURLPath: (NSString *)urlPath
                                            useToken: (BOOL)useToken
                                     inputParameters: (NSDictionary*)parameters
                                         outputClass:(Class)outputClass
                                       responseBlock:(void (^)(id, NSError *))responseBlock
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

#pragma mark Search
- (NSOperation*)searchEventsSearchEvents:(SearchCriteriaDto*)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceSearchEventsURLPath];
	NSDictionary *inputParameters = [searchCriteriaDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SearchResultDto class] responseBlock:responseBlock];
}

- (NSOperation*)searchReservationsSearchReservations:(SearchCriteriaDto*)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceSearchReservationsURLPath];
	NSDictionary *inputParameters = [searchCriteriaDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SearchResultDto class] responseBlock:responseBlock];
}

- (NSOperation*)searchGroupsSearchGroups:(SearchCriteriaDto*)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceSearchGroupsURLPath];
	NSDictionary *inputParameters = [searchCriteriaDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SearchResultDto class] responseBlock:responseBlock];
}


#pragma mark Transaction
- (NSOperation*)transactionAddMarkdownAddMarkdown:(MarkdownRequestDto*)markdownRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionAddMarkdownURLPath];
	NSDictionary *inputParameters = [markdownRequestDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation*)transactionAddFeeAddFee:(AddFeeRequestDto*)addFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionAddFeeURLPath];
	NSDictionary *inputParameters = [addFeeRequestDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation*)transactionFillLineItemsFillLineItems:(LineItemListDto*)lineItemListDto responseBlock:(void(^)(LineItemListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionFillLineItemsURLPath];
	NSDictionary *inputParameters = [lineItemListDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[LineItemListDto class] responseBlock:responseBlock];
}

- (NSOperation*)transactionPostvoidVoidTransaction:(TransactionDto*)transactionDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionPostvoidURLPath];
	NSDictionary *inputParameters = [transactionDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[TransactionDto class] responseBlock:responseBlock];
}

- (NSOperation*)transactionPostTuxDepositPostTuxDeposit:(TransactionDto*)transactionDto responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionPostTuxDepositURLPath];
	NSDictionary *inputParameters = [transactionDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation*)transactionApplyPfDiscountApplyPfDiscount:(ApplyCouponRequestDto*)applyCouponRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionApplyPfDiscountURLPath];
	NSDictionary *inputParameters = [applyCouponRequestDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation*)transactionApplyCouponApplyCoupon:(ApplyCouponRequestDto*)applyCouponRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionApplyCouponURLPath];
	NSDictionary *inputParameters = [applyCouponRequestDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}


#pragma mark Inventory
- (NSOperation*)inventorySchoolsSchoolStSearchByStateWithSchoolSt:(NSString*)schoolSt responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsSchoolStURLPath, schoolSt];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SchoolListDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventorySchoolsSearchAllWithResponseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsURLPath];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SchoolListDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventorySchoolsSchoolNoFindBySchoolNoWithSchoolNo:(NSNumber*)schoolNo responseBlock:(void(^)(SchoolDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsSchoolNoURLPath, schoolNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SchoolDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventorySchoolsSchoolStSchoolCitySearchByStateAndCityWithSchoolSt:(NSString*)schoolSt schoolCity:(NSString*)schoolCity responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsSchoolStSchoolCityURLPath, schoolSt, schoolCity];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SchoolListDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventoryStoresPickupSearchPickupStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresPickupURLPath];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[StoresDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventoryStoresSearchAllStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresURLPath];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[StoresDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventoryStoresReturnSearchReturnStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresReturnURLPath];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[StoresDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventoryStoresStoreNoFindByStoreNoWithStoreNo:(NSString*)storeNo responseBlock:(void(^)(StoreDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresStoreNoURLPath, storeNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[StoreDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventorySizesFilterSizesWithResponseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySizesURLPath];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SizeListDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventoryStylesStyleNoFindByStyleNumberWithStyleNo:(NSString*)styleNo responseBlock:(void(^)(StyleInformationDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStylesStyleNoURLPath, styleNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[StyleInformationDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventoryStylesSearchByFilterWithResponseBlock:(void(^)(StyleInformationListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStylesURLPath];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[StyleInformationListDto class] responseBlock:responseBlock];
}

- (NSOperation*)inventoryPrintersStoreNoFindPrintersForStoreWithStoreNo:(NSString*)storeNo responseBlock:(void(^)(PrintersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryPrintersStoreNoURLPath, storeNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[PrintersDto class] responseBlock:responseBlock];
}


#pragma mark Receipts
- (NSOperation*)receiptsSendReceiptWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReceiptsURLPath];
	NSDictionary *inputParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark Reservation
- (NSOperation*)reservationReservationNoSummaryFindSummaryByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoSummaryURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoSummaryUpdateSummary:(ReservationSummaryDto*)reservationSummaryDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoSummaryURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationSummaryDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoValidateIsValidForCommitWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationValidationDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoValidateURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationValidationDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoLogisticFindLogisticByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoLogisticURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoLogisticUpdateLogistic:(ReservationLogisticDto*)reservationLogisticDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoLogisticURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationLogisticDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationCreateReservation:(ReservationCreationDto*)reservationCreationDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationURLPath];
	NSDictionary *inputParameters = [reservationCreationDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoRemoveReservationWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoOffersFindOffersByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoOffersURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationOffersDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoOffersUpdateOffers:(ReservationOffersDto*)reservationOffersDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoOffersURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationOffersDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationOffersDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoCommitCommitReservation:(ReservationCommitDto*)reservationCommitDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoCommitURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationCommitDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoMeasurementFindMeasurementByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoMeasurementURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationMeasurementDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoMeasurementUpdateMeasurement:(ReservationMeasurementDto*)reservationMeasurementDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoMeasurementURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationMeasurementDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationMeasurementDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoStylesLineNoUpdateStyle:(ReservationStyleDto*)reservationStyleDto reservationNo:(NSString*)reservationNo lineNo:(NSNumber*)lineNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesLineNoURLPath, reservationNo, lineNo];
	NSDictionary *inputParameters = [reservationStyleDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationStyleDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoStylesLineNoRemoveStyleWithReservationNo:(NSString*)reservationNo lineNo:(NSNumber*)lineNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesLineNoURLPath, reservationNo, lineNo];
	NSDictionary *inputParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoStylesLineNoFindReservationStyleWithReservationNo:(NSString*)reservationNo lineNo:(NSNumber*)lineNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesLineNoURLPath, reservationNo, lineNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationStyleDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoStylesFindReservationStylesWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoStylesCreateStyle:(ReservationStyleDto*)reservationStyleDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationStyleDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationStyleDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoSizesStyleFindReservationSizesWithReservationNo:(NSString*)reservationNo style:(NSString*)style responseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoSizesStyleURLPath, reservationNo, style];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[SizeListDto class] responseBlock:responseBlock];
}

- (NSOperation*)reservationReservationNoCopyStylesToCopyStylesTo:(ReservationNumbersDto*)reservationNumbersDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoCopyStylesToURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationNumbersDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark Tender
- (NSOperation*)tenderAuthorizeAuthorize:(TendersAuthorizeRequestDto*)tendersAuthorizeRequestDto responseBlock:(void(^)(TendersAuthorizeRequestDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTenderAuthorizeURLPath];
	NSDictionary *inputParameters = [tendersAuthorizeRequestDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[TendersAuthorizeRequestDto class] responseBlock:responseBlock];
}

- (NSOperation*)tenderLookupLookup:(TenderDto*)tenderDto responseBlock:(void(^)(TenderDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTenderLookupURLPath];
	NSDictionary *inputParameters = [tenderDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[TenderDto class] responseBlock:responseBlock];
}


#pragma mark Customer
- (NSOperation*)customerUpdateCustomer:(CustomerDto*)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerURLPath];
	NSDictionary *inputParameters = [customerDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation*)customerCreateCustomer:(CustomerCreateDto*)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerURLPath];
	NSDictionary *inputParameters = [customerCreateDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation*)customerSearchSearchCustomers:(CustomerSearchCriteriaDto*)customerSearchCriteriaDto responseBlock:(void(^)(CustomerSearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerSearchURLPath];
	NSDictionary *inputParameters = [customerSearchCriteriaDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[CustomerSearchResultDto class] responseBlock:responseBlock];
}

- (NSOperation*)customerPartyIdGetCustomerWithPartyId:(NSString*)partyId responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerPartyIdURLPath, partyId];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation*)customerPfCreatePfCustomer:(CustomerCreateDto*)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerPfURLPath];
	NSDictionary *inputParameters = [customerCreateDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation*)customerPfEnrollPfCustomer:(CustomerDto*)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerPfURLPath];
	NSDictionary *inputParameters = [customerDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}


#pragma mark Groups
- (NSOperation*)groupsGroupIdReservationsGetReservationsWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupReservationsDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdReservationsURLPath, groupId];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupReservationsDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdReservationsAddReservation:(ReservationCreationDto*)reservationCreationDto groupId:(NSNumber*)groupId responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdReservationsURLPath, groupId];
	NSDictionary *inputParameters = [reservationCreationDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[ReservationSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdLogisticGetLogisticsWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdLogisticURLPath, groupId];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdLogisticUpdateLogistic:(GroupLogisticDto*)groupLogisticDto groupId:(NSNumber*)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdLogisticURLPath, groupId];
	NSDictionary *inputParameters = [groupLogisticDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdReservationsReservationNoRemoveReservationWithGroupId:(NSNumber*)groupId reservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdReservationsReservationNoURLPath, groupId, reservationNo];
	NSDictionary *inputParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdSummaryGetSummaryGroupWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdSummaryURLPath, groupId];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdSummaryUpdateSummary:(GroupSummaryDto*)groupSummaryDto groupId:(NSNumber*)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdSummaryURLPath, groupId];
	NSDictionary *inputParameters = [groupSummaryDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdOffersGetOffersWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersURLPath, groupId];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdOffersUpdateOffers:(GroupOffersDto*)groupOffersDto groupId:(NSNumber*)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersURLPath, groupId];
	NSDictionary *inputParameters = [groupOffersDto dictionaryInfo];
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsCreateGroup:(GroupCreationDto*)groupCreationDto responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsURLPath];
	NSDictionary *inputParameters = [groupCreationDto dictionaryInfo];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation*)groupsGroupIdGetGroupWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdURLPath, groupId];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[GroupDto class] responseBlock:responseBlock];
}


#pragma mark Rules
- (NSOperation*)rulesEventDatesEventDateEventTypeCalculateEventDaysForEventTypeWithEventDate:(NSString*)eventDate eventType:(NSString*)eventType responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceRulesEventDatesEventDateEventTypeURLPath, eventDate, eventType];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[EventDatesDto class] responseBlock:responseBlock];
}

- (NSOperation*)rulesEventDatesEventDateCalculateEventDaysWithEventDate:(NSString*)eventDate responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceRulesEventDatesEventDateURLPath, eventDate];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:[EventDatesDto class] responseBlock:responseBlock];
}


#pragma mark Auth
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


#pragma mark ApplicationWadl
- (NSOperation*)applicationWadlGetWadlWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceApplicationWadlURLPath];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation*)applicationWadlPathGeExternalGrammarWithPath:(NSString*)path responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceApplicationWadlPathURLPath, path];
	NSDictionary *inputParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark -

-(NSOperation *)userLogoutResponseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self fakeRequestWithResponseBlock:^(NSDictionary *response, NSError *error) {
        if (responseBlock) {
            responseBlock(response, error);
        }
    }];
}

- (NSOperation*)fakeRequestWithResponseBlock:(void(^)(NSDictionary *response, NSError *error))responseBlock;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    int randomE = arc4random()%7+50;
    int randomDotE = arc4random()%1000;
    
    int randomS = arc4random()%7+50;
    int randomDotS = arc4random()%1000;
    
    NSString* urlString = [NSString stringWithFormat:@"http://geocode-maps.yandex.ru/1.x/?geocode=E%d.%d,S%d.%d&format=json", randomE, randomDotE, randomS, randomDotS];
    
    return [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)   {
        if (responseBlock) {
            responseBlock([NSDictionary dictionary], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (responseBlock) {
            responseBlock(nil, error);
        }
    }];
}

@end
