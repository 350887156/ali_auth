//
//  UIImage+FlutterExtension.m
//  ali_auth
//
//  Created by V123456 on 2021/5/13.
//

#import "AliAuthPluginUtil.h"
#import <Flutter/Flutter.h>
@implementation AliAuthPluginUtil

/// 获取Flutter素材文件
/// @param path 文件路径
+ (UIImage *)getFlutterAssetImage:(NSString *)path {
    
    FlutterViewController *flutterVc = [self getFlutterViewController];
    NSString *newPath = [flutterVc lookupKeyForAsset:path];
    NSBundle *bundle = [NSBundle bundleForClass: [self class]];
    return [UIImage imageNamed:newPath inBundle:bundle compatibleWithTraitCollection:nil];
}
+ (UIImage *)getImage:(NSDictionary *)arguments imageNameKey:(NSString *)imageNameKey {
    NSString *imageName = arguments[imageNameKey];
    return [self getFlutterAssetImage:imageName];
}
+ (UIColor *)getColor:(NSDictionary *)arguments colorKey:(NSString *)colorKey {
    NSString *hex = arguments[colorKey];
    return [self colorWithHexString:hex];
}
+ (FlutterViewController *)getFlutterViewController {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return (FlutterViewController *)window.rootViewController;
}

+ (UIViewController *)findCurrentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}
+ (UIColor *)colorWithHexString:(NSString *)hexColor {
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString length] < 6) return [UIColor blackColor];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return [UIColor blackColor];

    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];

    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1];
}
+ (UIImage *)imageWithHexString:(NSString *)hex
{
    UIColor *color = [self colorWithHexString:hex];
    if (color == nil) {
        return nil;
    }
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
