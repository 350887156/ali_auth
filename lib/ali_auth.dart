/*
 * @Author: your name
 * @Date: 2021-05-12 17:29:01
 * @LastEditTime: 2021-06-21 10:19:11
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /ali_auth/lib/ali_auth.dart
 */
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/services.dart';

typedef AliAuthCallback = void Function(AliAuthResultModel result);

class AliAuth {
  static const MethodChannel _channel =
      const MethodChannel('com.lajiaoyang.ali_auth');
  static bool _init = false;
  static AliAuthCallback _initHandler;
  static AliAuthCallback _prepareLoginHandler;
  static AliAuthCallback _loginHandler;
  static AliAuthCallback _checkEnvAvailableHandler;
  static AliAuthCallback _accelerateVerifyHandler;
  static AliAuthCallback _cancelLoginHandler;
  static AliAuthCallback _getCurrentCarrierNameHandler;

  static void init({
    String iOSKey,
    String androidKey,
    AliAuthCallback callback,
  }) async {
    _initHandler = callback;
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
    _channel.setMethodCallHandler((call) async {
      final method = call.method;
      if ('callBack' != method) {
        return;
      }
      final arguments = call.arguments;
      if (!(arguments is Map)) {
        return;
      }
      _handleMessage(arguments);
    });
    await _channel.invokeMethod('init', parameter);
  }

  static void _handleMessage(final dynamic arguments) {
    final model =
        AliAuthResultModel.fromMap(Map<String, dynamic>.from(arguments));
    final type = model.type;
    switch (type) {
      case AliAuthResultType.Init:
        if (AliAuth._initHandler != null) {
          _initHandler(model);
        }
        break;
      case AliAuthResultType.Prepare:
        if (AliAuth._prepareLoginHandler != null) {
          _prepareLoginHandler(model);
        }
        break;
      case AliAuthResultType.Login:
        if (AliAuth._loginHandler != null) {
          _loginHandler(model);
        }
        break;
      case AliAuthResultType.CheckEnvAvailable:
        if (AliAuth._checkEnvAvailableHandler != null) {
          _checkEnvAvailableHandler(model);
        }
        break;
      case AliAuthResultType.AccelerateVerify:
        if (AliAuth._accelerateVerifyHandler != null) {
          _accelerateVerifyHandler(model);
        }
        break;
      case AliAuthResultType.CancelLogin:
        if (AliAuth._cancelLoginHandler != null) {
          _cancelLoginHandler(model);
        }
        break;
      case AliAuthResultType.GetCurrentCarrierName:
        if (AliAuth._getCurrentCarrierNameHandler != null) {
          _getCurrentCarrierNameHandler(model);
        }
        break;
      case AliAuthResultType.Undefined:
        break;
    }
  }

  static void prepareLogin({AliAuthCallback callback}) async {
    _prepareLoginHandler = callback;
    await _channel.invokeMethod('pre');
  }

  static void login(AliAuthUIConfig uiConfig,
      {AliAuthCallback callback}) async {
    Map<String, dynamic> parameter = {};
    _loginHandler = callback;
    parameter['UIConfig'] = uiConfig.toMap();
    await _channel.invokeMethod('login', parameter);
  }

  static void checkEnvAvailable({AliAuthCallback callback}) async {
    _checkEnvAvailableHandler = callback;
    await _channel.invokeMethod('checkEnvAvailable');
  }

  static void accelerateVerify({AliAuthCallback callback}) async {
    _accelerateVerifyHandler = callback;
    await _channel.invokeMethod('accelerateVerify');
  }

  static void cancelLogin({AliAuthCallback callback}) async {
    _cancelLoginHandler = callback;
    await _channel.invokeMethod('cancelLogin');
  }
}

class AliAuthUIConfig {
  String logoImage;
  List<String> checkBoxImage;
  List<String> loginBtnColors;
  AliAuthUIConfigPrivacy privacy;
  AliAuthUIConfig(
      {this.logoImage, this.loginBtnColors, this.privacy, this.checkBoxImage});
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
    map['checkBoxImages'] = checkBoxImage;
    return map;
  }
}

class AliAuthUIConfigPrivacy {
  String title;
  String url;
  AliAuthUIConfigPrivacy({this.title, this.url});
}

class AliAuthResultModel {
  final int code;
  final String msg;
  final String token;
  final AliAuthResultType type;
  const AliAuthResultModel({
    this.code,
    this.msg,
    this.token,
    this.type,
  });
  Map<String, dynamic> get toMap {
    Map<String, dynamic> map = {};
    map['code'] = code;
    map['msg'] = msg;
    map['token'] = token;
    map['type'] = type.toString();
    return map;
  }

  factory AliAuthResultModel.fromMap(Map<String, dynamic> map) {
    final String codeStr = map['code'];
    int code;
    try {
      code = int.tryParse(codeStr);
    } catch (e) {}
    final String msg = map['msg'];
    final String token = map['token'];
    final String method = map['method'];
    AliAuthResultType type;
    switch (method) {
      case 'init':
        type = AliAuthResultType.Init;
        break;
      case 'pre':
        type = AliAuthResultType.Prepare;
        break;
      case 'login':
        type = AliAuthResultType.Login;
        break;
      case 'checkEnvAvailable':
        type = AliAuthResultType.CheckEnvAvailable;
        break;
      case 'accelerateVerify':
        type = AliAuthResultType.AccelerateVerify;
        break;
      case 'cancelLogin':
        type = AliAuthResultType.CancelLogin;
        break;
      case 'getCurrentCarrierName':
        type = AliAuthResultType.GetCurrentCarrierName;
        break;
      default:
        type = AliAuthResultType.Undefined;
        break;
    }
    return AliAuthResultModel(
      code: code,
      msg: msg,
      token: token,
      type: type,
    );
  }
}

enum AliAuthResultType {
  Init,
  Prepare,
  Login,
  CheckEnvAvailable,
  AccelerateVerify,
  CancelLogin,
  GetCurrentCarrierName,
  Undefined
}
