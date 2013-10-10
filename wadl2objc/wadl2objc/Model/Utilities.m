//
//  Utilities.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 31.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "Utilities.h"

static char base_64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};


BOOL isValidEmail(NSString *candidate)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

BOOL isValidGroup(NSString *candidate)
{
    NSString *groupRegex = @"[0-9]+";
    NSPredicate *groupTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", groupRegex];
    
    return [groupTest evaluateWithObject:candidate];
}

BOOL isValidPhoeNumber(NSString *candidate)
{
    NSString *numRegex = @"[+]{0,1}[0-9\\)\\( -]+";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    
    return [numTest evaluateWithObject:candidate];
}

BOOL isValidName(NSString *candidate)
{
    NSString *numRegex = @"[A-Za-z.\' -]+";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    
    return [numTest evaluateWithObject:candidate];
}

BOOL isValidUserName(NSString *candidate)
{
    NSString *numRegex = @"[A-Za-z.0-9_-]+";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    
    return [numTest evaluateWithObject:candidate];
}

BOOL isValidPassword(NSString *candidate)
{
    NSString *numRegex = @"[A-Za-z.0-9_-]+";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    
    return [numTest evaluateWithObject:candidate];
}

CGFloat heightOfTextLabel(NSString* text, CGFloat width, UIFont* font)
{
    CGSize maxSize = CGSizeMake(width, 1 << 16);
    CGSize expectedLabelSize = [text sizeWithFont: font
                                constrainedToSize: maxSize
                                    lineBreakMode: NSLineBreakByWordWrapping];
    return expectedLabelSize.height;
}

NSString * NSStringBase64FromData(NSData* data)
{
    int length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = (const unsigned char *)[data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base_64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

@implementation Utilities

+ (NSString *)NSStringBase64FromData:(NSData *)data
{
    int length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = (const unsigned char *)[data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base_64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

@end
