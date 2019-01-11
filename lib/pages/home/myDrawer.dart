import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(width: 304.0),
      child: new Material(
        elevation: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: new ListView.builder(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return  Container(
                    width: 304.0,
                    height: 304.0,
                    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Text('323'),
       
      );;
            },
          ),
        ),
      ),
    );
  }
}
