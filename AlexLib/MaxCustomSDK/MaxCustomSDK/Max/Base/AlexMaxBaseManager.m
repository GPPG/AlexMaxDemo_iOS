

#import "AlexMaxBaseManager.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppLovinSDK/ALSdkConfiguration.h>

@interface AlexMaxBaseManager()

@property (atomic, assign) BOOL isMaxInitSucceed;

@end

@implementation AlexMaxBaseManager

+ (instancetype)sharedManager {
    static AlexMaxBaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AlexMaxBaseManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - 初始化
+ (void)initWithCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        ATUnitGroupModel *unitGroupModel =(ATUnitGroupModel*)serverInfo[kATAdapterCustomInfoUnitGroupModelKey];
        ATPlacementModel *placementModel = (ATPlacementModel*)serverInfo[kATAdapterCustomInfoPlacementModelKey];
        
        [AlexMaxBaseManager setPersonalizedStateWithUnitGroupModel:unitGroupModel];
        
        // for max dynamic HB to set sdkSetting
        ALSdk *sdk = [ALSdk sharedWithKey:unitGroupModel.content[@"sdk_key"] ? unitGroupModel.content[@"sdk_key"] : @""];
        ALSdkSettings *sdkSettings = sdk.settings;
        
        [AlexMaxBaseManager setSdkSettings:sdkSettings placementModel:placementModel];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[ATAPI sharedInstance] setVersion:[ALSdk version] forNetwork:kATNetworkNameMax];
            
        });
    });
}

+ (void)initALSDKWithServerInfo:(NSDictionary *)serverInfo {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initMaxSdk:serverInfo];
        });
    });
}
+ (void)initC2SALSDKWithServerInfo:(NSDictionary *)serverInfo parObject:(id)parObject{
    
    [[AlexMaxBaseManager sharedManager].c2sRequestArray addObject:parObject];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initMaxSdk:serverInfo];
        });
    });
}



+ (void)initMaxSdk:(NSDictionary * _Nonnull)serverInfo {
    
    ATPlacementModel *placementModel = (ATPlacementModel*)serverInfo[kATAdapterCustomInfoPlacementModelKey];
    ATUnitGroupModel *unitGroupModel =(ATUnitGroupModel*)serverInfo[kATAdapterCustomInfoUnitGroupModelKey];
    
    ALSdkSettings *settings = [[ALSdkSettings alloc] init];
    [AlexMaxBaseManager setSdkSettings:settings placementModel:placementModel];
    
    if ([self whetherCallApplovinInitAPI]) {
        [self callApplovinInitApi:serverInfo unitGroupModel:unitGroupModel];
    } else {
        [self callMaxInitApi:serverInfo unitGroupModel:unitGroupModel settings:settings];
    }
}

+ (void)callMaxInitApi:(NSDictionary * _Nonnull)serverInfo unitGroupModel:(ATUnitGroupModel *)unitGroupModel settings:(ALSdkSettings *)settings {
    
    ALSdk *sdk = [ALSdk sharedWithKey:unitGroupModel.content[@"sdk_key"] ? unitGroupModel.content[@"sdk_key"] : @"" settings: settings];
    sdk.mediationProvider = @"max";
    sdk.userIdentifier = unitGroupModel.content[@"userID"];
    [sdk initializeSdkWithCompletionHandler:^(ALSdkConfiguration * _Nonnull configuration) {
        [AlexMaxBaseManager sharedManager].isMaxInitSucceed = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:AlexMaxStartInitSuccessKey object:nil];
    }];
}

+ (void)callApplovinInitApi:(NSDictionary * _Nonnull)serverInfo unitGroupModel:(ATUnitGroupModel *)unitGroupModel {
    NSMutableDictionary *info = serverInfo.mutableCopy;
    info[@"sdkkey"] = unitGroupModel.content[@"sdk_key"] ? unitGroupModel.content[@"sdk_key"] : @"";
    
    Class clazz = NSClassFromString(@"ATApplovinBaseManager");
    if (clazz && [clazz respondsToSelector:@selector(initWithCustomInfo:localInfo:)]) {
        [clazz performSelector:@selector(initWithCustomInfo:localInfo:) withObject:info withObject:info];
    }
}
+ (BOOL)whetherCallApplovinInitAPI {
    if (NSClassFromString(@"ATApplovinBaseManager") != nil) {
        return YES;
    }
    return NO;
}


- (BOOL)getMAXInitSucceedStatus {
    
    if ([AlexMaxBaseManager whetherCallApplovinInitAPI]) {
        return [self isApplovinInitSucceed];
    }
    return self.isMaxInitSucceed;
}

- (BOOL)isApplovinInitSucceed {
    __block BOOL applovin = NO;
    [[ATAPI sharedInstance] inspectInitFlagForNetwork:kATNetworkNameApplovin usingBlock:^NSInteger(NSInteger currentValue) {
        if (currentValue == 2) {
            applovin = YES;
        }
        return currentValue;
    }];
    NSLog(@"MAX---applovin---init:%d",applovin);
    return applovin;
}

#pragma mark - 隐私权限
+ (void)setPersonalizedStateWithUnitGroupModel:(ATUnitGroupModel *)unitGroupModel {
    // privacy setting
    BOOL state = [[ATAPI sharedInstance] getPersonalizedAdState] == ATNonpersonalizedAdStateType ? YES : NO;
    if (state) {
        [ALPrivacySettings setHasUserConsent:NO];
    } else {
        [ALPrivacySettings setHasUserConsent:YES];
    }
}

#pragma mark - 动态出价
+ (void)setSdkSettings:(ALSdkSettings *)sdkSettings placementModel:(ATPlacementModel *)placementModel {
    
    __block NSString *adUnitIds=@"";
    __block NSString *adFormats=@"";
    [placementModel.dynamicHBAdUnitIds enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *formatStr = nil;
        switch ([key integerValue]) {
            case ATAdFormatNative:
                formatStr = [NSString stringWithFormat:@"%@", MAAdFormat.native.label];
                break;
            case ATAdFormatRewardedVideo:
                formatStr = [NSString stringWithFormat:@"%@", MAAdFormat.rewarded.label];
                break;
            case ATAdFormatBanner:
                formatStr = [NSString stringWithFormat:@"%@", MAAdFormat.banner.label];
                break;
            case ATAdFormatInterstitial:
                formatStr = [NSString stringWithFormat:@"%@", MAAdFormat.interstitial.label];
                break;
            case ATAdFormatSplash:
                formatStr = [NSString stringWithFormat:@"%@", MAAdFormat.appOpen.label];
                break;
                
            default:
                break;
        }
        
        NSString *idsStr = [obj componentsJoinedByString:@","];
        if (adUnitIds.length==0) {
            adUnitIds = idsStr;
        } else {
            adUnitIds = [NSString stringWithFormat:@"%@,%@",adUnitIds,idsStr];
        }
        
        if (adFormats.length==0) {
            adFormats = formatStr;
        } else {
            adFormats = [NSString stringWithFormat:@"%@,%@",adFormats,formatStr];
        }
    }];
    
    // 关闭预缓存
    [sdkSettings setExtraParameterForKey:@"disable_b2b_ad_unit_ids" value :adUnitIds];
    // 禁用自动重试
    [sdkSettings setExtraParameterForKey:@"disable_auto_retry_ad_formats" value: adFormats];
}
#pragma mark - other
+ (NSString *)getMaxFormat:(MAAd*)maxAd {
    NSString *maxFormat = @"";
    if (maxAd.format == MAAdFormat.interstitial) {
        maxFormat = @"INTER";
    } else if (maxAd.format == MAAdFormat.rewarded) {
        maxFormat = @"REWARDED";
    } else if (maxAd.format == MAAdFormat.banner) {
        maxFormat = @"BANNER";
    } else if (maxAd.format == MAAdFormat.native) {
        maxFormat = @"NATIVE";
    } else if (maxAd.format == MAAdFormat.mrec) {
        maxFormat = @"MREC";
    } else if (maxAd.format == MAAdFormat.leader) {
        maxFormat = @"LEADER";
    } else if (maxAd.format == MAAdFormat.crossPromo) {
        maxFormat = @"XPROMO";
    } else if (maxAd.format == MAAdFormat.rewardedInterstitial) {
        maxFormat = @"REWARDED_INTER";
    }
    return maxFormat;
}

#pragma mark - lazy
- (NSMutableArray *)c2sRequestArray {
    if (_c2sRequestArray) return _c2sRequestArray;
    NSMutableArray *c2sRequestArray = [[NSMutableArray alloc]init];
    return _c2sRequestArray = c2sRequestArray;
}

@end

