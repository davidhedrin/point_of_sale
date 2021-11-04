import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/add/addCategory_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  static const String id = 'inout-screen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  FirebaseServices _services = FirebaseServices();

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
            title: Text('Category', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _services.category.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  return Text('Terjadi kesalahan');
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage((document.data()! as dynamic)['imageUrl']),

                      ),
                      title: Text((document.data()! as dynamic)['category'], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              Navigator.pushNamed(context, AddCategoryScreen.id);
            },
            backgroundColor: Colors.white,
            icon: Icon(Icons.add, color: Colors.black,),
            label: Text('Category', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
          ),
        ),
      ),
    );
  }
}


//dalam body
/*Column(
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
),*/
