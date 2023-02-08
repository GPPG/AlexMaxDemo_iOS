//
//  ATAdapterLoaderProtocol.h
//  AnyThinkSDK
//
//  Created by GUO PENG on 2022/12/12.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ATAdapterLoaderProtocol <NSObject>

- (void)loadADWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion;

- (void)initializationSucceedLoad;

@end

NS_ASSUME_NONNULL_END
