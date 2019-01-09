import 'package:flutter/material.dart';
// 异步请求包
import 'dart:io';
// 解析格式包
import 'dart:convert';

class homeListView extends StatefulWidget {
  _homeListViewState createState() => _homeListViewState();
}

// 渲染列表项
// 列表布局

class _homeListViewState extends State<homeListView> {
  // 请求数据
  List<Map> list = [];
  _getList() async {
    var homelist = await homeList();
    print('homelist$homelist');
  }
  void initState() {
    super.initState();
       _getList();
       setState(() {
              });
  }
  @override
  Widget build(BuildContext context) {
    return new ListView(
      // children: <Widget>[Text('fddd')],
      children: list.map((Map item) {
        // var word  = item.typeName??null;
        print(item);
        return Text('222'); //News接收2个参数（标题和图片url）
      }).toList(),
    );
  }
}

Future<Map> homeList() async {
  final String basic =
      'https://www.easy-mock.com/mock/5c3590b5879a3554aca75c6d/api';
  try {
    final client =
        await new HttpClient().getUrl(Uri.parse('${basic}/homlistview'));
    HttpClientResponse response = await client.close();
    var body = await response.transform(utf8.decoder).join();
    // print("fuck:$body");
    return jsonDecode(body);
  } catch (error) {
    print(" error: '$error'");
    return null;
  }
}
