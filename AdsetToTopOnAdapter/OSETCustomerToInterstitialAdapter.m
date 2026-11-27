//
//  OSETCustomerToInterstitialAdapter.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETCustomerToInterstitialAdapter.h"
#import "OSETInterstitialCustomEvent.h"

@interface OSETCustomerToInterstitialAdapter ()
@property (nonatomic, strong) OSETInterstitialCustomEvent *customEvent;
@property (nonatomic, strong) OSETInterstitialAd *interstitialAd;

@end

@implementation OSETCustomerToInterstitialAdapter

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {

    NSString *osetSlotId = [self osetSlotIdFromServerContent:argument.serverContentDic];
    self.interstitialAd = [[OSETInterstitialAd alloc] initWithSlotId:osetSlotId];
    self.interstitialAd.delegate = self.customEvent;
    [self.interstitialAd loadInterstitialAdData];
}

#pragma mark - Ad show
- (void)showInterstitialInViewController:(UIViewController *)viewController {
    [self.interstitialAd showInterstitialFromRootViewController:viewController];
}

#pragma mark - Ad ready
- (BOOL)adReadyInterstitialWithInfo:(NSDictionary *)info {
    return self.interstitialAd.isAdValid;
}

#pragma mark - C2S Win Loss
- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    [OSETCustomBaseAdapter reportBidResult:result forAd:self.interstitialAd];
}

#pragma mark - lazy
- (OSETInterstitialCustomEvent *)customEvent{
    if (_customEvent == nil) {
        _customEvent = [[OSETInterstitialCustomEvent alloc] init];
        _customEvent.adStatusBridge = self.adStatusBridge;
    }
    return _customEvent;
}

@end
