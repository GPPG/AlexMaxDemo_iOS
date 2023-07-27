
#import "AlexMaxNativeRenderer.h"
#import "AlexMaxNativeCustomEvent.h"
#import <Masonry/Masonry.h>

@interface AlexMaxNativeRenderer()

@property(nonatomic, weak) AlexMaxNativeCustomEvent *customEvent;

@end


@implementation AlexMaxNativeRenderer

- (void)bindCustomEvent {
    ATNativeADCache *offer = (ATNativeADCache*)self.ADView.nativeAd;
    self.customEvent = offer.assets[kATAdAssetsCustomEventKey];
    self.customEvent.adView = self.ADView;
    self.ADView.customEvent = self.customEvent;
}

- (void)renderOffer:(ATNativeADCache *)offer {
    [super renderOffer:offer];
    
    MANativeAdView *view = offer.assets[kATMAXNativeAssetsExpressAdViewKey];
    [self.ADView addSubview:view];

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ADView.mas_centerX);
        make.centerY.equalTo(self.ADView.mas_centerY);
        make.width.mas_equalTo(@(self.configuration.ADFrame.size.width));
        make.height.mas_equalTo(@(self.configuration.ADFrame.size.height));
    }];
}

- (ATNativeAdRenderType)getCurrentNativeAdRenderType {
    return ATNativeAdRenderExpress;
}

@end
