import 'package:flutter/material.dart';
import 'package:shark_account_flutter/pages/account/index.dart';
import 'package:shark_account_flutter/pages/chart/index.dart';
import 'package:shark_account_flutter/pages/user/index.dart';
import 'package:shark_account_flutter/pages/discover/index.dart';
import 'package:shark_account_flutter/pages/home/index.dart';

//导航类
class NavigationIconView {
  NavigationIconView({Widget icon, Widget title, TickerProvider vsync})
      : item = new BottomNavigationBarItem(
          icon: icon,
          title: title,
        ),
        controller = new AnimationController(
            duration: kThemeAnimationDuration, vsync: vsync);

  final BottomNavigationBarItem item;
  final AnimationController controller;
}

class Demo extends StatefulWidget {
  final String title;
  Demo({Key key, this.title}) : super(key: key);
  _Demo createState() => _Demo(title: title);
}

class _Demo extends State<Demo> with TickerProviderStateMixin {
  String title;
  int _selectedIndex = 0;
  _Demo({Key key, this.title}) : super();

 void _onItemTapped(int index) {
   setState(() {
     _selectedIndex = index;
   });
 }

  final  _pageList = <StatefulWidget>[
      new MyHomePage(),
      new Chart(),
      new Account(),
      new Discover(),
      new User(),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
      ),
      body: _pageList[_selectedIndex],
      bottomNavigationBar:BottomNavigationBar(
       items: <BottomNavigationBarItem>[
         BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
         BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('图标')),
         BottomNavigationBarItem(icon: Icon(Icons.add_alert ), title: Text('记账')),
         BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('发现')),
         BottomNavigationBarItem(icon: Icon(Icons.assistant), title: Text('我的')),
       ],
       currentIndex: _selectedIndex,
       fixedColor: Theme.of(context).primaryColor,
      type: BottomNavigationBarType.fixed,
       onTap: _onItemTapped,
     ),
    );
  }
}
