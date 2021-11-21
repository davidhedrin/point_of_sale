import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/screens/add/addPosCart_screen.dart';
import 'package:point_of_sale/screens/details/pos_produk_detail_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/services/cart_service.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/widgets/add_cart/add_to_cart_produk_screen.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  static const String id = 'pos-screen';

  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {

  final FirebaseServices _services = FirebaseServices();
  CartService _cart = CartService();

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
                title: Text('System POS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
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
                    childAspectRatio: 0.8,
                    controller: new ScrollController(keepScrollOffset: false),
                    scrollDirection: Axis.vertical,
                    children: snapshot.data!.docs.map((DocumentSnapshot doc){
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0, left: 5.0, top: 10.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context){
                                  return POSProdukDetailScreen(
                                    idProduk: data['id_produk'],
                                    namaProduk: data['nama_produk'],
                                    document: doc,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black45,
                            ),
                            child: GridTile(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  SizedBox(height: 5.0,),
                                  InkWell(
                                    onTap: (){},
                                    child: Container(
                                      height: 38,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),  // radius of 10
                                          color: Colors.white
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AddToCardProdukScreen(document: doc as dynamic,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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

        floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: _cart.cart.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Text('Terjadi kesalahan');
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            return FloatingActionButton.extended(
              onPressed: (){
                Navigator.pushNamed(context, AddPosCartScreen.id);
              },
              backgroundColor: Colors.white,
              icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.black,),
              label: snapshot.data!.docs.length == 0 ? Text(
                'Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
              ) : Row(
                children: [
                  Text('Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
                  SizedBox(width: 5,),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    maxRadius: 13,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text('${snapshot.data!.docs.length}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ],
              ),
            );
            /*return Row(
              children: snapshot.data!.docs.map((DocumentSnapshot doc){
                return FloatingActionButton.extended(
                  onPressed: (){
                    Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context){
                        return AddPosCartScreen(
                          document: doc as dynamic,
                        );
                      },
                    ),
                    );
                  },
                  backgroundColor: Colors.white,
                  icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.black,),
                  label: snapshot.data!.docs.length == 0 ? Text(
                    'Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ) : Row(
                    children: [
                      Text('Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(width: 5,),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        maxRadius: 13,
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text('${snapshot.data!.docs.length}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );*/
          },
        ),
      ),
    );
  }
}

