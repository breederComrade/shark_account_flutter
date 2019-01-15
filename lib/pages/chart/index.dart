import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
class Chart extends StatefulWidget {
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var page_index = 0;
  void initState() { 
    super.initState();
  // tab控制
   _tabController = TabController(
    length: 3,
    vsync: this,
  );
   _tabController.addListener((){
     setState(() {
     page_index = _tabController.index;
   });
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
           elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('支出'),
            Icon(Icons.arrow_drop_down,size: 38.0,)
          ],
        ),
        bottom: TabBar(
          tabs: <Widget>[
            Text('周'),
            Text('月'),
            Text('年'),
          ],
          controller: _tabController,
        ),
      ),
      body:Text('${page_index}')
    );
    
  }
}


