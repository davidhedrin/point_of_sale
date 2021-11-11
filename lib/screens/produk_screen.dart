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
  final numbers = List.generate(100, (index) => '$index');
  final FirebaseServices _services = FirebaseServices();
  String perKg = '/kg';

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
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
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xff363636),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: _services.produk.snapshots(),
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
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context){
                                  return ProdukDetailScreen(
                                    idProduk: snapshot.data!.docs[index].get('id_produk'),
                                    namaProduk: snapshot.data!.docs[index].get('nama_produk'),
                                    //imgUrlProduk: snapshot.data!.docs[index].get('imageUrl'),
                                  );
                                },
                              ),
                            );
                          },
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
                                              content: Text('Yakin ingin menghapus Produk ${snapshot.data!.docs[index].get('nama_produk')}', style: TextStyle(fontSize: 18,),),
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
                                                    _services.produk.doc(snapshot.data!.docs[index].get('id_produk')).delete();
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
                                    SizedBox(height: 15.0,),
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      child: Image.network(snapshot.data!.docs[index].get('imageUrl'), width: 90,),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text(
                                      snapshot.data!.docs[index].get('kode_produk'),
                                      style: TextStyle(color: Colors.white70, fontSize: 13),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index].get('nama_produk'),
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(snapshot.data!.docs[index].get('harga_produk')),
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
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
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
