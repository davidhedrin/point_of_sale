import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/widgets/home_body_navButtom.dart';
import 'package:point_of_sale/widgets/nav_bar.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';
import 'package:point_of_sale/widgets/setting_body_navButtom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: CustomAppBar(),
        body: bodyPages(),
        bottomNavigationBar: buildBottomNavBar(),
      ),
    );
  }

  //body
  Widget bodyPages(){
    switch (index){
      case 1:
        return SettingBodyMenu();
      case 0:
      default:
        return BodyHomeMenu();
    }
  }

  //buttom navigator bar
  Widget buildBottomNavBar(){
    return BottomNavyBar(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      selectedIndex: index,
      containerHeight: 60,
      itemCornerRadius: 20,
      onItemSelected: (index) => setState(() => this.index = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(icon: Icon(Icons.home_filled, size: 34,), activeColor: Color(0xff363636), title: Text('Beranda'), textAlign: TextAlign.center,),
        BottomNavyBarItem(icon: Icon(Icons.settings, size: 34,), activeColor: Color(0xff363636), title: Text('Akun'), textAlign: TextAlign.center,),
      ],
    );
  }
}

