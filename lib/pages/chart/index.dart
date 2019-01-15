import 'package:flutter/material.dart';
class Chart extends StatefulWidget {
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
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
        )
      ),
      body:Text('图表')
    );
    
  }
}