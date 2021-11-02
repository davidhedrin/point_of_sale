import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/add/addPosCart_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  static const String id = 'pos-screen';

  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Color(0xff363636),
          centerTitle: true,
          elevation: 0.0,
          title: Text('Point Of Sales', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
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
              Center(child: Text('ini POS Screen'))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, AddPosCartScreen.id);
          },
          backgroundColor: Colors.white,
          icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.black,),
          label: Row(
            children: [
              Text('Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
              SizedBox(width: 5,),
              CircleAvatar(
                backgroundColor: Colors.red,
                maxRadius: 13,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
