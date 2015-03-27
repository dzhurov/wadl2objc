//
//  ServerInteractionManager.h
//  GroupManager
//
//  Created by Dmitry Zhurov on 14.09.12.
//  Copyright (c) 2012 The Mens Wearhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "APIConsts.h"
#import "ChangeLogisticsRequestDto.h"
#import "GroupRepresentativeDto.h"
#import "DiscountInfoDto.h"
#import "ReservationRemoveItemsRequestDto.h"
#import "FeeDto.h"
#import "ReservationFeesAndPayments.h"
#import "TransactionDto.h"
#import "DiscountDescriptionRawDto.h"
#import "ReservationReorderItemDto.h"
#import "CustomerSearchResultDto.h"
#import "AuthManagerPermissionDto.h"
#import "MessageDto.h"
#import "ReorderStatusResponseDto.h"
#import "SizeDto.h"
#import "AddItemDto.h"
#import "ErrorDto.h"
#import "AbstractInstant.h"
#import "StyleBlockingDto.h"
#import "MaxRefundRequestDto.h"
#import "LineItemDto.h"
#import "AuthManagerDto.h"
#import "ApplyCouponRequestDto.h"
#import "MaxRefundRequestListDto.h"
#import "AuthManagerResponseDto.h"
#import "LocalDate.h"
#import "CatalogItemDto.h"
#import "PostPickupRequestDto.h"
#import "AssignStylesRequest.h"
#import "CatalogDto.h"
#import "GroupCallLogDto.h"
#import "ReservationAdoptionRequestDto.h"
#import "SearchResultDto.h"
#import "AbstractDateTime.h"
#import "AuthStoreStateDto.h"
#import "LineItemReceiptDto.h"
#import "BaseDto.h"
#import "LineItemStateDto.h"
#import "SizeListDto.h"
#import "GroupOffersDto.h"
#import "ReservationDto.h"
#import "GroupCallLogListDto.h"
#import "ReservationPosSummaryDto.h"
#import "BaseDateTime.h"
#import "WeddingGroupCallRequestDto.h"
#import "TendersAuthorizeRequestDto.h"
#import "TaxExemptionRequestDto.h"
#import "BaseLocal.h"
#import "CustomerSearchCriteriaDto.h"
#import "CustomerValidationDto.h"
#import "MaxRefundDto.h"
#import "AddReservationsRequestDto.h"
#import "ApplyPfDiscountRequestDto.h"
#import "LineItemGarmentDto.h"
#import "RemoveItemDto.h"
#import "ReservationCreationDto.h"
#import "ReservationMeasurementDto.h"
#import "AuthStoreDto.h"
#import "DashboardQueryPosReservationDto.h"
#import "WeddingGroupCallDto.h"
#import "TenderSignatureDto.h"
#import "OrderDto.h"
#import "PaymentReceiptDto.h"
#import "PrintersDto.h"
#import "ReservationAdoptionDto.h"
#import "CatalogListDto.h"
#import "SchoolListDto.h"
#import "ReservationPosGarmentsDto.h"
#import "PromDetailDto.h"
#import "GroupDto.h"
#import "TaxExemptionDto.h"
#import "PageDto.h"
#import "CustomerCreateDto.h"
#import "EventDatesDto.h"
#import "ReceiptRequestContainerDto.h"
#import "ReservationFavoritesListDto.h"
#import "StyleInformationDto.h"
#import "LineItemModifierDto.h"
#import "LineItemListDto.h"
#import "GroupCreationDto.h"
#import "MarkdownDto.h"
#import "TenderDto.h"
#import "ReservationPaymentsListDto.h"
#import "ReservationAddItemsRequestDto.h"
#import "PointDto.h"
#import "ReservationOffersDto.h"
#import "TransactionCreationDto.h"
#import "WeddingGroupCallListDto.h"
#import "PostFreeTuxPickupRequestDto.h"
#import "GiftCardValidateResponseDto.h"
#import "LogEntryDto.h"
#import "PostTuxDepositResponseDto.h"
#import "ReservationValidationDto.h"
#import "MaxRefundListDto.h"
#import "ReservationStyleListDto.h"
#import "SearchCriteriaDto.h"
#import "DropoffLineItemsRequestDto.h"
#import "AddHatPackageRequestDto.h"
#import "PrinterDto.h"
#import "ReservationPaymentsDto.h"
#import "BridalShowCallDto.h"
#import "StoreDto.h"
#import "PaymentInfoDto.h"
#import "MarkdownRequestDto.h"
#import "ChangeRequestDto.h"
#import "ReservationReorderRequestDto.h"
#import "AuthResponseDto.h"
#import "ReceiptResponseDto.h"
#import "SchoolDto.h"
#import "StoreNoDto.h"
#import "CopyStylesResponseDto.h"
#import "CustomerDto.h"
#import "AuthUserDto.h"
#import "ReservationSummaryDto.h"
#import "SizeAvailabilityRequestDto.h"
#import "StoreListDto.h"
#import "SignatureDto.h"
#import "GroupReservationsDto.h"
#import "ReservationPickupDetailsDto.h"
#import "AbstractPartial.h"
#import "GiftCardValidateDto.h"
#import "StyleDto.h"
#import "MarkdownEditRequestDto.h"
#import "SendWeeklyReportsDto.h"
#import "DateTime.h"
#import "AddReservationsResponseDto.h"
#import "ReservationNumbersDto.h"
#import "ReservationCommitDto.h"
#import "PosVersionDto.h"
#import "ReorderValidationResponseDto.h"
#import "GroupLogisticDto.h"
#import "StyleInformationListDto.h"
#import "ReservationFavoritesDto.h"
#import "ReservationStyleDto.h"
#import "ReservationReferenceDto.h"
#import "BridalShowCallListDto.h"
#import "ReservationLogisticDto.h"
#import "GroupSummaryDto.h"
#import "ChangeItemsLostFeeRequestDto.h"
#import "ReceiptRequestDto.h"
#import "AddFeeRequestDto.h"
#import "StoresDto.h"
#import "CatalogItemListDto.h"
#import "ReservationReferenceListDto.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};

typedef void(^ResponseBlock)(id responseObject, NSError *error);

#define kRequestTimeoutInterval     (NSTimeInterval)(10.f)  //sec

@protocol MWAccountManager <NSObject>

- (BOOL)reloginSynchronous:(NSError**)error;
- (NSString*)token:(NSError**)error;

@end

@interface ServerInteractionManager : NSObject

@property (nonatomic, weak) id <MWAccountManager> accountManager;

+ (instancetype)sharedManager;

// Here starts generated services methods. Don't touch it!
#pragma mark - Generated Services

// DashboardReportsAdoption

- (NSOperation *)dashboardReportsAdoptionCommittedReservationsCommittedReservationsAdoption:(ReservationAdoptionRequestDto *)reservationAdoptionRequestDto responseBlock:(void(^)(ReservationAdoptionDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsAdoptionWeeklyCommittedReportXlsxWeeklyCommittedReportWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsAdoptionWeeklyWeddingReportXlsxWeeklyWeddingReportWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsAdoptionStatsExcelXlsStatsReportWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsAdoptionSendWeeklyReportsSendWeeklyReports:(SendWeeklyReportsDto *)sendWeeklyReportsDto responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsAdoptionCreatedReservationsCreatedReservationsAdoption:(ReservationAdoptionRequestDto *)reservationAdoptionRequestDto responseBlock:(void(^)(ReservationAdoptionDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsAdoptionWeddingGroupsWeddingGroupAdoption:(ReservationAdoptionRequestDto *)reservationAdoptionRequestDto responseBlock:(void(^)(ReservationAdoptionDto *response, NSError *error))responseBlock;

// DashboardQuery

- (NSOperation *)dashboardQueryUniverseDeviceFindDeviceStateWithDeviceId:(NSString *)deviceId responseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardQueryTuxoracleReservationFindTuxOracleReservationByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardQueryPosReservationFindPosReservationByNo:(DashboardQueryPosReservationDto *)dashboardQueryPosReservationDto responseBlock:(void(^)(id response, NSError *error))responseBlock;

// Transaction

- (NSOperation *)transactionEditMarkdownEditMarkdown:(MarkdownEditRequestDto *)markdownEditRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionAddTaxExemptionAddTaxExemption:(TaxExemptionRequestDto *)taxExemptionRequestDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionFillLineItemsFillLineItems:(LineItemListDto *)lineItemListDto responseBlock:(void(^)(LineItemListDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionRemoveMarkdownRemoveMarkdown:(MarkdownRequestDto *)markdownRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionCreateCreateTransaction:(TransactionCreationDto *)transactionCreationDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionPostvoidVoidTransaction:(TransactionDto *)transactionDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionSetCustomerSaveCustomerInTransaction:(TransactionDto *)transactionDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionAddFeeAddFee:(AddFeeRequestDto *)addFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionPostTuxDropoffPostTuxDropoff:(TransactionDto *)transactionDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionApplyPfDiscountApplyPfDiscount:(ApplyPfDiscountRequestDto *)applyPfDiscountRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionRemoveTaxExemptionRemoveTaxExemption:(TaxExemptionRequestDto *)taxExemptionRequestDto responseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionChangeItemsLostFeeChangeItemsLostFee:(ChangeItemsLostFeeRequestDto *)changeItemsLostFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionAddMarkdownAddMarkdown:(MarkdownRequestDto *)markdownRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionApplyCouponApplyCoupon:(ApplyCouponRequestDto *)applyCouponRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionChangeLateFeeChangeLateFee:(AddFeeRequestDto *)addFeeRequestDto responseBlock:(void(^)(LineItemDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionCurrentGetCurrentTransactionWithResponseBlock:(void(^)(TransactionDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionFillLineItemsDropoffFillLineItems:(DropoffLineItemsRequestDto *)dropoffLineItemsRequestDto responseBlock:(void(^)(LineItemListDto *response, NSError *error))responseBlock;
- (NSOperation *)transactionPostTuxDepositPostTuxDeposit:(TransactionDto *)transactionDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock;

// Receipts

- (NSOperation *)receiptsSendReceipt:(ReceiptRequestDto *)receiptRequestDto responseBlock:(void(^)(ReceiptResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)receiptsMultiSendReceipt:(ReceiptRequestContainerDto *)receiptRequestContainerDto responseBlock:(void(^)(ReceiptResponseDto *response, NSError *error))responseBlock;

// DashboardReportsStores

- (NSOperation *)dashboardReportsStoresLaunchedStoresDeleteLaunchedStore:(StoreNoDto *)storeNoDto responseBlock:(void(^)(StoreListDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsStoresLaunchedStoresLaunchedStoresWithResponseBlock:(void(^)(StoreListDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardReportsStoresLaunchedStoresCreateLaunchedStore:(StoreNoDto *)storeNoDto responseBlock:(void(^)(StoreListDto *response, NSError *error))responseBlock;

// Customer

- (NSOperation *)customerValidateValidateCustomer:(CustomerDto *)customerDto responseBlock:(void(^)(CustomerValidationDto *response, NSError *error))responseBlock;
- (NSOperation *)customerGetCustomerWithPartyId:(NSString *)partyId responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation *)customerPfEnrollPfCustomer:(CustomerDto *)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation *)customerPfCreatePfCustomer:(CustomerCreateDto *)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation *)customerUpdateCustomer:(CustomerDto *)customerDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation *)customerCreateCustomer:(CustomerCreateDto *)customerCreateDto responseBlock:(void(^)(CustomerDto *response, NSError *error))responseBlock;
- (NSOperation *)customerSearchSearchCustomers:(CustomerSearchCriteriaDto *)customerSearchCriteriaDto responseBlock:(void(^)(CustomerSearchResultDto *response, NSError *error))responseBlock;

// Log

- (NSOperation *)logLogClient:(LogEntryDto *)logEntryDto responseBlock:(void(^)(id response, NSError *error))responseBlock;

// Rules

- (NSOperation *)rulesEventDatesCalculateEventDaysWithEventDate:(NSString *)eventDate responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock;
- (NSOperation *)rulesEventDatesCalculateEventDaysForEventTypeWithEventDate:(NSString *)eventDate eventType:(NSString *)eventType responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock;

// Pos

- (NSOperation *)posFreeTuxPickupPostFreeTuxPickup:(PostFreeTuxPickupRequestDto *)postFreeTuxPickupRequestDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)posReservationMaxRefundMaxRefundAmount:(MaxRefundRequestDto *)maxRefundRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(MaxRefundListDto *response, NSError *error))responseBlock;
- (NSOperation *)posReservationPosSummaryFindPosSummaryByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPosSummaryDto *response, NSError *error))responseBlock;
- (NSOperation *)posReservationPosDetailsFindPosDetailsByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPickupDetailsDto *response, NSError *error))responseBlock;
- (NSOperation *)posReservationPaymentsReservationPaymentsBatch:(ReservationNumbersDto *)reservationNumbersDto responseBlock:(void(^)(ReservationPaymentsListDto *response, NSError *error))responseBlock;
- (NSOperation *)posVersionVersionWithResponseBlock:(void(^)(PosVersionDto *response, NSError *error))responseBlock;
- (NSOperation *)posGiftCardValidateGiftCardValidate:(GiftCardValidateDto *)giftCardValidateDto responseBlock:(void(^)(GiftCardValidateResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)posReservationReservationPaymentsReservationPaymentsWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPaymentsDto *response, NSError *error))responseBlock;
- (NSOperation *)posTxPostPickupPostPickup:(PostPickupRequestDto *)postPickupRequestDto responseBlock:(void(^)(PostTuxDepositResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)posReservationPosGarmentsFindPosGarmentsByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPosGarmentsDto *response, NSError *error))responseBlock;
- (NSOperation *)posMaxRefundMaxRefundAmountBatch:(MaxRefundRequestListDto *)maxRefundRequestListDto responseBlock:(void(^)(MaxRefundListDto *response, NSError *error))responseBlock;

// DashboardDiagnostic

- (NSOperation *)dashboardDiagnosticFingerprintsPrintFingerPrintsWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticEmployeeAnonimousDiagnosticEmployeeServiceAnonimousWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticGiftcardDiagnosticGiftCardWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticReservationDiagnosticReservationServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticVersionDiagnosticGetVersionWithResponseBlock:(void(^)(PosVersionDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticCustomerDiagnosticCustomerServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticTuxoracleDiagnosticTuxOracleWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticTxwadminDiagnosticTxwAdminWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticGetcustomerDiagnosticGetCustomerWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticEmployeeDiagnosticEmployeeServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticGetregisterstateDiagnosticGetRegisterStateWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticPrinterPrinterServiceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticGetErrorGetErrorDtoWithResponseBlock:(void(^)(ErrorDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardDiagnosticTuxmobDiagnosticTuxMobWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;

// Search

- (NSOperation *)searchReservationsSearchReservations:(SearchCriteriaDto *)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock;
- (NSOperation *)searchGroupsSearchGroups:(SearchCriteriaDto *)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock;
- (NSOperation *)searchEventsSearchEvents:(SearchCriteriaDto *)searchCriteriaDto responseBlock:(void(^)(SearchResultDto *response, NSError *error))responseBlock;

// Inventory

- (NSOperation *)inventoryCatalogFindCatalogWithCatalogNo:(NSString *)catalogNo measurementsReservationNo:(NSString *)measurementsReservationNo responseBlock:(void(^)(CatalogItemListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryCatalogsSearchAllWithResponseBlock:(void(^)(CatalogListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryStoresSearchAllStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryStoresReturnSearchReturnStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryStoresFindByStoreNoWithStoreNo:(NSString *)storeNo responseBlock:(void(^)(StoreDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryStoresPickupSearchPickupStoresWithResponseBlock:(void(^)(StoresDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryPrintersFindPrintersForStoreWithStoreNo:(NSString *)storeNo responseBlock:(void(^)(PrintersDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryPrintersFindAllPrintersWithResponseBlock:(void(^)(PrintersDto *response, NSError *error))responseBlock;
- (NSOperation *)inventorySchoolsSearchAllWithIfModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventorySchoolsSearchByCriteria:(SchoolDto *)schoolDto ifModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventorySchoolsSearchByStateWithSchoolSt:(NSString *)schoolSt ifModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventorySchoolsFindBySchoolNoWithSchoolNo:(NSNumber *)schoolNo responseBlock:(void(^)(SchoolDto *response, NSError *error))responseBlock;
- (NSOperation *)inventorySchoolsSearchByStateAndCityWithSchoolSt:(NSString *)schoolSt schoolCity:(NSString *)schoolCity ifModifiedSince:(NSString *)ifModifiedSince range:(NSString *)range responseBlock:(void(^)(SchoolListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryStylesFindByStyleNumberWithStyleNo:(NSString *)styleNo responseBlock:(void(^)(StyleInformationDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryStylesSearchByFilterWithType:(NSString *)type store:(NSString *)store responseBlock:(void(^)(StyleInformationListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventorySizesFilterSizesWithStyle:(NSString *)style store:(NSString *)store eventDate:(NSString *)eventDate eventType:(NSString *)eventType group:(NSNumber *)group responseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock;
- (NSOperation *)inventoryDiscountFindDiscountInfoWithCode:(NSString *)code eventType:(NSString *)eventType responseBlock:(void(^)(DiscountInfoDto *response, NSError *error))responseBlock;

// Reservation

- (NSOperation *)reservationStylesFindReservationStyleWithReservationNo:(NSString *)reservationNo lineNo:(NSNumber *)lineNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationStylesUpdateStyle:(ReservationStyleDto *)reservationStyleDto reservationNo:(NSString *)reservationNo lineNo:(NSNumber *)lineNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationStylesRemoveStyleWithReservationNo:(NSString *)reservationNo lineNo:(NSNumber *)lineNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationAssignStylesToAssignStylesTo:(AssignStylesRequest *)assignStylesRequest responseBlock:(void(^)(CopyStylesResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationStylesFindReservationStylesWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationStylesCreateStyle:(ReservationStyleDto *)reservationStyleDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationCopyStylesToCopyStylesTo:(ReservationNumbersDto *)reservationNumbersDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(CopyStylesResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationSizesFindReservationSizes:(StyleInformationDto *)styleInformationDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(SizeListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationSizeReservationSizeAvailability:(SizeAvailabilityRequestDto *)sizeAvailabilityRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(SizeDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationValidateChangeValidate:(ChangeRequestDto *)changeRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReorderValidationResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationChangeLogisticsChangeLogistics:(ChangeLogisticsRequestDto *)changeLogisticsRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)reservationChangeChange:(ChangeRequestDto *)changeRequestDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)reservationReorderStatusReorderStatusWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReorderStatusResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationHatpackageRemoveHatPackageWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationHatpackageAddHatPackageWithReservationNo:(NSString *)reservationNo catalogCode:(NSString *)catalogCode responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationHatpackageUpdateHatPackageWithReservationNo:(NSString *)reservationNo catalogCode:(NSString *)catalogCode responseBlock:(void(^)(ReservationStyleListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationLogisticUpdateLogistic:(ReservationLogisticDto *)reservationLogisticDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationLogisticFindLogisticByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationSummaryFindSummaryByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationSummaryUpdateSummary:(ReservationSummaryDto *)reservationSummaryDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationOffersDiscountAssignReservationDiscount:(ReservationOffersDto *)reservationOffersDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationOffersDiscountDeleteReservationDiscountWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationMeasurementUpdateMeasurement:(ReservationMeasurementDto *)reservationMeasurementDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationMeasurementFindMeasurementByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationFavoritesFindFavoritesByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationFavoritesListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationRemoveReservationWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)reservationCreateReservation:(ReservationCreationDto *)reservationCreationDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationCommitCommitReservation:(ReservationCommitDto *)reservationCommitDto reservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)reservationValidateIsValidForCommitWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationValidationDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationPosSummaryFindPosSummaryByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationPosSummaryDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationReferencesFindReferencesByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationReferenceListDto *response, NSError *error))responseBlock;
- (NSOperation *)reservationOffersFindOffersByNoWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;

// Tender

- (NSOperation *)tenderCaptureSignatureCaptureSignature:(TenderSignatureDto *)tenderSignatureDto responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)tenderAuthorizeAuthorize:(TendersAuthorizeRequestDto *)tendersAuthorizeRequestDto responseBlock:(void(^)(TendersAuthorizeRequestDto *response, NSError *error))responseBlock;
- (NSOperation *)tenderLookupLookup:(TenderDto *)tenderDto responseBlock:(void(^)(TenderDto *response, NSError *error))responseBlock;

// DashboardRawDiscounts

- (NSOperation *)dashboardRawDiscountsDescriptionDiscountDescriptionsWithCode:(NSString *)code responseBlock:(void(^)(DiscountDescriptionRawDto *response, NSError *error))responseBlock;
- (NSOperation *)dashboardRawDiscountsFindDiscountsWithCode:(NSString *)code responseBlock:(void(^)(id response, NSError *error))responseBlock;

// Testing

- (NSOperation *)testingReservationPreparedForShipFreeTuxWithNegativeBalanceCreateForShipFreeTuxWithNegativeBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipWithPositiveBalanceCreateForShipWithPositiveBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipWithZeroBalanceCreateForShipWithZeroBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingPosFindTransactionWithTransactionNumber:(NSString *)transactionNumber responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipWithNegativeBalanceCreateForShipWithNegativeBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipFreeTuxWithNegativeBalanceCreateForShipFreeTuxWithNegativeBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedNotPayedCreateNotPayedReservationWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipFreeTuxWithZeroBalanceCreateForShipFreeTuxWithZeroBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationShipChangeStatusToShipWithReservationNo:(NSString *)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipWithZeroBalanceCreateForShipWithZeroBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipWithNegativeBalanceCreateForShipWithNegativeBalanceWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipFreeTuxWithZeroBalanceCreateForShipFreeTuxWithZeroBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)testingReservationPreparedForShipWithPositiveBalanceCreateForShipWithPositiveBalanceWithShipToStore:(NSString *)shipToStore responseBlock:(void(^)(id response, NSError *error))responseBlock;

// Groups

- (NSOperation *)groupsReservationsGetReservationsWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupReservationsDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersFreeSuitDeleteFreeSuitWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersFreeSuitAssignFreeSuitWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsCallLogCallLog:(GroupCallLogDto *)groupCallLogDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupCallLogListDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsWeddingCallListWeddingCallList:(WeddingGroupCallRequestDto *)weddingGroupCallRequestDto responseBlock:(void(^)(WeddingGroupCallListDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsBridalShowCallsUpdateBridalShowCall:(BridalShowCallDto *)bridalShowCallDto groupId:(NSNumber *)groupId responseBlock:(void(^)(BridalShowCallDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersDiscountAssignDiscount:(GroupOffersDto *)groupOffersDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersDiscountDeleteDiscountWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsCallLogsGetGroupCallLogsWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupCallLogListDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsWeddingCallAddWeddingCall:(WeddingGroupCallDto *)weddingGroupCallDto groupId:(NSNumber *)groupId responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersFreeTuxDeleteFreeTuxWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersFreeTuxAssignFreeTuxWithGroupId:(NSNumber *)groupId reservationNo:(NSString *)reservationNo responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersPromoCodeDeletePromoCodeWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersPromoCodeAssignPromoCode:(GroupOffersDto *)groupOffersDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsAddReservationsAddReservationList:(AddReservationsRequestDto *)addReservationsRequestDto groupId:(NSNumber *)groupId responseBlock:(void(^)(AddReservationsResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsGetGroupWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsSummaryGetSummaryGroupWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsSummaryUpdateSummary:(GroupSummaryDto *)groupSummaryDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupSummaryDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsOffersGetOffersWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupOffersDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsLogisticUpdateLogistic:(GroupLogisticDto *)groupLogisticDto groupId:(NSNumber *)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsLogisticGetLogisticsWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(GroupLogisticDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsCreateGroup:(GroupCreationDto *)groupCreationDto responseBlock:(void(^)(GroupDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsBridalShowCallsFindBridalShowCallList:(PageDto *)pageDto responseBlock:(void(^)(BridalShowCallListDto *response, NSError *error))responseBlock;
- (NSOperation *)groupsFavoritesFindFavoritesByGroupIdWithGroupId:(NSNumber *)groupId responseBlock:(void(^)(ReservationFavoritesListDto *response, NSError *error))responseBlock;

// Auth

- (NSOperation *)authStoreCloseRegisterSessionWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)authStoreGetRegisterSessionWithResponseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock;
- (NSOperation *)authStoreOpenRegisterSession:(AuthStoreDto *)authStoreDto responseBlock:(void(^)(AuthStoreStateDto *response, NSError *error))responseBlock;
- (NSOperation *)authUserSignOutCurrentUserWithDate:(NSString *)date responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation *)authUserGetCurrentUserWithDate:(NSString *)date responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock;
- (NSOperation *)authUserAuthenticateUser:(AuthUserDto *)authUserDto date:(NSString *)date responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock;
- (NSOperation *)authManagerPermissionManagerOverrideRemovePermissionWithUserPermission:(NSString *)userPermission responseBlock:(void(^)(AuthManagerResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)authManagerManagerOverrideRemoveRoleWithResponseBlock:(void(^)(AuthManagerResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)authManagerManagerOverrideAddRole:(AuthManagerDto *)authManagerDto responseBlock:(void(^)(AuthManagerResponseDto *response, NSError *error))responseBlock;
- (NSOperation *)authDashboardAuthenticateDashboardUser:(AuthUserDto *)authUserDto responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock;
- (NSOperation *)authDashboardSignOutDashboardCurrentUserWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;

#pragma mark -
// end of generated services methods

@end
