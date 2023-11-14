

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AlexNetworkC2STool : NSObject

+ (instancetype)sharedInstance;

- (void)saveRequestItem:(id)request withUnitId:(NSString *)unitID;

- (id)getRequestItemWithUnitID:(NSString*)unitID;

- (void)removeRequestItemWithUnitID:(NSString*)unitID;

- (NSDictionary *)getRequests;

@end

NS_ASSUME_NONNULL_END
