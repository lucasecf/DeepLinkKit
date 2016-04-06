#import "DPLSerializableObject.h"

@implementation DPLSerializableObject

+ (BOOL)canInitWithDictionary:(NSDictionary<NSString *, NSObject *> *)dictionary {
    return [dictionary isKindOfClass:[NSDictionary class]] && dictionary[@"some_id"];
}


- (instancetype)initWithDictionary:(NSDictionary<NSString *, NSObject *> *)dictionary {
    if (![[self class] canInitWithDictionary:dictionary]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        [self updateWithRepresentation:dictionary];
    }
    
    return self;
}


- (void)updateWithRepresentation:(NSDictionary<NSString *, NSObject *> *)dictionary {
    self.someID      = (NSString *) dictionary[@"some_id"]     ?: self.someID;
    self.someString  = (NSString *) dictionary[@"some_string"] ?: self.someString;
    self.someURL     = [NSURL URLWithString:(NSString *)dictionary[@"some_url"]] ?: self.someURL;
   
    if (dictionary[@"some_int"]) {
        self.someInteger = [(NSNumber *)dictionary[@"some_int"] integerValue];
    }
}


- (NSDictionary<NSString *, NSObject *> *)dictionaryRepresentation {
    return @{ @"some_id":     self.someID     ?: @"",
              @"some_string": self.someString ?: @"",
              @"some_url":    self.someURL.absoluteString ?: @"",
              @"some_int":    @(self.someInteger) };
}

@end
