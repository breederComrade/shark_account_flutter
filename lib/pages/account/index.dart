import 'package:flutter/material.dart';
class Account extends StatefulWidget {
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
      body:Text('记账')
    );
  }
}