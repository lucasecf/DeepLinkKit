#import "NSString+DPLQuery.h"

static NSString * const DPL_ArrayLiteral = @"[]";

@implementation NSString (UBRQuery)

+ (NSString *)DPL_queryStringWithParameters:(NSDictionary *)parameters {
    return [self DPL_queryStringWithParameters:parameters orderedParameterNames:nil];
}


+ (NSString *)DPL_queryStringWithParameters:(NSDictionary *)parameters orderedParameterNames:(NSOrderedSet *)orderedParameterNames {
    NSArray *orderedParametersArray;
    if (orderedParameterNames && orderedParameterNames.count == [parameters allKeys].count) {
        orderedParametersArray = [orderedParameterNames array];
    }
    else {
        orderedParametersArray = [[parameters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }

    NSMutableString *query = [NSMutableString string];
    NSString *percentEscapedArrayLiteral = [DPL_ArrayLiteral DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [orderedParametersArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *value = @"";
        if ([parameters[key] isKindOfClass:[NSArray class]]) {
            NSString *keyValuePair = nil;
            NSString *arrayValueString = nil;
            for (NSString *arrayValue in parameters[key]) {
                arrayValueString = [arrayValue.description DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                key = [key DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                keyValuePair = [NSString stringWithFormat:@"%@%@=%@", key, percentEscapedArrayLiteral, arrayValueString];
                keyValuePair = [NSString stringWithFormat:@"%@%@", (value.length > 0) ? @"&" : @"", keyValuePair];
                value = [value stringByAppendingString:keyValuePair];
            }
            if (value.length == 0) {
                value = [NSString stringWithFormat:@"%@%@", key, percentEscapedArrayLiteral];
            }
            key = @"";
        }
        else {
            value = [parameters[key] description];
            key   = [key DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            value = [value DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        [query appendFormat:@"%@%@%@%@", (idx > 0) ? @"&" : @"", key, (value.length > 0 && key.length > 0)  ? @"=" : @"", value];
    }];
    return [query copy];
}


- (NSDictionary *)DPL_parametersDictionaryAndOrderFromQueryString {
    NSArray *params = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:[params count]];
    NSMutableOrderedSet *orderedParameters = [NSMutableOrderedSet orderedSet];
    NSString *key;
    NSObject *value;
    NSArray *pairs;
    for (NSString *param in params) {
        pairs = [param componentsSeparatedByString:@"="];
        if (pairs.count == 2) {
            // e.g. ?key=value
            key   = [pairs[0] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            value = [pairs[1] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([key DPL_containsArrayLiteral]) {
                // e.g. ?items[]=item1&items[]=item2
                key = [key DPL_stringByRemovingArrayLiteral];
                if (!paramsDict[key]) {
                    paramsDict[key] = @[value];
                }
                else {
                    paramsDict[key] = [paramsDict[key] arrayByAddingObject:value];
                }
            }
            else {
                paramsDict[key] = value;
            }
        }
        else if (pairs.count == 1) {
            key = [[pairs firstObject] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([key DPL_containsArrayLiteral]) {
                // e.g. ?items[]
                key = [key DPL_stringByRemovingArrayLiteral];
                value = @[];
            }
            else {
                // e.g. ?key
                value = @"";
            }
            paramsDict[key] = value;
        }
        [orderedParameters addObject:key];
    }
    return @{ DPL_ParametersValuesDictionaryKey: [paramsDict copy], DPL_OrderedParameterNamesSetKey: [orderedParameters copy] };
}


#pragma mark - URL Encoding/Decoding

- (NSString *)DPL_stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *allowedCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharactersSet];
}


- (NSString *)DPL_stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    return [self stringByRemovingPercentEncoding];
}


#pragma mark - Array Literals

- (BOOL)DPL_containsArrayLiteral {
    return [self hasSuffix:DPL_ArrayLiteral];
}


- (NSString *)DPL_stringByRemovingArrayLiteral {
    if ([self DPL_containsArrayLiteral]) {
        return [self substringWithRange:NSMakeRange(0, self.length - DPL_ArrayLiteral.length)];
    }
    return [self copy];
}

@end
