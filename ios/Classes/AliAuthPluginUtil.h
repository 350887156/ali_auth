//
//  UIImage+FlutterExtension.h
//  ali_auth
//
//  Created by V123456 on 2021/5/13.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>


@interface AliAuthPluginUtil :NSObject

/// 获取Flutter素材文件
/// @param path 文件路径
+ (UIImage *)getFlutterAssetImage:(NSString *)path;

+ (UIImage *)getImage:(NSDictionary *)arguments imageNameKey:(NSString *)imageNameKey;

+ (UIColor *)getColor:(NSDictionary *)arguments colorKey:(NSString *)colorKey;

+ (FlutterViewController *)getFlutterViewController;

+ (UIViewController *)findCurrentViewController;

+ (UIColor *)colorWithHexString:(NSString *)hexColor;

+ (UIImage *)imageWithHexString:(NSString *)hex;
@end

