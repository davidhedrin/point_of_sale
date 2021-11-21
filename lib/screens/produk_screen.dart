import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/screens/add/addProduk_screen.dart';
import 'package:point_of_sale/screens/details/produk_detail_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({Key? key}) : super(key: key);

  static const String id = 'produk-screen';

  @override
  _ProdukScreenState createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  final FirebaseServices _services = FirebaseServices();

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
                title: Text('Produk Toko', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
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
                      hintText: 'Search Produk',
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
          stream: _searchTextController.text.isEmpty ? _services.produk.snapshots() :
          _services.produk.where('nama_produk', isGreaterThanOrEqualTo: searchKey).
          where('nama_produk', isLessThan: searchKey + 'z').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
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
                        height: 220,
                        child: Image.asset('images/Emptyproduk.png')
                    ),
                    SizedBox(height: 10,),
                    Text('Berlum ada Produk!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                ),
              );
            }else{
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    children: snapshot.data!.docs.map((DocumentSnapshot doc){
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context){
                              return ProdukDetailScreen(
                                idProduk: data['id_produk'],
                                namaProduk: data['nama_produk'],
                              );
                            },
                          ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0, left: 5.0, top: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.black45,
                              child: GridTile(
                                header: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete_forever_sharp, color: Colors.red,),
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return CupertinoAlertDialog(
                                              title: Text('Hapus Produk!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                              content: Text('Yakin ingin menghapus Produk ${data['nama_produk']}', style: TextStyle(fontSize: 18,),),
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
                                                    _services.produk.doc(data['id_produk']).delete();
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      child: Image.network(data['imageUrl'], width: 90,),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text(
                                      data['category_produk']['nama_category'],
                                      style: TextStyle(color: Colors.white70, fontSize: 13),
                                    ),
                                    Text(
                                      data['nama_produk'],
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['harga_produk']),
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        Text('/kg', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, AddProdukData.id);
          },
          backgroundColor: Colors.white,
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text('Produk', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
        ),
      ),
    );
  }
}
