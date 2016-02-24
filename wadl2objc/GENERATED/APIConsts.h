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

// Customer
#define kWADLServiceCustomerURLPath @"customer"
#define kWADLServiceCustomerPartyIdURLPath @"customer/%@"
#define kWADLServiceCustomerPfURLPath @"customer/pf"
#define kWADLServiceCustomerSearchURLPath @"customer/search"
#define kWADLServiceCustomerValidateURLPath @"customer/validate"

// DashboardDiagnostic
#define kWADLServiceDashboardDiagnosticURLPath @"dashboard/diagnostic"
#define kWADLServiceDashboardDiagnosticAddressURLPath @"dashboard/diagnostic/address"
#define kWADLServiceDashboardDiagnosticCustomerURLPath @"dashboard/diagnostic/customer"
#define kWADLServiceDashboardDiagnosticEmployeeURLPath @"dashboard/diagnostic/employee"
#define kWADLServiceDashboardDiagnosticEmployeeAnonimousURLPath @"dashboard/diagnostic/employeeAnonimous"
#define kWADLServiceDashboardDiagnosticFingerprintsURLPath @"dashboard/diagnostic/fingerprints"
#define kWADLServiceDashboardDiagnosticGetErrorURLPath @"dashboard/diagnostic/getError"
#define kWADLServiceDashboardDiagnosticGetcustomerURLPath @"dashboard/diagnostic/getcustomer"
#define kWADLServiceDashboardDiagnosticGetregisterstateURLPath @"dashboard/diagnostic/getregisterstate"
#define kWADLServiceDashboardDiagnosticGiftcardURLPath @"dashboard/diagnostic/giftcard"
#define kWADLServiceDashboardDiagnosticIsdURLPath @"dashboard/diagnostic/isd"
#define kWADLServiceDashboardDiagnosticPipeURLPath @"dashboard/diagnostic/pipe"
#define kWADLServiceDashboardDiagnosticPrinterURLPath @"dashboard/diagnostic/printer"
#define kWADLServiceDashboardDiagnosticReservationURLPath @"dashboard/diagnostic/reservation"
#define kWADLServiceDashboardDiagnosticTuxmobURLPath @"dashboard/diagnostic/tuxmob"
#define kWADLServiceDashboardDiagnosticTuxoracleURLPath @"dashboard/diagnostic/tuxoracle"
#define kWADLServiceDashboardDiagnosticTxwadminURLPath @"dashboard/diagnostic/txwadmin"
#define kWADLServiceDashboardDiagnosticVersionURLPath @"dashboard/diagnostic/version"

// DashboardJob
#define kWADLServiceDashboardJobURLPath @"dashboard/job"
#define kWADLServiceDashboardJobDetailsURLPath @"dashboard/job/details"
#define kWADLServiceDashboardJobJobKeyDisableURLPath @"dashboard/job/%@/disable"
#define kWADLServiceDashboardJobJobKeyEnableURLPath @"dashboard/job/%@/enable"
#define kWADLServiceDashboardJobJobKeyRunURLPath @"dashboard/job/%@/run"

// DashboardProperties
#define kWADLServiceDashboardPropertiesURLPath @"dashboard/properties"

// DashboardQuery
#define kWADLServiceDashboardQueryURLPath @"dashboard/query"
#define kWADLServiceDashboardQueryPosReservationURLPath @"dashboard/query/pos/reservation"
#define kWADLServiceDashboardQueryTuxoracleReservationReservationNoURLPath @"dashboard/query/tuxoracle/reservation/%@"
#define kWADLServiceDashboardQueryUniverseDeviceDeviceIdURLPath @"dashboard/query/universe/device/%@"

// DashboardQuestionnaire
#define kWADLServiceDashboardQuestionnaireURLPath @"dashboard/questionnaire"
#define kWADLServiceDashboardQuestionnaireResultURLPath @"dashboard/questionnaire/result"
#define kWADLServiceDashboardQuestionnaireResultsSendURLPath @"dashboard/questionnaire/results/send"

// DashboardRawDiscounts
#define kWADLServiceDashboardRawDiscountsURLPath @"dashboard/raw/discounts"
#define kWADLServiceDashboardRawDiscountsCodeURLPath @"dashboard/raw/discounts/%@"
#define kWADLServiceDashboardRawDiscountsCodeDescriptionURLPath @"dashboard/raw/discounts/%@/description"

// DashboardReportsAdoption
#define kWADLServiceDashboardReportsAdoptionURLPath @"dashboard/reports/adoption"
#define kWADLServiceDashboardReportsAdoptionCommittedReservationsURLPath @"dashboard/reports/adoption/committedReservations"
#define kWADLServiceDashboardReportsAdoptionCreatedReservationsURLPath @"dashboard/reports/adoption/createdReservations"
#define kWADLServiceDashboardReportsAdoptionSendWeeklyReportsURLPath @"dashboard/reports/adoption/sendWeeklyReports"
#define kWADLServiceDashboardReportsAdoptionStatsExcelXlsURLPath @"dashboard/reports/adoption/statsExcel.xls"
#define kWADLServiceDashboardReportsAdoptionWeddingGroupsURLPath @"dashboard/reports/adoption/weddingGroups"
#define kWADLServiceDashboardReportsAdoptionWeeklyCommittedReportXlsxURLPath @"dashboard/reports/adoption/weeklyCommittedReport.xlsx"
#define kWADLServiceDashboardReportsAdoptionWeeklyGroupReportXlsxURLPath @"dashboard/reports/adoption/weeklyGroupReport.xlsx"

// DashboardReportsStores
#define kWADLServiceDashboardReportsStoresURLPath @"dashboard/reports/stores"
#define kWADLServiceDashboardReportsStoresLaunchedStoresURLPath @"dashboard/reports/stores/launchedStores"

// Groups
#define kWADLServiceGroupsURLPath @"groups"
#define kWADLServiceGroupsBatchURLPath @"groups/batch"
#define kWADLServiceGroupsBridalShowCallsURLPath @"groups/bridalShowCalls"
#define kWADLServiceGroupsBridalShowCallsGroupIdURLPath @"groups/bridalShowCalls/%@"
#define kWADLServiceGroupsGroupIdURLPath @"groups/%@"
#define kWADLServiceGroupsGroupIdAddReservationsURLPath @"groups/%@/addReservations"
#define kWADLServiceGroupsGroupIdCallLogURLPath @"groups/%@/callLog"
#define kWADLServiceGroupsGroupIdCallLogsURLPath @"groups/%@/callLogs"
#define kWADLServiceGroupsGroupIdFavoritesURLPath @"groups/%@/favorites"
#define kWADLServiceGroupsGroupIdLogisticURLPath @"groups/%@/logistic"
#define kWADLServiceGroupsGroupIdNotFittedReservationsURLPath @"groups/%@/notFittedReservations"
#define kWADLServiceGroupsGroupIdOffersURLPath @"groups/%@/offers"
#define kWADLServiceGroupsGroupIdOffersDiscountURLPath @"groups/%@/offers/discount"
#define kWADLServiceGroupsGroupIdOffersFreeSuitReservationNoURLPath @"groups/%@/offers/freeSuit/%@"
#define kWADLServiceGroupsGroupIdOffersFreeTuxReservationNoURLPath @"groups/%@/offers/freeTux/%@"
#define kWADLServiceGroupsGroupIdOffersPromoCodeURLPath @"groups/%@/offers/promoCode"
#define kWADLServiceGroupsGroupIdReservationsURLPath @"groups/%@/reservations"
#define kWADLServiceGroupsGroupIdSummaryURLPath @"groups/%@/summary"
#define kWADLServiceGroupsGroupIdWeddingCallURLPath @"groups/%@/weddingCall"
#define kWADLServiceGroupsWeddingCallListURLPath @"groups/weddingCallList"

// Inventory
#define kWADLServiceInventoryURLPath @"inventory"
#define kWADLServiceInventoryAppointmentsURLPath @"inventory/appointments"
#define kWADLServiceInventoryAppointmentsCheckIdURLPath @"inventory/appointments/check/%@"
#define kWADLServiceInventoryAppointmentsIdURLPath @"inventory/appointments/%@"
#define kWADLServiceInventoryAppointmentsLeadURLPath @"inventory/appointments/lead"
#define kWADLServiceInventoryAppointmentsSearchURLPath @"inventory/appointments/search"
#define kWADLServiceInventoryCatalogCatalogNoMeasurementsReservationNoURLPath @"inventory/catalog/%@/%@"
#define kWADLServiceInventoryCatalogsURLPath @"inventory/catalogs"
#define kWADLServiceInventoryDiscountURLPath @"inventory/discount"
#define kWADLServiceInventoryPrintersURLPath @"inventory/printers"
#define kWADLServiceInventoryPrintersStoreNoURLPath @"inventory/printers/%@"
#define kWADLServiceInventoryPromoURLPath @"inventory/promo"
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
#define kWADLServiceInventoryStylesPricesURLPath @"inventory/styles/prices"
#define kWADLServiceInventoryStylesStyleNoURLPath @"inventory/styles/%@"
#define kWADLServiceInventoryZipZipCodeURLPath @"inventory/zip/%@"

// Log
#define kWADLServiceLogURLPath @"log"

// Pos
#define kWADLServicePosURLPath @"pos"
#define kWADLServicePosFreeTuxPickupURLPath @"pos/freeTuxPickup"
#define kWADLServicePosGiftCardValidateURLPath @"pos/giftCardValidate"
#define kWADLServicePosMaxRefundURLPath @"pos/maxRefund"
#define kWADLServicePosPosSummaryBatchURLPath @"pos/posSummary/batch"
#define kWADLServicePosReservationPaymentDetailsURLPath @"pos/reservation/paymentDetails"
#define kWADLServicePosReservationPaymentsURLPath @"pos/reservationPayments"
#define kWADLServicePosReservationReservationNoMaxRefundURLPath @"pos/reservation/%@/maxRefund"
#define kWADLServicePosReservationReservationNoPosDetailsURLPath @"pos/reservation/%@/posDetails"
#define kWADLServicePosReservationReservationNoPosGarmentsURLPath @"pos/reservation/%@/posGarments"
#define kWADLServicePosReservationReservationNoPosSummaryURLPath @"pos/reservation/%@/posSummary"
#define kWADLServicePosReservationReservationNoReservationPaymentsURLPath @"pos/reservation/%@/reservationPayments"
#define kWADLServicePosTxPostPickupURLPath @"pos/tx/postPickup"
#define kWADLServicePosVersionURLPath @"pos/version"

// Questionnaire
#define kWADLServiceQuestionnaireURLPath @"questionnaire"
#define kWADLServiceQuestionnaireAnswersURLPath @"questionnaire/answers"
#define kWADLServiceQuestionnaireQuestionnaireNameReservationReservationNoStatusURLPath @"questionnaire/%@/reservation/%@/status"
#define kWADLServiceQuestionnaireStatusURLPath @"questionnaire/status"
#define kWADLServiceQuestionnaireTitleQuestionsQuestionKeyOptionsURLPath @"questionnaire/%@/questions/%@/options"

// Receipts
#define kWADLServiceReceiptsURLPath @"receipts"
#define kWADLServiceReceiptsAppointmentsURLPath @"receipts/appointments"
#define kWADLServiceReceiptsDropoffDcURLPath @"receipts/dropoff/dc"
#define kWADLServiceReceiptsDropoffNoBalanceURLPath @"receipts/dropoff/noBalance"
#define kWADLServiceReceiptsDropoffReprintURLPath @"receipts/dropoffReprint"
#define kWADLServiceReceiptsMultiURLPath @"receipts/multi"
#define kWADLServiceReceiptsSearchDropoffReceiptsURLPath @"receipts/searchDropoffReceipts"

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
#define kWADLServiceReservationShippingAddressURLPath @"reservation/shipping/address"
#define kWADLServiceReservationSummaryBatchURLPath @"reservation/summary/batch"

// Rules
#define kWADLServiceRulesURLPath @"rules"
#define kWADLServiceRulesEventDatesEventDateURLPath @"rules/eventDates/%@"
#define kWADLServiceRulesEventDatesEventDateEventTypeURLPath @"rules/eventDates/%@/%@"

// Search
#define kWADLServiceSearchURLPath @"search"
#define kWADLServiceSearchEventsURLPath @"search/events"
#define kWADLServiceSearchGroupsURLPath @"search/groups"
#define kWADLServiceSearchReservationsURLPath @"search/reservations"

// Tender
#define kWADLServiceTenderURLPath @"tender"
#define kWADLServiceTenderAuthorizeURLPath @"tender/authorize"
#define kWADLServiceTenderCaptureSignatureURLPath @"tender/captureSignature"
#define kWADLServiceTenderLookupURLPath @"tender/lookup"

// Testing
#define kWADLServiceTestingURLPath @"testing"
#define kWADLServiceTestingPosTransactionNumberURLPath @"testing/pos/%@"
#define kWADLServiceTestingReservationPreparedURLPath @"testing/reservation/prepared"
#define kWADLServiceTestingReservationReservationNoShipURLPath @"testing/reservation/%@/ship"
#define kWADLServiceTestingTenderBlobURLPath @"testing/tender/blob"
#define kWADLServiceTestingTuxonlineTokenURLPath @"testing/tuxonline/token"

// Transaction
#define kWADLServiceTransactionURLPath @"transaction"
#define kWADLServiceTransactionAddFeeURLPath @"transaction/addFee"
#define kWADLServiceTransactionAddMarkdownURLPath @"transaction/addMarkdown"
#define kWADLServiceTransactionAddTaxExemptionURLPath @"transaction/addTaxExemption"
#define kWADLServiceTransactionApplyCouponURLPath @"transaction/applyCoupon"
#define kWADLServiceTransactionApplyPfDiscountURLPath @"transaction/applyPfDiscount"
#define kWADLServiceTransactionChangeItemsLostFeeURLPath @"transaction/changeItemsLostFee"
#define kWADLServiceTransactionChangeLateFeeURLPath @"transaction/changeLateFee"
#define kWADLServiceTransactionChangeTaxExemptionURLPath @"transaction/changeTaxExemption"
#define kWADLServiceTransactionCreateURLPath @"transaction/create"
#define kWADLServiceTransactionCurrentURLPath @"transaction/current"
#define kWADLServiceTransactionEditMarkdownURLPath @"transaction/editMarkdown"
#define kWADLServiceTransactionFillLineItemsURLPath @"transaction/fillLineItems"
#define kWADLServiceTransactionFillLineItemsDropoffURLPath @"transaction/fillLineItemsDropoff"
#define kWADLServiceTransactionPostResultURLPath @"transaction/postResult"
#define kWADLServiceTransactionPostTuxDepositURLPath @"transaction/postTuxDeposit"
#define kWADLServiceTransactionPostTuxDropoffURLPath @"transaction/postTuxDropoff"
#define kWADLServiceTransactionPostTuxDropoffWithoutPaymentURLPath @"transaction/postTuxDropoffWithoutPayment"
#define kWADLServiceTransactionPostvoidURLPath @"transaction/postvoid"
#define kWADLServiceTransactionRemoveMarkdownURLPath @"transaction/removeMarkdown"
#define kWADLServiceTransactionRemoveTaxExemptionURLPath @"transaction/removeTaxExemption"
#define kWADLServiceTransactionSearchByStoreURLPath @"transaction/searchByStore"
#define kWADLServiceTransactionSetCustomerURLPath @"transaction/setCustomer"

#pragma mark -

#endif
