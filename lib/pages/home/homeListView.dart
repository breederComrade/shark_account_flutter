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

// class _homeListViewState extends State<homeListView> with AutomaticKeepAliveClientMixin {
class _homeListViewState extends State<homeListView> {
  //  @protected
  // bool get wantKeepAlive=>true;

  // 请求数据
  List<Map> list = List();
  _getList() async {
    // print('_getList$list');
    List<Map> temp = [];
    Map homelist = await homeList();
    print(homelist);
    var sync_data = homelist['data']['sync_data'];
    print(sync_data);
    for (var i = 0; i < sync_data.length; i++) {
      var target = sync_data[i];
      var show = target['expenditure']['show'];
      for (var b = 0; b < show.length; b++) {
        var showItem = show[b];
        list.add(showItem);
      }
    }

    if (!mounted) return;
    setState(() {});
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _getList();
    return new ListView(
      children: <Widget>[
        Text('2')
      ],
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
