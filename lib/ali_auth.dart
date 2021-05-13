/*
 * @Author: your name
 * @Date: 2021-05-12 17:29:01
 * @LastEditTime: 2021-05-13 15:56:50
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /ali_auth/lib/ali_auth.dart
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class AliAuth {
  static const MethodChannel _channel =
      const MethodChannel('com.lajiaoyang.ali_auth');
  static const BasicMessageChannel _basicMessageChannel = BasicMessageChannel(
      'com.lajiaoyang.ali_auth.BasicMessageChannel', StandardMessageCodec());
  static bool _init = false;
  static Future init({String iOSKey, String androidKey}) async {
    if (_init == true) {
      return;
    }
    _init = true;
    Map<String, dynamic> parameter = {};
    if (Platform.isAndroid) {
      parameter['appKey'] = androidKey;
    } else {
      parameter['appKey'] = iOSKey;
    }

    _basicMessageChannel.setMessageHandler((message) async {
      print('flutter BasicMessageChannel 收到消息$message');
    });
    return await _channel.invokeMethod('init', parameter);
  }

  static Future pre() async {
    return await _channel.invokeMethod('pre');
  }

  static Future login(AliAuthUIConfig uiConfig) async {
    Map<String, dynamic> parameter = {};
    parameter['UIConfig'] = uiConfig.toMap();
    return await _channel.invokeMethod('login', parameter);
  }

  static Future debugLogin(AliAuthUIConfig uiConfig) async {
    Map<String, dynamic> parameter = {};
    parameter['UIConfig'] = uiConfig.toMap();
    return await _channel.invokeMethod('debugLogin', parameter);
  }

  static Future checkEnvAvailable() async {
    return await _channel.invokeMethod('checkEnvAvailable');
  }

  static Future accelerateVerify() async {
    return await _channel.invokeMethod('accelerateVerify');
  }

  static Future checkDeviceCellularDataEnable() async {
    return await _channel.invokeMethod('checkDeviceCellularDataEnable');
  }

  static Future simSupportedIsOK() async {
    return await _channel.invokeMethod('simSupportedIsOK');
  }

  static Future cancelLogin() async {
    return await _channel.invokeMethod('cancelLogin');
  }

  static Future getCurrentCarrierName() async {
    return await _channel.invokeMethod('getCurrentCarrierName');
  }
}

class AliAuthUIConfig {
  String logoImage;
  List<String> loginBtnColors;
  AliAuthUIConfigPrivacy privacy;
  AliAuthUIConfig({this.logoImage, this.loginBtnColors, this.privacy});
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['logoImage'] = logoImage;
    if (loginBtnColors?.length == 3) {
      map['loginBtnColors'] =
          '${loginBtnColors[0]},${loginBtnColors[1]},${loginBtnColors[2]}';
    }
    if (privacy?.title != null && privacy?.url != null) {
      map['privacy'] = [privacy.title, privacy.url];
    }
    return map;
  }
}

class AliAuthUIConfigPrivacy {
  String title;
  String url;
  AliAuthUIConfigPrivacy({this.title, this.url});
}
