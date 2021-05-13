/*
 * @Author: your name
 * @Date: 2021-05-12 17:29:03
 * @LastEditTime: 2021-05-13 15:57:09
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /example/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ali_auth/ali_auth.dart';
import 'package:flutter/services.dart';

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
              //ios
              final appKey =
                  'FqkuICQmq6p56nf0eEW56DH87rDJkhpIhnmUm8B4VNsa2GpfX6usLW/12ANy3HJnLcYjQb88epymuft++tPIJ8th8943KcUYwD8QhKLPuYyWpi2/GxGgW0+n30NP6fKyuL6UYlG24F7/UaC0oXum1kG4fwdFgDmTI4jqlQC2kpbpdZUsCeNs1fGXmjFUUPwjKI6GMzzM+DaNwxlj+C1C8QDMgoV1/dEq6AqL21ijxm3We5f3hEzBcuDzRf9L0T9VpEgE4l7pIj8=';
              final result = await AliAuth.init(iOSKey: appKey);
              print('flutter打印日志$result');
            }),
            _action('取消登录', () async {
              final result = await AliAuth.cancelLogin();
              print('flutter打印日志$result');
            }),
            _action('加速一键登录授权页弹起', () async {
              final result = await AliAuth.pre();
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
                      title: '协议', url: 'https://www.taobao.com'),
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
            _action('蜂窝数据网络是否开启，即3G/4G', () async {
              final result = await AliAuth.checkDeviceCellularDataEnable();
              print('flutter打印日志$result');
            }),
            _action('判断当前设备是否有SIM卡', () async {
              final result = await AliAuth.simSupportedIsOK();
              print('flutter打印日志$result');
            }),
            _action('获取当前上网卡运营商名称，比如中国移动', () async {
              final result = await AliAuth.getCurrentCarrierName();
              print('flutter打印日志$result');
            })
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
