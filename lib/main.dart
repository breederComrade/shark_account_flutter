import 'package:flutter/material.dart';
import 'package:shark_account_flutter/pages/home/index.dart';
import 'package:shark_account_flutter/pages/demo/demo.dart';
import 'package:shark_account_flutter/config/ThemeUtils.dart';
import 'package:shark_account_flutter/pages/account/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // TODO: 让app接受一个参数设置名字

  Color themeColor = ThemeUtils.currentColorTheme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '鲨鱼记账',
      theme: ThemeData(primaryColor: themeColor, fontFamily: 'PingFang SC'),
      // home: MyHomePage(title: '鲨鱼记账'),

      home: Demo(title: '鱿鱼记账'),
      // 关闭
      debugShowCheckedModeBanner: false,
      // 生成静态路由
      routes: <String, WidgetBuilder>{
        // 这里可以定义静态路由，不能传递参数
        '/account': (_) => new Account(),
      },
    );
  }
}
