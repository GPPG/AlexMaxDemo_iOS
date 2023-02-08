//
//  ATWaterfallManager.h
//  AnyThinkSDK
//
//  Created by Martin Lau on 2020/4/28.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATWaterfall.h"
#import "ATWaterfallWrapper.h"

typedef void(^WaterfallCompletionBlock)(ATWaterFallMode *waterFallMode);

#define ATWaterfallTool [ATWaterfallManager sharedManager]
@interface ATWaterfallManager : NSObject
+ (instancetype)sharedManager;

- (void)removeWaterfallWrappers:(NSString *)placementID;

- (BOOL)loadingAdForPlacementID:(NSString*)placementID;

// just for api: check ad loading status
- (BOOL)loadingAdForPlacementID:(NSString*)placementID skipSettingLoadingStatus:(BOOL)skip;

- (void)attachWaterfall:(ATWaterfall*)waterfall waterfallCompletionBlock:(WaterfallCompletionBlock)waterfallCompletionBlock;

- (void)attachDefaultWaterfall:(ATWaterfall*)defaultWaterfall waterfallCompletionBlock:(WaterfallCompletionBlock)waterfallCompletionBlock;

- (void)asyncAccessWaterfallForPlacementID:(NSString*)placementID requestID:(NSString*)requestID waterfallCompletionBlock:(WaterfallCompletionBlock)waterfallCompletionBlock;

- (ATWaterFallMode *)syncAccessWaterfallForPlacementID:(NSString*)placementID requestID:(NSString*)requestID;

@end
