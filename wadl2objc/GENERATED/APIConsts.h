//
//  APIConsts.h
//
//  Created by wadl2objc
//

#ifndef wadl2objc_APIConsts_h
#define wadl2objc_APIConsts_h

#pragma mark - Generated Services

// DashboardReportsAdoption
#define kWADLServiceDashboardReportsAdoptionStatsExcelXlsURLPath @"dashboard/reports/adoption/statsExcel.xls"
#define kWADLServiceDashboardReportsAdoptionSendWeeklyReportsURLPath @"dashboard/reports/adoption/sendWeeklyReports"
#define kWADLServiceDashboardReportsAdoptionWeeklyCommittedReportXlsxURLPath @"dashboard/reports/adoption/weeklyCommittedReport.xlsx"
#define kWADLServiceDashboardReportsAdoptionWeddingGroupsURLPath @"dashboard/reports/adoption/weddingGroups"
#define kWADLServiceDashboardReportsAdoptionWeeklyWeddingReportXlsxURLPath @"dashboard/reports/adoption/weeklyWeddingReport.xlsx"
#define kWADLServiceDashboardReportsAdoptionCommittedReservationsURLPath @"dashboard/reports/adoption/committedReservations"
#define kWADLServiceDashboardReportsAdoptionCreatedReservationsURLPath @"dashboard/reports/adoption/createdReservations"
#define kWADLServiceDashboardReportsAdoptionURLPath @"dashboard/reports/adoption"

// DashboardQuery
#define kWADLServiceDashboardQueryURLPath @"dashboard/query"
#define kWADLServiceDashboardQueryTuxoracleReservationReservationNoURLPath @"dashboard/query/tuxoracle/reservation/%@"
#define kWADLServiceDashboardQueryPosReservationURLPath @"dashboard/query/pos/reservation"
#define kWADLServiceDashboardQueryUniverseDeviceDeviceIdURLPath @"dashboard/query/universe/device/%@"

// Transaction
#define kWADLServiceTransactionURLPath @"transaction"
#define kWADLServiceTransactionEditMarkdownURLPath @"transaction/editMarkdown"
#define kWADLServiceTransactionCreateURLPath @"transaction/create"
#define kWADLServiceTransactionPostvoidURLPath @"transaction/postvoid"
#define kWADLServiceTransactionSetCustomerURLPath @"transaction/setCustomer"
#define kWADLServiceTransactionApplyPfDiscountURLPath @"transaction/applyPfDiscount"
#define kWADLServiceTransactionAddTaxExemptionURLPath @"transaction/addTaxExemption"
#define kWADLServiceTransactionChangeItemsLostFeeURLPath @"transaction/changeItemsLostFee"
#define kWADLServiceTransactionApplyCouponURLPath @"transaction/applyCoupon"
#define kWADLServiceTransactionChangeLateFeeURLPath @"transaction/changeLateFee"
#define kWADLServiceTransactionFillLineItemsDropoffURLPath @"transaction/fillLineItemsDropoff"
#define kWADLServiceTransactionAddFeeURLPath @"transaction/addFee"
#define kWADLServiceTransactionAddMarkdownURLPath @"transaction/addMarkdown"
#define kWADLServiceTransactionPostTuxDepositURLPath @"transaction/postTuxDeposit"
#define kWADLServiceTransactionCurrentURLPath @"transaction/current"
#define kWADLServiceTransactionPostTuxDropoffURLPath @"transaction/postTuxDropoff"
#define kWADLServiceTransactionRemoveTaxExemptionURLPath @"transaction/removeTaxExemption"
#define kWADLServiceTransactionFillLineItemsURLPath @"transaction/fillLineItems"
#define kWADLServiceTransactionRemoveMarkdownURLPath @"transaction/removeMarkdown"

// Receipts
#define kWADLServiceReceiptsMultiURLPath @"receipts/multi"
#define kWADLServiceReceiptsURLPath @"receipts"

// DashboardReportsStores
#define kWADLServiceDashboardReportsStoresLaunchedStoresURLPath @"dashboard/reports/stores/launchedStores"
#define kWADLServiceDashboardReportsStoresURLPath @"dashboard/reports/stores"

// Customer
#define kWADLServiceCustomerValidateURLPath @"customer/validate"
#define kWADLServiceCustomerPartyIdURLPath @"customer/%@"
#define kWADLServiceCustomerSearchURLPath @"customer/search"
#define kWADLServiceCustomerPfURLPath @"customer/pf"
#define kWADLServiceCustomerURLPath @"customer"

// Log
#define kWADLServiceLogURLPath @"log"

// Rules
#define kWADLServiceRulesURLPath @"rules"
#define kWADLServiceRulesEventDatesEventDateURLPath @"rules/eventDates/%@"
#define kWADLServiceRulesEventDatesEventDateEventTypeURLPath @"rules/eventDates/%@/%@"

// Pos
#define kWADLServicePosGiftCardValidateURLPath @"pos/giftCardValidate"
#define kWADLServicePosReservationReservationNoReservationPaymentsURLPath @"pos/reservation/%@/reservationPayments"
#define kWADLServicePosReservationReservationNoMaxRefundURLPath @"pos/reservation/%@/maxRefund"
#define kWADLServicePosReservationReservationNoPosDetailsURLPath @"pos/reservation/%@/posDetails"
#define kWADLServicePosTxPostPickupURLPath @"pos/tx/postPickup"
#define kWADLServicePosFreeTuxPickupURLPath @"pos/freeTuxPickup"
#define kWADLServicePosReservationReservationNoPosGarmentsURLPath @"pos/reservation/%@/posGarments"
#define kWADLServicePosReservationPaymentsURLPath @"pos/reservationPayments"
#define kWADLServicePosMaxRefundURLPath @"pos/maxRefund"
#define kWADLServicePosVersionURLPath @"pos/version"
#define kWADLServicePosURLPath @"pos"
#define kWADLServicePosReservationReservationNoPosSummaryURLPath @"pos/reservation/%@/posSummary"

// DashboardDiagnostic
#define kWADLServiceDashboardDiagnosticGiftcardURLPath @"dashboard/diagnostic/giftcard"
#define kWADLServiceDashboardDiagnosticEmployeeAnonimousURLPath @"dashboard/diagnostic/employeeAnonimous"
#define kWADLServiceDashboardDiagnosticTxwadminURLPath @"dashboard/diagnostic/txwadmin"
#define kWADLServiceDashboardDiagnosticReservationURLPath @"dashboard/diagnostic/reservation"
#define kWADLServiceDashboardDiagnosticPrinterURLPath @"dashboard/diagnostic/printer"
#define kWADLServiceDashboardDiagnosticFingerprintsURLPath @"dashboard/diagnostic/fingerprints"
#define kWADLServiceDashboardDiagnosticGetErrorURLPath @"dashboard/diagnostic/getError"
#define kWADLServiceDashboardDiagnosticTuxmobURLPath @"dashboard/diagnostic/tuxmob"
#define kWADLServiceDashboardDiagnosticGetregisterstateURLPath @"dashboard/diagnostic/getregisterstate"
#define kWADLServiceDashboardDiagnosticCustomerURLPath @"dashboard/diagnostic/customer"
#define kWADLServiceDashboardDiagnosticEmployeeURLPath @"dashboard/diagnostic/employee"
#define kWADLServiceDashboardDiagnosticVersionURLPath @"dashboard/diagnostic/version"
#define kWADLServiceDashboardDiagnosticGetcustomerURLPath @"dashboard/diagnostic/getcustomer"
#define kWADLServiceDashboardDiagnosticTuxoracleURLPath @"dashboard/diagnostic/tuxoracle"
#define kWADLServiceDashboardDiagnosticURLPath @"dashboard/diagnostic"

// Search
#define kWADLServiceSearchGroupsURLPath @"search/groups"
#define kWADLServiceSearchReservationsURLPath @"search/reservations"
#define kWADLServiceSearchEventsURLPath @"search/events"
#define kWADLServiceSearchURLPath @"search"

// Inventory
#define kWADLServiceInventoryCatalogsURLPath @"inventory/catalogs"
#define kWADLServiceInventoryStylesStyleNoURLPath @"inventory/styles/%@"
#define kWADLServiceInventorySizesURLPath @"inventory/sizes"
#define kWADLServiceInventoryDiscountURLPath @"inventory/discount"
#define kWADLServiceInventoryStoresURLPath @"inventory/stores"
#define kWADLServiceInventorySchoolsSchoolStURLPath @"inventory/schools/%@"
#define kWADLServiceInventoryStylesURLPath @"inventory/styles"
#define kWADLServiceInventoryCatalogCatalogNoMeasurementsReservationNoURLPath @"inventory/catalog/%@/%@"
#define kWADLServiceInventorySchoolsURLPath @"inventory/schools"
#define kWADLServiceInventoryStoresReturnURLPath @"inventory/stores/return"
#define kWADLServiceInventoryStoresPickupURLPath @"inventory/stores/pickup"
#define kWADLServiceInventorySchoolsSchoolNoURLPath @"inventory/schools/%@"
#define kWADLServiceInventorySchoolsSchoolStSchoolCityURLPath @"inventory/schools/%@/%@"
#define kWADLServiceInventoryPrintersURLPath @"inventory/printers"
#define kWADLServiceInventoryURLPath @"inventory"
#define kWADLServiceInventoryStoresStoreNoURLPath @"inventory/stores/%@"
#define kWADLServiceInventoryPrintersStoreNoURLPath @"inventory/printers/%@"

// Reservation
#define kWADLServiceReservationReservationNoValidateChangeURLPath @"reservation/%@/validateChange"
#define kWADLServiceReservationReservationNoSizeURLPath @"reservation/%@/size"
#define kWADLServiceReservationReservationNoPosSummaryURLPath @"reservation/%@/posSummary"
#define kWADLServiceReservationReservationNoHatpackageCatalogCodeURLPath @"reservation/%@/hatpackage/%@"
#define kWADLServiceReservationAssignStylesToURLPath @"reservation/assignStylesTo"
#define kWADLServiceReservationReservationNoCopyStylesToURLPath @"reservation/%@/copyStylesTo"
#define kWADLServiceReservationReservationNoValidateURLPath @"reservation/%@/validate"
#define kWADLServiceReservationReservationNoStylesLineNoURLPath @"reservation/%@/styles/%@"
#define kWADLServiceReservationReservationNoChangeURLPath @"reservation/%@/change"
#define kWADLServiceReservationReservationNoSizesURLPath @"reservation/%@/sizes"
#define kWADLServiceReservationReservationNoStylesURLPath @"reservation/%@/styles"
#define kWADLServiceReservationReservationNoHatpackageURLPath @"reservation/%@/hatpackage"
#define kWADLServiceReservationURLPath @"reservation"
#define kWADLServiceReservationReservationNoSummaryURLPath @"reservation/%@/summary"
#define kWADLServiceReservationReservationNoMeasurementURLPath @"reservation/%@/measurement"
#define kWADLServiceReservationReservationNoChangeLogisticsURLPath @"reservation/%@/changeLogistics"
#define kWADLServiceReservationReservationNoURLPath @"reservation/%@"
#define kWADLServiceReservationReservationNoCommitURLPath @"reservation/%@/commit"
#define kWADLServiceReservationReservationNoReorderStatusURLPath @"reservation/%@/reorderStatus"
#define kWADLServiceReservationReservationNoLogisticURLPath @"reservation/%@/logistic"
#define kWADLServiceReservationReservationNoOffersDiscountURLPath @"reservation/%@/offers/discount"
#define kWADLServiceReservationReservationNoOffersURLPath @"reservation/%@/offers"
#define kWADLServiceReservationReservationNoFavoritesURLPath @"reservation/%@/favorites"
#define kWADLServiceReservationReservationNoReferencesURLPath @"reservation/%@/references"

// Tender
#define kWADLServiceTenderLookupURLPath @"tender/lookup"
#define kWADLServiceTenderAuthorizeURLPath @"tender/authorize"
#define kWADLServiceTenderURLPath @"tender"
#define kWADLServiceTenderCaptureSignatureURLPath @"tender/captureSignature"

// DashboardRawDiscounts
#define kWADLServiceDashboardRawDiscountsCodeDescriptionURLPath @"dashboard/raw/discounts/%@/description"
#define kWADLServiceDashboardRawDiscountsCodeURLPath @"dashboard/raw/discounts/%@"
#define kWADLServiceDashboardRawDiscountsURLPath @"dashboard/raw/discounts"

// Testing
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithZeroBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipFreeTuxWithZeroBalance/%@"
#define kWADLServiceTestingReservationReservationNoShipURLPath @"testing/reservation/%@/ship"
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithNegativeBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipFreeTuxWithNegativeBalance/%@"
#define kWADLServiceTestingReservationPreparedForShipWithNegativeBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipWithNegativeBalance/%@"
#define kWADLServiceTestingPosTransactionNumberURLPath @"testing/pos/%@"
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithNegativeBalanceURLPath @"testing/reservation/prepared/forShipFreeTuxWithNegativeBalance"
#define kWADLServiceTestingReservationPreparedForShipWithZeroBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipWithZeroBalance/%@"
#define kWADLServiceTestingReservationPreparedForShipWithPositiveBalanceShipToStoreURLPath @"testing/reservation/prepared/forShipWithPositiveBalance/%@"
#define kWADLServiceTestingReservationPreparedForShipWithNegativeBalanceURLPath @"testing/reservation/prepared/forShipWithNegativeBalance"
#define kWADLServiceTestingReservationPreparedNotPayedURLPath @"testing/reservation/prepared/notPayed"
#define kWADLServiceTestingURLPath @"testing"
#define kWADLServiceTestingReservationPreparedForShipFreeTuxWithZeroBalanceURLPath @"testing/reservation/prepared/forShipFreeTuxWithZeroBalance"
#define kWADLServiceTestingReservationPreparedForShipWithPositiveBalanceURLPath @"testing/reservation/prepared/forShipWithPositiveBalance"
#define kWADLServiceTestingReservationPreparedForShipWithZeroBalanceURLPath @"testing/reservation/prepared/forShipWithZeroBalance"

// Groups
#define kWADLServiceGroupsGroupIdOffersFreeSuitReservationNoURLPath @"groups/%@/offers/freeSuit/%@"
#define kWADLServiceGroupsGroupIdAddReservationsURLPath @"groups/%@/addReservations"
#define kWADLServiceGroupsGroupIdWeddingCallURLPath @"groups/%@/weddingCall"
#define kWADLServiceGroupsGroupIdSummaryURLPath @"groups/%@/summary"
#define kWADLServiceGroupsGroupIdReservationsURLPath @"groups/%@/reservations"
#define kWADLServiceGroupsWeddingCallListURLPath @"groups/weddingCallList"
#define kWADLServiceGroupsGroupIdCallLogURLPath @"groups/%@/callLog"
#define kWADLServiceGroupsGroupIdURLPath @"groups/%@"
#define kWADLServiceGroupsGroupIdOffersURLPath @"groups/%@/offers"
#define kWADLServiceGroupsGroupIdOffersFreeTuxReservationNoURLPath @"groups/%@/offers/freeTux/%@"
#define kWADLServiceGroupsGroupIdOffersDiscountURLPath @"groups/%@/offers/discount"
#define kWADLServiceGroupsBridalShowCallsGroupIdURLPath @"groups/bridalShowCalls/%@"
#define kWADLServiceGroupsGroupIdFavoritesURLPath @"groups/%@/favorites"
#define kWADLServiceGroupsURLPath @"groups"
#define kWADLServiceGroupsGroupIdCallLogsURLPath @"groups/%@/callLogs"
#define kWADLServiceGroupsGroupIdLogisticURLPath @"groups/%@/logistic"
#define kWADLServiceGroupsBridalShowCallsURLPath @"groups/bridalShowCalls"
#define kWADLServiceGroupsGroupIdOffersPromoCodeURLPath @"groups/%@/offers/promoCode"

// Auth
#define kWADLServiceAuthDashboardURLPath @"auth/dashboard"
#define kWADLServiceAuthManagerPermissionUserPermissionURLPath @"auth/manager/permission/%@"
#define kWADLServiceAuthURLPath @"auth"
#define kWADLServiceAuthManagerURLPath @"auth/manager"
#define kWADLServiceAuthStoreURLPath @"auth/store"
#define kWADLServiceAuthUserURLPath @"auth/user"

#pragma mark -

#endif
