/*
 * @Author: your name
 * @Date: 2021-05-12 17:29:03
 * @LastEditTime: 2021-05-14 15:43:30
 * @LastEditors: Sclea
 * @Description: In User Settings Edit
 * @FilePath: /example/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ali_auth/ali_auth.dart';
import 'package:flutter/services.dart';

import 'config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            _action('init', () async {
              final result = await AliAuth.init(
                  iOSKey: Config.iOSKey, androidKey: Config.androidKey);
              print('flutter打印日志$result');
            }),
            _action('取消登录', () async {
              final result = await AliAuth.cancelLogin();
              print('flutter打印日志$result');
            }),
            _action('加速一键登录授权页弹起', () async {
              final result = await AliAuth.prepareLogin();
              print('flutter打印日志$result');
            }),
            _action('login', () async {
              final model = AliAuthUIConfig(
                  logoImage: 'assets/taobao.png',
                  privacy: AliAuthUIConfigPrivacy(
                      title: '协议', url: 'https://www.taobao.com'),
                  loginBtnColors: ['#00A57B', '#878282', '#00A57B']);
              final result = await AliAuth.login(model);
              print('flutter打印日志$result');
            }),
            _action('debugLogin', () async {
              final model = AliAuthUIConfig(
                  logoImage: 'assets/taobao.png',
                  privacy: AliAuthUIConfigPrivacy(
                      title: '协议', url: 'https://www.baidu.com'),
                  loginBtnColors: ['#00A57B', '#878282', '#00A57B']);
              final result = await AliAuth.debugLogin(model);
              print('flutter打印日志$result');
            }),
            _action('checkEnvAvailable', () async {
              final result = await AliAuth.checkEnvAvailable();
              print('flutter打印日志$result');
            }),
            _action('加速获取本机号码校验token', () async {
              final result = await AliAuth.accelerateVerify();
              print('flutter打印日志$result');
            }),
          ],
        ),
      ),
    );
  }

  Widget _action(String title, VoidCallback onTap) {
    return ListTile(
      title: Text('$title'),
      onTap: onTap,
    );
  }
}
