import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/add/addSuplier_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class SuplierScreen extends StatefulWidget {
  const SuplierScreen({Key? key}) : super(key: key);

  static const String id = 'suplier-screen';

  @override
  _SuplierScreenState createState() => _SuplierScreenState();
}

class _SuplierScreenState extends State<SuplierScreen> {
  FirebaseServices _services = FirebaseServices();

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
          child: StreamBuilder<QuerySnapshot>(
            stream: _services.suplier.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text('Terjadi kesalahan');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.data!.docs.length == 0){//jika data kosong
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 180,
                          child: Image.asset('images/EmptySuplier.png')
                      ),
                      SizedBox(height: 15,),
                      Text('Berlum ada Suplier!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                    ],
                  ),
                );
              }else{
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    return Container(
                      margin: EdgeInsets.only(bottom: 17, right: 25, left: 25),
                      height: 140,//tinggi gambar
                      child: Stack(
                        children: [
                          Positioned.fill(//background image
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset('images/suplierImageCard.jpg', fit: BoxFit.cover,),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 140,//tinggi background
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Row(
                              children: [
                                Text((document.data()! as dynamic)['id_suplier'], style: TextStyle(color: Colors.white, fontSize: 13),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                            child: Row(
                              children: [
                                /*ClipOval(
                                  child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(2),
                                    height: 70,//size gambar
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.network((document.data()! as dynamic)['imageUrl'], fit: BoxFit.fill,),
                                    ),
                                  ),
                                ),*/
                                Text((document.data()! as dynamic)['nama_suplier'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0, left: 10.0),
                            child: Row(
                              children: [
                                Text((document.data()! as dynamic)['no_handpone'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                              ],
                            ),
                          ),

                          //Alamat
                          Padding(
                            padding: const EdgeInsets.only(top: 110.0, left: 10.0),
                            child: Column(
                              children: [
                                Flexible(
                                  child: Text((document.data()! as dynamic)['alamat_suplier'],
                                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget> [
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.delete_forever, color: Colors.red, size: 30,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
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
