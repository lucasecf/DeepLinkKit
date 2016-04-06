@import Foundation;

@protocol DPLSerializable <NSObject>

/**
 Inticates whether or not an instance can be created from the provided dictionary representation.
 @param dictionary An NSDictionary representation to be inspected.
 @return YES if a concrete instance can be initialized with the provided dictionary, otherwise NO.
 */
+ (BOOL)canInitWithDictionary:(NSDictionary<NSString *, NSObject *> *)dictionary;


/**
 Initializes an object with the provided dictionary representation.
 @param An NSDictionary representation of the object to be created.
 */
- (instancetype)initWithDictionary:(NSDictionary<NSString *, NSObject *> *)dictionary;


/**
 Updates the receiver with the provided dictionary representation.
 @param An NSDictionary representation of the object.
 */
- (void)updateWithRepresentation:(NSDictionary<NSString *, NSObject *> *)dictionary;


/**
 Returns a dictionary representation of the receiver.
 */
- (NSDictionary<NSString *, NSObject *> *)dictionaryRepresentation;

@end
