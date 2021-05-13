#import "AliAuthPlugin.h"
#import <ATAuthSDK/ATAuthSDK.h>
#import <YTXOperators/YTXOperators.h>
#import "AliAuthPluginUtil.h"
#import "AliAuthCustomUIUtil.h"
static NSTimeInterval const kTimerOut = 5000;
static NSString * const kAliAuthPluginBasicMessageChannelKey = @"com.lajiaoyang.ali_auth.BasicMessageChannel";
@interface AliAuthPlugin()
@property (nonatomic, strong) FlutterBasicMessageChannel *channel;
@end
@implementation AliAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.lajiaoyang.ali_auth"
            binaryMessenger:[registrar messenger]];
  AliAuthPlugin* instance = [[AliAuthPlugin alloc] initWithBinaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
}
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
{
    self = [super init];
    if (self) {
        self.channel = [FlutterBasicMessageChannel messageChannelWithName:kAliAuthPluginBasicMessageChannelKey binaryMessenger:messenger];
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
  } else if ([@"debugLogin" isEqualToString:call.method]) {
      UIViewController *controller = [AliAuthPluginUtil findCurrentViewController];
      TXCustomModel *model = [AliAuthCustomUIUtil handle:call.arguments];
      
      [[TXCommonHandler sharedInstance] debugLoginUIWithController:controller model:model complete:^(NSDictionary * _Nonnull resultDic) {
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
      
  } else if ([@"checkDeviceCellularDataEnable" isEqualToString:call.method]) {
      BOOL enable = [TXCommonUtils checkDeviceCellularDataEnable];
      result(@(enable));
  } else if ([@"simSupportedIsOK" isEqualToString:call.method]) {
      BOOL sim = [TXCommonUtils simSupportedIsOK];
      result(@(sim));
  } else if ([@"cancelLogin" isEqualToString:call.method]){
      [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
      result(@(YES));
  } else if ([@"getCurrentCarrierName" isEqualToString:call.method]) {
      NSString *name = [TXCommonUtils getCurrentCarrierName];
      result(name);
  }
  
  
//  else {
//    result(FlutterMethodNotImplemented);
//  }
}
- (void)log:(NSDictionary *)resultDic {
   
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:0 error:0];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Flutter iOS 日志%@",dataStr);
}
- (TXCustomModel *)_buildSheetPortraitModel:(NSDictionary *)arguments {
    
    NSDictionary *customUIConfig = arguments[@"UIConfig"];
    
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@0, @0, @0, @0];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.checkBoxIsChecked = true;
//    model.privacyOne = @[@"协议", @"https://www.baidu.com"];
    model.alertTitleBarColor = [UIColor whiteColor];
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width;
        frame.size.height = 460;
        frame.origin.x = 0;
        frame.origin.y = superViewSize.height - frame.size.height;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 20;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 20 + 80 + 20;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 120 + 20 + 15;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30;
        return frame;
    };

    
    return model;
}

@end
