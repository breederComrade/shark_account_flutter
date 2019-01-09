import 'package:flutter/material.dart';
import 'package:shark_account_flutter/pages/home/homeListView.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool _result = false;
  String _result;
  final List<String> popupRoutes = <String>['1', '2', '3'];
  Future<Null> _openNewPage() async {
    // bool value = await showDialog(
    //     context: context,
    //     barrierDismissible: true,
    //     child: Center(
    //       child: new GestureDetector(
    //         child: new Text('确定'),
    //         onTap: () {
    //           Navigator.of(context).pop(true);
    //         },
    //       ),
    //     ));

    String selected = await showMenu<String>(
      context: context,
      // initialValue: selectedPopupRoute,
      position: new RelativeRect.fromLTRB(120.0, 100.0, -10.0, 100.0),
      items: popupRoutes.map((String popupRoute) {
        return new PopupMenuItem<String>(
          child: new Text(popupRoute),
          value: popupRoute,
        );
      }).toList(),
    );

    setState(() {
      print('kasi $selected');
      _result = selected;
    });
  }

// 从底部弹出
  Null _openModel() {
    return showModalBottomSheet<Null>(
      context: context,
      builder: (BuildContext context) {
        // return new Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(32.0),
        //     child: Text('ffffff',
        //         textAlign: TextAlign.center,
        //         style: TextStyle(color: Colors.red, fontSize: 24.0)),
        //   ),
        // );

        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            
          
            new ListTile(
              leading: Icon(Icons.ac_unit),
              title: Text('caddd'),
              onTap: () {
                print('fuck');
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: Icon(Icons.ac_unit),
              title: Text('caddd'),
              onTap: () {
                print('fuck');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _openNewPage2() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context, _, __) {
          return Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
            children: <Widget>[
              Text('mmapi'),
              RaisedButton(
                child: Text('fanh'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new RotationTransition(
              turns: new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('鱿鱼记账',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
      ),
      // body: Center(
        // child: Row(children: <Widget>[
        //   Column(children: <Widget>[
        //     RaisedButton(
        //   child: Text('测试弹出路由11'),
        //   onPressed: () {
        //     print('开始弹出路由');
        //     // _openNewPage();
        //     // _openModel();
        //     _openNewPage2();
        //   },
        // ),
        // Container(
        //    padding: EdgeInsets.all(10.0),
        //    decoration: BoxDecoration(
        //       // border: Border.all(color:Colors.blue,width: 1.0),
        //       border:Border(
        //         top:BorderSide(width: 1.0,color: Colors.grey),
        //         right: BorderSide(width: 1.0,color:Colors.grey),
        //         bottom: BorderSide(width: 1.0,color:Colors.grey),
        //         left: BorderSide(width: 1.0,color:Colors.grey),
        //       ),
        //       borderRadius: BorderRadius.all(Radius.circular(100.0))
        //     ),
        //   child: ClipOval(
        //     child: Text('22'),
         
        // ),)

        //   ],
          // )
         
        // ],) 
      // ),
      body: homeListView(),
    );
  }
}
