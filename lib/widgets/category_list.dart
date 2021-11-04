import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AuthProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xff363636),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pilih Category Produk', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.white,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: _services.category.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text('Terjadi kesalahan');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage((document.data()! as dynamic)['imageUrl']),
                      ),
                      title: Text((document.data()! as dynamic)['category']),
                      onTap: (){
                        _provider.selectCategory((document.data()! as dynamic)['category']);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
