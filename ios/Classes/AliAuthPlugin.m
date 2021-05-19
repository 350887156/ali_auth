#import "AliAuthPlugin.h"
#import <ATAuthSDK/ATAuthSDK.h>
#import <YTXOperators/YTXOperators.h>
#import "AliAuthPluginUtil.h"
#import "AliAuthCustomUIUtil.h"
static NSTimeInterval const kTimerOut = 3;
static NSString * const kAliAuthPluginBasicMessageChannelKey = @"com.lajiaoyang.ali_auth.BasicMessageChannel";
@interface AliAuthPlugin()
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, assign) BOOL initSDK;
@end
@implementation AliAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.lajiaoyang.ali_auth"
            binaryMessenger:[registrar messenger]];
  AliAuthPlugin* instance = [[AliAuthPlugin alloc] initWithChannel:channel];
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
    if (![@"init" isEqualToString:call.method] && self.initSDK == NO) {
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        [resultDict setValue:@"70001" forKey:@"code"];
        [resultDict setValue:@"SDK未初始化" forKey:@"msg"];
        [resultDict setValue:call.method forKey:@"method"];
        [self _handelMethod:call.method resultDic:resultDict];
        
    } else if ([@"init" isEqualToString:call.method]) {
        self.initSDK = YES;
      NSString *appKey = call.arguments[@"appKey"];
      [[TXCommonHandler sharedInstance] setAuthSDKInfo:appKey complete:^(NSDictionary * _Nonnull resultDic) {
          __strong typeof(self) strongSelf = weakSelf;
          [strongSelf _handelMethod:call.method resultDic:resultDic];
      }];
  } else if ([@"pre" isEqualToString:call.method]) {
      [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:kTimerOut complete:^(NSDictionary * _Nonnull resultDic) {
          __strong typeof(self) strongSelf = weakSelf;
          [strongSelf _handelMethod:call.method resultDic:resultDic];
      }];
  } else if ([@"login" isEqualToString:call.method]) {
      UIViewController *controller = [AliAuthPluginUtil findCurrentViewController];
      TXCustomModel *model = [AliAuthCustomUIUtil handle:call.arguments];
      [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:kTimerOut controller:controller model:model complete:^(NSDictionary * _Nonnull resultDic) {
          __strong typeof(self) strongSelf = weakSelf;
          NSString *code = resultDic[@"resultCode"];
          if ([@"600001" isEqualToString:code] || [@"700002" isEqualToString:code]) {
          } else {
              [strongSelf _handelMethod:call.method resultDic:resultDic];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
              });
          }
      }];
  } else if ([@"checkEnvAvailable" isEqualToString:call.method]) {
      [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
          __strong typeof(self) strongSelf = weakSelf;
          [strongSelf _handelMethod:call.method resultDic:resultDic];
      }];
  } else if ([@"accelerateVerify" isEqualToString:call.method]) {
      [[TXCommonHandler sharedInstance] accelerateVerifyWithTimeout:kTimerOut complete:^(NSDictionary * _Nonnull resultDic) {
          __strong typeof(self) strongSelf = weakSelf;
          [strongSelf _handelMethod:call.method resultDic:resultDic];
      }];
      
  } else if ([@"cancelLogin" isEqualToString:call.method]){
      [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
      NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
      [resultDict setValue:@"0" forKey:@"code"];
      [resultDict setValue:@"取消登录成功" forKey:@"msg"];
      [resultDict setValue:call.method forKey:@"method"];
      [self _handelMethod:call.method resultDic:resultDict];
  } else if ([@"getCurrentCarrierName" isEqualToString:call.method]) {
      NSString *name = [TXCommonUtils getCurrentCarrierName];
      NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
      if (name.length) {
          [resultDict setValue:@"0" forKey:@"code"];
          [resultDict setValue:@"获取当前运营商名称成功" forKey:@"msg"];
          [resultDict setValue:name forKey:@"name"];
      } else {
          [resultDict setValue:@"600004" forKey:@"code"];
          [resultDict setValue:@"获取当前运营商名称失败" forKey:@"msg"];
      }
      [resultDict setValue:call.method forKey:@"method"];
      [self _handelMethod:call.method resultDic:resultDict];
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)_handelMethod:(NSString *)method resultDic:(NSDictionary *)resultDic {
    NSString *msg = resultDic[@"msg"];
    NSString *code = resultDic[@"resultCode"];
    if([@"600000" isEqualToString:code]) {
        code = @"0";
    }
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if ([method isEqualToString:@"login"]) {
        NSString *token = resultDic[@"token"];
        [result setValue:token forKey:@"token"];
    } else if ([method isEqualToString:@"getCurrentCarrierName"]) {
        NSString *name =resultDic[@"name"];
        [result setValue:name forKey:@"name"];
    }
    [result setValue:msg forKey:@"msg"];
    [result setValue:code forKey:@"code"];
    [result setValue:method forKey:@"method"];
    [self.channel invokeMethod:@"callBack" arguments:result];
}

@end
