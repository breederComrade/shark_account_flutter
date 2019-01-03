import 'package:flutter/material.dart';
class Discover extends StatefulWidget {
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
        return Scaffold(
         appBar: AppBar(
        title: Text('鲨鱼记账',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
      ),
      body:Text('发现')
    );
  }
}