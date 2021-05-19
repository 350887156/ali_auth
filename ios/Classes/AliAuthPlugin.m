#import "AliAuthPlugin.h"
#import <ATAuthSDK/ATAuthSDK.h>
#import <YTXOperators/YTXOperators.h>
#import "AliAuthPluginUtil.h"
#import "AliAuthCustomUIUtil.h"
static NSTimeInterval const kTimerOut = 5000;
static NSString * const kAliAuthPluginBasicMessageChannelKey = @"com.lajiaoyang.ali_auth.BasicMessageChannel";
@interface AliAuthPlugin()
@property (nonatomic, weak) FlutterMethodChannel *channel;
@end
@implementation AliAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.lajiaoyang.ali_auth"
            binaryMessenger:[registrar messenger]];
  AliAuthPlugin* instance = [[AliAuthPlugin alloc] initWithBinaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
}
- (instancetype)initWithChannel:(FlutterMethodChannel *)channel;
{
    
    self = [super init];
    if (self) {
        self.channel = channel;
    }
    return self;
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
  if ([@"init" isEqualToString:call.method]) {
      
      NSString *appKey = call.arguments[@"appKey"];
      [[TXCommonHandler sharedInstance] setAuthSDKInfo:appKey complete:^(NSDictionary * _Nonnull resultDic) {
          result(resultDic);
      }];
  } else if ([@"pre" isEqualToString:call.method]) {
      [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:kTimerOut complete:^(NSDictionary * _Nonnull resultDic) {
          result(resultDic);
      }];
  } else if ([@"login" isEqualToString:call.method]) {
      UIViewController *controller = [AliAuthPluginUtil findCurrentViewController];
      TXCustomModel *model = [AliAuthCustomUIUtil handle:call.arguments];
      [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:kTimerOut controller:controller model:model complete:^(NSDictionary * _Nonnull resultDic) {
          __strong typeof(self) strongSelf = weakSelf;
          [strongSelf.channel sendMessage:resultDic];
      }];
  } else if ([@"checkEnvAvailable" isEqualToString:call.method]) {
      
      [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
          result(resultDic);
      }];
  } else if ([@"accelerateVerify" isEqualToString:call.method]) {
      [[TXCommonHandler sharedInstance] accelerateVerifyWithTimeout:kTimerOut complete:^(NSDictionary * _Nonnull resultDic) {
          result(resultDic);
      }];
      
  } else if ([@"simSupportedIsOK" isEqualToString:call.method]) {
      BOOL sim = [TXCommonUtils simSupportedIsOK];
      result(@(sim));
  } else if ([@"cancelLogin" isEqualToString:call.method]){
      [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
      result(@(YES));
  } else if ([@"getCurrentCarrierName" isEqualToString:call.method]) {
      NSString *name = [TXCommonUtils getCurrentCarrierName];
      result(name);
  } else {
    result(FlutterMethodNotImplemented);
  }
}


@end
