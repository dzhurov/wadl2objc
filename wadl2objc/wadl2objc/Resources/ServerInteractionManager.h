//
//  ServerInteractionManager.h
//  GroupManager
//
//  Created by Dmitry Zhurov on 14.09.12.
//  Copyright (c) 2012 The Mens Wearhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWAccountManager.h"
#import "CWLSynthesizeSingleton.h"
#import "APIConsts.h"
#import "SchoolDto.h"
#import "AuthUserDto.h"
#import "ReservationLogisticDto.h"
#import "ReservationMeasurementDto.h"
#import "ReservationSummaryDto.h"
#import "ReservationOffersDto.h"
#import "ReservationStyleDto.h"
#import "EventDatesDto.h"
#import "AuthStoreDto.h"
#import "ReservationCreationDto.h"
#import "StyleInformationDto.h"
#import "AbstractDateTime.h"
#import "AbstractInstant.h"
#import "BaseDateTime.h"
#import "DateTime.h"
#import "StyleSizeDto.h"
#import "StoreDto.h"
#import "StoresDto.h"
#import "LocalDate.h"
#import "BaseLocal.h"
#import "GroupRepresentativeDto.h"
#import "GroupSummaryDto.h"
#import "AbstractPartial.h"
#import "SearchResultDto.h"
#import "OrderDto.h"
#import "GroupLogisticDto.h"
#import "SearchCriteriaDto.h"
#import "GroupCreationDto.h"
#import "GroupOffersDto.h"
#import "AuthStoreStateDto.h"
#import "GroupReservationsDto.h"
#import "ReservationDto.h"
#import "SchoolListDto.h"
#import "StyleInformationListDto.h"
#import "ReservationStyleListDto.h"
#import "CustomerDto.h"
#import "CustomerSearchResultDto.h"
#import "GroupDto.h"
#import "CustomerCreateDto.h"
#import "SignatureDto.h"
#import "PointDto.h"
#import "CustomerSearchCriteriaDto.h"
#import "PrintersDto.h"
#import "PrinterDto.h"
#import "TendersAuthorizeRequestDto.h"
#import "AuthResponseDto.h"
#import "LineItemListDto.h"
#import "LineItemDto.h"
#import "TenderDto.h"
#import "TransactionDto.h"
#import "ReservationSignatureDto.h"
#import "LineItemModifierDto.h"
#import "ReservationCommitDto.h"
#import "SizeListDto.h"
#import "ReservationNumbersDto.h"
#import "SizeDto.h"
#import "PromDetailDto.h"
#import "AddFeeRequestDto.h"
#import "FeeDto.h"
#import "ApplyCouponRequestDto.h"
#import "MarkdownRequestDto.h"
#import "MarkdownDto.h"
#import "ReservationValidationDto.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};

typedef void(^ResponseBlock)(id responseObject, NSError *error);

#define kRequestTimeoutInterval     (NSTimeInterval)(10.f)  //sec

@interface ServerInteractionManager : NSObject

@property (nonatomic, weak) id <MWAccountManager> accountManager;

+ (instancetype)sharedManager;

// Here starts generated services methods. Don't touch it!
#pragma mark - Generated Services

// Search

- (NSOperation*)searchEventsSearchEvents:(SearchCriteriaDto*)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock;
- (NSOperation*)searchReservationsSearchReservations:(SearchCriteriaDto*)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock;
- (NSOperation*)searchGroupsSearchGroups:(SearchCriteriaDto*)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock;

// Transaction

- (NSOperation*)transactionAddMarkdownAddMarkdown:(MarkdownRequestDto*)markdownRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation*)transactionAddFeeAddFee:(AddFeeRequestDto*)addFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation*)transactionFillLineItemsFillLineItems:(LineItemListDto*)lineItemListDto responseBlock:(void(^)(LineItemListDto *response, NSError *error))responseBlock;
- (NSOperation*)transactionPostvoidVoidTransaction:(TransactionDto*)transactionDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock;
- (NSOperation*)transactionPostTuxDepositPostTuxDeposit:(TransactionDto*)transactionDto responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)transactionApplyPfDiscountApplyPfDiscount:(ApplyCouponRequestDto*)applyCouponRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation*)transactionApplyCouponApplyCoupon:(ApplyCouponRequestDto*)applyCouponRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;

// Inventory

- (NSOperation*)inventorySchoolsSchoolStSearchByStateWithSchoolSt:(NSString*)schoolSt responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock;
- (NSOperation*)inventorySchoolsSearchAllWithResponseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock;
- (NSOperation*)inventorySchoolsSchoolNoFindBySchoolNoWithSchoolNo:(NSNumber*)schoolNo responseBlock:(void(^)(SchoolDto *response, NSError *error))responseBlock;
- (NSOperation*)inventorySchoolsSchoolStSchoolCitySearchByStateAndCityWithSchoolSt:(NSString*)schoolSt schoolCity:(NSString*)schoolCity responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock;
- (NSOperation*)inventoryStoresPickupSearchPickupStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock;
- (NSOperation*)inventoryStoresSearchAllStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock;
- (NSOperation*)inventoryStoresReturnSearchReturnStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock;
- (NSOperation*)inventoryStoresStoreNoFindByStoreNoWithStoreNo:(NSString*)storeNo responseBlock:(void(^)(StoreDto *response, NSError *error))responseBlock;
- (NSOperation*)inventorySizesFilterSizesWithResponseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock;
- (NSOperation*)inventoryStylesStyleNoFindByStyleNumberWithStyleNo:(NSString*)styleNo responseBlock:(void(^)(StyleInformationDto *response, NSError *error))responseBlock;
- (NSOperation*)inventoryStylesSearchByFilterWithResponseBlock:(void(^)(StyleInformationListDto *response, NSError *error))responseBlock;
- (NSOperation*)inventoryPrintersStoreNoFindPrintersForStoreWithStoreNo:(NSString*)storeNo responseBlock:(void(^)(PrintersDto *response, NSError *error))responseBlock;

// Receipts

- (NSOperation*)receiptsSendReceiptWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;

// Reservation

- (NSOperation*)reservationReservationNoSummaryFindSummaryByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoSummaryUpdateSummary:(ReservationSummaryDto*)reservationSummaryDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoValidateIsValidForCommitWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationValidationDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoLogisticFindLogisticByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoLogisticUpdateLogistic:(ReservationLogisticDto*)reservationLogisticDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationCreateReservation:(ReservationCreationDto*)reservationCreationDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoRemoveReservationWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoOffersFindOffersByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoOffersUpdateOffers:(ReservationOffersDto*)reservationOffersDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoCommitCommitReservation:(ReservationCommitDto*)reservationCommitDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoMeasurementFindMeasurementByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoMeasurementUpdateMeasurement:(ReservationMeasurementDto*)reservationMeasurementDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoStylesLineNoUpdateStyle:(ReservationStyleDto*)reservationStyleDto reservationNo:(NSString*)reservationNo lineNo:(NSNumber*)lineNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoStylesLineNoRemoveStyleWithReservationNo:(NSString*)reservationNo lineNo:(NSNumber*)lineNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoStylesLineNoFindReservationStyleWithReservationNo:(NSString*)reservationNo lineNo:(NSNumber*)lineNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoStylesFindReservationStylesWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoStylesCreateStyle:(ReservationStyleDto*)reservationStyleDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoSizesStyleFindReservationSizesWithReservationNo:(NSString*)reservationNo style:(NSString*)style responseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoCopyStylesToCopyStylesTo:(ReservationNumbersDto*)reservationNumbersDto reservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;

// Tender

- (NSOperation*)tenderAuthorizeAuthorize:(TendersAuthorizeRequestDto*)tendersAuthorizeRequestDto responseBlock:(void(^)(TendersAuthorizeRequestDto *response, NSError *error))responseBlock;
- (NSOperation*)tenderLookupLookup:(TenderDto*)tenderDto responseBlock:(void(^)(TenderDto *response, NSError *error))responseBlock;

// Customer

- (NSOperation*)customerUpdateCustomer:(CustomerDto*)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation*)customerCreateCustomer:(CustomerCreateDto*)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation*)customerSearchSearchCustomers:(CustomerSearchCriteriaDto*)customerSearchCriteriaDto responseBlock:(void(^)(CustomerSearchResultDto *response, NSError *error))responseBlock;
- (NSOperation*)customerPartyIdGetCustomerWithPartyId:(NSString*)partyId responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation*)customerPfCreatePfCustomer:(CustomerCreateDto*)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation*)customerPfEnrollPfCustomer:(CustomerDto*)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;

// Groups

- (NSOperation*)groupsGroupIdReservationsGetReservationsWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupReservationsDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdReservationsAddReservation:(ReservationCreationDto*)reservationCreationDto groupId:(NSNumber*)groupId responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdLogisticGetLogisticsWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdLogisticUpdateLogistic:(GroupLogisticDto*)groupLogisticDto groupId:(NSNumber*)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdReservationsReservationNoRemoveReservationWithGroupId:(NSNumber*)groupId reservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdSummaryGetSummaryGroupWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdSummaryUpdateSummary:(GroupSummaryDto*)groupSummaryDto groupId:(NSNumber*)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdOffersGetOffersWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdOffersUpdateOffers:(GroupOffersDto*)groupOffersDto groupId:(NSNumber*)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsCreateGroup:(GroupCreationDto*)groupCreationDto responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)groupsGroupIdGetGroupWithGroupId:(NSNumber*)groupId responseBlock:(void(^)(GroupDto *response, NSError *error))responseBlock;

// Rules

- (NSOperation*)rulesEventDatesEventDateEventTypeCalculateEventDaysForEventTypeWithEventDate:(NSString*)eventDate eventType:(NSString*)eventType responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock;
- (NSOperation*)rulesEventDatesEventDateCalculateEventDaysWithEventDate:(NSString*)eventDate responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock;

// Auth

- (NSOperation*)authUserAuthenticateUser:(AuthUserDto*)authUserDto responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock;
- (NSOperation*)authStoreGetRegisterSessionWithResponseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock;
- (NSOperation*)authStoreOpenRegisterSession:(AuthStoreDto*)authStoreDto responseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock;
- (NSOperation*)authStoreCloseRegisterSessionWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;

// ApplicationWadl

- (NSOperation*)applicationWadlGetWadlWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)applicationWadlPathGeExternalGrammarWithPath:(NSString*)path responseBlock:(void(^)(id response, NSError *error))responseBlock;

#pragma mark -
// end of generated services methods

#pragma mark other services
// Account management
- (NSOperation*)userLogoutResponseBlock:(void(^)(id _null, NSError *error))responseBlock;
- (NSOperation*)fakeRequestWithResponseBlock:(void(^)(NSDictionary *response, NSError *error))responseBlock;

@end
