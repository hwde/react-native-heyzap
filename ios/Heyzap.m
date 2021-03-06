#import "Heyzap.h"

@implementation RCTConvert (HeyzapAdOptions)
RCT_ENUM_CONVERTER(HZAdOptions, (@{
  @"AdOptionsNone" : @(HZAdOptionsNone),
  @"AdOptionsDisableAutoPrefetching" : @(HZAdOptionsDisableAutoPrefetching),
  @"AdOptionsInstallTrackingOnly" : @(HZAdOptionsInstallTrackingOnly),
  @"AdOptionsDisableMediation" : @(HZAdOptionsDisableMedation),
  @"AdOptionsDisableAutomaticIAPRecording" :
      @(HZAdOptionsDisableAutomaticIAPRecording),
  @"AdOptionsChildDirectedAds" : @(HZAdOptionsChildDirectedAds),
}),
                   HZAdOptionsNone, integerValue)
@end

@implementation Heyzap

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(Heyzap)

NSString *const ERROR_DOMAIN = @"HEYZAP";

- (id)init {
  self = [super init];
  if (self) {
    [HeyzapAds setFramework:@"react-native"];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

#pragma mark - Exported constants

- (NSDictionary *)constantsToExport {
  return @{
    @"AdOptionsNone" : @(HZAdOptionsNone),
    @"AdOptionsDisableAutoPrefetching" : @(HZAdOptionsDisableAutoPrefetching),
    @"AdOptionsInstallTrackingOnly" : @(HZAdOptionsInstallTrackingOnly),
    @"AdOptionsDisableMediation" : @(HZAdOptionsDisableMedation),
    @"AdOptionsDisableAutomaticIAPRecording" :
        @(HZAdOptionsDisableAutomaticIAPRecording),
    @"AdOptionsChildDirectedAds" : @(HZAdOptionsChildDirectedAds),
    @"NetworkHeyzap" : HZNetworkHeyzap,
    @"NetworkCrossPromo" : HZNetworkCrossPromo,
    @"NetworkFacebook" : HZNetworkFacebook,
    @"NetworkUnityAds" : HZNetworkUnityAds,
    @"NetworkAppLovin" : HZNetworkAppLovin,
    @"NetworkVungle" : HZNetworkVungle,
    @"NetworkChartboost" : HZNetworkChartboost,
    @"NetworkAdColony" : HZNetworkAdColony,
    @"NetworkAdMob" : HZNetworkAdMob,
    @"NetworkIAd" : HZNetworkIAd,
    @"NetworkHyprMX" : HZNetworkHyprMX,
    @"NetworkHeyzapExchange" : HZNetworkHeyzapExchange,
    @"NetworkLeadbolt" : HZNetworkLeadbolt,
    @"NetworkInMobi" : HZNetworkInMobi,
    @"NetworkCallbackInitialized" : HZNetworkCallbackInitialized,
    @"NetworkCallbackShow" : HZNetworkCallbackShow,
    @"NetworkCallbackAvailable" : HZNetworkCallbackAvailable,
    @"NetworkCallbackHide" : HZNetworkCallbackHide,
    @"NetworkCallbackFetchFailed" : HZNetworkCallbackFetchFailed,
    @"NetworkCallbackClick" : HZNetworkCallbackClick,
    @"NetworkCallbackDismiss" : HZNetworkCallbackDismiss,
    @"NetworkCallbackIncentivizedResultIncomplete" :
        HZNetworkCallbackIncentivizedResultIncomplete,
    @"NetworkCallbackIncentivizedResultComplete" :
        HZNetworkCallbackIncentivizedResultComplete,
    @"NetworkCallbackAudioStarting" : HZNetworkCallbackAudioStarting,
    @"NetworkCallbackAudioFinished" : HZNetworkCallbackAudioFinished,
    @"NetworkCallbackLeaveApplication" : HZNetworkCallbackLeaveApplication,
    @"RemoteDataRefreshedNotification" : HZRemoteDataRefreshedNotification,
    @"MediationNetworkCallbackNotification" :
        HZMediationNetworkCallbackNotification,
    @"MediationDidShowAdNotification" : HZMediationDidShowAdNotification,
    @"MediationDidFailToShowAdNotification" :
        HZMediationDidFailToShowAdNotification,
    @"MediationDidReceiveAdNotification" : HZMediationDidReceiveAdNotification,
    @"MediationDidFailToReceiveAdNotification" :
        HZMediationDidFailToReceiveAdNotification,
    @"MediationDidClickAdNotification" : HZMediationDidClickAdNotification,
    @"MediationDidHideAdNotification" : HZMediationDidHideAdNotification,
    @"MediationWillStartAdAudioNotification" :
        HZMediationWillStartAdAudioNotification,
    @"MediationDidFinishAdAudioNotification" :
        HZMediationDidFinishAdAudioNotification,
    @"MediationDidCompleteIncentivizedAdNotification" :
        HZMediationDidCompleteIncentivizedAdNotification,
    @"MediationDidFailToCompleteIncentivizedAdNotification" :
        HZMediationDidFailToCompleteIncentivizedAdNotification,
    @"NetworkCallbackNameUserInfoKey" : HZNetworkCallbackNameUserInfoKey,
    @"AdTagUserInfoKey" : HZAdTagUserInfoKey,
    @"NetworkNameUserInfoKey" : HZNetworkNameUserInfoKey,
  };
};

#pragma mark - Exported methods

RCT_EXPORT_METHOD(start
                  : (NSString *)publisherId resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {

  [HeyzapAds startWithPublisherID:publisherId];
  if ([HeyzapAds isStarted]) {
    [self addObservers];

    return resolve([self getStatus]);
  }

  NSString *errorMessage = @"Heyzap failed to start";
  return reject(ERROR_DOMAIN, errorMessage,
                [NSError errorWithDomain:ERROR_DOMAIN
                                    code:-57
                                userInfo:@{
                                  @"error" : errorMessage
                                }]);
}

RCT_EXPORT_METHOD(showDebugPanel) {
  [HeyzapAds presentMediationDebugViewController];
}

RCT_EXPORT_METHOD(showInterstitialAd
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {

  if ([HZInterstitialAd isAvailable]) {
    [HZInterstitialAd show];
    return resolve([NSMutableDictionary dictionary]);
  }

  NSString *errorMessage = @"An interstitial ad is not available";
  return reject(ERROR_DOMAIN, errorMessage,
                [NSError errorWithDomain:ERROR_DOMAIN
                                    code:-57
                                userInfo:@{
                                  @"error" : errorMessage
                                }]);
}

RCT_EXPORT_METHOD(fetchVideoAd
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {

  [HZVideoAd fetchWithCompletion:^(BOOL result, NSError *error) {
    if (result) {
      return resolve([NSMutableDictionary dictionary]);
    }
    return reject(ERROR_DOMAIN, @"A video ad could not be fetched", error);
  }];
}

RCT_EXPORT_METHOD(showVideoAd
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {

  if ([HZVideoAd isAvailable]) {
    [HZVideoAd show];
    return resolve([NSMutableDictionary dictionary]);
  }

  NSString *errorMessage = @"A video ad is not available";
  return reject(
      ERROR_DOMAIN, errorMessage,
      [NSError
          errorWithDomain:ERROR_DOMAIN
                     code:-57
                 userInfo:[NSDictionary
                              dictionaryWithObjectsAndKeys:ERROR_DOMAIN,
                                                           errorMessage, nil]]);
}

RCT_EXPORT_METHOD(fetchIncentivizedAd
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {

  [HZIncentivizedAd fetchWithCompletion:^(BOOL result, NSError *error) {
    if (result) {
      return resolve([NSMutableDictionary dictionary]);
    }
    return reject(ERROR_DOMAIN, @"An incentivized ad could not be fetched",
                  error);
  }];
}

RCT_EXPORT_METHOD(showIncentivizedAd
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {

  if ([HZIncentivizedAd isAvailable]) {
    [HZIncentivizedAd show];
    return resolve([NSMutableDictionary dictionary]);
  }

  NSString *errorMessage = @"An incentivized ad is not available";
  return reject(ERROR_DOMAIN, errorMessage,
                [NSError errorWithDomain:ERROR_DOMAIN
                                    code:-57
                                userInfo:@{
                                  @"error" : errorMessage
                                }]);
}

#pragma mark - Private methods

- (NSDictionary *)getStatus {

  return @{
    HZNetworkHeyzap : @([HeyzapAds isNetworkInitialized:HZNetworkHeyzap]),
    HZNetworkCrossPromo :
        @([HeyzapAds isNetworkInitialized:HZNetworkCrossPromo]),
    HZNetworkFacebook : @([HeyzapAds isNetworkInitialized:HZNetworkFacebook]),
    HZNetworkUnityAds : @([HeyzapAds isNetworkInitialized:HZNetworkUnityAds]),
    HZNetworkAppLovin : @([HeyzapAds isNetworkInitialized:HZNetworkAppLovin]),
    HZNetworkVungle : @([HeyzapAds isNetworkInitialized:HZNetworkVungle]),
    HZNetworkChartboost :
        @([HeyzapAds isNetworkInitialized:HZNetworkChartboost]),
    HZNetworkAdColony : @([HeyzapAds isNetworkInitialized:HZNetworkAdColony]),
    HZNetworkAdMob : @([HeyzapAds isNetworkInitialized:HZNetworkAdMob]),
    HZNetworkIAd : @([HeyzapAds isNetworkInitialized:HZNetworkIAd]),
    HZNetworkHyprMX : @([HeyzapAds isNetworkInitialized:HZNetworkHyprMX]),
    HZNetworkHeyzapExchange :
        @([HeyzapAds isNetworkInitialized:HZNetworkHeyzapExchange]),
    HZNetworkLeadbolt : @([HeyzapAds isNetworkInitialized:HZNetworkLeadbolt]),
    HZNetworkInMobi : @([HeyzapAds isNetworkInitialized:HZNetworkInMobi]),
  };
}

#pragma mark - Observers

- (void)didReceiveAdNotificationHandler:(NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidReceiveAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"]
                      }];
}

- (void)didFailToReceiveAdNotificationHandler:(NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidFailToReceiveAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"]
                      }];
}

- (void)didShowAdNotificationHandler:(NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidShowAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" :
                            notification.userInfo[@"HZNetworkNameUserInfoKey"]
                      }];
}

- (void)didFailToShowAdNotificationHandler:(NSNotification *)notification
                                  andError:(NSError *)error {

  NSString *networkName = nil;
  NSString *errorReason = nil;

  if ([notification.userInfo objectForKey:@"HZNetworkNameUserInfoKey"]) {
    networkName = notification.userInfo[@"HZNetworkNameUserInfoKey"];
  }

  if ([notification.userInfo objectForKey:@"NSUnderlyingErrorKey"]) {
    errorReason = notification.userInfo[@"NSUnderlyingErrorKey"];
  }

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidFailToShowAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" : networkName,
                        @"errorReason" : errorReason,
                        @"error" : error
                      }];
}

- (void)didClickAdNotificationHandler:(NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidClickAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" :
                            notification.userInfo[@"HZNetworkNameUserInfoKey"]
                      }];
}

- (void)didHideAdNotificationHandler:(NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidHideAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" :
                            notification.userInfo[@"HZNetworkNameUserInfoKey"]
                      }];
}

- (void)willStartAdAudioNotificationHandler:(NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"WillStartAdAudio"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" :
                            notification.userInfo[@"HZNetworkNameUserInfoKey"]
                      }];
}

- (void)didFinishAdAudioNotificationHandler:(NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidFinishAdAudio"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" :
                            notification.userInfo[@"HZNetworkNameUserInfoKey"]
                      }];
}

- (void)didCompleteIncentivizedAdNotificationHandler:
        (NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidCompleteIncentivizedAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" :
                            notification.userInfo[@"HZNetworkNameUserInfoKey"]
                      }];
}

- (void)didFailToCompleteIncentivizedAdNotificationHandler:
        (NSNotification *)notification {

  [self.bridge.eventDispatcher
      sendAppEventWithName:@"DidFailToCompleteIncentivizedAd"
                      body:@{
                        @"tag" : notification.userInfo[@"HZAdTagUserInfoKey"],
                        @"network" :
                            notification.userInfo[@"HZNetworkNameUserInfoKey"]
                      }];
}

#pragma mark - Attach observers

- (void)addObservers {
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didReceiveAdNotificationHandler:)
             name:HZMediationDidReceiveAdNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didFailToReceiveAdNotificationHandler:)
             name:HZMediationDidFailToReceiveAdNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didShowAdNotificationHandler:)
             name:HZMediationDidShowAdNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didFailToShowAdNotificationHandler:andError:)
             name:HZMediationDidFailToShowAdNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didClickAdNotificationHandler:)
             name:HZMediationDidClickAdNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didHideAdNotificationHandler:)
             name:HZMediationDidHideAdNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(willStartAdAudioNotificationHandler:)
             name:HZMediationWillStartAdAudioNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didFinishAdAudioNotificationHandler:)
             name:HZMediationDidFinishAdAudioNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didCompleteIncentivizedAdNotificationHandler:)
             name:HZMediationDidCompleteIncentivizedAdNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didFailToCompleteIncentivizedAdNotificationHandler:)
             name:HZMediationDidFailToCompleteIncentivizedAdNotification
           object:nil];
}

@end
