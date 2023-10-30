
#import "AlexMaxNativeRenderer.h"
#import "AlexMaxNativeCustomEvent.h"
#import <Masonry/Masonry.h>
#import "AlexMaxBaseManager.h"

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

- (UIView *)getNetWorkMediaView{
    if ([self isMaxAdTemplateType]) {
        return nil;
    }
    return [[UIView alloc]init];
}

- (void)renderOffer:(ATNativeADCache *)offer {
    [super renderOffer:offer];
    
    if ([self isMaxAdTemplateType]) {
        [self templateRenderOffer:offer];
        return;
    }
    [self slefRenderRenderOffer:offer];
}

#pragma mark - 模板
- (void)templateRenderOffer:(ATNativeADCache * _Nonnull)offer {
    
    MANativeAdView *view = offer.assets[kAlexMAXNativeAssetsExpressAdViewKey];
    [self.ADView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ADView.mas_centerX);
        make.centerY.equalTo(self.ADView.mas_centerY);
        make.width.mas_equalTo(@(self.configuration.ADFrame.size.width));
        make.height.mas_equalTo(@(self.configuration.ADFrame.size.height));
    }];
}

#pragma mark - 自渲染
- (void)slefRenderRenderOffer:(ATNativeADCache * _Nonnull)offer {
    MANativeAdView *nativeAdView = [self createMaxNativeAdView];
      
    if (self.ADView.selfRenderView) {
        [self.ADView.selfRenderView addSubview:nativeAdView];
        [self.ADView.selfRenderView bringSubviewToFront:nativeAdView];
        [nativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.ADView.selfRenderView);
        }];
    } else {
        [self.ADView addSubview:nativeAdView];
        [self.ADView bringSubviewToFront:nativeAdView];
        [nativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.ADView);
        }];
    }
    [self.ADView setNeedsLayout];
    [self.ADView layoutIfNeeded];
    
    if ([self.ADView respondsToSelector:@selector(titleLabel)] && self.ADView.titleLabel) {
        [nativeAdView addSubview:self.ADView.titleLabel];
        nativeAdView.titleLabel = self.ADView.titleLabel;
    }
    
    if ([self.ADView respondsToSelector:@selector(ctaLabel)] && self.ADView.ctaLabel) {
        UIButton *ctaBtn = [[UIButton alloc]initWithFrame:self.ADView.ctaLabel.frame];
        ctaBtn.backgroundColor = self.ADView.ctaLabel.backgroundColor;
        ctaBtn.tag = self.ADView.ctaLabel.tag;
        ctaBtn.layer.cornerRadius = self.ADView.ctaLabel.layer.cornerRadius;
        ctaBtn.layer.masksToBounds = self.ADView.ctaLabel.layer.masksToBounds;
        [nativeAdView addSubview:ctaBtn];
        nativeAdView.callToActionButton = ctaBtn;
        self.ADView.ctaLabel.hidden = YES;
    }
    
    if ([self.ADView respondsToSelector:@selector(advertiserLabel)] && self.ADView.advertiserLabel) {
        [nativeAdView addSubview:self.ADView.advertiserLabel];
        nativeAdView.advertiserLabel = self.ADView.advertiserLabel;
    }
    
    if ([self.ADView respondsToSelector:@selector(textLabel)] && self.ADView.textLabel) {
        [nativeAdView addSubview:self.ADView.textLabel];
        nativeAdView.bodyLabel = self.ADView.textLabel;
    }
    
    if ([self.ADView respondsToSelector:@selector(iconImageView)] && self.ADView.iconImageView) {
        [nativeAdView addSubview:self.ADView.iconImageView];
        nativeAdView.iconImageView = self.ADView.iconImageView;
    }
    
    if ([self.ADView respondsToSelector:@selector(domainLabel)] && self.ADView.domainLabel) {
        [nativeAdView addSubview:self.ADView.domainLabel];
        nativeAdView.optionsContentView = self.ADView.domainLabel;
    }
    
    if ([self.ADView respondsToSelector:@selector(mediaView)] && self.ADView.mediaView) {
        [nativeAdView addSubview:self.ADView.mediaView];
        nativeAdView.mediaContentView = self.ADView.mediaView;
    }
    
    if ([self.ADView respondsToSelector:@selector(dislikeButton)] && self.ADView.dislikeButton) {
        [self.ADView.selfRenderView bringSubviewToFront:self.ADView.dislikeButton];
    }
    [self.customEvent.maxNativeAdLoader renderNativeAdView: nativeAdView withAd: self.customEvent.maxAd];
}

- (void)dealloc {
    if (self.customEvent.maxAd) {
        [self.customEvent.maxNativeAdLoader destroyAd: self.customEvent.maxAd];
    }
}

- (MANativeAdView *)createMaxNativeAdView {
    
    MANativeAdView *nativeAdView = [[MANativeAdView alloc]init];
    
    MANativeAdViewBinder *binder = [[MANativeAdViewBinder alloc] initWithBuilderBlock:^(MANativeAdViewBinderBuilder *builder) {
        builder.titleLabelTag = self.ADView.titleLabel.tag;
        builder.advertiserLabelTag = self.ADView.advertiserLabel.tag;
        builder.bodyLabelTag = self.ADView.textLabel.tag;
        builder.iconImageViewTag = self.ADView.iconImageView.tag;
        builder.optionsContentViewTag = self.ADView.domainLabel.tag;
        builder.mediaContentViewTag = self.ADView.mediaView.tag;
        builder.callToActionButtonTag = self.ADView.ctaLabel.tag;
        builder.starRatingContentViewTag = self.ADView.ratingLabel.tag;
    }];
    [nativeAdView bindViewsWithAdViewBinder: binder];
    return nativeAdView;
}



#pragma mark - other
- (BOOL)isMaxAdTemplateType {
    if ([self.customEvent.serverInfo[@"unit_type"] integerValue] == AlexMaxNativeRenderTypeTemplate) {
        return YES;
    }
    return NO;
}
- (ATNativeAdRenderType)getCurrentNativeAdRenderType {
    
    if ([self isMaxAdTemplateType]) {
        return ATNativeAdRenderExpress;
    }
    return ATNativeAdRenderSelfRender;
}

@end
