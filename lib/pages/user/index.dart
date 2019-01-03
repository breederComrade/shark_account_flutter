import 'package:flutter/material.dart';

class User extends StatefulWidget {
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
        title: Text('我的',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
      ),
      body:Text('我的')
    );
  }
}