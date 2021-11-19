import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class AddPosCartScreen extends StatefulWidget {
  const AddPosCartScreen({Key? key, this.document}) : super(key: key);
  final DocumentSnapshot <Map<String, dynamic>>? document;

  static const String id = 'addposcart-screen';

  @override
  _AddPosCartScreenState createState() => _AddPosCartScreenState();
}

class _AddPosCartScreenState extends State<AddPosCartScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff363636),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(300),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Color(0xff363636),
                elevation: 0.0,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Tambah Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),),
                    Text(
                      '${_cartProvider.cartQty} ${_cartProvider.cartQty >1 ? 'Items, ' : 'Item, '}',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ),
              ),

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
                                //controller: _suplierTextController,
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
                              /*showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return SuplierList();
                                },
                              ).whenComplete((){
                                _suplierTextController.text = _authData.selectedSuplier!;
                              });*/
                            },
                            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700],),
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
        body: Center(
          child: Text('Cart Screen'),
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
                        'Rp. ${_cartProvider.subTotal.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Total harga)',
                        style: TextStyle(color: Colors.green, fontSize: 12,),
                      ),
                    ],
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                    ),
                    child: Text('CHECKOUT', style: TextStyle(color: Colors.white),),
                    color: Colors.deepOrangeAccent,
                    onPressed: (){},
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

//Text('Tambah Pesanan, ${_cartProvider.cartQty}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),