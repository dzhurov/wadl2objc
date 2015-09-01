//
//  APIConsts.h
//
//  Created by wadl2objc
//

#ifndef wadl2objc_APIConsts_h
#define wadl2objc_APIConsts_h

#pragma mark - Generated Services

// Auth
#define kWADLServiceAuthURLPath @"auth"
#define kWADLServiceAuthDashboardURLPath @"auth/dashboard"
#define kWADLServiceAuthManagerURLPath @"auth/manager"
#define kWADLServiceAuthManagerPermissionUserPermissionURLPath @"auth/manager/permission/%@"
#define kWADLServiceAuthStoreURLPath @"auth/store"
#define kWADLServiceAuthUserURLPath @"auth/user"

// Groups
#define kWADLServiceGroupsURLPath @"groups"
#define kWADLServiceGroupsBridalShowCallsURLPath @"groups/bridalShowCalls"
#define kWADLServiceGroupsBridalShowCallsGroupIdURLPath @"groups/bridalShowCalls/%@"
#define kWADLServiceGroupsGroupIdURLPath @"groups/%@"
#define kWADLServiceGroupsGroupIdAddReservationsURLPath @"groups/%@/addReservations"
#define kWADLServiceGroupsGroupIdCallLogURLPath @"groups/%@/callLog"
#define kWADLServiceGroupsGroupIdCallLogsURLPath @"groups/%@/callLogs"
#define kWADLServiceGroupsGroupIdFavoritesURLPath @"groups/%@/favorites"
#define kWADLServiceGroupsGroupIdLogisticURLPath @"groups/%@/logistic"
#define kWADLServiceGroupsGroupIdOffersURLPath @"groups/%@/offers"
#define kWADLServiceGroupsGroupIdOffersDiscountURLPath @"groups/%@/offers/discount"
#define kWADLServiceGroupsGroupIdOffersFreeSuitReservationNoURLPath @"groups/%@/offers/freeSuit/%@"
#define kWADLServiceGroupsGroupIdOffersFreeTuxReservationNoURLPath @"groups/%@/offers/freeTux/%@"
#define kWADLServiceGroupsGroupIdOffersPromoCodeURLPath @"groups/%@/offers/promoCode"
#define kWADLServiceGroupsGroupIdReservationsURLPath @"groups/%@/reservations"
#define kWADLServiceGroupsGroupIdSummaryURLPath @"groups/%@/summary"
#define kWADLServiceGroupsGroupIdWeddingCallURLPath @"groups/%@/weddingCall"
#define kWADLServiceGroupsWeddingCallListURLPath @"groups/weddingCallList"

// Testing
#define kWADLServiceTestingURLPath @"testing"
#define kWADLServiceTestingPosTransactionNumberURLPath @"testing/pos/%@"
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithNegativeBalanceURLPath @"testing/reservation/prepared/forShipFreeTuxWithNegativeBalance"
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithNegativeBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipFreeTuxWithNegativeBalance/%@"
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithZeroBalanceURLPath @"testing/reservation/prepared/forShipFreeTuxWithZeroBalance"
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithZeroBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipFreeTuxWithZeroBalance/%@"
#define kWADLServiceTestingReservationPreparedForShipWithNegativeBalanceURLPath @"testing/reservation/prepared/forShipWithNegativeBalance"
#define kWADLServiceTestingReservationPreparedForShipWithNegativeBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipWithNegativeBalance/%@"
#define kWADLServiceTestingReservationPreparedForShipWithPositiveBalanceURLPath @"testing/reservation/prepared/forShipWithPositiveBalance"
#define kWADLServiceTestingReservationPreparedForShipWithPositiveBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipWithPositiveBalance/%@"
#define kWADLServiceTestingReservationPreparedForShipWithZeroBalanceURLPath @"testing/reservation/prepared/forShipWithZeroBalance"
#define kWADLServiceTestingReservationPreparedForShipWithZeroBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipWithZeroBalance/%@"
#define kWADLServiceTestingReservationPreparedNotPayedURLPath @"testing/reservation/prepared/notPayed"
#define kWADLServiceTestingReservationReservationNoShipURLPath @"testing/reservation/%@/ship"

// DashboardRawDiscounts
#define kWADLServiceDashboardRawDiscountsURLPath @"dashboard/raw/discounts"
#define kWADLServiceDashboardRawDiscountsCodeURLPath @"dashboard/raw/discounts/%@"
#define kWADLServiceDashboardRawDiscountsCodeDescriptionURLPath @"dashboard/raw/discounts/%@/description"

// Tender
#define kWADLServiceTenderURLPath @"tender"
#define kWADLServiceTenderAuthorizeURLPath @"tender/authorize"
#define kWADLServiceTenderCaptureSignatureURLPath @"tender/captureSignature"
#define kWADLServiceTenderLookupURLPath @"tender/lookup"

// Reservation
#define kWADLServiceReservationURLPath @"reservation"
#define kWADLServiceReservationAssignStylesToURLPath @"reservation/assignStylesTo"
#define kWADLServiceReservationReservationNoURLPath @"reservation/%@"
#define kWADLServiceReservationReservationNoChangeURLPath @"reservation/%@/change"
#define kWADLServiceReservationReservationNoChangeLogisticsURLPath @"reservation/%@/changeLogistics"
#define kWADLServiceReservationReservationNoCommitURLPath @"reservation/%@/commit"
#define kWADLServiceReservationReservationNoCopyStylesToURLPath @"reservation/%@/copyStylesTo"
#define kWADLServiceReservationReservationNoFavoritesURLPath @"reservation/%@/favorites"
#define kWADLServiceReservationReservationNoHatpackageURLPath @"reservation/%@/hatpackage"
#define kWADLServiceReservationReservationNoHatpackageCatalogCodeURLPath @"reservation/%@/hatpackage/%@"
#define kWADLServiceReservationReservationNoLogisticURLPath @"reservation/%@/logistic"
#define kWADLServiceReservationReservationNoMeasurementURLPath @"reservation/%@/measurement"
#define kWADLServiceReservationReservationNoOffersURLPath @"reservation/%@/offers"
#define kWADLServiceReservationReservationNoOffersDiscountURLPath @"reservation/%@/offers/discount"
#define kWADLServiceReservationReservationNoPosSummaryURLPath @"reservation/%@/posSummary"
#define kWADLServiceReservationReservationNoReferencesURLPath @"reservation/%@/references"
#define kWADLServiceReservationReservationNoReorderStatusURLPath @"reservation/%@/reorderStatus"
#define kWADLServiceReservationReservationNoSizeURLPath @"reservation/%@/size"
#define kWADLServiceReservationReservationNoSizesURLPath @"reservation/%@/sizes"
#define kWADLServiceReservationReservationNoStylesURLPath @"reservation/%@/styles"
#define kWADLServiceReservationReservationNoStylesLineNoURLPath @"reservation/%@/styles/%@"
#define kWADLServiceReservationReservationNoSummaryURLPath @"reservation/%@/summary"
#define kWADLServiceReservationReservationNoValidateURLPath @"reservation/%@/validate"
#define kWADLServiceReservationReservationNoValidateChangeURLPath @"reservation/%@/validateChange"

// Inventory
#define kWADLServiceInventoryURLPath @"inventory"
#define kWADLServiceInventoryCatalogCatalogNoMeasurementsReservationNoURLPath @"inventory/catalog/%@/%@"
#define kWADLServiceInventoryCatalogsURLPath @"inventory/catalogs"
#define kWADLServiceInventoryDiscountURLPath @"inventory/discount"
#define kWADLServiceInventoryPrintersURLPath @"inventory/printers"
#define kWADLServiceInventoryPrintersStoreNoURLPath @"inventory/printers/%@"
#define kWADLServiceInventorySchoolsURLPath @"inventory/schools"
#define kWADLServiceInventorySchoolsSchoolNoURLPath @"inventory/schools/%@"
#define kWADLServiceInventorySchoolsSchoolStURLPath @"inventory/schools/%@"
#define kWADLServiceInventorySchoolsSchoolStSchoolCityURLPath @"inventory/schools/%@/%@"
#define kWADLServiceInventorySizesURLPath @"inventory/sizes"
#define kWADLServiceInventoryStoresURLPath @"inventory/stores"
#define kWADLServiceInventoryStoresPickupURLPath @"inventory/stores/pickup"
#define kWADLServiceInventoryStoresReturnURLPath @"inventory/stores/return"
#define kWADLServiceInventoryStoresStoreNoURLPath @"inventory/stores/%@"
#define kWADLServiceInventoryStylesURLPath @"inventory/styles"
#define kWADLServiceInventoryStylesStyleNoURLPath @"inventory/styles/%@"

// Search
#define kWADLServiceSearchURLPath @"search"
#define kWADLServiceSearchEventsURLPath @"search/events"
#define kWADLServiceSearchGroupsURLPath @"search/groups"
#define kWADLServiceSearchReservationsURLPath @"search/reservations"

// DashboardDiagnostic
#define kWADLServiceDashboardDiagnosticURLPath @"dashboard/diagnostic"
#define kWADLServiceDashboardDiagnosticCustomerURLPath @"dashboard/diagnostic/customer"
#define kWADLServiceDashboardDiagnosticEmployeeURLPath @"dashboard/diagnostic/employee"
#define kWADLServiceDashboardDiagnosticEmployeeAnonimousURLPath @"dashboard/diagnostic/employeeAnonimous"
#define kWADLServiceDashboardDiagnosticFingerprintsURLPath @"dashboard/diagnostic/fingerprints"
#define kWADLServiceDashboardDiagnosticGetErrorURLPath @"dashboard/diagnostic/getError"
#define kWADLServiceDashboardDiagnosticGetcustomerURLPath @"dashboard/diagnostic/getcustomer"
#define kWADLServiceDashboardDiagnosticGetregisterstateURLPath @"dashboard/diagnostic/getregisterstate"
#define kWADLServiceDashboardDiagnosticGiftcardURLPath @"dashboard/diagnostic/giftcard"
#define kWADLServiceDashboardDiagnosticPrinterURLPath @"dashboard/diagnostic/printer"
#define kWADLServiceDashboardDiagnosticReservationURLPath @"dashboard/diagnostic/reservation"
#define kWADLServiceDashboardDiagnosticTuxmobURLPath @"dashboard/diagnostic/tuxmob"
#define kWADLServiceDashboardDiagnosticTuxoracleURLPath @"dashboard/diagnostic/tuxoracle"
#define kWADLServiceDashboardDiagnosticTxwadminURLPath @"dashboard/diagnostic/txwadmin"
#define kWADLServiceDashboardDiagnosticVersionURLPath @"dashboard/diagnostic/version"

// Pos
#define kWADLServicePosURLPath @"pos"
#define kWADLServicePosFreeTuxPickupURLPath @"pos/freeTuxPickup"
#define kWADLServicePosGiftCardValidateURLPath @"pos/giftCardValidate"
#define kWADLServicePosMaxRefundURLPath @"pos/maxRefund"
#define kWADLServicePosReservationPaymentsURLPath @"pos/reservationPayments"
#define kWADLServicePosReservationReservationNoMaxRefundURLPath @"pos/reservation/%@/maxRefund"
#define kWADLServicePosReservationReservationNoPosDetailsURLPath @"pos/reservation/%@/posDetails"
#define kWADLServicePosReservationReservationNoPosGarmentsURLPath @"pos/reservation/%@/posGarments"
#define kWADLServicePosReservationReservationNoPosSummaryURLPath @"pos/reservation/%@/posSummary"
#define kWADLServicePosReservationReservationNoReservationPaymentsURLPath @"pos/reservation/%@/reservationPayments"
#define kWADLServicePosTxPostPickupURLPath @"pos/tx/postPickup"
#define kWADLServicePosVersionURLPath @"pos/version"

// Rules
#define kWADLServiceRulesURLPath @"rules"
#define kWADLServiceRulesEventDatesEventDateURLPath @"rules/eventDates/%@"
#define kWADLServiceRulesEventDatesEventDateEventTypeURLPath @"rules/eventDates/%@/%@"

// Log
#define kWADLServiceLogURLPath @"log"

// Customer
#define kWADLServiceCustomerURLPath @"customer"
#define kWADLServiceCustomerPartyIdURLPath @"customer/%@"
#define kWADLServiceCustomerPfURLPath @"customer/pf"
#define kWADLServiceCustomerSearchURLPath @"customer/search"
#define kWADLServiceCustomerValidateURLPath @"customer/validate"

// DashboardReportsStores
#define kWADLServiceDashboardReportsStoresURLPath @"dashboard/reports/stores"
#define kWADLServiceDashboardReportsStoresLaunchedStoresURLPath @"dashboard/reports/stores/launchedStores"

// Receipts
#define kWADLServiceReceiptsURLPath @"receipts"
#define kWADLServiceReceiptsMultiURLPath @"receipts/multi"

// Transaction
#define kWADLServiceTransactionURLPath @"transaction"
#define kWADLServiceTransactionAddFeeURLPath @"transaction/addFee"
#define kWADLServiceTransactionAddMarkdownURLPath @"transaction/addMarkdown"
#define kWADLServiceTransactionAddTaxExemptionURLPath @"transaction/addTaxExemption"
#define kWADLServiceTransactionApplyCouponURLPath @"transaction/applyCoupon"
#define kWADLServiceTransactionApplyPfDiscountURLPath @"transaction/applyPfDiscount"
#define kWADLServiceTransactionChangeItemsLostFeeURLPath @"transaction/changeItemsLostFee"
#define kWADLServiceTransactionChangeLateFeeURLPath @"transaction/changeLateFee"
#define kWADLServiceTransactionCreateURLPath @"transaction/create"
#define kWADLServiceTransactionCurrentURLPath @"transaction/current"
#define kWADLServiceTransactionEditMarkdownURLPath @"transaction/editMarkdown"
#define kWADLServiceTransactionFillLineItemsURLPath @"transaction/fillLineItems"
#define kWADLServiceTransactionFillLineItemsDropoffURLPath @"transaction/fillLineItemsDropoff"
#define kWADLServiceTransactionPostTuxDepositURLPath @"transaction/postTuxDeposit"
#define kWADLServiceTransactionPostTuxDropoffURLPath @"transaction/postTuxDropoff"
#define kWADLServiceTransactionPostvoidURLPath @"transaction/postvoid"
#define kWADLServiceTransactionRemoveMarkdownURLPath @"transaction/removeMarkdown"
#define kWADLServiceTransactionRemoveTaxExemptionURLPath @"transaction/removeTaxExemption"
#define kWADLServiceTransactionSetCustomerURLPath @"transaction/setCustomer"

// DashboardQuery
#define kWADLServiceDashboardQueryURLPath @"dashboard/query"
#define kWADLServiceDashboardQueryPosReservationURLPath @"dashboard/query/pos/reservation"
#define kWADLServiceDashboardQueryTuxoracleReservationReservationNoURLPath @"dashboard/query/tuxoracle/reservation/%@"
#define kWADLServiceDashboardQueryUniverseDeviceDeviceIdURLPath @"dashboard/query/universe/device/%@"

// DashboardReportsAdoption
#define kWADLServiceDashboardReportsAdoptionURLPath @"dashboard/reports/adoption"
#define kWADLServiceDashboardReportsAdoptionCommittedReservationsURLPath @"dashboard/reports/adoption/committedReservations"
#define kWADLServiceDashboardReportsAdoptionCreatedReservationsURLPath @"dashboard/reports/adoption/createdReservations"
#define kWADLServiceDashboardReportsAdoptionSendWeeklyReportsURLPath @"dashboard/reports/adoption/sendWeeklyReports"
#define kWADLServiceDashboardReportsAdoptionStatsExcelXlsURLPath @"dashboard/reports/adoption/statsExcel.xls"
#define kWADLServiceDashboardReportsAdoptionWeddingGroupsURLPath @"dashboard/reports/adoption/weddingGroups"
#define kWADLServiceDashboardReportsAdoptionWeeklyCommittedReportXlsxURLPath @"dashboard/reports/adoption/weeklyCommittedReport.xlsx"
#define kWADLServiceDashboardReportsAdoptionWeeklyWeddingReportXlsxURLPath @"dashboard/reports/adoption/weeklyWeddingReport.xlsx"

#pragma mark -

#endif
