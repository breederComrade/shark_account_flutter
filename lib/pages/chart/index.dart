import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'weather_details_header.dart';
import 'simple_line_chart.dart';
import 'dart:ui';
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
  }

   
  

  @override
  Widget build(BuildContext context) {
     Paint paint = new Paint();
     paint.color = Colors.black;
    return Scaffold(
         appBar: AppBar(
           elevation: 0.0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('支出'),
            Icon(Icons.arrow_drop_down,size: 18.0,)
          ],
        ),
      ),
      body:getLineChart()
    );
  }

Widget getLineChart({double statusBarHeight = 24.0}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // 根据比例来显示子元素高度
        //  AspectRatio(
        //    aspectRatio: 100/60,
        //    child: WeatherDetailsHeader(statusBarHeight),
        //  ),
         Expanded(
             
             child: TabBarControllerHome(),
           ),
      ],
    );
}

TabBarControllerHome(){
  return DefaultTabController(
    length: 3,
    child:Column(
      children: <Widget>[
        PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child:Container(
          color: Theme.of(context).primaryColor,
          child:  TabBar(
          tabs:[
            Tab(text: '周',),
            Tab(text: '日',),
            Tab(text: '年',),
          ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
                indicatorColor: Colors.black,
                indicatorHeight: 25.0,
                tabBarIndicatorSize: TabBarIndicatorSize.tab),
        ),
        ),
        
      ),
       Expanded(
         child: TabBarView(children: [
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new SizedBox(
              height: 250.0,
              child: new SimpleLineChart.withRandomData(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new SizedBox(
              height: 250.0,
              child: new SimpleLineChart.withRandomData(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new SizedBox(
              height: 250.0,
              child: new SimpleLineChart.withRandomData(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new SizedBox(
              height: 250.0,
              child: new SimpleLineChart.withRandomData(),
            ),
          ),
        ]),
       )
      ],
    )
  );
}



}