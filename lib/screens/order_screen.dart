import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/screens/details/order_detail_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/pos_screen.dart';
import 'package:point_of_sale/services/cart_service.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const String id = 'order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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

  String dateTime = 'PilihWaktu';
  String dateTimeText = 'Pilih waktu:';
  late DateTime? _myDateTime = null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xff363636),
          drawer: NavigationDrawerWidget(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Color(0xff363636),
                  centerTitle: true,
                  elevation: 0.0,
                  title: Text('Pesanan', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.home_filled),
                      iconSize: 25.0,
                      onPressed: () {
                        Navigator.of(context).pop();
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
                        hintText: 'Search Transaksi',
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
          body: Column(
            children: [
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: 'All Order'),
                  Tab(text: 'Tanggal',),
                ]
              ),
              Divider(color: Colors.white70,),
              Expanded(
                  child: Container(
                    child: TabBarView(
                      children: [
                        //all orders
                        Column(
                          children: [
                            Container(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: _searchTextController.text.isEmpty ? _cart.trans.snapshots() :
                                _cart.trans.where('namaCustomer', isGreaterThanOrEqualTo: searchKey).
                                where('namaCustomer', isLessThan: searchKey + 'z').snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }
                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  if(!snapshot.hasData){
                                    return Center(child: Text('Tidak ada pesanan'),);
                                  }
                                  return Expanded(
                                    child: ListView(
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                        var doc_id = document.id;
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 8),
                                          child: new Container(
                                            color: Colors.black54,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: (){
                                                    Navigator.push(
                                                      context, MaterialPageRoute(
                                                      builder: (context){
                                                        return OrderDetailScreen(
                                                          idTrans: doc_id,
                                                        );
                                                      },
                                                    ),
                                                    );
                                                  },
                                                  horizontalTitleGap: 0,
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: 14,
                                                    child: Image.asset('images/pokdakan.png'),
                                                  ),
                                                  title: Text(
                                                    data['customer']['nama_cutomer'],
                                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    '${DateFormat('kk:mm – d MMM y').format(DateTime.parse(data['waktu_trans']))}',
                                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                                  ),
                                                  trailing: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text('${data['metode_bayar']} - ${data['metode_kirim']}', style: TextStyle(color: Colors.white, fontSize: 13),),
                                                      Text(
                                                        '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['sub_total_harga'])}',
                                                        style: TextStyle(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ExpansionTile(
                                                  collapsedIconColor: Colors.white60,
                                                  title: Row(
                                                    children: [
                                                      Text('Detail', style: TextStyle(color: Colors.white, fontSize: 13,),),
                                                      SizedBox(width: 8,),
                                                      Text(doc_id, style: TextStyle(color: Colors.green,  fontSize: 15, fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                  subtitle: Text('Detail Pesanan Transaksi', style: TextStyle(color: Colors.white60, fontSize: 12),),
                                                  children: [
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: data['produks'].length,
                                                        itemBuilder: (BuildContext context, int index){
                                                          return ListTile(
                                                            leading: CircleAvatar(
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                                child: Image.network(data['produks'][index]['imageUrl'], fit: BoxFit.cover,),
                                                              ),
                                                            ),
                                                            title: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      data['produks'][index]['nama_produk'],
                                                                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                                                    ),
                                                                    Card(
                                                                      color: Colors.deepOrange,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(right: 5.0, left: 5.0, top: 3.0, bottom: 3.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              data['produks'][index]['kode_produk'],
                                                                              style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['produks'][index]['harga_produk']*data['produks'][index]['unit_produk'])}',
                                                                  style: TextStyle(color: Colors.white, fontSize: 13,),
                                                                ),
                                                              ],
                                                            ),
                                                            subtitle: Row(
                                                              children: [
                                                                Text(
                                                                  '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['produks'][index]['harga_produk'])}/kg',
                                                                  style: TextStyle(fontSize: 12, color: Colors.white,),
                                                                ),
                                                                Text(
                                                                  ' x ${data['produks'][index]['unit_produk']}',
                                                                  style: TextStyle(fontSize: 12, color: Colors.blue,),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        //pilih tanggal
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0, left: 17.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateTimeText,
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        _myDateTime = await showDatePicker(
                                          context: context,
                                          initialDate: _myDateTime == null ? DateTime.now() : _myDateTime!,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime.now(),
                                        );
                                        setState(() {
                                          dateTimeText = DateFormat('d MMMM y').format(_myDateTime!);
                                          dateTime = DateFormat('y-MM-d').format(_myDateTime!);
                                        });
                                      },
                                      icon: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.date_range, color: Colors.blue, size: 20,),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: _cart.trans.where('waktu_trans', isGreaterThanOrEqualTo: dateTime).
                                where('waktu_trans', isLessThan: dateTime + 'z').snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }
                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  return Expanded(
                                    child: ListView(
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                        var doc_id = document.id;
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 8),
                                          child: new Container(
                                            color: Colors.black54,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: (){
                                                    Navigator.push(
                                                      context, MaterialPageRoute(
                                                      builder: (context){
                                                        return OrderDetailScreen(
                                                          idTrans: doc_id,
                                                        );
                                                      },
                                                    ),
                                                    );
                                                  },
                                                  horizontalTitleGap: 0,
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: 14,
                                                    child: Image.asset('images/pokdakan.png'),
                                                  ),
                                                  title: Text(
                                                    data['customer']['nama_cutomer'],
                                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    '${DateFormat('kk:mm – d MMM y').format(DateTime.parse(data['waktu_trans']))}',
                                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                                  ),
                                                  trailing: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text('${data['metode_bayar']} - ${data['metode_kirim']}', style: TextStyle(color: Colors.white, fontSize: 13),),
                                                      Text(
                                                        '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['sub_total_harga'])}',
                                                        style: TextStyle(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ExpansionTile(
                                                  collapsedIconColor: Colors.white60,
                                                  title: Row(
                                                    children: [
                                                      Text('Detail', style: TextStyle(color: Colors.white, fontSize: 13,),),
                                                      SizedBox(width: 8,),
                                                      Text(doc_id, style: TextStyle(color: Colors.green,  fontSize: 15, fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                  subtitle: Text('Detail Pesanan Transaksi', style: TextStyle(color: Colors.white60, fontSize: 12),),
                                                  children: [
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: data['produks'].length,
                                                        itemBuilder: (BuildContext context, int index){
                                                          return ListTile(
                                                            leading: CircleAvatar(
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                                child: Image.network(data['produks'][index]['imageUrl'], fit: BoxFit.cover,),
                                                              ),
                                                            ),
                                                            title: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      data['produks'][index]['nama_produk'],
                                                                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                                                    ),
                                                                    Card(
                                                                      color: Colors.deepOrange,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(right: 5.0, left: 5.0, top: 3.0, bottom: 3.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              data['produks'][index]['kode_produk'],
                                                                              style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['produks'][index]['harga_produk']*data['produks'][index]['unit_produk'])}',
                                                                  style: TextStyle(color: Colors.white, fontSize: 13,),
                                                                ),
                                                              ],
                                                            ),
                                                            subtitle: Row(
                                                              children: [
                                                                Text(
                                                                  '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['produks'][index]['harga_produk'])}/kg',
                                                                  style: TextStyle(fontSize: 12, color: Colors.white,),
                                                                ),
                                                                Text(
                                                                  ' x ${data['produks'][index]['unit_produk']}',
                                                                  style: TextStyle(fontSize: 12, color: Colors.blue,),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ]
                    ),
                  )
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              Navigator.pushReplacementNamed(context, PosScreen.id);
            },
            backgroundColor: Colors.white,
            icon: Icon(Icons.add, color: Colors.black,),
            label: Text('Pesanan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
          ),
        ),
      ),
    );
  }
}
