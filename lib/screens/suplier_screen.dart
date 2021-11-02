import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/add/addSuplier_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class SuplierScreen extends StatefulWidget {
  const SuplierScreen({Key? key}) : super(key: key);

  static const String id = 'suplier-screen';

  @override
  _SuplierScreenState createState() => _SuplierScreenState();
}

class _SuplierScreenState extends State<SuplierScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Color(0xff363636),
          centerTitle: true,
          elevation: 0.0,
          title: Text('Supliers', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
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
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xff363636),
          ),
          child: ListView(
            children: <Widget>[
              Center(child: Text('ini Suplier Screen'))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, AddSuplierData.id);
          },
          backgroundColor: Colors.white,
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text('Suplier', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
        ),
      ),
    );
  }
}
