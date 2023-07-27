//
//  ATNativeRenderer.h
//  AnyThinkSDK
//
//  Created by Martin Lau on 25/04/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "ATNativeADRenderer.h"
//#import "ATAPI.h"
@protocol ATNativeADRenderer;
@class ATNativeADCache;
@interface ATNativeRenderer : NSObject<ATNativeADRenderer>

-(UIView*)retriveADView;
- (void)recordCustomPlayerStatus:(ATPlayerStatus)status currentTime:(NSTimeInterval)time;
-(instancetype) initWithConfiguraton:(ATNativeADConfiguration*)configuration adView:(ATNativeADView*)adView;
-(__kindof UIView*)createMediaView;
@property(nonatomic, weak) ATNativeADView *ADView;
@property(nonatomic, readonly) ATNativeADConfiguration *configuration;

- (UIView *)getNetWorkMediaView;

- (UIView *)getNetWorkShakeView:(ATNativeADCache *)offer frame:(CGRect)frame;


// for override
- (void)closeAct;


@end
