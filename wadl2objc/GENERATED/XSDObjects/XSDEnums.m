//
//  XSDEnums.m
//
//  Generated by wadl2objc 2015.08.18 15:57:01.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "XSDEnums.h"

@interface XSDEnums ()

@property(nonatomic, strong) NSDictionary *AppointmentTypeDictionary;
@property(nonatomic, strong) NSDictionary *ModifierTypeDictionary;
@property(nonatomic, strong) NSDictionary *RestTransactionTypeDictionary;
@property(nonatomic, strong) NSDictionary *QuestionnaireStatusDictionary;
@property(nonatomic, strong) NSDictionary *GenderTypeDictionary;
@property(nonatomic, strong) NSDictionary *ReservationPickupStatusDictionary;
@property(nonatomic, strong) NSDictionary *ModifierStatusDictionary;
@property(nonatomic, strong) NSDictionary *AppointmentSourceDictionary;
@property(nonatomic, strong) NSDictionary *MarkdownReasonCodeDictionary;
@property(nonatomic, strong) NSDictionary *EventTypeDictionary;
@property(nonatomic, strong) NSDictionary *UserRoleDictionary;
@property(nonatomic, strong) NSDictionary *FilterValueDictionary;
@property(nonatomic, strong) NSDictionary *PrinterTypeDictionary;
@property(nonatomic, strong) NSDictionary *CompanyDictionary;
@property(nonatomic, strong) NSDictionary *ReservationPosStatusDictionary;
@property(nonatomic, strong) NSDictionary *ReservationReferenceTypeDictionary;
@property(nonatomic, strong) NSDictionary *PrinterStatusDictionary;
@property(nonatomic, strong) NSDictionary *ReservationSourceDictionary;
@property(nonatomic, strong) NSDictionary *BrandDictionary;
@property(nonatomic, strong) NSDictionary *MessageLevelDictionary;
@property(nonatomic, strong) NSDictionary *MessageTargetDictionary;
@property(nonatomic, strong) NSDictionary *RepresentativeRoleDictionary;
@property(nonatomic, strong) NSDictionary *CreditCardTypeDictionary;
@property(nonatomic, strong) NSDictionary *LogEntryLevelDictionary;
@property(nonatomic, strong) NSDictionary *GroupTypeDictionary;
@property(nonatomic, strong) NSDictionary *ReservationRoleDictionary;
@property(nonatomic, strong) NSDictionary *UserPermissionsDictionary;
@property(nonatomic, strong) NSDictionary *CallLogMetDictionary;
@property(nonatomic, strong) NSDictionary *TenderTypeDictionary;
@property(nonatomic, strong) NSDictionary *GarmentLostStatusDictionary;
@property(nonatomic, strong) NSDictionary *UsaStateCodeDictionary;
@property(nonatomic, strong) NSDictionary *ErrorCodeDictionary;
@property(nonatomic, strong) NSDictionary *TaxExemptionTypeEnumDictionary;
@property(nonatomic, strong) NSDictionary *StoreStatusDictionary;
@property(nonatomic, strong) NSDictionary *FeeTypeDictionary;
@property(nonatomic, strong) NSDictionary *ErrorTypeDictionary;
@property(nonatomic, strong) NSDictionary *ReservationReorderStatusDictionary;
@property(nonatomic, strong) NSDictionary *BridalShowDispositionCodeDictionary;
@property(nonatomic, strong) NSDictionary *MessageTypeDictionary;
@property(nonatomic, strong) NSDictionary *PromRepDictionary;
@property(nonatomic, strong) NSDictionary *PaymentTypeDictionary;
@property(nonatomic, strong) NSDictionary *ReceiptStatusDictionary;
@property(nonatomic, strong) NSDictionary *ReceiptTargetTypeDictionary;
@property(nonatomic, strong) NSDictionary *TaxExemptionIdTypeEnumDictionary;
@property(nonatomic, strong) NSDictionary *ReservationDropOffStatusDictionary;
@property(nonatomic, strong) NSDictionary *GradeLevelTypeDictionary;
@property(nonatomic, strong) NSDictionary *GroupDispositionCodeDictionary;
@property(nonatomic, strong) NSDictionary *AuthResponseTypeDictionary;
@property(nonatomic, strong) NSDictionary *ClientTypeDictionary;
@property(nonatomic, strong) NSDictionary *SchoolStatusDictionary;
@property(nonatomic, strong) NSDictionary *ReceiptTypeDictionary;
@property(nonatomic, strong) NSDictionary *AppointmentCreateStatusDictionary;
@property(nonatomic, strong) NSDictionary *GroupPrimaryContactTypeDictionary;
@property(nonatomic, strong) NSDictionary *DuplicateReorderReasonDictionary;
@property(nonatomic, strong) NSDictionary *CallLogTalkedToDictionary;
@property(nonatomic, strong) NSDictionary *ReservationStatusDictionary;
@property(nonatomic, strong) NSDictionary *StyleItemTypeDictionary;
@property(nonatomic, strong) NSDictionary *PreferredContactModeDictionary;
@property(nonatomic, strong) NSDictionary *MarkdownTypeDictionary;
@property(nonatomic, strong) NSDictionary *GroupStatusDictionary;
@property(nonatomic, strong) NSDictionary *EntryMethodDictionary;

- (NSUInteger)enumValueForObject:(id)object enumName:(NSString*)enumName;
- (id)objectForEnumValue:(NSUInteger)enumValue enumName:(NSString*)enumName;

@end

@implementation XSDEnums

static XSDEnums *sharedInstanse = nil;

+ (XSDEnums*)sharedInstanse
{
    if ( !sharedInstanse){
        sharedInstanse = [[XSDEnums alloc] init];
    }
    return sharedInstanse;
}

- (id)init
{
    self = [super init];
    if (self) {
		_AppointmentTypeDictionary = @{ @(AppointmentTypeTUXEDO) : kAppointmentTypeTUXEDOString };
		_ModifierTypeDictionary = @{ @(ModifierTypeDAMAGE_HANDLING) : kModifierTypeDAMAGE_HANDLINGString, @(ModifierTypeRUSH_FEE) : kModifierTypeRUSH_FEEString, @(ModifierTypeCHANGE_ORDER_FEE) : kModifierTypeCHANGE_ORDER_FEEString, @(ModifierTypeMANUAL_MARKDOWN) : kModifierTypeMANUAL_MARKDOWNString, @(ModifierTypePERFECT_FIT_DISCOUNT) : kModifierTypePERFECT_FIT_DISCOUNTString, @(ModifierTypeDISCOUNT) : kModifierTypeDISCOUNTString, @(ModifierTypeLATE_FEE) : kModifierTypeLATE_FEEString, @(ModifierTypeLOST_ITEM_FEE) : kModifierTypeLOST_ITEM_FEEString };
		_RestTransactionTypeDictionary = @{ @(RestTransactionTypeSALE) : kRestTransactionTypeSALEString, @(RestTransactionTypePICKUP) : kRestTransactionTypePICKUPString, @(RestTransactionTypeFREE_TUX) : kRestTransactionTypeFREE_TUXString, @(RestTransactionTypeDROPOFF) : kRestTransactionTypeDROPOFFString };
		_QuestionnaireStatusDictionary = @{ @(QuestionnaireStatusOPEN) : kQuestionnaireStatusOPENString, @(QuestionnaireStatusCOMPLETED) : kQuestionnaireStatusCOMPLETEDString, @(QuestionnaireStatusDECLINED) : kQuestionnaireStatusDECLINEDString };
		_GenderTypeDictionary = @{ @(GenderTypeF) : kGenderTypeFString, @(GenderTypeM) : kGenderTypeMString, @(GenderTypeX) : kGenderTypeXString };
		_ReservationPickupStatusDictionary = @{ @(ReservationPickupStatusOPEN) : kReservationPickupStatusOPENString, @(ReservationPickupStatusOPEN_FREE_TUX) : kReservationPickupStatusOPEN_FREE_TUXString, @(ReservationPickupStatusNOT_AT_THIS_STORE) : kReservationPickupStatusNOT_AT_THIS_STOREString, @(ReservationPickupStatusCANCELED) : kReservationPickupStatusCANCELEDString, @(ReservationPickupStatusALREADY_PICKED_UP) : kReservationPickupStatusALREADY_PICKED_UPString };
		_ModifierStatusDictionary = @{ @(ModifierStatusON) : kModifierStatusONString, @(ModifierStatusOFF) : kModifierStatusOFFString, @(ModifierStatusON_DISABLED) : kModifierStatusON_DISABLEDString, @(ModifierStatusOFF_DISABLED) : kModifierStatusOFF_DISABLEDString };
		_AppointmentSourceDictionary = @{ @(AppointmentSourceSTORE) : kAppointmentSourceSTOREString, @(AppointmentSourceCALL_CENTER) : kAppointmentSourceCALL_CENTERString, @(AppointmentSourceBRIDAL_SHOW) : kAppointmentSourceBRIDAL_SHOWString, @(AppointmentSourceWEB) : kAppointmentSourceWEBString };
		_MarkdownReasonCodeDictionary = @{ @(MarkdownReasonCodeCOMPETITOR) : kMarkdownReasonCodeCOMPETITORString, @(MarkdownReasonCodeOTHER) : kMarkdownReasonCodeOTHERString };
		_EventTypeDictionary = @{ @(EventTypeWED) : kEventTypeWEDString, @(EventTypeBUS) : kEventTypeBUSString, @(EventTypePROM) : kEventTypePROMString, @(EventTypeQUINCE) : kEventTypeQUINCEString, @(EventTypeIND) : kEventTypeINDString, @(EventTypeHOME) : kEventTypeHOMEString, @(EventTypeGRAD) : kEventTypeGRADString, @(EventTypeOTHER) : kEventTypeOTHERString, @(EventTypeFASH) : kEventTypeFASHString, @(EventTypePHOTO_SHOOT) : kEventTypePHOTO_SHOOTString, @(EventTypeTRYON) : kEventTypeTRYONString, @(EventTypeMARDI_GRAS) : kEventTypeMARDI_GRASString, @(EventTypeORGANIZATION) : kEventTypeORGANIZATIONString, @(EventTypeTMW_PARTY) : kEventTypeTMW_PARTYString, @(EventTypeSHOW) : kEventTypeSHOWString, @(EventTypeONLINE) : kEventTypeONLINEString, @(EventTypeINSTORE) : kEventTypeINSTOREString, @(EventTypeDECA_FBLA) : kEventTypeDECA_FBLAString, @(EventTypeDON) : kEventTypeDONString, @(EventTypeOTHERGROUP) : kEventTypeOTHERGROUPString };
		_UserRoleDictionary = @{ @(UserRoleSTART_DAY) : kUserRoleSTART_DAYString, @(UserRoleRESV_MAINTENANCE) : kUserRoleRESV_MAINTENANCEString, @(UserRoleAPPLY_EMPLOYEE_DISCOUNT) : kUserRoleAPPLY_EMPLOYEE_DISCOUNTString, @(UserRoleAPPLY_FAMILY_DISCOUNT) : kUserRoleAPPLY_FAMILY_DISCOUNTString, @(UserRoleAPPLY_AFF_EMPLOYEE_DISCOUNT) : kUserRoleAPPLY_AFF_EMPLOYEE_DISCOUNTString, @(UserRoleAPPLY_AFF_FAMILY_DISCOUNT) : kUserRoleAPPLY_AFF_FAMILY_DISCOUNTString, @(UserRoleLTR_MANAGER_OVERRIDE) : kUserRoleLTR_MANAGER_OVERRIDEString };
		_FilterValueDictionary = @{ @(FilterValueON) : kFilterValueONString, @(FilterValueALL) : kFilterValueALLString };
		_PrinterTypeDictionary = @{ @(PrinterTypePAGE_A4) : kPrinterTypePAGE_A4String, @(PrinterTypePAGE_DEFAULT) : kPrinterTypePAGE_DEFAULTString, @(PrinterTypeROLL_DEFAULT) : kPrinterTypeROLL_DEFAULTString };
		_CompanyDictionary = @{ @(CompanyTMW) : kCompanyTMWString, @(CompanyJAB) : kCompanyJABString, @(CompanyKNG) : kCompanyKNGString };
		_ReservationPosStatusDictionary = @{ @(ReservationPosStatusOPEN) : kReservationPosStatusOPENString, @(ReservationPosStatusPIF) : kReservationPosStatusPIFString, @(ReservationPosStatusCANCEL) : kReservationPosStatusCANCELString, @(ReservationPosStatusREFUND) : kReservationPosStatusREFUNDString, @(ReservationPosStatusNO_SHOW) : kReservationPosStatusNO_SHOWString, @(ReservationPosStatusFREE) : kReservationPosStatusFREEString };
		_ReservationReferenceTypeDictionary = @{ @(ReservationReferenceTypeHAT_PACKAGE) : kReservationReferenceTypeHAT_PACKAGEString, @(ReservationReferenceTypeREORDER) : kReservationReferenceTypeREORDERString, @(ReservationReferenceTypeFREE_SUIT) : kReservationReferenceTypeFREE_SUITString, @(ReservationReferenceTypeUNKNOWN) : kReservationReferenceTypeUNKNOWNString };
		_PrinterStatusDictionary = @{ @(PrinterStatusACTIVE) : kPrinterStatusACTIVEString };
		_ReservationSourceDictionary = @{ @(ReservationSourceORIGINAL) : kReservationSourceORIGINALString, @(ReservationSourceREORDER) : kReservationSourceREORDERString, @(ReservationSourceDISPLAY) : kReservationSourceDISPLAYString, @(ReservationSourceADD) : kReservationSourceADDString, @(ReservationSourceLOCATE) : kReservationSourceLOCATEString, @(ReservationSourceTRYON) : kReservationSourceTRYONString, @(ReservationSourceBACKSTOCK) : kReservationSourceBACKSTOCKString };
		_BrandDictionary = @{ @(BrandTMW) : kBrandTMWString, @(BrandJAB) : kBrandJABString, @(BrandMWTUX) : kBrandMWTUXString, @(BrandMWOUT) : kBrandMWOUTString };
		_MessageLevelDictionary = @{ @(MessageLevelINFO) : kMessageLevelINFOString, @(MessageLevelWARNING) : kMessageLevelWARNINGString, @(MessageLevelERROR) : kMessageLevelERRORString };
		_MessageTargetDictionary = @{ @(MessageTargetGROUP) : kMessageTargetGROUPString, @(MessageTargetRESERVATION) : kMessageTargetRESERVATIONString, @(MessageTargetDISCOUNT) : kMessageTargetDISCOUNTString };
		_RepresentativeRoleDictionary = @{ @(RepresentativeRoleBRI) : kRepresentativeRoleBRIString, @(RepresentativeRoleGRO) : kRepresentativeRoleGROString, @(RepresentativeRoleREP) : kRepresentativeRoleREPString, @(RepresentativeRoleQ) : kRepresentativeRoleQString, @(RepresentativeRoleD) : kRepresentativeRoleDString, @(RepresentativeRoleS) : kRepresentativeRoleSString, @(RepresentativeRoleO) : kRepresentativeRoleOString, @(RepresentativeRoleL) : kRepresentativeRoleLString, @(RepresentativeRoleIN_STORE) : kRepresentativeRoleIN_STOREString };
		_CreditCardTypeDictionary = @{ @(CreditCardTypeVISA) : kCreditCardTypeVISAString, @(CreditCardTypeMASTERCARD) : kCreditCardTypeMASTERCARDString, @(CreditCardTypeAMERICAN_EXPRESS) : kCreditCardTypeAMERICAN_EXPRESSString, @(CreditCardTypeDISCOVER) : kCreditCardTypeDISCOVERString };
		_LogEntryLevelDictionary = @{ @(LogEntryLevelDEBUG) : kLogEntryLevelDEBUGString, @(LogEntryLevelINFO) : kLogEntryLevelINFOString, @(LogEntryLevelWARN) : kLogEntryLevelWARNString, @(LogEntryLevelERROR) : kLogEntryLevelERRORString };
		_GroupTypeDictionary = @{ @(GroupTypeWED) : kGroupTypeWEDString, @(GroupTypePROM) : kGroupTypePROMString, @(GroupTypeSCHOOL) : kGroupTypeSCHOOLString, @(GroupTypeBUS) : kGroupTypeBUSString, @(GroupTypeQUINCE) : kGroupTypeQUINCEString };
		_ReservationRoleDictionary = @{ @(ReservationRoleGR) : kReservationRoleGRString, @(ReservationRoleBM) : kReservationRoleBMString, @(ReservationRoleGM) : kReservationRoleGMString, @(ReservationRoleJGM) : kReservationRoleJGMString, @(ReservationRoleRB) : kReservationRoleRBString, @(ReservationRoleUSH) : kReservationRoleUSHString, @(ReservationRoleFOB) : kReservationRoleFOBString, @(ReservationRoleFOG) : kReservationRoleFOGString, @(ReservationRoleSFB) : kReservationRoleSFBString, @(ReservationRoleSFG) : kReservationRoleSFGString, @(ReservationRoleGFB) : kReservationRoleGFBString, @(ReservationRoleGFG) : kReservationRoleGFGString, @(ReservationRoleUNC) : kReservationRoleUNCString, @(ReservationRoleNA) : kReservationRoleNAString, @(ReservationRoleAT) : kReservationRoleATString, @(ReservationRoleREP) : kReservationRoleREPString, @(ReservationRoleMEM) : kReservationRoleMEMString };
		_UserPermissionsDictionary = @{ @(UserPermissionsFEES_MANAGE) : kUserPermissionsFEES_MANAGEString, @(UserPermissionsREFUND_OVERRIDE) : kUserPermissionsREFUND_OVERRIDEString };
		_CallLogMetDictionary = @{ @(CallLogMetON_PHONE) : kCallLogMetON_PHONEString, @(CallLogMetFACE_TO_FACE) : kCallLogMetFACE_TO_FACEString };
		_TenderTypeDictionary = @{ @(TenderTypeCREDIT_CARD) : kTenderTypeCREDIT_CARDString, @(TenderTypeCASH) : kTenderTypeCASHString, @(TenderTypeGIFT_CARD) : kTenderTypeGIFT_CARDString };
		_GarmentLostStatusDictionary = @{ @(GarmentLostStatusLOST) : kGarmentLostStatusLOSTString, @(GarmentLostStatusLOST_ALREADY_PAID) : kGarmentLostStatusLOST_ALREADY_PAIDString, @(GarmentLostStatusNOT_LOST) : kGarmentLostStatusNOT_LOSTString };
		_UsaStateCodeDictionary = @{ @(UsaStateCodeAK) : kUsaStateCodeAKString, @(UsaStateCodeAS) : kUsaStateCodeASString, @(UsaStateCodeAZ) : kUsaStateCodeAZString, @(UsaStateCodeAR) : kUsaStateCodeARString, @(UsaStateCodeCA) : kUsaStateCodeCAString, @(UsaStateCodeCO) : kUsaStateCodeCOString, @(UsaStateCodeCT) : kUsaStateCodeCTString, @(UsaStateCodeDE) : kUsaStateCodeDEString, @(UsaStateCodeDC) : kUsaStateCodeDCString, @(UsaStateCodeFM) : kUsaStateCodeFMString, @(UsaStateCodeFL) : kUsaStateCodeFLString, @(UsaStateCodeGA) : kUsaStateCodeGAString, @(UsaStateCodeGU) : kUsaStateCodeGUString, @(UsaStateCodeHI) : kUsaStateCodeHIString, @(UsaStateCodeID) : kUsaStateCodeIDString, @(UsaStateCodeIL) : kUsaStateCodeILString, @(UsaStateCodeIN) : kUsaStateCodeINString, @(UsaStateCodeIA) : kUsaStateCodeIAString, @(UsaStateCodeKS) : kUsaStateCodeKSString, @(UsaStateCodeKY) : kUsaStateCodeKYString, @(UsaStateCodeLA) : kUsaStateCodeLAString, @(UsaStateCodeME) : kUsaStateCodeMEString, @(UsaStateCodeMH) : kUsaStateCodeMHString, @(UsaStateCodeMD) : kUsaStateCodeMDString, @(UsaStateCodeMA) : kUsaStateCodeMAString, @(UsaStateCodeMI) : kUsaStateCodeMIString, @(UsaStateCodeMN) : kUsaStateCodeMNString, @(UsaStateCodeMS) : kUsaStateCodeMSString, @(UsaStateCodeMO) : kUsaStateCodeMOString, @(UsaStateCodeMT) : kUsaStateCodeMTString, @(UsaStateCodeNE) : kUsaStateCodeNEString, @(UsaStateCodeNV) : kUsaStateCodeNVString, @(UsaStateCodeNH) : kUsaStateCodeNHString, @(UsaStateCodeNJ) : kUsaStateCodeNJString, @(UsaStateCodeNM) : kUsaStateCodeNMString, @(UsaStateCodeNY) : kUsaStateCodeNYString, @(UsaStateCodeNC) : kUsaStateCodeNCString, @(UsaStateCodeND) : kUsaStateCodeNDString, @(UsaStateCodeMP) : kUsaStateCodeMPString, @(UsaStateCodeOH) : kUsaStateCodeOHString, @(UsaStateCodeOK) : kUsaStateCodeOKString, @(UsaStateCodeOR) : kUsaStateCodeORString, @(UsaStateCodePW) : kUsaStateCodePWString, @(UsaStateCodePA) : kUsaStateCodePAString, @(UsaStateCodePR) : kUsaStateCodePRString, @(UsaStateCodeRI) : kUsaStateCodeRIString, @(UsaStateCodeSC) : kUsaStateCodeSCString, @(UsaStateCodeSD) : kUsaStateCodeSDString, @(UsaStateCodeTN) : kUsaStateCodeTNString, @(UsaStateCodeTX) : kUsaStateCodeTXString, @(UsaStateCodeUT) : kUsaStateCodeUTString, @(UsaStateCodeVT) : kUsaStateCodeVTString, @(UsaStateCodeVI) : kUsaStateCodeVIString, @(UsaStateCodeVA) : kUsaStateCodeVAString, @(UsaStateCodeWA) : kUsaStateCodeWAString, @(UsaStateCodeWV) : kUsaStateCodeWVString, @(UsaStateCodeWI) : kUsaStateCodeWIString, @(UsaStateCodeWY) : kUsaStateCodeWYString, @(UsaStateCodeAL) : kUsaStateCodeALString, @(UsaStateCodeAE) : kUsaStateCodeAEString, @(UsaStateCodeAA) : kUsaStateCodeAAString, @(UsaStateCodeAC) : kUsaStateCodeACString, @(UsaStateCodeAU) : kUsaStateCodeAUString, @(UsaStateCodeAM) : kUsaStateCodeAMString, @(UsaStateCodeAP) : kUsaStateCodeAPString, @(UsaStateCodeAB) : kUsaStateCodeABString, @(UsaStateCodeBC) : kUsaStateCodeBCString, @(UsaStateCodeMB) : kUsaStateCodeMBString, @(UsaStateCodeNB) : kUsaStateCodeNBString, @(UsaStateCodeNL) : kUsaStateCodeNLString, @(UsaStateCodeNT) : kUsaStateCodeNTString, @(UsaStateCodeNS) : kUsaStateCodeNSString, @(UsaStateCodeON) : kUsaStateCodeONString, @(UsaStateCodePE) : kUsaStateCodePEString, @(UsaStateCodeQC) : kUsaStateCodeQCString, @(UsaStateCodeSK) : kUsaStateCodeSKString, @(UsaStateCodeYT) : kUsaStateCodeYTString, @(UsaStateCodeNU) : kUsaStateCodeNUString, @(UsaStateCodeUNKNOWN) : kUsaStateCodeUNKNOWNString };
		_ErrorCodeDictionary = @{ @(ErrorCodeERR_PAYMENT_CardDecryptionException) : kErrorCodeERR_PAYMENT_CardDecryptionExceptionString, @(ErrorCodeERR_PAYMENT_NotValidCouponClientException) : kErrorCodeERR_PAYMENT_NotValidCouponClientExceptionString, @(ErrorCodeERR_PAYMENT_CardNotSupported) : kErrorCodeERR_PAYMENT_CardNotSupportedString, @(ErrorCodeERR_RESV_CommitManualOverrideRequiredException) : kErrorCodeERR_RESV_CommitManualOverrideRequiredExceptionString, @(ErrorCodeERR_RECEIPTS_EmaiNotSentException) : kErrorCodeERR_RECEIPTS_EmaiNotSentExceptionString, @(ErrorCodeERR_MANAGER_OVERRIDE) : kErrorCodeERR_MANAGER_OVERRIDEString, @(ErrorCodeERR_RefundPossibleOnPOSOnly) : kErrorCodeERR_RefundPossibleOnPOSOnlyString, @(ErrorCodeERR_ReservationReceivedAmountChanged) : kErrorCodeERR_ReservationReceivedAmountChangedString, @(ErrorCodeERR_DEFAULT) : kErrorCodeERR_DEFAULTString, @(ErrorCodeERR_TRANSACTION_PROCESSED) : kErrorCodeERR_TRANSACTION_PROCESSEDString, @(ErrorCodeERR_POST_FAILED) : kErrorCodeERR_POST_FAILEDString, @(ErrorCodeERR_VOID_TRANSACTION_FAILED) : kErrorCodeERR_VOID_TRANSACTION_FAILEDString, @(ErrorCodeERR_OpenSessionFailed) : kErrorCodeERR_OpenSessionFailedString };
		_TaxExemptionTypeEnumDictionary = @{ @(TaxExemptionTypeEnumUS_NONPROFIT) : kTaxExemptionTypeEnumUS_NONPROFITString, @(TaxExemptionTypeEnumUS_RESALE) : kTaxExemptionTypeEnumUS_RESALEString, @(TaxExemptionTypeEnumUS_GOVT) : kTaxExemptionTypeEnumUS_GOVTString, @(TaxExemptionTypeEnumUS_WA_NONRESIDENT) : kTaxExemptionTypeEnumUS_WA_NONRESIDENTString, @(TaxExemptionTypeEnumUS_TAX_ID) : kTaxExemptionTypeEnumUS_TAX_IDString, @(TaxExemptionTypeEnumCA_TRIBAL) : kTaxExemptionTypeEnumCA_TRIBALString, @(TaxExemptionTypeEnumCA_TRIBAL_SHIP) : kTaxExemptionTypeEnumCA_TRIBAL_SHIPString, @(TaxExemptionTypeEnumCA_GOVT) : kTaxExemptionTypeEnumCA_GOVTString, @(TaxExemptionTypeEnumCA_PROV_GOVT) : kTaxExemptionTypeEnumCA_PROV_GOVTString, @(TaxExemptionTypeEnumCA_DIPLOMAT) : kTaxExemptionTypeEnumCA_DIPLOMATString, @(TaxExemptionTypeEnumCA_UNDER_AGE) : kTaxExemptionTypeEnumCA_UNDER_AGEString };
		_StoreStatusDictionary = @{ @(StoreStatusOPEN) : kStoreStatusOPENString, @(StoreStatusCLOSED) : kStoreStatusCLOSEDString };
		_FeeTypeDictionary = @{ @(FeeTypeDAMAGE) : kFeeTypeDAMAGEString, @(FeeTypeCHANGE_ORDER) : kFeeTypeCHANGE_ORDERString, @(FeeTypeRUSH) : kFeeTypeRUSHString, @(FeeTypeLATE) : kFeeTypeLATEString };
		_ErrorTypeDictionary = @{ @(ErrorTypeSERVER) : kErrorTypeSERVERString, @(ErrorTypeCLIENT) : kErrorTypeCLIENTString };
		_ReservationReorderStatusDictionary = @{ @(ReservationReorderStatusREORDER) : kReservationReorderStatusREORDERString, @(ReservationReorderStatusEXCHANGE) : kReservationReorderStatusEXCHANGEString, @(ReservationReorderStatusNOT_AVAILABLE) : kReservationReorderStatusNOT_AVAILABLEString };
		_BridalShowDispositionCodeDictionary = @{ @(BridalShowDispositionCodeDONE) : kBridalShowDispositionCodeDONEString, @(BridalShowDispositionCodeAPP) : kBridalShowDispositionCodeAPPString, @(BridalShowDispositionCodeCBK) : kBridalShowDispositionCodeCBKString, @(BridalShowDispositionCodeUTC) : kBridalShowDispositionCodeUTCString, @(BridalShowDispositionCodeDNC) : kBridalShowDispositionCodeDNCString };
		_MessageTypeDictionary = @{ @(MessageTypeFREE_TUX_NOT_ELIGIBLE) : kMessageTypeFREE_TUX_NOT_ELIGIBLEString, @(MessageTypeSTYLE_MISSMATCH) : kMessageTypeSTYLE_MISSMATCHString, @(MessageTypeTAX_EXEMPTION) : kMessageTypeTAX_EXEMPTIONString, @(MessageTypeREFUND_CERTIFICATE_FORFEIT) : kMessageTypeREFUND_CERTIFICATE_FORFEITString };
		_PromRepDictionary = @{ @(PromRepONLINE) : kPromRepONLINEString, @(PromRepIN_STORE) : kPromRepIN_STOREString, @(PromRepDECA_FBLA) : kPromRepDECA_FBLAString };
		_PaymentTypeDictionary = @{ @(PaymentTypeCREDIT_CARD) : kPaymentTypeCREDIT_CARDString, @(PaymentTypeCHECK_REQUEST) : kPaymentTypeCHECK_REQUESTString, @(PaymentTypeGIFT_CERT) : kPaymentTypeGIFT_CERTString, @(PaymentTypeCASH) : kPaymentTypeCASHString };
		_ReceiptStatusDictionary = @{ @(ReceiptStatusSENT) : kReceiptStatusSENTString, @(ReceiptStatusPENDING) : kReceiptStatusPENDINGString, @(ReceiptStatusIN_QUEUE) : kReceiptStatusIN_QUEUEString, @(ReceiptStatusERROR) : kReceiptStatusERRORString };
		_ReceiptTargetTypeDictionary = @{ @(ReceiptTargetTypePRINTER) : kReceiptTargetTypePRINTERString, @(ReceiptTargetTypeEMAIL) : kReceiptTargetTypeEMAILString };
		_TaxExemptionIdTypeEnumDictionary = @{ @(TaxExemptionIdTypeEnumDIPLOMAT) : kTaxExemptionIdTypeEnumDIPLOMATString, @(TaxExemptionIdTypeEnumDL) : kTaxExemptionIdTypeEnumDLString, @(TaxExemptionIdTypeEnumFEIN) : kTaxExemptionIdTypeEnumFEINString, @(TaxExemptionIdTypeEnumRESALE_CERT) : kTaxExemptionIdTypeEnumRESALE_CERTString, @(TaxExemptionIdTypeEnumSTATE_ID) : kTaxExemptionIdTypeEnumSTATE_IDString, @(TaxExemptionIdTypeEnumTYPE_501C3) : kTaxExemptionIdTypeEnumTYPE_501C3String, @(TaxExemptionIdTypeEnumCA_DEPT) : kTaxExemptionIdTypeEnumCA_DEPTString, @(TaxExemptionIdTypeEnumCA_G_PERMIT) : kTaxExemptionIdTypeEnumCA_G_PERMITString, @(TaxExemptionIdTypeEnumCA_GOVT_ID) : kTaxExemptionIdTypeEnumCA_GOVT_IDString, @(TaxExemptionIdTypeEnumCA_CRA_BN) : kTaxExemptionIdTypeEnumCA_CRA_BNString };
		_ReservationDropOffStatusDictionary = @{ @(ReservationDropOffStatusPREPARING_TO_RETURN) : kReservationDropOffStatusPREPARING_TO_RETURNString, @(ReservationDropOffStatusCANCELED) : kReservationDropOffStatusCANCELEDString, @(ReservationDropOffStatusALREADY_RETURNED) : kReservationDropOffStatusALREADY_RETURNEDString, @(ReservationDropOffStatusLOST) : kReservationDropOffStatusLOSTString, @(ReservationDropOffStatusLOST_ITEMS) : kReservationDropOffStatusLOST_ITEMSString, @(ReservationDropOffStatusNO_LOST_ITEMS) : kReservationDropOffStatusNO_LOST_ITEMSString, @(ReservationDropOffStatusDROPOFF_NOT_ALLOWED) : kReservationDropOffStatusDROPOFF_NOT_ALLOWEDString };
		_GradeLevelTypeDictionary = @{ @(GradeLevelTypeFRESHMAN) : kGradeLevelTypeFRESHMANString, @(GradeLevelTypeJUNIOR) : kGradeLevelTypeJUNIORString, @(GradeLevelTypeSENIOR) : kGradeLevelTypeSENIORString, @(GradeLevelTypeSOPHOMORE) : kGradeLevelTypeSOPHOMOREString };
		_GroupDispositionCodeDictionary = @{ @(GroupDispositionCodeDONE) : kGroupDispositionCodeDONEString, @(GroupDispositionCodeMSG) : kGroupDispositionCodeMSGString, @(GroupDispositionCodeUTC) : kGroupDispositionCodeUTCString, @(GroupDispositionCodeDNC) : kGroupDispositionCodeDNCString };
		_AuthResponseTypeDictionary = @{ @(AuthResponseTypeAPPROVED) : kAuthResponseTypeAPPROVEDString, @(AuthResponseTypeDECLINED) : kAuthResponseTypeDECLINEDString, @(AuthResponseTypeDECLINED_REFERRED) : kAuthResponseTypeDECLINED_REFERREDString, @(AuthResponseTypeREFERRED) : kAuthResponseTypeREFERREDString, @(AuthResponseTypePARTIAL) : kAuthResponseTypePARTIALString, @(AuthResponseTypeUNKNOWN) : kAuthResponseTypeUNKNOWNString };
		_ClientTypeDictionary = @{ @(ClientTypeTUX_MOBILE) : kClientTypeTUX_MOBILEString, @(ClientTypeTUX_ONLINE) : kClientTypeTUX_ONLINEString, @(ClientTypeDASHBOARD) : kClientTypeDASHBOARDString };
		_SchoolStatusDictionary = @{ @(SchoolStatusACTIVE) : kSchoolStatusACTIVEString, @(SchoolStatusINACTIVE) : kSchoolStatusINACTIVEString };
		_ReceiptTypeDictionary = @{ @(ReceiptTypePOST_DEPOSIT) : kReceiptTypePOST_DEPOSITString, @(ReceiptTypeRENTAL_IND) : kReceiptTypeRENTAL_INDString, @(ReceiptTypeRENTAL_GROUP_CUSTOMER) : kReceiptTypeRENTAL_GROUP_CUSTOMERString, @(ReceiptTypeRENTAL_GROUP_STORE) : kReceiptTypeRENTAL_GROUP_STOREString, @(ReceiptTypeCOUPON_FREE_SUIT) : kReceiptTypeCOUPON_FREE_SUITString, @(ReceiptTypePOST_DEPOSIT_R2R_COUPON) : kReceiptTypePOST_DEPOSIT_R2R_COUPONString, @(ReceiptTypeCOUPON_FREE_RENTAL) : kReceiptTypeCOUPON_FREE_RENTALString, @(ReceiptTypeCOUPON_RETAIL) : kReceiptTypeCOUPON_RETAILString, @(ReceiptTypeRENTAL_IND_COUPON) : kReceiptTypeRENTAL_IND_COUPONString, @(ReceiptTypeWEDDING_CALL_LIST) : kReceiptTypeWEDDING_CALL_LISTString, @(ReceiptTypeBRIDAL_SHOW_CALL_LIST) : kReceiptTypeBRIDAL_SHOW_CALL_LISTString, @(ReceiptTypePICKUP) : kReceiptTypePICKUPString, @(ReceiptTypeDROPOFF) : kReceiptTypeDROPOFFString, @(ReceiptTypeDROPOFF_DC) : kReceiptTypeDROPOFF_DCString, @(ReceiptTypeDROPOFF_NO_BALANCE) : kReceiptTypeDROPOFF_NO_BALANCEString, @(ReceiptTypePICKUP_R2R_COUPON) : kReceiptTypePICKUP_R2R_COUPONString, @(ReceiptTypeDROPOFF_R2R_COUPON) : kReceiptTypeDROPOFF_R2R_COUPONString, @(ReceiptTypeAPPOINTMENTS) : kReceiptTypeAPPOINTMENTSString, @(ReceiptTypeTEST_PAGE) : kReceiptTypeTEST_PAGEString };
		_AppointmentCreateStatusDictionary = @{ @(AppointmentCreateStatusOK) : kAppointmentCreateStatusOKString, @(AppointmentCreateStatusFUTURE_APPOINTMENT_ALREADY_EXIST) : kAppointmentCreateStatusFUTURE_APPOINTMENT_ALREADY_EXISTString, @(AppointmentCreateStatusCC_LEADS_EXIST) : kAppointmentCreateStatusCC_LEADS_EXISTString, @(AppointmentCreateStatusGROUPS_EXIST) : kAppointmentCreateStatusGROUPS_EXISTString };
		_GroupPrimaryContactTypeDictionary = @{ @(GroupPrimaryContactTypeREP1) : kGroupPrimaryContactTypeREP1String, @(GroupPrimaryContactTypeREP2) : kGroupPrimaryContactTypeREP2String, @(GroupPrimaryContactTypeNOT_AVAILABLE) : kGroupPrimaryContactTypeNOT_AVAILABLEString };
		_DuplicateReorderReasonDictionary = @{ @(DuplicateReorderReasonALTER) : kDuplicateReorderReasonALTERString, @(DuplicateReorderReasonBUTTONS) : kDuplicateReorderReasonBUTTONSString, @(DuplicateReorderReasonCHANGE_DATE) : kDuplicateReorderReasonCHANGE_DATEString, @(DuplicateReorderReasonCHANGE_STORE) : kDuplicateReorderReasonCHANGE_STOREString, @(DuplicateReorderReasonCUSTOMER) : kDuplicateReorderReasonCUSTOMERString, @(DuplicateReorderReasonDAMAGED) : kDuplicateReorderReasonDAMAGEDString, @(DuplicateReorderReasonDID_NOT_RECEIVE) : kDuplicateReorderReasonDID_NOT_RECEIVEString, @(DuplicateReorderReasonDIRTY) : kDuplicateReorderReasonDIRTYString, @(DuplicateReorderReasonENTERED_WRONG) : kDuplicateReorderReasonENTERED_WRONGString, @(DuplicateReorderReasonMAX_LENGTH) : kDuplicateReorderReasonMAX_LENGTHString, @(DuplicateReorderReasonPARCEL) : kDuplicateReorderReasonPARCELString, @(DuplicateReorderReasonSENT_WRONG) : kDuplicateReorderReasonSENT_WRONGString, @(DuplicateReorderReasonSERIAL_NO_WRONG) : kDuplicateReorderReasonSERIAL_NO_WRONGString, @(DuplicateReorderReasonSHIP_WRONG) : kDuplicateReorderReasonSHIP_WRONGString, @(DuplicateReorderReasonTO_HUB_BEFORE_EVENT) : kDuplicateReorderReasonTO_HUB_BEFORE_EVENTString, @(DuplicateReorderReasonUSED_FOR_ANOTHER) : kDuplicateReorderReasonUSED_FOR_ANOTHERString };
		_CallLogTalkedToDictionary = @{ @(CallLogTalkedToGROOM) : kCallLogTalkedToGROOMString, @(CallLogTalkedToBRIDE) : kCallLogTalkedToBRIDEString, @(CallLogTalkedToGROOM_AND_BRIDE) : kCallLogTalkedToGROOM_AND_BRIDEString, @(CallLogTalkedToQUINCE) : kCallLogTalkedToQUINCEString, @(CallLogTalkedToSPONSOR) : kCallLogTalkedToSPONSORString, @(CallLogTalkedToQUINCE_AND_SPONSOR) : kCallLogTalkedToQUINCE_AND_SPONSORString };
		_ReservationStatusDictionary = @{ @(ReservationStatusNOTCOM) : kReservationStatusNOTCOMString, @(ReservationStatusCANCEL) : kReservationStatusCANCELString, @(ReservationStatusCOMMIT) : kReservationStatusCOMMITString, @(ReservationStatusASM) : kReservationStatusASMString, @(ReservationStatusQC) : kReservationStatusQCString, @(ReservationStatusBAGGED) : kReservationStatusBAGGEDString, @(ReservationStatusSHIP) : kReservationStatusSHIPString, @(ReservationStatusDC) : kReservationStatusDCString, @(ReservationStatusHOLD) : kReservationStatusHOLDString, @(ReservationStatusLOCATE) : kReservationStatusLOCATEString, @(ReservationStatusLOST) : kReservationStatusLOSTString };
		_StyleItemTypeDictionary = @{ @(StyleItemTypeCOAT) : kStyleItemTypeCOATString, @(StyleItemTypePANTS) : kStyleItemTypePANTSString, @(StyleItemTypeSHIRT) : kStyleItemTypeSHIRTString, @(StyleItemTypeCUMMERBUND) : kStyleItemTypeCUMMERBUNDString, @(StyleItemTypeVEST) : kStyleItemTypeVESTString, @(StyleItemTypeNECKWEAR) : kStyleItemTypeNECKWEARString, @(StyleItemTypeSHOES) : kStyleItemTypeSHOESString, @(StyleItemTypeSUSPENDERS) : kStyleItemTypeSUSPENDERSString, @(StyleItemTypeJEWELRY) : kStyleItemTypeJEWELRYString, @(StyleItemTypeBELT) : kStyleItemTypeBELTString, @(StyleItemTypeACCESSORY) : kStyleItemTypeACCESSORYString };
		_PreferredContactModeDictionary = @{ @(PreferredContactModeALL_FORMS) : kPreferredContactModeALL_FORMSString, @(PreferredContactModePHONE) : kPreferredContactModePHONEString, @(PreferredContactModeEMAIL) : kPreferredContactModeEMAILString, @(PreferredContactModeMAIL) : kPreferredContactModeMAILString, @(PreferredContactModeMAIL_WITHOUT_REWARD_CERTS) : kPreferredContactModeMAIL_WITHOUT_REWARD_CERTSString };
		_MarkdownTypeDictionary = @{ @(MarkdownTypeAMOUNT) : kMarkdownTypeAMOUNTString, @(MarkdownTypePERCENT) : kMarkdownTypePERCENTString };
		_GroupStatusDictionary = @{ @(GroupStatusCANCEL) : kGroupStatusCANCELString };
		_EntryMethodDictionary = @{ @(EntryMethodKEYED) : kEntryMethodKEYEDString, @(EntryMethodSCANNED) : kEntryMethodSCANNEDString };

    }
    return self;
}

- (NSDictionary*)dictionaryForEnumName:(NSString*)enumName
{
    NSString *dictKey = [enumName stringByAppendingString:@"Dictionary"];
    NSDictionary *enumDict = [self valueForKey: dictKey];
    return enumDict;
}

- (NSUInteger)enumValueForObject:(id)object enumName:(NSString*)enumName
{
    NSArray *keys = [[self dictionaryForEnumName:enumName] allKeysForObject:object];
    NSUInteger result = 0;
    if ( keys.count ){
        result = [keys[0] unsignedIntegerValue];
    }
    return result;
}

- (id)objectForEnumValue:(NSUInteger)enumValue enumName:(NSString *)enumName
{
    id result = [[self dictionaryForEnumName:enumName] objectForKey:@(enumValue)];
    return result;
}

+ (NSUInteger)enumValueForObject:(id)object enumName:(NSString *)enumName
{
    return [[XSDEnums sharedInstanse] enumValueForObject:object enumName:enumName];
}

+ (id)objectForEnumValue:(NSUInteger)enumValue enumName:(NSString *)enumName
{
    return [[self sharedInstanse] objectForEnumValue:enumValue enumName:enumName];
}

@end
