import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/providers/cart_provider.dart';
import 'package:point_of_sale/services/cart_service.dart';
import 'package:point_of_sale/widgets/list/suplier_category_list.dart';
import 'package:provider/provider.dart';

class AddPosCartScreen extends StatefulWidget {
  const AddPosCartScreen({Key? key,}) : super(key: key);

  static const String id = 'addposcart-screen';

  @override
  _AddPosCartScreenState createState() => _AddPosCartScreenState();
}

class _AddPosCartScreenState extends State<AddPosCartScreen> {
  CartService _cart = CartService();
  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot? documents;

  bool _ignoring = false;

  String? metodeBayar;
  String? metodeKirim;
  List<String> _pilihPembayaran = ['Cash', 'Transfer'];
  List<String> _pilihPengiriman = ['Pick Up', 'Kurir'];


  var _cutomerTextController = TextEditingController();
  var _idCartTextController = TextEditingController();


  @override
  void initState() {
    getCartItems();
    super.initState();
  }
  Future<void> getCartItems() async {
    final snapshot = await _cart.cart.get();
    if(snapshot.docs.length == 0){
      setState(() {
        _ignoring = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff363636),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
            ),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.blueGrey[800],
                  elevation: 0.0,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Tambah Pesanan', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 19),),
                      Text(
                        '${_cartProvider.cartQty} ${_cartProvider.cartQty >1 ? 'Items ' : 'Item '} dikaranjang',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.white70,),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _cutomerTextController,
                                  autofocus: false,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'pilih customer';
                                    }
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Icon(Icons.people_alt_outlined, color: Colors.white,),
                                    labelText: 'Customer*',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.white60),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return CustomerList();
                                  },
                                ).whenComplete((){
                                  _cutomerTextController.text = _authData.selectedCustomer!;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down, color: Colors.white70,),
                            ),
                          ],
                        ),

                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Bayar:', style: TextStyle(color: Colors.white),),
                            SizedBox(width: 25,),
                            Container(
                              width: 275,
                              child: DropdownButton(
                                hint: Text('Pilih bayar...', style: TextStyle(fontSize: 16, color: Colors.white60),),
                                value: metodeBayar,
                                isExpanded: true,
                                dropdownColor: Colors.grey,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                icon: Icon(Icons.arrow_drop_down, color: Colors.white70,),
                                items: _pilihPembayaran.map((bayar) =>
                                  DropdownMenuItem(
                                    value: bayar,
                                    child: Text(bayar)
                                  ),
                                ).toList(),
                                onChanged: (value){
                                  setState(() {
                                    metodeBayar = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Kirim:', style: TextStyle(color: Colors.white),),
                            SizedBox(width: 25,),
                            Container(
                              width: 275,
                              child: DropdownButton(
                                hint: Text('Metode kirim...', style: TextStyle(fontSize: 16, color: Colors.white60),),
                                value: metodeKirim,
                                isExpanded: true,
                                dropdownColor: Colors.grey,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                icon: Icon(Icons.arrow_drop_down, color: Colors.white70,),
                                items: _pilihPengiriman.map((kirim) =>
                                  DropdownMenuItem(
                                    value: kirim,
                                    child: Text(kirim)
                                  ),
                                ).toList(),
                                onChanged: (value){
                                  setState(() {
                                    metodeKirim = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Produk:', style: TextStyle(color: Colors.white),),
                  Text(
                    '${_cartProvider.cartQty} ${_cartProvider.cartQty >1 ? 'Items ' : 'Item '}',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder<QuerySnapshot>(
                stream: _cart.cart.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasError){
                    return Text('Terjadi kesalahan!');
                  }
                  if(snapshot.hasData){
                    if(snapshot.data!.docs.length == 0){
                      return Column(
                        children: [
                          SizedBox(height: 60,),
                          SizedBox(
                            height: 180,
                            child: Image.asset('images/EmptySuplier.png'),
                          ),
                          SizedBox(height: 15,),
                          Text('Berlum ada Orderan!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      );
                    }else{
                      return Column(
                        children: snapshot.data!.docs.map((DocumentSnapshot doc){
                          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                          return Column(
                            children: [
                              Divider(color: Colors.white70,),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(100)),
                                              child: Image.network(data['imageUrl']),
                                            ),
                                          ),
                                          SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data['kode_produk'], style: TextStyle(color: Colors.white, fontSize: 13),),
                                              Text(data['nama_produk'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                              Text(data['ket_produk'], style: TextStyle(color: Colors.white70, fontSize: 13),),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['harga_produk'])}/kg',
                                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                                  ),
                                                  Text(' x${data['unit_produk'].toString()}', style: TextStyle(color: Colors.blue, fontSize: 13),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(height: 35,),
                                          Text('Total harga', style: TextStyle(color: Colors.white, fontSize: 12),),
                                          Text(
                                            NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['total_harga']),
                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  }else{
                    return Text('');
                  }
                },
              ),
            ),
            Divider(color: Colors.white70,),
          ],
        ),

        bottomSheet: Container(
          height: 60,
          color: Colors.blueGrey[800],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(_cartProvider.subTotal),
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Total keseluruhan harga)',
                        style: TextStyle(color: Colors.green, fontSize: 12,),
                      ),
                    ],
                  ),
                  IgnorePointer(
                    ignoring: _ignoring,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                      ),
                      child: Text('CHECKOUT', style: TextStyle(color: Colors.white),),
                      color: _ignoring ? Colors.grey :Colors.deepOrangeAccent,
                      onPressed: (){
                        EasyLoading.show(status: 'Menyimpan...');
                        if(_formKey.currentState!.validate()){
                          if(metodeKirim != null && metodeBayar != null){
                            _authData.saveOrderToDbTrans(
                              _cartProvider,
                              double.parse(_cartProvider.subTotal.toString()),
                              metodeBayar,
                              metodeKirim,
                            );
                            _cart.removeCart();
                            EasyLoading.showSuccess('Tersimpan');
                            Navigator.pop(context);
                          }else{
                            EasyLoading.showInfo('Lengkapi data!');
                          }
                        }else{
                          EasyLoading.showInfo('Lengkapi data!');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}