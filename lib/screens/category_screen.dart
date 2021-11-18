import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/screens/add/addCategory_screen.dart';
import 'package:point_of_sale/screens/details/category_detail_screen.dart';
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

  late TextEditingController _searchTextController;
  late String searchKey;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  void dispose(){
    super.dispose();
    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff363636),
        drawer: NavigationDrawerWidget(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125),
          child: Column(
            children: [
              AppBar(
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
              Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 5.0),
                child: TextField(
                  controller: _searchTextController,
                  onChanged: (value){
                    setState(() {
                      searchKey = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      hintText: 'Search Category',
                      hintStyle: TextStyle(color: Colors.white60),
                      fillColor: Colors.white.withOpacity(0.5),
                      filled: true,
                      suffixIcon: _searchTextController.text.isEmpty ? IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.search, color: Colors.white70,),
                      ) : IconButton(
                        icon: Icon(Icons.clear, color: Colors.red,),
                        onPressed: (){
                          _searchTextController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _searchTextController.text.isEmpty ? _services.category.snapshots() :
          _services.category.where('category', isGreaterThanOrEqualTo: searchKey).
          where('category', isLessThan: searchKey + 'z').snapshots(),
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
                      height: 230,
                      child: Image.asset('images/EmptyCategory.png'),
                    ),
                    SizedBox(height: 15,),
                    Text('Berlum ada Category!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                ),
              );
            }else{
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document){
                  return Container(
                    margin: EdgeInsets.only(bottom: 17, right: 25, left: 25),
                    height: 100,//tinggi gambar
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){
                              return CategoryDetailScreen(
                                idCategory: (document.data()! as dynamic)['category_id'],
                              );
                            }
                        ),
                        );
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(//background image
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network((document.data()! as dynamic)['imageUrl'], fit: BoxFit.cover,),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,//tinggi background
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            bottom: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(2),
                                      height: 70,//size gambar
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: Image.network((document.data()! as dynamic)['imageUrl'], fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text((document.data()! as dynamic)['category'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget> [
                              IconButton(
                                icon: Icon(Icons.delete_forever, color: Colors.red, size: 30,),
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return CupertinoAlertDialog(
                                        title: Text('Hapus Category!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                        content: Text('Yakin ingin menghapus Category ${(document.data()! as dynamic)['category']}', style: TextStyle(fontSize: 18,),),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text('Batal'),
                                            onPressed: (){Navigator.of(context).pop();},
                                          ),
                                          CupertinoDialogAction(
                                            child: Text('Iya'),
                                            onPressed: (){
                                              EasyLoading.showSuccess('Dihapus');
                                              Navigator.of(context).pop();
                                              _services.category.doc((document.data()! as dynamic)['category_id']).delete();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
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


