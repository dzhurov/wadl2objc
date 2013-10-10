//
//  WADLServiceSection.m
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLServiceSection.h"
#import "WADLServicePathParameter.h"
#import "XSDTypes.h"
#import "WADLService.h"

#define kSupportedHTTPMethodsArray @[@"GET", @"POST", @"PUT", @"DELTE"]

@implementation WADLServiceSection

synthesizeLazzyProperty(childSections, NSMutableArray);
synthesizeLazzyProperty(pathParameters, NSMutableArray);
synthesizeLazzyProperty(services, NSMutableArray);
synthesizeLazzyProperty(queryParameters, NSMutableArray);

- (id)initWithDictionary:(NSDictionary *)dictionary parantSection:(WADLServiceSection *)parantSection
{
    self = [super init];
    if (self){
        self.parantServiceSection = parantSection;
        [self setDictionary:dictionary];
    }
    return self;
}

- (void)setDictionary:(NSDictionary*)dictionary
{
    // Path
    NSString *path = dictionary[@"_path"];
    NSMutableArray *pathComponents = [[path componentsSeparatedByString:@"/"] mutableCopy];
    NSDictionary *params = dictionary[@"param"];
    if ( params.count ){
        for (NSDictionary *paramDict in params) {
            WADLServicePathParameter *parameter = [WADLServicePathParameter new];
            parameter.name = paramDict[@"_name"];
            parameter.type = classNameForXSDType( paramDict[@"_type"] );
            NSString *parameterStyle = paramDict[@"_style"];
            if ([parameterStyle isEqualToString:@"query"]){
                [self.queryParameters addObject:parameter];
            }
            else if ([parameterStyle isEqualToString:@"template"]){
                [self.pathParameters addObject:parameter];
                for (int i = 0; i < pathComponents.count; i++) {
                    NSString *onePathComponent = pathComponents[i];
                    NSRange range = [onePathComponent rangeOfString:parameter.name];
                    if ( range.location != NSNotFound ){
                        NSString *regexSeparator = @": ";
                        if ( onePathComponent.length > parameter.name.length + 2/*breckets*/ ){
                            NSRange regexRange = NSMakeRange(range.length + range.location + regexSeparator.length, onePathComponent.length - (range.length + range.location + regexSeparator.length) - 1);
                            NSString *regex = [onePathComponent substringWithRange:regexRange];
                            parameter.regex = regex;
                        }
                        [pathComponents replaceObjectAtIndex:i withObject:@"%@"];
                        break;
                    }//if ( range.location != NSNotFound )
                }//for (int i = 0; i < pathComponents.count; i++)
            }
        }//for (NSDictionary *paramDict in params)
    }//else if ([parameterStyle isEqualToString:@"template"])
    self.path = [pathComponents componentsJoinedByString:@"/"];

    // Child sections
    NSArray *subsectionsArray = dictionary[@"resource"];
    for (NSDictionary *subsectionDict in subsectionsArray) {
        WADLServiceSection *section = [[WADLServiceSection alloc] initWithDictionary:subsectionDict parantSection:self];
        [self.childSections addObject:section];
    }
    
    // Methods
    NSArray *methodsArray = dictionary[@"method"];
    for (NSDictionary *methodDict in methodsArray) {
        NSString *httpMethod = methodDict[@"_name"];
        if ( [kSupportedHTTPMethodsArray containsObject:httpMethod] ){
            WADLService *service = [[WADLService alloc] initWithDictionary:methodDict parantSection:self];
            [self.services addObject:service];
        }
    }
}

@end
