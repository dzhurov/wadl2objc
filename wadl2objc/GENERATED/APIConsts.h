//
//  APIConsts.h
//
//  Created by wadl2objc
//

#ifndef wadl2objc_APIConsts_h
#define wadl2objc_APIConsts_h

#pragma mark - Generated Services

// Search
#define kWADLServiceSearchGroupsURLPath @"search/groups"
#define kWADLServiceSearchReservationsURLPath @"search/reservations"
#define kWADLServiceSearchEventsURLPath @"search/events"
#define kWADLServiceSearchURLPath @"search"

// Transaction
#define kWADLServiceTransactionPostTuxDepositURLPath @"transaction/postTuxDeposit"
#define kWADLServiceTransactionURLPath @"transaction"
#define kWADLServiceTransactionAddFeeURLPath @"transaction/addFee"
#define kWADLServiceTransactionFillLineItemsURLPath @"transaction/fillLineItems"
#define kWADLServiceTransactionAddMarkdownURLPath @"transaction/addMarkdown"
#define kWADLServiceTransactionPostvoidURLPath @"transaction/postvoid"
#define kWADLServiceTransactionApplyCouponURLPath @"transaction/applyCoupon"

// Inventory
#define kWADLServiceInventoryStylesStyleNoURLPath @"inventory/styles/%@"
#define kWADLServiceInventorySchoolsSchoolStURLPath @"inventory/schools/%@"
#define kWADLServiceInventoryStoresURLPath @"inventory/stores"
#define kWADLServiceInventoryStylesURLPath @"inventory/styles"
#define kWADLServiceInventorySchoolsURLPath @"inventory/schools"
#define kWADLServiceInventorySchoolsSchoolCitySchoolStURLPath @"inventory/schools/%@/%@"
#define kWADLServiceInventoryStoresReturnURLPath @"inventory/stores/return"
#define kWADLServiceInventorySchoolsSchoolNoURLPath @"inventory/schools/%@"
#define kWADLServiceInventoryStoresPickupURLPath @"inventory/stores/pickup"
#define kWADLServiceInventorySizesURLPath @"inventory/sizes"
#define kWADLServiceInventoryURLPath @"inventory"
#define kWADLServiceInventoryStoresStoreNoURLPath @"inventory/stores/%@"
#define kWADLServiceInventoryPrintersStoreNoURLPath @"inventory/printers/%@"

// Reservation
#define kWADLServiceReservationReservationNoLogisticURLPath @"reservation/%@/logistic"
#define kWADLServiceReservationURLPath @"reservation"
#define kWADLServiceReservationReservationNoOffersURLPath @"reservation/%@/offers"
#define kWADLServiceReservationReservationNoURLPath @"reservation/%@"
#define kWADLServiceReservationStyleSizesReservationNoURLPath @"reservation/%@/sizes/%@"
#define kWADLServiceReservationReservationNoCommitURLPath @"reservation/%@/commit"
#define kWADLServiceReservationReservationNoSummaryURLPath @"reservation/%@/summary"
#define kWADLServiceReservationReservationNoStylesLineNoURLPath @"reservation/%@/styles/%@"
#define kWADLServiceReservationReservationNoCopyStylesToURLPath @"reservation/%@/copyStylesTo"
#define kWADLServiceReservationReservationNoMeasurementURLPath @"reservation/%@/measurement"
#define kWADLServiceReservationReservationNoStylesURLPath @"reservation/%@/styles"

// Receipts
#define kWADLServiceReceiptsURLPath @"receipts"

// Tender
#define kWADLServiceTenderLookupURLPath @"tender/lookup"
#define kWADLServiceTenderURLPath @"tender"
#define kWADLServiceTenderAuthorizeURLPath @"tender/authorize"

// Customer
#define kWADLServiceCustomerPartyIdURLPath @"customer/%@"
#define kWADLServiceCustomerSearchURLPath @"customer/search"
#define kWADLServiceCustomerPfURLPath @"customer/pf"
#define kWADLServiceCustomerURLPath @"customer"

// Rules
#define kWADLServiceRulesURLPath @"rules"
#define kWADLServiceRulesEventDatesEventDateEventTypeURLPath @"rules/eventDates/%@/%@"
#define kWADLServiceRulesEventDatesEventDateURLPath @"rules/eventDates/%@"

// Groups
#define kWADLServiceGroupsURLPath @"groups"
#define kWADLServiceGroupsGroupIdLogisticURLPath @"groups/%@/logistic"
#define kWADLServiceGroupsGroupIdURLPath @"groups/%@"
#define kWADLServiceGroupsGroupIdReservationsURLPath @"groups/%@/reservations"
#define kWADLServiceGroupsGroupIdOffersURLPath @"groups/%@/offers"
#define kWADLServiceGroupsGroupIdReservationsReservationNoURLPath @"groups/%@/reservations/%@"
#define kWADLServiceGroupsGroupIdSummaryURLPath @"groups/%@/summary"

// Auth
#define kWADLServiceAuthStoreURLPath @"auth/store"
#define kWADLServiceAuthUserURLPath @"auth/user"
#define kWADLServiceAuthURLPath @"auth"

// ApplicationWadl
#define kWADLServiceApplicationWadlPathURLPath @"application.wadl/%@"
#define kWADLServiceApplicationWadlURLPath @"application.wadl"

#pragma mark -

#endif
