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
    var sync_data = homelist['data']['sync_data'];
    for (var i = 0; i < sync_data.length; i++) {
      var target = sync_data[i];
      var show = target['expenditure']['show'];
      for (var b = 0; b < show.length; b++) {
        var showItem = show[b];
        list.add(showItem);
      }
    }
    print('list$list');
  }

  void initState() {
    super.initState();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
      _getList();
    return new ListView(
      children: list.map((Map item) {
        print('ffff$item');
        return Row(
          
          children: <Widget>[
           
           Container(
             padding: EdgeInsets.all(5.0),

             decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(100)),
             color: Colors.grey,

             ),
             child:  Icon(Icons.accessibility),
           ),
            Expanded(
              child: Text(item['typeName']),
            ) ,
            Text(item['typeID'])
          ],
        ); //News接收2个参数（标题和图片url）
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
