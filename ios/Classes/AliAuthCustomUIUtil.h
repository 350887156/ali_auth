//
//  AliAuthCustomUIUtil.h
//  ali_auth
//
//  Created by V123456 on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import <ATAuthSDK/ATAuthSDK.h>
#import <Flutter/Flutter.h>

@interface AliAuthCustomUIUtil : NSObject
+ (TXCustomModel *)handle:(NSDictionary *)arguments registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
@end


