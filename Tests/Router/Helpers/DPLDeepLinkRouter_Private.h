#import "DPLDeepLinkRouter.h"

@interface DPLDeepLinkRouter ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, __kindof Class <DPLRouteHandler> > *classesByRoute;
@property (nonatomic, strong) NSMutableDictionary<NSString *, DPLRouteHandlerBlock> *blocksByRoute;

@end
