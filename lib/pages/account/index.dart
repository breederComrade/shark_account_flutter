import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int curTab;
  // 控制器
  void initState() {
    super.initState();
    // 控制器在初始化状态赋值
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    setState(() {
      curTab = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(''),
        // 这个告诉flutter 是否要显示返回键 如果leading设置了值那这个没有用
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: <Widget>[
         FlatButton(
              child: Text('取消'), 
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        ],
        title: Center(
          child: SizedBox(
            width: 150,
            height: 80,
            child: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Container(
              // color: Colors.red,
              child: Text('支出',textAlign: TextAlign.center,style: TextStyle(
                fontSize: 18.0,fontWeight:FontWeight.w400,
              ),),
            ),
           Container(
              // color: Colors.red,
              child: Text('收入',textAlign: TextAlign.center,style: TextStyle(
                fontSize: 18.0,fontWeight:FontWeight.w400,
              ))
            ),
          ],
          isScrollable: false,
          indicatorColor: Colors.black,
          // indicatorWeight: 2.0,
          // indicatorPadding: EdgeInsets.all(11.0),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.black,
   
        ),
        ),
          )
        ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Text('`1111'),
          new Text('22222'),
        ],
      ),
    );
  }
}
