import 'package:flutter/material.dart';
import 'package:shark_account_flutter/pages/account/index.dart' show Account;
import 'package:shark_account_flutter/pages/chart/index.dart';
import 'package:shark_account_flutter/pages/user/index.dart';
import 'package:shark_account_flutter/pages/discover/index.dart';
import 'package:shark_account_flutter/pages/home/index.dart';
import 'package:shark_account_flutter/config/ThemeUtils.dart';

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
      new MyInfoPage(),
    ];
  Color _tabColor = ThemeUtils.currentColorTheme;

  // tabaItems
    var _tabList =[
      tabMap(iconData: Icons.album,text:'明细'),
      tabMap(iconData: Icons.face,text:'图表'),
      tabMap(iconData: Icons.table_chart,text:'记账'),
      tabMap(iconData: Icons.gps_fixed,text:'发现'),
      tabMap(iconData: Icons.av_timer,text:'我的'),
    ];
  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(5, (int index){
       return _buildTabItem(
          item:_tabList[index],
          index:index,
          onPressed:(index){
            setState(() {
                _selectedIndex = index;          
            });
          }
       );
    });
  
    return Scaffold(
      
      floatingActionButton:FloatingActionButton(
        elevation: 0.0,
        onPressed: (){
          //  Navigator.of(context)
          //       .push(MaterialPageRoute(builder: (BuildContext context) {
          //     return Account();
          //   }));
          /* 
            Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return CompanyDetail(company);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child),
          );
        }));         
           */
            //  命名路由
            // Navigator.of(context).pushNamed('/account');
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, _, __) {
                        return Account();
                },
                opaque: false,
                transitionDuration: Duration(milliseconds: 400),
                transitionsBuilder: (_,Animation<double> animation ,__,Widget child){
                  /*     return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>( begin: const Offset(0.0, 1.0),
                            end: Offset.zero,).animate(animation),
                            child: child,
                        ),
                      
                      ); */

                      return SlideTransition(position: Tween<Offset>( begin: const Offset(0.0, 1.0),
                            end: Offset.zero,).animate(animation),
                            child: child);
                    }
                )
           );
        },
        backgroundColor: _tabColor,
        child: Center(
          child: 
             Icon(Icons.add,color: Colors.black,size: 30.0,)
        ),
      ),
      body: _pageList[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
       BottomAppBar(
        color: Colors.white,
        notchMargin: -10.0, 
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
    )
          ),
    );
  }

// 构建item
    Widget _buildTabItem({tabMap item,int index,ValueChanged<int> onPressed}){
       Color color = _selectedIndex==index?Theme.of(context).primaryColor:Colors.grey;
      return Expanded(child: SizedBox(
            height:50.0,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
              onTap:(){
                if(index !=2){
                   onPressed(index);
                }
                
              },
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 5.0),child: Icon(item.iconData,color:color,size: 25.0,),),
                  Text(item.text,style: TextStyle(
                    color: Colors.grey,fontSize: 12.0
                  ),)

                ],
              ),

              ),
            ),
      ),);
    }



}

class tabMap {
  tabMap({this.iconData,this.text});
  IconData iconData;
  String text;
}

