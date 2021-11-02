import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/add/addCustomer_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  static const String id = 'customer-screen';

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Color(0xff363636),
          centerTitle: true,
          elevation: 0.0,
          title: Text('Customers', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
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
              Center(child: Text('ini Customer Screen'))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, AddCustomerData.id);
          },
          backgroundColor: Colors.white,
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text('Customer', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
        ),
      ),
    );
  }
}
