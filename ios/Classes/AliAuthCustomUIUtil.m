//
//  AliAuthCustomUIUtil.m
//  ali_auth
//
//  Created by V123456 on 2021/5/13.
//

#import "AliAuthCustomUIUtil.h"
#import "AliAuthPluginUtil.h"
@implementation AliAuthCustomUIUtil
+ (TXCustomModel *)handle:(NSDictionary *)arguments {
    
    NSDictionary *customUIConfig = arguments[@"UIConfig"];
    
    
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertTitleBarColor = [UIColor whiteColor];
    model.alertTitle = [[NSAttributedString alloc] init];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_gray"];
    if (customUIConfig != nil) {
        NSString *loginBtnColorsStr = customUIConfig[@"loginBtnColors"];
        NSString *logoImageKey = customUIConfig[@"logoImage"];
        NSArray *privacy = customUIConfig[@"privacy"];
        if (logoImageKey != nil) {
            model.logoImage = [AliAuthPluginUtil getFlutterAssetImage:logoImageKey];
        }
        if (loginBtnColorsStr != nil) {
            NSArray *loginBtnBgImgs = [loginBtnColorsStr componentsSeparatedByString:@","];
            if (loginBtnBgImgs.count == 3) {
                UIImage *defaultImage = [AliAuthPluginUtil imageWithHexString:loginBtnBgImgs.firstObject];
                UIImage *disableImage = [AliAuthPluginUtil imageWithHexString:loginBtnBgImgs[0]];
                model.loginBtnBgImgs = @[defaultImage,disableImage,defaultImage];
            }
        }
        
        if (privacy.count == 2) {
            model.privacyOne = privacy;
        }
    }
    
    model.changeBtnIsHidden = YES;
    model.checkBoxIsChecked = true;
    
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
