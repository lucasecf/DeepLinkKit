@import Foundation;
#import "DPLMatchResult.h"

@interface DPLRegularExpression : NSRegularExpression

@property (nonatomic, strong) NSArray<NSString *> *groupNames;

+ (instancetype)regularExpressionWithPattern:(NSString *)pattern;

- (DPLMatchResult *)matchResultForString:(NSString *)str;

@end
