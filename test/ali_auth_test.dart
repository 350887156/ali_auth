/*
 * @Author: your name
 * @Date: 2021-05-12 17:29:01
 * @LastEditTime: 2021-05-13 14:08:45
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /ali_auth/test/ali_auth_test.dart
 */
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ali_auth/ali_auth.dart';

void main() {
  const MethodChannel channel = MethodChannel('ali_auth');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
