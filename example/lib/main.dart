/*
 * @Author: your name
 * @Date: 2021-05-12 17:29:03
 * @LastEditTime: 2021-06-21 10:11:32
 * @LastEditors: Please set LastEditors
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
  void initState() {
    super.initState();
    AliAuth.init(
        iOSKey: Config.iOSKey,
        androidKey: Config.androidKey,
        callback: (result) {
          print('flutter打印日志${result.toMap}');
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            _action('取消登录', () async {
              AliAuth.cancelLogin(callback: (result) {
                print('flutter打印日志${result.toMap}');
              });
            }),
            _action('加速一键登录授权页弹起', () async {
              AliAuth.prepareLogin(callback: (result) {
                print('flutter打印日志${result.toMap}');
              });
            }),
            _action('login', () async {
              final model = AliAuthUIConfig(
                  logoImage: 'assets/taobao.png',
                  checkBoxImage: [
                    'assets/check_box.png',
                    'assets/un_check_box.png'
                  ],
                  privacy: AliAuthUIConfigPrivacy(
                      title: '协议', url: 'https://www.baidu.com'),
                  loginBtnColors: ['#00A57B', '#878282', '#00A57B']);
              AliAuth.login(model, callback: (result) {
                print('flutter打印日志${result.toMap}');
              });
            }),
            _action('检查环境是否可用', () async {
              AliAuth.checkEnvAvailable(callback: (result) {
                print('flutter打印日志${result.toMap}');
              });
            }),
            _action('加速获取本机号码校验token', () async {
              AliAuth.accelerateVerify(callback: (result) {
                print('flutter打印日志${result.toMap}');
              });
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
