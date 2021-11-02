import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class InOutScreen extends StatefulWidget {
  const InOutScreen({Key? key}) : super(key: key);

  static const String id = 'inout-screen';

  @override
  _InOutScreenState createState() => _InOutScreenState();
}

class _InOutScreenState extends State<InOutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            backgroundColor: Color(0xff363636),
            centerTitle: true,
            elevation: 0.0,
            title: Text('In-Out', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home_filled),
                iconSize: 25.0,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                },
                color: Colors.white70,
              ),
            ],
          ),
          body: Column(
            children: [
              TabBar(
                  tabs: [
                    Tab(child: Text('Pemasukan', style: TextStyle(color: Colors.black),),),
                    Tab(child: Text('Pengeluaran', style: TextStyle(color: Colors.black),),),
                  ]
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    children: [
                      Center(child: Text('View Pemasukan', style: TextStyle(color: Colors.black),),),
                      Center(child: Text('View Pengeluaran', style: TextStyle(color: Colors.black),),),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: (){},
            backgroundColor: Color(0xff363636),
            icon: Icon(Icons.add),
            label: Text('Laporan', style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }
}
