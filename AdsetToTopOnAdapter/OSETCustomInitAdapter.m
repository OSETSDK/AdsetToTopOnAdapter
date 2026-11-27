//
//  OSETCustomInitAdapter.m
//  OSETATADemo
//
//  Created by Shens on 25/11/2025.
//

#import "OSETCustomInitAdapter.h"

@implementation OSETCustomInitAdapter

/** 初始化 OSET SDK，完成后通知渠道。 */
- (void)initWithInitArgument:(ATAdInitArgument *)adInitArgument {
    NSDictionary *settings = adInitArgument.serverContentDic;
    NSString *appId = [settings[@"app_id"] isKindOfClass:NSString.class] ? settings[@"app_id"] : nil;
#if DEBUG
    NSLog(@"hh [OSETTopOnAdapter] %@ 后台下发 appId=%@", NSStringFromClass(self.class), @"<redacted>");
#endif
    if (!appId.length) {
        NSError *error = [NSError errorWithDomain:@"OSETAnyThinkAdapter" code:70001
                                        userInfo:@{NSLocalizedDescriptionKey: @"初始化 appId 为空"}];
        [self notificationNetworkInitFail:error];
        return;
    }

    [OSETManager configureWithAppId:appId completion:^(BOOL success, NSError *error) {
#if DEBUG
        NSLog(@"hh [OSETTopOnAdapter] 奇点初始化 success=%d errorCode=%ld", success, (long)error.code);
#endif
        if (success) {
            [self notificationNetworkInitSuccess];
        } else {
            NSError *failure = error ?: [NSError errorWithDomain:@"OSETAnyThinkAdapter" code:70001
                                                        userInfo:@{NSLocalizedDescriptionKey: @"SDK 初始化失败"}];
            [self notificationNetworkInitFail:failure];
        }
    }];
}

#pragma mark - version
- (nullable NSString *)sdkVersion {
   return [OSETManager version];
}

- (nullable NSString *)adapterVersion {
   return @"8.0.0.0";
}
@end
