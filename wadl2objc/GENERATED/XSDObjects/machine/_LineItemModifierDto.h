//
//  _LineItemModifierDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "XSDEnums.h"

@interface _LineItemModifierDto : XSDBaseEntity

/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *modifierCertificateValue;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *modifierOriginalValue;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *modifierReceivedValue;
@property(nonatomic) ModifierStatus modifierStatus;
@property(nonatomic) ModifierType modifierType;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *modifierValue;

@end
