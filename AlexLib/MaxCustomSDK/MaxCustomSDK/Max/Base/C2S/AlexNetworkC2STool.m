
#import "AlexNetworkC2STool.h"


@interface AlexNetworkC2STool()

@property(nonatomic, strong) NSMutableDictionary<NSString *, id> *requestDic;

@end


@implementation AlexNetworkC2STool


+ (instancetype)sharedInstance {
    static AlexNetworkC2STool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AlexNetworkC2STool alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    _requestDic = [NSMutableDictionary dictionary];
    return self;
}

#pragma mark - request CRUD
- (void)saveRequestItem:(id)request withUnitId:(NSString *)unitID{
    [self.requestDic setValue:request forKey:unitID];
}

- (id)getRequestItemWithUnitID:(NSString*)unitID {
    return [self.requestDic objectForKey:unitID];
}

- (void)removeRequestItemWithUnitID:(NSString*)unitID {
    [self.requestDic removeObjectForKey:unitID];
}

- (NSDictionary *)getRequests {
    return self.requestDic;
}

@end
