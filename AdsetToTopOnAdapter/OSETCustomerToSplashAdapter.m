//
//  OSETCustomerToSplashAdapter.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETCustomerToSplashAdapter.h"
#import "OSETSplashCustomEvent.h"




#import <Adset/OSETSDK.h>
@interface OSETCustomerToSplashAdapter ()
@property (nonatomic, strong) OSETSplashCustomEvent *customEvent;
@property (nonatomic, strong) OSETSplashAd *splashAd;

@end
@implementation OSETCustomerToSplashAdapter
#pragma mark - load Ad
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    NSString *osetSlotId = [self osetSlotIdFromServerContent:argument.serverContentDic];
#if DEBUG
    NSLog(@"hh [OSETTopOnAdapter] %@ 后台下发 slotId=%@", NSStringFromClass(self.class), @"<redacted>");
#endif
    self.splashAd = [[OSETSplashAd alloc] initWithSlotId:osetSlotId window:nil bottomView:self.containerView];
    self.splashAd.delegate = self.customEvent;
    [self.splashAd loadSplashAd];
}
// Ad ready
- (BOOL)adReadySplashWithInfo:(NSDictionary *)info {
    return self.splashAd.isAdValid;
}
// Ad show
- (void)showSplashAdInWindow:(UIWindow *)window inViewController:(UIViewController *)inViewController parameter:(NSDictionary *)parameter {
    if(window){
        self.splashAd.window = window;
    }else if(inViewController){
        self.splashAd.window = inViewController.view.window;
    }

    [self.splashAd showSplashAd];
}

#pragma mark - C2S Win Loss
- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    [OSETCustomBaseAdapter reportBidResult:result forAd:self.splashAd];
}





#pragma mark - lazy
- (OSETSplashCustomEvent *)customEvent {
    if (_customEvent == nil) {
        _customEvent = [[OSETSplashCustomEvent alloc] init];
        _customEvent.adStatusBridge = self.adStatusBridge;
    }
    return _customEvent;
}

@end
