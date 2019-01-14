import 'package:flutter/material.dart';
import 'package:shark_account_flutter/pages/home/homeListView.dart';
import 'package:shark_account_flutter/pages/home/myDrawer.dart';
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

  TextStyle headTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 15.0,
    
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
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
      body: Column(
        children: <Widget>[
           Container(
             color: Theme.of(context).primaryColor,
             child:Theme(
                data: Theme.of(context).copyWith(
                ),
               child: Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                          Column( 
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:MainAxisAlignment.start,
                            children: <Widget>[
                                 Text('2019年',style: headTitleStyle,),
                                 GestureDetector(
                              // onTap: () => showDatePicker(
                              //   context: context,
                              //   firstDate: DateTime(2018),
                              //   initialDate: DateTime(2019),
                              //   lastDate: DateTime(2020),
                              //   textDirection: TextDirection.rtl
                              // ),
                              onTap: (){
                                showModalBottomSheet<Null>(context:context, builder:(BuildContext context) {
                                      return new Container(
                                        child: new Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: new Text(
                                            '时间选择',
                                            textAlign: TextAlign.center,
                                            style: new TextStyle(
                                              color: Theme.of(context).accentColor,
                                              fontSize: 24.0
                                            )
                                          )
                                        )
                                      );
                                    });
                              },
                              child: Row(
                                children: <Widget>[
                                  RichText(
                                text: TextSpan(
                                  text: '1',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '月',
                                      style: TextStyle(
                                        fontSize: 16.0
                                      )
                                    )
                                  ]
                                ),

                              ),
                              Icon(Icons.arrow_drop_down,size: 39.0,),
                             Container(
                               padding: const EdgeInsets.only(right: 5000.0),
                               margin: const EdgeInsets.only(right: 10.0),
                               height: 20.0,
                               width: 1.0,
                               color: Colors.black,
                             )
                                ],
                          )
                            )
                                  ],),
                                Expanded(
                             child:  Column( 
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:MainAxisAlignment.start,children: <Widget>[
                              Text('收入',style: headTitleStyle,),
                            RichText(
                                text: TextSpan(
                                  text: '856.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '00',
                                      style: TextStyle(
                                        fontSize: 16.0
                                      )
                                    )
                                  ]
                                ),

                                    )
                                ],),
                           ),
                            Expanded(
                            child:  Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column( 
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:MainAxisAlignment.start,
                            children: <Widget>[
                              Text('收入',style: headTitleStyle,),
                            RichText(
                                text: TextSpan(
                                  text: '856.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '00',
                                      style: TextStyle(
                                        fontSize: 16.0
                                      )
                                    )
                                  ]
                                ),
                              )
                          ],),
                            )
                          )
                        

                    ],
             ),
               )
             ),
           ),
           Expanded(
             child:   ListView.builder(
           itemCount: 60,
           itemBuilder: (BuildContext context,int i){
             return Container(
                  child: Row(
                    children: <Widget>[
                    Container(
                      
                       child: Padding(
                         padding: const EdgeInsets.all(20.0),
                         child: ClipOval(
                           child: Container(
                             padding: const EdgeInsets.all(8.0),
                             color: Colors.blueGrey,
                           child:  Icon(Icons.rotate_right,size: 30.0,color: Colors.yellow,),    
                           )
                          ,
                         ),
                       ),
                    ),
                     Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
               height: 50.0,
                              
                              child:
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text('宠物$i'),
                                ),
                                Expanded(
                                  
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:const EdgeInsets.only(right: 10.0),
                                      child: Text('${i*2}'),
                                    ),
                                  ),
                                ),

                              ],
                            )),
                            Divider(
                              height: 1.0,
                              color: Colors.grey,
                            )
                          ],
                        ),
                         
                        )
                    ],
                  ),
             );
           },
         ),
           )
        
        ],
      )
    );
  }
}
