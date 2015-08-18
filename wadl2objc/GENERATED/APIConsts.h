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
#define kWADLServiceDashboardReportsAdoptionWeeklyGroupReportXlsxURLPath @"dashboard/reports/adoption/weeklyGroupReport.xlsx"
#define kWADLServiceDashboardReportsAdoptionCommittedReservationsURLPath @"dashboard/reports/adoption/committedReservations"
#define kWADLServiceDashboardReportsAdoptionWeddingGroupsURLPath @"dashboard/reports/adoption/weddingGroups"
#define kWADLServiceDashboardReportsAdoptionCreatedReservationsURLPath @"dashboard/reports/adoption/createdReservations"
#define kWADLServiceDashboardReportsAdoptionURLPath @"dashboard/reports/adoption"

// DashboardQuery
#define kWADLServiceDashboardQueryURLPath @"dashboard/query"
#define kWADLServiceDashboardQueryPosReservationURLPath @"dashboard/query/pos/reservation"
#define kWADLServiceDashboardQueryTuxoracleReservationReservationNoURLPath @"dashboard/query/tuxoracle/reservation/%@"
#define kWADLServiceDashboardQueryUniverseDeviceDeviceIdURLPath @"dashboard/query/universe/device/%@"

// Transaction
#define kWADLServiceTransactionApplyCouponURLPath @"transaction/applyCoupon"
#define kWADLServiceTransactionChangeTaxExemptionURLPath @"transaction/changeTaxExemption"
#define kWADLServiceTransactionChangeLateFeeURLPath @"transaction/changeLateFee"
#define kWADLServiceTransactionPostTuxDropoffURLPath @"transaction/postTuxDropoff"
#define kWADLServiceTransactionChangeItemsLostFeeURLPath @"transaction/changeItemsLostFee"
#define kWADLServiceTransactionCreateURLPath @"transaction/create"
#define kWADLServiceTransactionSetCustomerURLPath @"transaction/setCustomer"
#define kWADLServiceTransactionRemoveTaxExemptionURLPath @"transaction/removeTaxExemption"
#define kWADLServiceTransactionURLPath @"transaction"
#define kWADLServiceTransactionFillLineItemsDropoffURLPath @"transaction/fillLineItemsDropoff"
#define kWADLServiceTransactionEditMarkdownURLPath @"transaction/editMarkdown"
#define kWADLServiceTransactionApplyPfDiscountURLPath @"transaction/applyPfDiscount"
#define kWADLServiceTransactionAddFeeURLPath @"transaction/addFee"
#define kWADLServiceTransactionAddTaxExemptionURLPath @"transaction/addTaxExemption"
#define kWADLServiceTransactionAddMarkdownURLPath @"transaction/addMarkdown"
#define kWADLServiceTransactionPostTuxDepositURLPath @"transaction/postTuxDeposit"
#define kWADLServiceTransactionPostvoidURLPath @"transaction/postvoid"
#define kWADLServiceTransactionPostTuxDropoffWithoutPaymentURLPath @"transaction/postTuxDropoffWithoutPayment"
#define kWADLServiceTransactionFillLineItemsURLPath @"transaction/fillLineItems"
#define kWADLServiceTransactionCurrentURLPath @"transaction/current"
#define kWADLServiceTransactionRemoveMarkdownURLPath @"transaction/removeMarkdown"

// Receipts
#define kWADLServiceReceiptsSearchDropoffReceiptsURLPath @"receipts/searchDropoffReceipts"
#define kWADLServiceReceiptsMultiURLPath @"receipts/multi"
#define kWADLServiceReceiptsDropoffNoBalanceURLPath @"receipts/dropoff/noBalance"
#define kWADLServiceReceiptsDropoffDcURLPath @"receipts/dropoff/dc"
#define kWADLServiceReceiptsURLPath @"receipts"
#define kWADLServiceReceiptsDropoffReprintURLPath @"receipts/dropoffReprint"
#define kWADLServiceReceiptsAppointmentsURLPath @"receipts/appointments"

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

// DashboardProperties
#define kWADLServiceDashboardPropertiesURLPath @"dashboard/properties"

// Pos
#define kWADLServicePosGiftCardValidateURLPath @"pos/giftCardValidate"
#define kWADLServicePosReservationReservationNoReservationPaymentsURLPath @"pos/reservation/%@/reservationPayments"
#define kWADLServicePosPosSummaryBatchURLPath @"pos/posSummary/batch"
#define kWADLServicePosReservationReservationNoMaxRefundURLPath @"pos/reservation/%@/maxRefund"
#define kWADLServicePosReservationReservationNoPosDetailsURLPath @"pos/reservation/%@/posDetails"
#define kWADLServicePosTxPostPickupURLPath @"pos/tx/postPickup"
#define kWADLServicePosFreeTuxPickupURLPath @"pos/freeTuxPickup"
#define kWADLServicePosMaxRefundURLPath @"pos/maxRefund"
#define kWADLServicePosReservationReservationNoPosGarmentsURLPath @"pos/reservation/%@/posGarments"
#define kWADLServicePosReservationPaymentsURLPath @"pos/reservationPayments"
#define kWADLServicePosVersionURLPath @"pos/version"
#define kWADLServicePosURLPath @"pos"
#define kWADLServicePosReservationReservationNoPosSummaryURLPath @"pos/reservation/%@/posSummary"

// Questionnaire
#define kWADLServiceQuestionnaireURLPath @"questionnaire"
#define kWADLServiceQuestionnaireStatusURLPath @"questionnaire/status"
#define kWADLServiceQuestionnaireQuestionnaireNameReservationReservationNoStatusURLPath @"questionnaire/%@/reservation/%@/status"
#define kWADLServiceQuestionnaireTitleQuestionsQuestionKeyOptionsURLPath @"questionnaire/%@/questions/%@/options"
#define kWADLServiceQuestionnaireAnswersURLPath @"questionnaire/answers"

// DashboardDiagnostic
#define kWADLServiceDashboardDiagnosticEmployeeAnonimousURLPath @"dashboard/diagnostic/employeeAnonimous"
#define kWADLServiceDashboardDiagnosticGiftcardURLPath @"dashboard/diagnostic/giftcard"
#define kWADLServiceDashboardDiagnosticTxwadminURLPath @"dashboard/diagnostic/txwadmin"
#define kWADLServiceDashboardDiagnosticTuxmobURLPath @"dashboard/diagnostic/tuxmob"
#define kWADLServiceDashboardDiagnosticPrinterURLPath @"dashboard/diagnostic/printer"
#define kWADLServiceDashboardDiagnosticFingerprintsURLPath @"dashboard/diagnostic/fingerprints"
#define kWADLServiceDashboardDiagnosticReservationURLPath @"dashboard/diagnostic/reservation"
#define kWADLServiceDashboardDiagnosticTuxoracleURLPath @"dashboard/diagnostic/tuxoracle"
#define kWADLServiceDashboardDiagnosticIsdURLPath @"dashboard/diagnostic/isd"
#define kWADLServiceDashboardDiagnosticGetregisterstateURLPath @"dashboard/diagnostic/getregisterstate"
#define kWADLServiceDashboardDiagnosticCustomerURLPath @"dashboard/diagnostic/customer"
#define kWADLServiceDashboardDiagnosticEmployeeURLPath @"dashboard/diagnostic/employee"
#define kWADLServiceDashboardDiagnosticVersionURLPath @"dashboard/diagnostic/version"
#define kWADLServiceDashboardDiagnosticGetcustomerURLPath @"dashboard/diagnostic/getcustomer"
#define kWADLServiceDashboardDiagnosticURLPath @"dashboard/diagnostic"
#define kWADLServiceDashboardDiagnosticGetErrorURLPath @"dashboard/diagnostic/getError"

// Search
#define kWADLServiceSearchGroupsURLPath @"search/groups"
#define kWADLServiceSearchReservationsURLPath @"search/reservations"
#define kWADLServiceSearchEventsURLPath @"search/events"
#define kWADLServiceSearchURLPath @"search"

// Inventory
#define kWADLServiceInventorySchoolsSchoolStSchoolCityURLPath @"inventory/schools/%@/%@"
#define kWADLServiceInventoryStoresURLPath @"inventory/stores"
#define kWADLServiceInventoryCatalogCatalogNoMeasurementsReservationNoURLPath @"inventory/catalog/%@/%@"
#define kWADLServiceInventoryStylesURLPath @"inventory/styles"
#define kWADLServiceInventoryAppointmentsIdURLPath @"inventory/appointments/%@"
#define kWADLServiceInventoryZipZipCodeURLPath @"inventory/zip/%@"
#define kWADLServiceInventoryStoresStoreNoURLPath @"inventory/stores/%@"
#define kWADLServiceInventoryAppointmentsURLPath @"inventory/appointments"
#define kWADLServiceInventoryPromoURLPath @"inventory/promo"
#define kWADLServiceInventorySizesURLPath @"inventory/sizes"
#define kWADLServiceInventorySchoolsURLPath @"inventory/schools"
#define kWADLServiceInventorySchoolsSchoolStURLPath @"inventory/schools/%@"
#define kWADLServiceInventoryStylesPricesURLPath @"inventory/styles/prices"
#define kWADLServiceInventoryStoresPickupURLPath @"inventory/stores/pickup"
#define kWADLServiceInventoryAppointmentsSearchURLPath @"inventory/appointments/search"
#define kWADLServiceInventoryCatalogsURLPath @"inventory/catalogs"
#define kWADLServiceInventorySchoolsSchoolNoURLPath @"inventory/schools/%@"
#define kWADLServiceInventoryPrintersURLPath @"inventory/printers"
#define kWADLServiceInventoryAppointmentsLeadURLPath @"inventory/appointments/lead"
#define kWADLServiceInventoryPrintersStoreNoURLPath @"inventory/printers/%@"
#define kWADLServiceInventoryStylesStyleNoURLPath @"inventory/styles/%@"
#define kWADLServiceInventoryDiscountURLPath @"inventory/discount"
#define kWADLServiceInventoryURLPath @"inventory"
#define kWADLServiceInventoryStoresReturnURLPath @"inventory/stores/return"

// Reservation
#define kWADLServiceReservationReservationNoValidateChangeURLPath @"reservation/%@/validateChange"
#define kWADLServiceReservationReservationNoSizeURLPath @"reservation/%@/size"
#define kWADLServiceReservationSummaryBatchURLPath @"reservation/summary/batch"
#define kWADLServiceReservationReservationNoPosSummaryURLPath @"reservation/%@/posSummary"
#define kWADLServiceReservationReservationNoHatpackageCatalogCodeURLPath @"reservation/%@/hatpackage/%@"
#define kWADLServiceReservationAssignStylesToURLPath @"reservation/assignStylesTo"
#define kWADLServiceReservationReservationNoValidateURLPath @"reservation/%@/validate"
#define kWADLServiceReservationReservationNoCopyStylesToURLPath @"reservation/%@/copyStylesTo"
#define kWADLServiceReservationReservationNoStylesLineNoURLPath @"reservation/%@/styles/%@"
#define kWADLServiceReservationReservationNoChangeURLPath @"reservation/%@/change"
#define kWADLServiceReservationReservationNoSizesURLPath @"reservation/%@/sizes"
#define kWADLServiceReservationReservationNoStylesURLPath @"reservation/%@/styles"
#define kWADLServiceReservationReservationNoHatpackageURLPath @"reservation/%@/hatpackage"
#define kWADLServiceReservationURLPath @"reservation"
#define kWADLServiceReservationReservationNoSummaryURLPath @"reservation/%@/summary"
#define kWADLServiceReservationReservationNoChangeLogisticsURLPath @"reservation/%@/changeLogistics"
#define kWADLServiceReservationReservationNoReorderStatusURLPath @"reservation/%@/reorderStatus"
#define kWADLServiceReservationReservationNoCommitURLPath @"reservation/%@/commit"
#define kWADLServiceReservationReservationNoMeasurementURLPath @"reservation/%@/measurement"
#define kWADLServiceReservationReservationNoURLPath @"reservation/%@"
#define kWADLServiceReservationShippingAddressURLPath @"reservation/shipping/address"
#define kWADLServiceReservationReservationNoLogisticURLPath @"reservation/%@/logistic"
#define kWADLServiceReservationReservationNoOffersDiscountURLPath @"reservation/%@/offers/discount"
#define kWADLServiceReservationReservationNoOffersURLPath @"reservation/%@/offers"
#define kWADLServiceReservationReservationNoFavoritesURLPath @"reservation/%@/favorites"
#define kWADLServiceReservationReservationNoReferencesURLPath @"reservation/%@/references"

// Tender
#define kWADLServiceTenderCaptureSignatureURLPath @"tender/captureSignature"
#define kWADLServiceTenderAuthorizeURLPath @"tender/authorize"
#define kWADLServiceTenderLookupURLPath @"tender/lookup"
#define kWADLServiceTenderURLPath @"tender"

// DashboardRawDiscounts
#define kWADLServiceDashboardRawDiscountsCodeURLPath @"dashboard/raw/discounts/%@"
#define kWADLServiceDashboardRawDiscountsCodeDescriptionURLPath @"dashboard/raw/discounts/%@/description"
#define kWADLServiceDashboardRawDiscountsURLPath @"dashboard/raw/discounts"

// Testing
#define kWADLServiceTestingReservationPreparedURLPath @"testing/reservation/prepared"
#define kWADLServiceTestingURLPath @"testing"
#define kWADLServiceTestingPosTransactionNumberURLPath @"testing/pos/%@"
#define kWADLServiceTestingReservationReservationNoShipURLPath @"testing/reservation/%@/ship"

// Groups
#define kWADLServiceGroupsGroupIdSummaryURLPath @"groups/%@/summary"
#define kWADLServiceGroupsGroupIdAddReservationsURLPath @"groups/%@/addReservations"
#define kWADLServiceGroupsGroupIdWeddingCallURLPath @"groups/%@/weddingCall"
#define kWADLServiceGroupsGroupIdOffersFreeSuitReservationNoURLPath @"groups/%@/offers/freeSuit/%@"
#define kWADLServiceGroupsGroupIdOffersURLPath @"groups/%@/offers"
#define kWADLServiceGroupsWeddingCallListURLPath @"groups/weddingCallList"
#define kWADLServiceGroupsGroupIdURLPath @"groups/%@"
#define kWADLServiceGroupsGroupIdCallLogURLPath @"groups/%@/callLog"
#define kWADLServiceGroupsGroupIdReservationsURLPath @"groups/%@/reservations"
#define kWADLServiceGroupsGroupIdOffersFreeTuxReservationNoURLPath @"groups/%@/offers/freeTux/%@"
#define kWADLServiceGroupsGroupIdOffersDiscountURLPath @"groups/%@/offers/discount"
#define kWADLServiceGroupsBridalShowCallsGroupIdURLPath @"groups/bridalShowCalls/%@"
#define kWADLServiceGroupsGroupIdFavoritesURLPath @"groups/%@/favorites"
#define kWADLServiceGroupsURLPath @"groups"
#define kWADLServiceGroupsGroupIdLogisticURLPath @"groups/%@/logistic"
#define kWADLServiceGroupsGroupIdCallLogsURLPath @"groups/%@/callLogs"
#define kWADLServiceGroupsBridalShowCallsURLPath @"groups/bridalShowCalls"
#define kWADLServiceGroupsGroupIdOffersPromoCodeURLPath @"groups/%@/offers/promoCode"
#define kWADLServiceGroupsBatchURLPath @"groups/batch"

// Auth
#define kWADLServiceAuthDashboardURLPath @"auth/dashboard"
#define kWADLServiceAuthManagerPermissionUserPermissionURLPath @"auth/manager/permission/%@"
#define kWADLServiceAuthURLPath @"auth"
#define kWADLServiceAuthManagerURLPath @"auth/manager"
#define kWADLServiceAuthStoreURLPath @"auth/store"
#define kWADLServiceAuthUserURLPath @"auth/user"

#pragma mark -

#endif
