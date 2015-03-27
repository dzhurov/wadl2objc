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

#pragma mark DashboardReportsAdoption
- (NSOperation *)dashboardReportsAdoptionCommittedReservationsCommittedReservationsAdoption:(ReservationAdoptionRequestDto *)reservationAdoptionRequestDto responseBlock:(void(^)(ReservationAdoptionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsAdoptionCommittedReservationsURLPath];
	NSDictionary *inputParameters = [reservationAdoptionRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationAdoptionDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsAdoptionWeeklyCommittedReportXlsxWeeklyCommittedReportWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsAdoptionWeeklyCommittedReportXlsxURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsAdoptionWeeklyWeddingReportXlsxWeeklyWeddingReportWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsAdoptionWeeklyWeddingReportXlsxURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsAdoptionStatsExcelXlsStatsReportWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsAdoptionStatsExcelXlsURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsAdoptionSendWeeklyReportsSendWeeklyReports:(SendWeeklyReportsDto *)sendWeeklyReportsDto responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsAdoptionSendWeeklyReportsURLPath];
	NSDictionary *inputParameters = [sendWeeklyReportsDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsAdoptionCreatedReservationsCreatedReservationsAdoption:(ReservationAdoptionRequestDto *)reservationAdoptionRequestDto responseBlock:(void(^)(ReservationAdoptionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsAdoptionCreatedReservationsURLPath];
	NSDictionary *inputParameters = [reservationAdoptionRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationAdoptionDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsAdoptionWeddingGroupsWeddingGroupAdoption:(ReservationAdoptionRequestDto *)reservationAdoptionRequestDto responseBlock:(void(^)(ReservationAdoptionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsAdoptionWeddingGroupsURLPath];
	NSDictionary *inputParameters = [reservationAdoptionRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationAdoptionDto class] responseBlock:responseBlock];
}


#pragma mark DashboardQuery
- (NSOperation *)dashboardQueryUniverseDeviceFindDeviceStateWithDeviceId:(NSString *)deviceId responseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardQueryUniverseDeviceDeviceIdURLPath, deviceId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthStoreStateDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardQueryTuxoracleReservationFindTuxOracleReservationByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardQueryTuxoracleReservationReservationNoURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardQueryPosReservationFindPosReservationByNo:(DashboardQueryPosReservationDto *)dashboardQueryPosReservationDto responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardQueryPosReservationURLPath];
	NSDictionary *inputParameters = [dashboardQueryPosReservationDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark Transaction
- (NSOperation *)transactionEditMarkdownEditMarkdown:(MarkdownEditRequestDto *)markdownEditRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionEditMarkdownURLPath];
	NSDictionary *inputParameters = [markdownEditRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionAddTaxExemptionAddTaxExemption:(TaxExemptionRequestDto *)taxExemptionRequestDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionAddTaxExemptionURLPath];
	NSDictionary *inputParameters = [taxExemptionRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TransactionDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionFillLineItemsFillLineItems:(LineItemListDto *)lineItemListDto responseBlock:(void(^)(LineItemListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionFillLineItemsURLPath];
	NSDictionary *inputParameters = [lineItemListDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemListDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionRemoveMarkdownRemoveMarkdown:(MarkdownRequestDto *)markdownRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionRemoveMarkdownURLPath];
	NSDictionary *inputParameters = [markdownRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionCreateCreateTransaction:(TransactionCreationDto *)transactionCreationDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionCreateURLPath];
	NSDictionary *inputParameters = [transactionCreationDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TransactionDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionPostvoidVoidTransaction:(TransactionDto *)transactionDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionPostvoidURLPath];
	NSDictionary *inputParameters = [transactionDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TransactionDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionSetCustomerSaveCustomerInTransaction:(TransactionDto *)transactionDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionSetCustomerURLPath];
	NSDictionary *inputParameters = [transactionDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TransactionDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionAddFeeAddFee:(AddFeeRequestDto *)addFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionAddFeeURLPath];
	NSDictionary *inputParameters = [addFeeRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionPostTuxDropoffPostTuxDropoff:(TransactionDto *)transactionDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionPostTuxDropoffURLPath];
	NSDictionary *inputParameters = [transactionDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PostTuxDepositResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionApplyPfDiscountApplyPfDiscount:(ApplyPfDiscountRequestDto *)applyPfDiscountRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionApplyPfDiscountURLPath];
	NSDictionary *inputParameters = [applyPfDiscountRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionRemoveTaxExemptionRemoveTaxExemption:(TaxExemptionRequestDto *)taxExemptionRequestDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionRemoveTaxExemptionURLPath];
	NSDictionary *inputParameters = [taxExemptionRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TransactionDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionChangeItemsLostFeeChangeItemsLostFee:(ChangeItemsLostFeeRequestDto *)changeItemsLostFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionChangeItemsLostFeeURLPath];
	NSDictionary *inputParameters = [changeItemsLostFeeRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionAddMarkdownAddMarkdown:(MarkdownRequestDto *)markdownRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionAddMarkdownURLPath];
	NSDictionary *inputParameters = [markdownRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionApplyCouponApplyCoupon:(ApplyCouponRequestDto *)applyCouponRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionApplyCouponURLPath];
	NSDictionary *inputParameters = [applyCouponRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionChangeLateFeeChangeLateFee:(AddFeeRequestDto *)addFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionChangeLateFeeURLPath];
	NSDictionary *inputParameters = [addFeeRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionCurrentGetCurrentTransactionWithResponseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionCurrentURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TransactionDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionFillLineItemsDropoffFillLineItems:(DropoffLineItemsRequestDto *)dropoffLineItemsRequestDto responseBlock:(void(^)(LineItemListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionFillLineItemsDropoffURLPath];
	NSDictionary *inputParameters = [dropoffLineItemsRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[LineItemListDto class] responseBlock:responseBlock];
}

- (NSOperation *)transactionPostTuxDepositPostTuxDeposit:(TransactionDto *)transactionDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTransactionPostTuxDepositURLPath];
	NSDictionary *inputParameters = [transactionDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PostTuxDepositResponseDto class] responseBlock:responseBlock];
}


#pragma mark Receipts
- (NSOperation *)receiptsSendReceipt:(ReceiptRequestDto *)receiptRequestDto responseBlock:(void(^)(ReceiptResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReceiptsURLPath];
	NSDictionary *inputParameters = [receiptRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReceiptResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)receiptsMultiSendReceipt:(ReceiptRequestContainerDto *)receiptRequestContainerDto responseBlock:(void(^)(ReceiptResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReceiptsMultiURLPath];
	NSDictionary *inputParameters = [receiptRequestContainerDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReceiptResponseDto class] responseBlock:responseBlock];
}


#pragma mark DashboardReportsStores
- (NSOperation *)dashboardReportsStoresLaunchedStoresDeleteLaunchedStore:(StoreNoDto *)storeNoDto responseBlock:(void(^)(StoreListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsStoresLaunchedStoresURLPath];
	NSDictionary *inputParameters = [storeNoDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StoreListDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsStoresLaunchedStoresLaunchedStoresWithResponseBlock:(void(^)(StoreListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsStoresLaunchedStoresURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StoreListDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardReportsStoresLaunchedStoresCreateLaunchedStore:(StoreNoDto *)storeNoDto responseBlock:(void(^)(StoreListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardReportsStoresLaunchedStoresURLPath];
	NSDictionary *inputParameters = [storeNoDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StoreListDto class] responseBlock:responseBlock];
}


#pragma mark Customer
- (NSOperation *)customerValidateValidateCustomer:(CustomerDto *)customerDto responseBlock:(void(^)(CustomerValidationDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerValidateURLPath];
	NSDictionary *inputParameters = [customerDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CustomerValidationDto class] responseBlock:responseBlock];
}

- (NSOperation *)customerGetCustomerWithPartyId:(NSString *)partyId responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerPartyIdURLPath, partyId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation *)customerPfEnrollPfCustomer:(CustomerDto *)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerPfURLPath];
	NSDictionary *inputParameters = [customerDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation *)customerPfCreatePfCustomer:(CustomerCreateDto *)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerPfURLPath];
	NSDictionary *inputParameters = [customerCreateDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation *)customerUpdateCustomer:(CustomerDto *)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerURLPath];
	NSDictionary *inputParameters = [customerDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation *)customerCreateCustomer:(CustomerCreateDto *)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerURLPath];
	NSDictionary *inputParameters = [customerCreateDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CustomerDto class] responseBlock:responseBlock];
}

- (NSOperation *)customerSearchSearchCustomers:(CustomerSearchCriteriaDto *)customerSearchCriteriaDto responseBlock:(void(^)(CustomerSearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceCustomerSearchURLPath];
	NSDictionary *inputParameters = [customerSearchCriteriaDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CustomerSearchResultDto class] responseBlock:responseBlock];
}


#pragma mark Log
- (NSOperation *)logLogClient:(LogEntryDto *)logEntryDto responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceLogURLPath];
	NSDictionary *inputParameters = [logEntryDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark Rules
- (NSOperation *)rulesEventDatesCalculateEventDaysWithEventDate:(NSString *)eventDate responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceRulesEventDatesEventDateURLPath, eventDate];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[EventDatesDto class] responseBlock:responseBlock];
}

- (NSOperation *)rulesEventDatesCalculateEventDaysForEventTypeWithEventDate:(NSString *)eventDate eventType:(NSString *)eventType responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceRulesEventDatesEventDateEventTypeURLPath, eventDate, eventType];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[EventDatesDto class] responseBlock:responseBlock];
}


#pragma mark Pos
- (NSOperation *)posFreeTuxPickupPostFreeTuxPickup:(PostFreeTuxPickupRequestDto *)postFreeTuxPickupRequestDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosFreeTuxPickupURLPath];
	NSDictionary *inputParameters = [postFreeTuxPickupRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PostTuxDepositResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)posReservationMaxRefundMaxRefundAmount:(MaxRefundRequestDto *)maxRefundRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(MaxRefundListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosReservationReservationNoMaxRefundURLPath, reservationNo];
	NSDictionary *inputParameters = [maxRefundRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[MaxRefundListDto class] responseBlock:responseBlock];
}

- (NSOperation *)posReservationPosSummaryFindPosSummaryByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPosSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosReservationReservationNoPosSummaryURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationPosSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation *)posReservationPosDetailsFindPosDetailsByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPickupDetailsDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosReservationReservationNoPosDetailsURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationPickupDetailsDto class] responseBlock:responseBlock];
}

- (NSOperation *)posReservationPaymentsReservationPaymentsBatch:(ReservationNumbersDto *)reservationNumbersDto responseBlock:(void(^)(ReservationPaymentsListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosReservationPaymentsURLPath];
	NSDictionary *inputParameters = [reservationNumbersDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationPaymentsListDto class] responseBlock:responseBlock];
}

- (NSOperation *)posVersionVersionWithResponseBlock:(void(^)(PosVersionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosVersionURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PosVersionDto class] responseBlock:responseBlock];
}

- (NSOperation *)posGiftCardValidateGiftCardValidate:(GiftCardValidateDto *)giftCardValidateDto responseBlock:(void(^)(GiftCardValidateResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosGiftCardValidateURLPath];
	NSDictionary *inputParameters = [giftCardValidateDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GiftCardValidateResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)posReservationReservationPaymentsReservationPaymentsWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPaymentsDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosReservationReservationNoReservationPaymentsURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationPaymentsDto class] responseBlock:responseBlock];
}

- (NSOperation *)posTxPostPickupPostPickup:(PostPickupRequestDto *)postPickupRequestDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosTxPostPickupURLPath];
	NSDictionary *inputParameters = [postPickupRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PostTuxDepositResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)posReservationPosGarmentsFindPosGarmentsByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPosGarmentsDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosReservationReservationNoPosGarmentsURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationPosGarmentsDto class] responseBlock:responseBlock];
}

- (NSOperation *)posMaxRefundMaxRefundAmountBatch:(MaxRefundRequestListDto *)maxRefundRequestListDto responseBlock:(void(^)(MaxRefundListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServicePosMaxRefundURLPath];
	NSDictionary *inputParameters = [maxRefundRequestListDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[MaxRefundListDto class] responseBlock:responseBlock];
}


#pragma mark DashboardDiagnostic
- (NSOperation *)dashboardDiagnosticFingerprintsPrintFingerPrintsWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticFingerprintsURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticEmployeeAnonimousDiagnosticEmployeeServiceAnonimousWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticEmployeeAnonimousURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticGiftcardDiagnosticGiftCardWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticGiftcardURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticReservationDiagnosticReservationServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticReservationURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticVersionDiagnosticGetVersionWithResponseBlock:(void(^)(PosVersionDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticVersionURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PosVersionDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticCustomerDiagnosticCustomerServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticCustomerURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticTuxoracleDiagnosticTuxOracleWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticTuxoracleURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticTxwadminDiagnosticTxwAdminWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticTxwadminURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticGetcustomerDiagnosticGetCustomerWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticGetcustomerURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticEmployeeDiagnosticEmployeeServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticEmployeeURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticGetregisterstateDiagnosticGetRegisterStateWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticGetregisterstateURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticPrinterPrinterServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticPrinterURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticGetErrorGetErrorDtoWithResponseBlock:(void(^)(ErrorDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticGetErrorURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ErrorDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardDiagnosticTuxmobDiagnosticTuxMobWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardDiagnosticTuxmobURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark Search
- (NSOperation *)searchReservationsSearchReservations:(SearchCriteriaDto *)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceSearchReservationsURLPath];
	NSDictionary *inputParameters = [searchCriteriaDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SearchResultDto class] responseBlock:responseBlock];
}

- (NSOperation *)searchGroupsSearchGroups:(SearchCriteriaDto *)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceSearchGroupsURLPath];
	NSDictionary *inputParameters = [searchCriteriaDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SearchResultDto class] responseBlock:responseBlock];
}

- (NSOperation *)searchEventsSearchEvents:(SearchCriteriaDto *)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceSearchEventsURLPath];
	NSDictionary *inputParameters = [searchCriteriaDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SearchResultDto class] responseBlock:responseBlock];
}


#pragma mark Inventory
- (NSOperation *)inventoryCatalogFindCatalogWithCatalogNo:(NSString *)catalogNo measurementsReservationNo:(NSString *)measurementsReservationNo responseBlock:(void(^)(CatalogItemListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryCatalogCatalogNoMeasurementsReservationNoURLPath, catalogNo, measurementsReservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CatalogItemListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryCatalogsSearchAllWithResponseBlock:(void(^)(CatalogListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryCatalogsURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CatalogListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryStoresSearchAllStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StoresDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryStoresReturnSearchReturnStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresReturnURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StoresDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryStoresFindByStoreNoWithStoreNo:(NSString *)storeNo responseBlock:(void(^)(StoreDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresStoreNoURLPath, storeNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StoreDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryStoresPickupSearchPickupStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStoresPickupURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StoresDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryPrintersFindPrintersForStoreWithStoreNo:(NSString *)storeNo responseBlock:(void(^)(PrintersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryPrintersStoreNoURLPath, storeNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PrintersDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryPrintersFindAllPrintersWithResponseBlock:(void(^)(PrintersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryPrintersURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[PrintersDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventorySchoolsSearchAllWithIfModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsURLPath];
	NSDictionary *inputParameters = nil;
	NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:2];
	[headParameters setValue:ifModifiedSince forKey:@"If-Modified-Since"];
	[headParameters setValue:range forKey:@"Range"];
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SchoolListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventorySchoolsSearchByCriteria:(SchoolDto *)schoolDto ifModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsURLPath];
	NSDictionary *inputParameters = [schoolDto dictionaryInfo];
	NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:2];
	[headParameters setValue:ifModifiedSince forKey:@"If-Modified-Since"];
	[headParameters setValue:range forKey:@"Range"];
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SchoolListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventorySchoolsSearchByStateWithSchoolSt:(NSString *)schoolSt ifModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsSchoolStURLPath, schoolSt];
	NSDictionary *inputParameters = nil;
	NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:2];
	[headParameters setValue:ifModifiedSince forKey:@"If-Modified-Since"];
	[headParameters setValue:range forKey:@"Range"];
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SchoolListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventorySchoolsFindBySchoolNoWithSchoolNo:(NSNumber *)schoolNo responseBlock:(void(^)(SchoolDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsSchoolNoURLPath, schoolNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SchoolDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventorySchoolsSearchByStateAndCityWithSchoolSt:(NSString *)schoolSt schoolCity:(NSString *)schoolCity ifModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySchoolsSchoolStSchoolCityURLPath, schoolSt, schoolCity];
	NSDictionary *inputParameters = nil;
	NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:2];
	[headParameters setValue:ifModifiedSince forKey:@"If-Modified-Since"];
	[headParameters setValue:range forKey:@"Range"];
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SchoolListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryStylesFindByStyleNumberWithStyleNo:(NSString *)styleNo responseBlock:(void(^)(StyleInformationDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStylesStyleNoURLPath, styleNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StyleInformationDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryStylesSearchByFilterWithType:(NSString *)type store:(NSString *)store responseBlock:(void(^)(StyleInformationListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryStylesURLPath];
	NSMutableDictionary *inputParameters = [NSMutableDictionary dictionaryWithCapacity:2];
	[inputParameters setValue:type forKey:@"type"];
	[inputParameters setValue:store forKey:@"store"];
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[StyleInformationListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventorySizesFilterSizesWithStyle:(NSString *)style store:(NSString *)store eventDate:(NSString *)eventDate eventType:(NSString *)eventType group:(NSNumber *)group responseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventorySizesURLPath];
	NSMutableDictionary *inputParameters = [NSMutableDictionary dictionaryWithCapacity:5];
	[inputParameters setValue:style forKey:@"style"];
	[inputParameters setValue:store forKey:@"store"];
	[inputParameters setValue:eventDate forKey:@"eventDate"];
	[inputParameters setValue:eventType forKey:@"eventType"];
	[inputParameters setValue:group forKey:@"group"];
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SizeListDto class] responseBlock:responseBlock];
}

- (NSOperation *)inventoryDiscountFindDiscountInfoWithCode:(NSString *)code eventType:(NSString *)eventType responseBlock:(void(^)(DiscountInfoDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceInventoryDiscountURLPath];
	NSMutableDictionary *inputParameters = [NSMutableDictionary dictionaryWithCapacity:2];
	[inputParameters setValue:code forKey:@"code"];
	[inputParameters setValue:eventType forKey:@"eventType"];
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[DiscountInfoDto class] responseBlock:responseBlock];
}


#pragma mark Reservation
- (NSOperation *)reservationStylesFindReservationStyleWithReservationNo:(NSString *)reservationNo lineNo:(NSNumber *)lineNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesLineNoURLPath, reservationNo, lineNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationStylesUpdateStyle:(ReservationStyleDto *)reservationStyleDto reservationNo:(NSString *)reservationNo lineNo:(NSNumber *)lineNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesLineNoURLPath, reservationNo, lineNo];
	NSDictionary *inputParameters = [reservationStyleDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationStylesRemoveStyleWithReservationNo:(NSString *)reservationNo lineNo:(NSNumber *)lineNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesLineNoURLPath, reservationNo, lineNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationAssignStylesToAssignStylesTo:(AssignStylesRequest *)assignStylesRequest responseBlock:(void(^)(CopyStylesResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationAssignStylesToURLPath];
	NSDictionary *inputParameters = [assignStylesRequest dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CopyStylesResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationStylesFindReservationStylesWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationStylesCreateStyle:(ReservationStyleDto *)reservationStyleDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoStylesURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationStyleDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationCopyStylesToCopyStylesTo:(ReservationNumbersDto *)reservationNumbersDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(CopyStylesResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoCopyStylesToURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationNumbersDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[CopyStylesResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationSizesFindReservationSizes:(StyleInformationDto *)styleInformationDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoSizesURLPath, reservationNo];
	NSDictionary *inputParameters = [styleInformationDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SizeListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationSizeReservationSizeAvailability:(SizeAvailabilityRequestDto *)sizeAvailabilityRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(SizeDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoSizeURLPath, reservationNo];
	NSDictionary *inputParameters = [sizeAvailabilityRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[SizeDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationValidateChangeValidate:(ChangeRequestDto *)changeRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReorderValidationResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoValidateChangeURLPath, reservationNo];
	NSDictionary *inputParameters = [changeRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReorderValidationResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationChangeLogisticsChangeLogistics:(ChangeLogisticsRequestDto *)changeLogisticsRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoChangeLogisticsURLPath, reservationNo];
	NSDictionary *inputParameters = [changeLogisticsRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)reservationChangeChange:(ChangeRequestDto *)changeRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoChangeURLPath, reservationNo];
	NSDictionary *inputParameters = [changeRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)reservationReorderStatusReorderStatusWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReorderStatusResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoReorderStatusURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReorderStatusResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationHatpackageRemoveHatPackageWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoHatpackageURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationHatpackageAddHatPackageWithReservationNo:(NSString *)reservationNo catalogCode:(NSString *)catalogCode responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoHatpackageCatalogCodeURLPath, reservationNo, catalogCode];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationHatpackageUpdateHatPackageWithReservationNo:(NSString *)reservationNo catalogCode:(NSString *)catalogCode responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoHatpackageCatalogCodeURLPath, reservationNo, catalogCode];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationStyleListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationLogisticUpdateLogistic:(ReservationLogisticDto *)reservationLogisticDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoLogisticURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationLogisticDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationLogisticFindLogisticByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoLogisticURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationSummaryFindSummaryByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoSummaryURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationSummaryUpdateSummary:(ReservationSummaryDto *)reservationSummaryDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoSummaryURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationSummaryDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationOffersDiscountAssignReservationDiscount:(ReservationOffersDto *)reservationOffersDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoOffersDiscountURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationOffersDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationOffersDiscountDeleteReservationDiscountWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoOffersDiscountURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationMeasurementUpdateMeasurement:(ReservationMeasurementDto *)reservationMeasurementDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoMeasurementURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationMeasurementDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationMeasurementDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationMeasurementFindMeasurementByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoMeasurementURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationMeasurementDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationFavoritesFindFavoritesByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationFavoritesListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoFavoritesURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationFavoritesListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationRemoveReservationWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)reservationCreateReservation:(ReservationCreationDto *)reservationCreationDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationURLPath];
	NSDictionary *inputParameters = [reservationCreationDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationCommitCommitReservation:(ReservationCommitDto *)reservationCommitDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoCommitURLPath, reservationNo];
	NSDictionary *inputParameters = [reservationCommitDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)reservationValidateIsValidForCommitWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationValidationDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoValidateURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationValidationDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationPosSummaryFindPosSummaryByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPosSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoPosSummaryURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationPosSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationReferencesFindReferencesByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationReferenceListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoReferencesURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationReferenceListDto class] responseBlock:responseBlock];
}

- (NSOperation *)reservationOffersFindOffersByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceReservationReservationNoOffersURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationOffersDto class] responseBlock:responseBlock];
}


#pragma mark Tender
- (NSOperation *)tenderCaptureSignatureCaptureSignature:(TenderSignatureDto *)tenderSignatureDto responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTenderCaptureSignatureURLPath];
	NSDictionary *inputParameters = [tenderSignatureDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)tenderAuthorizeAuthorize:(TendersAuthorizeRequestDto *)tendersAuthorizeRequestDto responseBlock:(void(^)(TendersAuthorizeRequestDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTenderAuthorizeURLPath];
	NSDictionary *inputParameters = [tendersAuthorizeRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TendersAuthorizeRequestDto class] responseBlock:responseBlock];
}

- (NSOperation *)tenderLookupLookup:(TenderDto *)tenderDto responseBlock:(void(^)(TenderDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTenderLookupURLPath];
	NSDictionary *inputParameters = [tenderDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[TenderDto class] responseBlock:responseBlock];
}


#pragma mark DashboardRawDiscounts
- (NSOperation *)dashboardRawDiscountsDescriptionDiscountDescriptionsWithCode:(NSString *)code responseBlock:(void(^)(DiscountDescriptionRawDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardRawDiscountsCodeDescriptionURLPath, code];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[DiscountDescriptionRawDto class] responseBlock:responseBlock];
}

- (NSOperation *)dashboardRawDiscountsFindDiscountsWithCode:(NSString *)code responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceDashboardRawDiscountsCodeURLPath, code];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark Testing
- (NSOperation *)testingReservationPreparedForShipFreeTuxWithNegativeBalanceCreateForShipFreeTuxWithNegativeBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipFreeTuxWithNegativeBalanceShipToStoreURLPath, shipToStore];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipWithPositiveBalanceCreateForShipWithPositiveBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipWithPositiveBalanceURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipWithZeroBalanceCreateForShipWithZeroBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipWithZeroBalanceShipToStoreURLPath, shipToStore];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingPosFindTransactionWithTransactionNumber:(NSString *)transactionNumber responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingPosTransactionNumberURLPath, transactionNumber];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipWithNegativeBalanceCreateForShipWithNegativeBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipWithNegativeBalanceShipToStoreURLPath, shipToStore];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipFreeTuxWithNegativeBalanceCreateForShipFreeTuxWithNegativeBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipFreeTuxWithNegativeBalanceURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedNotPayedCreateNotPayedReservationWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedNotPayedURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipFreeTuxWithZeroBalanceCreateForShipFreeTuxWithZeroBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipFreeTuxWithZeroBalanceURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationShipChangeStatusToShipWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationReservationNoShipURLPath, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipWithZeroBalanceCreateForShipWithZeroBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipWithZeroBalanceURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipWithNegativeBalanceCreateForShipWithNegativeBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipWithNegativeBalanceURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipFreeTuxWithZeroBalanceCreateForShipFreeTuxWithZeroBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipFreeTuxWithZeroBalanceShipToStoreURLPath, shipToStore];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)testingReservationPreparedForShipWithPositiveBalanceCreateForShipWithPositiveBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceTestingReservationPreparedForShipWithPositiveBalanceShipToStoreURLPath, shipToStore];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark Groups
- (NSOperation *)groupsReservationsGetReservationsWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupReservationsDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdReservationsURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupReservationsDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersFreeSuitDeleteFreeSuitWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersFreeSuitReservationNoURLPath, groupId, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersFreeSuitAssignFreeSuitWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersFreeSuitReservationNoURLPath, groupId, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsCallLogCallLog:(GroupCallLogDto *)groupCallLogDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupCallLogListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdCallLogURLPath, groupId];
	NSDictionary *inputParameters = [groupCallLogDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupCallLogListDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsWeddingCallListWeddingCallList:(WeddingGroupCallRequestDto *)weddingGroupCallRequestDto responseBlock:(void(^)(WeddingGroupCallListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsWeddingCallListURLPath];
	NSDictionary *inputParameters = [weddingGroupCallRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[WeddingGroupCallListDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsBridalShowCallsUpdateBridalShowCall:(BridalShowCallDto *)bridalShowCallDto groupId:(NSNumber *)groupId responseBlock:(void(^)(BridalShowCallDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsBridalShowCallsGroupIdURLPath, groupId];
	NSDictionary *inputParameters = [bridalShowCallDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[BridalShowCallDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersDiscountAssignDiscount:(GroupOffersDto *)groupOffersDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersDiscountURLPath, groupId];
	NSDictionary *inputParameters = [groupOffersDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersDiscountDeleteDiscountWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersDiscountURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsCallLogsGetGroupCallLogsWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupCallLogListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdCallLogsURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupCallLogListDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsWeddingCallAddWeddingCall:(WeddingGroupCallDto *)weddingGroupCallDto groupId:(NSNumber *)groupId responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdWeddingCallURLPath, groupId];
	NSDictionary *inputParameters = [weddingGroupCallDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersFreeTuxDeleteFreeTuxWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersFreeTuxReservationNoURLPath, groupId, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersFreeTuxAssignFreeTuxWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersFreeTuxReservationNoURLPath, groupId, reservationNo];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersPromoCodeDeletePromoCodeWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersPromoCodeURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersPromoCodeAssignPromoCode:(GroupOffersDto *)groupOffersDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersPromoCodeURLPath, groupId];
	NSDictionary *inputParameters = [groupOffersDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsAddReservationsAddReservationList:(AddReservationsRequestDto *)addReservationsRequestDto groupId:(NSNumber *)groupId responseBlock:(void(^)(AddReservationsResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdAddReservationsURLPath, groupId];
	NSDictionary *inputParameters = [addReservationsRequestDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AddReservationsResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsGetGroupWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsSummaryGetSummaryGroupWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdSummaryURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsSummaryUpdateSummary:(GroupSummaryDto *)groupSummaryDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdSummaryURLPath, groupId];
	NSDictionary *inputParameters = [groupSummaryDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupSummaryDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsOffersGetOffersWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdOffersURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupOffersDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsLogisticUpdateLogistic:(GroupLogisticDto *)groupLogisticDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdLogisticURLPath, groupId];
	NSDictionary *inputParameters = [groupLogisticDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePUTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsLogisticGetLogisticsWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdLogisticURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupLogisticDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsCreateGroup:(GroupCreationDto *)groupCreationDto responseBlock:(void(^)(GroupDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsURLPath];
	NSDictionary *inputParameters = [groupCreationDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[GroupDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsBridalShowCallsFindBridalShowCallList:(PageDto *)pageDto responseBlock:(void(^)(BridalShowCallListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsBridalShowCallsURLPath];
	NSDictionary *inputParameters = [pageDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[BridalShowCallListDto class] responseBlock:responseBlock];
}

- (NSOperation *)groupsFavoritesFindFavoritesByGroupIdWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(ReservationFavoritesListDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceGroupsGroupIdFavoritesURLPath, groupId];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[ReservationFavoritesListDto class] responseBlock:responseBlock];
}


#pragma mark Auth
- (NSOperation *)authStoreCloseRegisterSessionWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthStoreURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)authStoreGetRegisterSessionWithResponseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthStoreURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthStoreStateDto class] responseBlock:responseBlock];
}

- (NSOperation *)authStoreOpenRegisterSession:(AuthStoreDto *)authStoreDto responseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthStoreURLPath];
	NSDictionary *inputParameters = [authStoreDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthStoreStateDto class] responseBlock:responseBlock];
}

- (NSOperation *)authUserSignOutCurrentUserWithDate:(NSString *)date responseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthUserURLPath];
	NSDictionary *inputParameters = nil;
	NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:1];
	[headParameters setValue:date forKey:@"Date"];
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}

- (NSOperation *)authUserGetCurrentUserWithDate:(NSString *)date responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthUserURLPath];
	NSDictionary *inputParameters = nil;
	NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:1];
	[headParameters setValue:date forKey:@"Date"];
	return [self makeGETRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthUserDto class] responseBlock:responseBlock];
}

- (NSOperation *)authUserAuthenticateUser:(AuthUserDto *)authUserDto date:(NSString *)date responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthUserURLPath];
	NSDictionary *inputParameters = [authUserDto dictionaryInfo];
	NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:1];
	[headParameters setValue:date forKey:@"Date"];
	return [self makePOSTRequestForURLPath:thePath useToken:NO inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthUserDto class] responseBlock:responseBlock];
}

- (NSOperation *)authManagerPermissionManagerOverrideRemovePermissionWithUserPermission:(NSString *)userPermission responseBlock:(void(^)(AuthManagerResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthManagerPermissionUserPermissionURLPath, userPermission];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthManagerResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)authManagerManagerOverrideRemoveRoleWithResponseBlock:(void(^)(AuthManagerResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthManagerURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthManagerResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)authManagerManagerOverrideAddRole:(AuthManagerDto *)authManagerDto responseBlock:(void(^)(AuthManagerResponseDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthManagerURLPath];
	NSDictionary *inputParameters = [authManagerDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthManagerResponseDto class] responseBlock:responseBlock];
}

- (NSOperation *)authDashboardAuthenticateDashboardUser:(AuthUserDto *)authUserDto responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthDashboardURLPath];
	NSDictionary *inputParameters = [authUserDto dictionaryInfo];
	NSDictionary *headParameters = nil;
	return [self makePOSTRequestForURLPath:thePath useToken:NO inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:[AuthUserDto class] responseBlock:responseBlock];
}

- (NSOperation *)authDashboardSignOutDashboardCurrentUserWithResponseBlock:(void(^)(id response, NSError *error))responseBlock
{
	NSString *thePath = [NSString stringWithFormat: kWADLServiceAuthDashboardURLPath];
	NSDictionary *inputParameters = nil;
	NSDictionary *headParameters = nil;
	return [self makeDELETERequestForURLPath:thePath useToken:YES inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:Nil responseBlock:responseBlock];
}


#pragma mark -

@end
